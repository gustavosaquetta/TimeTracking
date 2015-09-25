unit ufrmPadrao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ImgList,
  Data.DB, Vcl.ExtCtrls, System.Actions, Vcl.ActnList, Vcl.Grids, Vcl.DBGrids,
  System.ImageList;

type
  TfrmPadrao = class(TForm)
    ToolBar1: TToolBar;
    btnNovo: TToolButton;
    btnAlterar: TToolButton;
    btnExcluir: TToolButton;
    btnSalvar: TToolButton;
    btnCancelar: TToolButton;
    ToolButton6: TToolButton;
    btnFechar: TToolButton;
    dsConsulta: TDataSource;
    Panel1: TPanel;
    PageControl1: TPageControl;
    tsConsulta: TTabSheet;
    tsCadastro: TTabSheet;
    sbStatus: TStatusBar;
    Panel2: TPanel;
    Panel3: TPanel;
    ActionList1: TActionList;
    actNovo: TAction;
    actAlterar: TAction;
    actExcluir: TAction;
    actSalvar: TAction;
    actCancelar: TAction;
    actFechar: TAction;
    Image1: TImage;
    Image2: TImage;
    grid1: TDBGrid;
    il1: TImageList;
    procedure actFecharExecute(Sender: TObject);
    procedure actCancelarExecute(Sender: TObject);
    procedure actNovoExecute(Sender: TObject);
    procedure actAlterarExecute(Sender: TObject);
    procedure actSalvarExecute(Sender: TObject);
    procedure inserir; virtual;
    procedure salvar;  virtual;
    procedure carregar; virtual;
    procedure limpar; virtual;
    procedure AtualizaDataset(ACampos: array of string); virtual;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure HabilitaBotoes(operacao: string);
    procedure HabilitaAba(operacao: string);
  public
    { Public declarations }
  end;

var
  frmPadrao: TfrmPadrao;

implementation

{$R *.dfm}

procedure TfrmPadrao.HabilitaBotoes(operacao:string);
begin
  if operacao = 'Cadastro' then
  begin
    actNovo.Enabled := False;
    actAlterar.Enabled := False;
    actExcluir.Enabled := False;
    actSalvar.Enabled := True;
    actCancelar.Enabled := True;
    actFechar.Enabled := False;
  end
  else
  begin
    actNovo.Enabled := True;
    actAlterar.Enabled := True;
    actExcluir.Enabled := True;
    actSalvar.Enabled := False;
    actCancelar.Enabled := False;
    actFechar.Enabled := True;
  end;
end;

procedure TfrmPadrao.HabilitaAba(operacao:string);
begin
  if operacao = 'Cadastro' then
  begin
    tsCadastro.Enabled := True;
    tsConsulta.Enabled := False;
    PageControl1.ActivePage := tsCadastro;
    HabilitaBotoes('Cadastro');
  end
  else
  begin
    tsCadastro.Enabled := False;
    tsConsulta.Enabled := True;
    PageControl1.ActivePage := tsConsulta;
    HabilitaBotoes('Consulta');
  end;
end;

procedure TfrmPadrao.actAlterarExecute(Sender: TObject);
begin
  HabilitaAba('Cadastro');
  sbStatus.Panels[0].Text := 'Editando';
  limpar;
  carregar;
end;

procedure TfrmPadrao.actCancelarExecute(Sender: TObject);
begin
  HabilitaAba('Consulta');
  sbStatus.Panels[0].Text := 'Listando';
  limpar;
end;

procedure TfrmPadrao.actFecharExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmPadrao.actNovoExecute(Sender: TObject);
begin
  limpar;
  HabilitaAba('Cadastro');
  sbStatus.Panels[0].Text := 'Inserindo';
end;

procedure TfrmPadrao.actSalvarExecute(Sender: TObject);
begin
  if sbStatus.Panels[0].Text = 'Inserindo' then
    inserir
  else
    salvar;
  HabilitaAba('Consulta');
  sbStatus.Panels[0].Text := 'Listando';
  AtualizaDataset([]);
end;

procedure TfrmPadrao.AtualizaDataset(ACampos: array of string);
begin
   //polimorfismo
end;

procedure TfrmPadrao.carregar;
begin
   //polimorfismo
end;

procedure TfrmPadrao.FormShow(Sender: TObject);
begin
  HabilitaAba('Consulta');
  sbStatus.Panels[0].Text := 'Listando';
  AtualizaDataset([]);
end;

procedure TfrmPadrao.inserir;
begin
   //polimorfismo
end;

procedure TfrmPadrao.limpar;
begin
  //polimorfismo
end;

procedure TfrmPadrao.salvar;
begin
   //polimorfismo
   limpar;
end;

end.
