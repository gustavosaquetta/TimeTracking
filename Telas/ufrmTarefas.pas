unit ufrmTarefas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ufrmPadrao, System.Actions,
  Vcl.ActnList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.ToolWin, Data.DB, uTarefa, uUsuario, uSituacao,
  System.ImageList, Vcl.Grids, Vcl.DBGrids;

type
  TfrmTarefas = class(TfrmPadrao)
    I_COD_TAREFA: TLabeledEdit;
    lbl1: TLabel;
    S_DESCRICAO: TMemo;
    lbl2: TLabel;
    I_ESTIMATIVA: TLabeledEdit;
    I_COD_USUARIO: TDBLookupComboBox;
    lbl3: TLabel;
    dsUsuario: TDataSource;
    S_NOME: TLabeledEdit;
    I_COD_SITUACAO: TDBLookupComboBox;
    dsSituacao: TDataSource;
    S_VERSAO: TLabeledEdit;
    procedure actExcluirExecute(Sender: TObject);
    procedure actNovoExecute(Sender: TObject);
    procedure actAlterarExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure inserir; override;
    procedure salvar;  override;
    procedure carregar; override;
    procedure limpar; override;
    procedure AtualizaDataset(ACampos: array of string); override;
  private
    { Private declarations }
    ATab: TTarefa;
    ATabUser: TUsuario;
    ATabSituacao:TSituacao;
  public
    { Public declarations }
  end;

var
  frmTarefas: TfrmTarefas;

implementation

{$R *.dfm}

uses uDM;

procedure TfrmTarefas.limpar;
var i: Integer;
begin
  inherited;
  for i := frmTarefas.ComponentCount -1 downto 0 do
  begin
    if (frmTarefas.Components[i] is TLabeledEdit) then
       (frmTarefas.Components[i] as TLabeledEdit).Clear;

    if (frmTarefas.Components[i] is TMemo) then
       (frmTarefas.Components[i] as TMemo).Clear;

    if (frmTarefas.Components[i] is TDBLookupComboBox) then
       (frmTarefas.Components[i] as TDBLookupComboBox).KeyValue := -1;
  end;
end;

procedure TfrmTarefas.carregar;
begin
  inherited;
  ATab.I_COD_TAREFA := dsConsulta.DataSet.FieldByName('I_COD_TAREFA').AsInteger;
  DM.Dao.Buscar(ATab);
  DM.Dao.CarregaObjeto(ATab,1,frmTarefas);
end;

procedure TfrmTarefas.actNovoExecute(Sender: TObject);
begin
  inherited;
  S_NOME.SetFocus;
end;

procedure TfrmTarefas.salvar;
var
  Registros: Integer;
begin
  try
    DM.Dao.CarregaObjeto(ATab,0,frmTarefas);

    DM.Transacao.StartTransaction;
    try
      Registros := DM.Dao.Salvar(ATab);

      DM.Transacao.Commit;

      sbStatus.Panels[0].Text := Format('Registro alterado: %d', [Registros]);
    except
      on E: Exception do
      begin
        if DM.Transacao.InTransaction then
          DM.Transacao.RollBack;
        ShowMessage('Ocorreu um problema ao executar operação: ' + e.Message);
      end;
    end;
  finally
    //
  end;
end;

procedure TfrmTarefas.inserir;
var
  Registros: Integer;
begin
  try
    DM.Dao.CarregaObjeto(ATab,0, frmTarefas);

    DM.Transacao.StartTransaction;
    try
      Registros := DM.Dao.Inserir(ATab);

      DM.Transacao.Commit;
      sbStatus.Panels[0].Text := Format('Registro inserido: %d', [Registros]);
    except
      on E: Exception do
      begin
        if DM.Transacao.InTransaction then
          DM.Transacao.RollBack;
        ShowMessage('Ocorreu um problema ao executar operação: ' + e.Message);
      end;
    end;
  finally
    //
  end;
end;

procedure TfrmTarefas.AtualizaDataset(ACampos: array of string);
var
  Registros: TDataset;
begin
  inherited;
  Registros := DM.Dao.ConsultaTab(ATab, ACampos);
  dsConsulta.DataSet := Registros;
  sbStatus.Panels[1].Text := 'Registros no DataSet: ' + IntToStr(Registros.RecordCount);
end;

procedure TfrmTarefas.FormCreate(Sender: TObject);
var
  Registros: TDataset;
begin
  inherited;
  ATab := TTarefa.Create;
  ATabUser := TUsuario.Create;
  Registros := DM.Dao.ConsultaTab(ATabUser, []);
  //Carrega o dbloockup
  dsUsuario.DataSet := Registros;
  I_COD_USUARIO.ListSource := dsUsuario;
  I_COD_USUARIO.ListField := 'S_NOME';
  I_COD_USUARIO.KeyField := 'I_COD_USUARIO';

  ATabSituacao := TSituacao.Create;
  Registros := DM.Dao.ConsultaTab(ATabSituacao, []);
  //Carrega o dbloockup
  dsSituacao.DataSet := Registros;
  I_COD_SITUACAO.ListSource := dsSituacao;
  I_COD_SITUACAO.ListField := 'S_NOME';
  I_COD_SITUACAO.KeyField := 'I_COD_SITUACAO';
end;

procedure TfrmTarefas.FormDestroy(Sender: TObject);
begin
  inherited;
  ATab.Free;
  ATabUser.Free;
  ATabSituacao.Free;
end;

procedure TfrmTarefas.actAlterarExecute(Sender: TObject);
begin
  inherited;
  S_NOME.SetFocus;
end;

procedure TfrmTarefas.actExcluirExecute(Sender: TObject);
var
  Registros: Integer;
begin
  inherited;
  ATab.I_COD_TAREFA := dsConsulta.DataSet.FieldByName('I_COD_TAREFA').AsInteger;
  DM.Transacao.StartTransaction;
  try
    Registros := DM.Dao.Excluir(ATab);

    DM.Transacao.Commit;

    sbStatus.Panels[1].Text := Format('Registro excluido: %d', [Registros]);

    AtualizaDataset([]);
  except
    on E: Exception do
    begin
      if DM.Transacao.InTransaction then
        DM.Transacao.RollBack;
      ShowMessage('Ocorreu um problema ao executar operação: ' + e.Message);
    end;
  end;
end;

end.
