program Game;

{$IFDEF FPC}{$MODE TP}{$ENDIF}

uses
  CRT, DOS,
  P92Core, Conv, Logger, BMFont, P92Geom, P92STR, P92TEX, Timing, P92VGA, P92KBD, P92Mouse;

type
  TEntityType = (
    EntityTypeNothing,
    EntityTypeSlimeGirl,
    EntityTypeCultist
  );

  TEntity = record
    alive: boolean;
    body: TZone;
    entityType: TEntityType;
  end;

const
  MoveSpeed = 100;

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


procedure DefaultEntity(var e: TEntity);
begin
  e.alive := false;
  e.entityType := EntityTypeNothing;

  FillChar(e.body, SizeOf(TZone), 0)
end;

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

  slimeMass := 10000;

  for a:=0 to high(entities) do
    DefaultEntity(entities[a]);

  playerEntityIdx := 0;

  entities[playerEntityIdx].body.x := VGAWidth / 2;
  entities[playerEntityIdx].body.y := VGAHeight / 2;
  entities[playerEntityIdx].body.width := 32;
  entities[playerEntityIdx].body.height := 16;
end;

procedure OnCleanup; far;
begin
  { Free all the resources here }
  FreeTex(SpecimenP92[0]);
  FreeTex(SpecimenP92[1]);
end;

procedure Update; far;
begin
  if IsKeyDown(SC_ESCAPE) then SignalDone;

  { Player movement }
  if IsKeyDown(SC_W) then
    entities[playerEntityIdx].body.y :=
      entities[playerEntityIdx].body.y - MoveSpeed * DeltaTime;

  { Handle game state updates here }

  t := t + DeltaTime
end;

procedure Draw; far;
var
  s: string;
  w: integer;
begin
  Cls($4F);

  if frac(t * 1.5) >= 0.5 then
    Spr(SpecimenP92[1],
      trunc(entities[playerEntityIdx].body.x),
      trunc(entities[playerEntityIdx].body.y))
  else
    Spr(SpecimenP92[0],
      trunc(entities[playerEntityIdx].body.x),
      trunc(entities[playerEntityIdx].body.y));

  PrintBMFont(P92SansFont, 'Mass: ' + I32Str(slimeMass), 10, 10);

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
