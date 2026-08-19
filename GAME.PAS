program Game;

{$IFDEF FPC}{$MODE TP}{$ENDIF}

uses
  CRT, DOS,
  P92Core, Logger, BMFont, P92STR, P92TEX, Timing, P92VGA, P92KBD, P92Mouse;

var
  { Asset variables }
  P92SansFont: TBMFont;
  SpecimenP92: array[0..1] of TTexture;

  { Game state variables }
  t: double;


procedure OnPreload; far;
begin
  LoadTex(SpecimenP92[0], 'IMG\SPP92_1.BMP');
  LoadTex(SpecimenP92[1], 'IMG\SPP92_2.BMP');
  LoadBMFont(P92SansFont, 'FONTS\P92SANS.TXT');
end;

procedure OnReady; far;
begin
  { Init game state variables here }
  t := 0.0;
end;

procedure OnCleanup; far;
begin
  { Free all the resources here }
  FreeTex(SpecimenP92[0]);
  FreeTex(SpecimenP92[1]);
end;

procedure Update; far;
begin
  { Handle inputs here }
  if IsKeyDown(SC_ESCAPE) then SignalDone;

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
    Spr(SpecimenP92[0], 148, 76)
  else
    Spr(SpecimenP92[1], 148, 76);

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
