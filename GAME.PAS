program Game;

{$IFDEF FPC}{$MODE TP}{$ENDIF}

uses
  CRT, DOS,
  P92Core, Conv, Logger, BMFont, P92Geom, P92STR, P92TEX, Timing, P92VGA, P92KBD, P92Mouse,
  UEntity;

const
  MoveSpeed = 100;
  MaxSlimeMass = 10000;

  { Slime mass "taxes" }

  ConversionMass = 2400;
  ItemPickupMass = 400;

var
  { Asset variables }
  P92SansFont: TBMFont;
  SpecimenP92: array[0..1] of TTexture;

  { Game state variables }
  t: double;
  lastW, lastA, lastS, lastD: boolean;

  slimeMass: integer;
  entities: array[0..19] of TEntity;
  playerEntityIdx: integer;


procedure OnPreload; far;
begin
  LoadTex(SpecimenP92[0], 'IMG\SPP92_1.BMP');
  LoadTex(SpecimenP92[1], 'IMG\SPP92_2.BMP');
  LoadBMFont(P92SansFont, 'FONTS\P92SANS.TXT');
end;

procedure OnReady; far;
var
  a: word;
begin
  { Init game state variables here }
  t := 0.0;

  for a:=0 to high(entities) do
    DefaultEntity(entities[a]);

  { Init player state }
  slimeMass := 6000;

  playerEntityIdx := 0;

  with entities[playerEntityIdx] do begin
    alive := true;
    entityType := EntityTypeSlimeGirl;
    body.x := VGAWidth / 2;
    body.y := VGAHeight / 2;
    body.width := 32;
    body.height := 16;
  end;
end;

procedure OnCleanup; far;
begin
  FreeTex(SpecimenP92[0]);
  FreeTex(SpecimenP92[1]);
  FreeBMFont(P92SansFont);
end;

function IsRightKeyPressed: boolean;
begin
  IsRightKeyPressed := IsKeyDown(SC_D) or IsKeyDown(SC_RIGHT)
end;

function IsLeftKeyPressed: boolean;
begin
  IsLeftKeyPressed := IsKeyDown(SC_A) or IsKeyDown(SC_LEFT)
end;

function IsUpKeyPressed: boolean;
begin
  IsUpKeyPressed := IsKeyDown(SC_W) or IsKeyDown(SC_UP)
end;

function IsDownKeyPressed: boolean;
begin
  IsDownKeyPressed := IsKeyDown(SC_S) or IsKeyDown(SC_DOWN)
end;


procedure Update; far;
var
  a: word;
  displacement: double;
begin
  if IsKeyDown(SC_ESCAPE) then SignalDone;

  { Player movement }
  if not IsUpKeyPressed and not IsDownKeyPressed then
    entities[playerEntityIdx].body.vy := 0.0
  else begin
    if IsUpKeyPressed then
      entities[playerEntityIdx].body.vy := -MoveSpeed * DeltaTime;

    if IsDownKeyPressed then
      entities[playerEntityIdx].body.vy := MoveSpeed * DeltaTime;
  end;

  if not IsLeftKeyPressed and not IsRightKeyPressed then
    entities[playerEntityIdx].body.vx := 0.0
  else begin
    if IsLeftKeyPressed then
      entities[playerEntityIdx].body.vx := -MoveSpeed * DeltaTime;

    if IsRightKeyPressed then
      entities[playerEntityIdx].body.vx := MoveSpeed * DeltaTime;
  end;

  { Commit vy }
  for a:=0 to high(entities) do begin
    if not entities[a].alive then continue;

    with entities[a] do
      body.y := body.y + body.vy;

    if a = playerEntityIdx then begin
      displacement := abs(entities[a].body.vx) + abs(entities[a].body.vy);

      dec(slimeMass, trunc(displacement));
    end;
  end;

  { Commit vx }
  for a:=0 to high(entities) do begin
    if not entities[a].alive then continue;

    with entities[a] do
      body.x := body.x + body.vx;
  end;

  t := t + DeltaTime
end;

procedure PrintDefault(const text: string; const x, y: integer);
begin
  PrintBMFont(P92SansFont, text, x, y)
end;

{ Forwards call to PrintDefault }
procedure DebugPhysicsBody(const body: TPhysicsBody; const x, y: integer);
begin
  PrintDefault(
    '{x=' + F32Str(body.x)
    + ', y=' + F32Str(body.y)
    + ', vx=' + f32str(body.vx)
    + ', vy=' + f32str(body.vy)
    + '}', x, y)
end;

procedure DrawEntity(const e: TEntity);
var
  x, y: integer;
begin
  if e.entityType = EntityTypeSlimeGirl then begin
    x := trunc(e.body.x) + trunc(e.body.width - SpecimenP92[0].width) div 2;
    y := trunc(e.body.y + e.body.height) - SpecimenP92[0].height;

    Spr(SpecimenP92[0], x, y);
  end;
end;

procedure Draw; far;
var
  a: word;
  s: string;
  w: integer;
begin
  Cls($4F);

  for a:=0 to high(entities) do begin
    if not entities[a].alive then continue;

    DrawEntity(entities[a]);
  end;

  PrintDefault('Mass: ' + I32Str(slimeMass) + ' SU', 10, 10);

  DrawPhysicsBody(entities[playerEntityIdx].body, $0C);

  DebugPhysicsBody(entities[playerEntityIdx].body, 10, 25);

  s := 'Hello world!';
  w := MeasureBMFont(P92SansFont, s);
  PrintBMFont(P92SansFont, s, (VGAWidth - w) div 2, 120);
end;

var
  appConfig: TP92AppConfig;
begin
  DefaultP92AppConfig(appConfig);

  @appConfig.OnPreload := @OnPreload;
  @appConfig.OnReady := @OnReady;
  @appConfig.Update := @Update;
  @appConfig.Draw := @Draw;
  @appConfig.OnCleanup := @OnCleanup;

  P92Start(appConfig)
end.
