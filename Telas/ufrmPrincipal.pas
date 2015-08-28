unit ufrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.ComCtrls, Vcl.ToolWin, Vcl.ImgList, cxGraphics;

type
  TfrmPincipal = class(TForm)
    sbPrincipal: TStatusBar;
    tbMenuPrincipal: TToolBar;
    btnTarefas: TToolButton;
    btnUsuarios: TToolButton;
    btnRelatorios: TToolButton;
    btnSair: TToolButton;
    actlstMenuPrincipal: TActionList;
    actTarefas: TAction;
    actUsuarios: TAction;
    actRelatorios: TAction;
    actSair: TAction;
    cximglstMenuPrincipal: TcxImageList;
    actTipo: TAction;
    actSituacao: TAction;
    btnTipo: TToolButton;
    btnSituacao: TToolButton;
    procedure actSairExecute(Sender: TObject);
    procedure actTarefasExecute(Sender: TObject);
    procedure actUsuariosExecute(Sender: TObject);
    procedure actTipoExecute(Sender: TObject);
    procedure actSituacaoExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPincipal: TfrmPincipal;

implementation

{$R *.dfm}

uses ufrmTarefas, ufrmUsuarios, uLibrary, ufrmSituacao, ufrmTipo;

procedure TfrmPincipal.actSairExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmPincipal.actSituacaoExecute(Sender: TObject);
begin
  AbreForm(TfrmSituacao, frmSituacao);
end;

procedure TfrmPincipal.actTarefasExecute(Sender: TObject);
begin
  AbreForm(TfrmTarefas, frmTarefas);
end;

procedure TfrmPincipal.actTipoExecute(Sender: TObject);
begin
  AbreForm(TfrmTipo,frmTipo);
end;

procedure TfrmPincipal.actUsuariosExecute(Sender: TObject);
begin
  AbreForm(TfrmUsuarios, frmUsuarios);
end;

end.
