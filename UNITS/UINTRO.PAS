{
  Intro Screen unit - Part of Posit-92 game engine
  Hevanafa

  Mandatory for intro screens
}

unit UIntro;

{$IFDEF FPC}{$Mode ObjFPC}{$H+}{$J-}{$ENDIF}

interface

uses P92TEX;

const
  IntroSlides = 2;

var
  texPosit92Logo, texLazarusLogo, texTurboPascal: TTexture;

procedure RenderIntro(const introSlide: integer);
procedure UnloadIntro;


implementation

uses
  P92VGA, BMFont, UAssets;

procedure PrintDefaultCentred(const text: string; const x, y: integer);
var
  w: word;
begin
  w := MeasureBMFont(P92SansFont, text);
  PrintBMFont(P92SansFont, text, x - w div 2, y)
end;

procedure RenderIntro(const introSlide: integer);
begin
  Cls($00);

  case introSlide of
    1: begin
      Spr(texPosit92Logo, 144, 84);
      PrintDefaultCentred('Made with Posit-92', vgaWidth div 2, 126)
    end;

    2: begin
      PrintDefaultCentred('Made with', vgaWidth div 2, 44);

      Spr(texLazarusLogo, 75, 67);
      Spr(texTurboPascal, 180, 67);

      PrintDefaultCentred('Lazarus IDE', 108, 144);
      PrintDefaultCentred('', 108, 154);
      PrintDefaultCentred('Turbo Pascal 7.0', 212, 144);
    end;
  end;
end;

procedure UnloadIntro;
begin
  FreeTex(texPosit92Logo);
  FreeTex(texLazarusLogo);
  FreeTex(texTurboPascal);
end;

end.
