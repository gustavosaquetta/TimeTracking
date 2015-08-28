program TimeTracking;

uses
  Vcl.Forms,
  ufrmPrincipal in 'ufrmPrincipal.pas' {frmPincipal},
  uTarefa in '..\Classes\uTarefa.pas',
  uDM in '..\Dados\uDM.pas' {DM: TDataModule},
  PrsAtributos in '..\Framework\PrsAtributos.pas',
  PrsBase in '..\Framework\PrsBase.pas',
  PrsDaoFDB in '..\Framework\PrsDaoFDB.pas',
  uLibrary in '..\Framework\uLibrary.pas',
  Vcl.Themes,
  Vcl.Styles,
  ufrmPadrao in 'ufrmPadrao.pas' {frmPadrao},
  ufrmTarefas in 'ufrmTarefas.pas' {frmTarefas},
  ufrmUsuarios in 'ufrmUsuarios.pas' {frmUsuarios},
  uUsuario in '..\Classes\uUsuario.pas',
  uSituacao in '..\Classes\uSituacao.pas',
  uTipo in '..\Classes\uTipo.pas',
  ufrmTipo in 'ufrmTipo.pas' {frmTipo},
  ufrmSituacao in 'ufrmSituacao.pas' {frmSituacao};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Metropolis UI Blue');
  Application.CreateForm(TfrmPincipal, frmPincipal);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmTipo, frmTipo);
  Application.CreateForm(TfrmSituacao, frmSituacao);
  Application.Run;
end.
