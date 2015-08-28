program EventTimer;

uses
  Vcl.Forms,
  uDM in '..\Dados\uDM.pas' {DM: TDataModule},
  ufrmEventTimer in 'ufrmEventTimer.pas' {frmEventTimer},
  PrsAtributos in '..\Framework\PrsAtributos.pas',
  PrsBase in '..\Framework\PrsBase.pas',
  PrsDaoFDB in '..\Framework\PrsDaoFDB.pas',
  uLibrary in '..\Framework\uLibrary.pas',
  Vcl.Themes,
  Vcl.Styles,
  uEvento in '..\Classes\uEvento.pas',
  uTarefa in '..\Classes\uTarefa.pas',
  uTipo in '..\Classes\uTipo.pas',
  uUsuario in '..\Classes\uUsuario.pas',
  ufrmLogin in 'ufrmLogin.pas' {frmLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Metropolis UI Blue');
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
