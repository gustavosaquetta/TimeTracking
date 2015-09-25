unit ufrmSituacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ufrmPadrao, Data.DB,
  System.Actions, Vcl.ActnList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.ToolWin, uSituacao, Vcl.StdCtrls, System.ImageList, Vcl.Grids, Vcl.DBGrids;

type
  TfrmSituacao = class(TfrmPadrao)
    I_COD_SITUACAO: TLabeledEdit;
    S_NOME: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actNovoExecute(Sender: TObject);
    procedure actAlterarExecute(Sender: TObject);
    procedure actExcluirExecute(Sender: TObject);
    procedure inserir; override;
    procedure salvar;  override;
    procedure carregar; override;
    procedure limpar; override;
    procedure AtualizaDataset(ACampos: array of string); override;
  private
    { Private declarations }
    ATab: TSituacao;
  public
    { Public declarations }
  end;

var
  frmSituacao: TfrmSituacao;

implementation

{$R *.dfm}

uses uDM;

{ TfrmSituacao }

procedure TfrmSituacao.actAlterarExecute(Sender: TObject);
begin
  inherited;
  S_NOME.SetFocus;
end;

procedure TfrmSituacao.actExcluirExecute(Sender: TObject);
var
  Registros: Integer;
begin
  inherited;
  ATab.I_COD_SITUACAO := dsConsulta.DataSet.FieldByName('I_COD_SITUACAO').AsInteger;
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

procedure TfrmSituacao.actNovoExecute(Sender: TObject);
begin
  inherited;
  S_NOME.SetFocus;
end;

procedure TfrmSituacao.AtualizaDataset(ACampos: array of string);
var
  Registros: TDataset;
begin
  inherited;
  Registros := DM.Dao.ConsultaTab(ATab, ACampos);
  dsConsulta.DataSet := Registros;
  sbStatus.Panels[1].Text := 'Registros no DataSet: ' + IntToStr(Registros.RecordCount);
end;

procedure TfrmSituacao.carregar;
begin
  inherited;
  ATab.I_COD_SITUACAO := dsConsulta.DataSet.FieldByName('I_COD_SITUACAO').AsInteger;
  DM.Dao.Buscar(ATab);
  DM.Dao.CarregaObjeto(ATab,1,frmSituacao);
end;

procedure TfrmSituacao.FormCreate(Sender: TObject);
begin
  inherited;
  ATab := TSituacao.Create;
end;

procedure TfrmSituacao.FormDestroy(Sender: TObject);
begin
  inherited;
  ATab.Free;
end;

procedure TfrmSituacao.inserir;
var
  Registros: Integer;
begin
  try
    DM.Dao.CarregaObjeto(ATab,0, frmSituacao);

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

procedure TfrmSituacao.limpar;
var i: Integer;
begin
  inherited;
  for i := frmSituacao.ComponentCount -1 downto 0 do
  begin
    if (frmSituacao.Components[i] is TLabeledEdit) then
       (frmSituacao.Components[i] as TLabeledEdit).Clear;
  end;
end;

procedure TfrmSituacao.salvar;
var
  Registros: Integer;
begin
  try
    DM.Dao.CarregaObjeto(ATab,0,frmSituacao);

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

end.
