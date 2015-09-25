unit ufrmUsuarios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ufrmPadrao, Data.DB,
  System.Actions, Vcl.ActnList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.ToolWin, Vcl.StdCtrls, uUsuario, Vcl.Grids, Vcl.DBGrids, System.ImageList;

type
  TfrmUsuarios = class(TfrmPadrao)
    lbledtI_COD_USUARIO: TLabeledEdit;
    lbledtS_NOME: TLabeledEdit;
    lbledtS_USUARIO: TLabeledEdit;
    lbledtS_SENHA: TLabeledEdit;
    procedure inserir; override;
    procedure salvar;  override;
    procedure carregar; override;
    procedure limpar; override;
    procedure AtualizaDataset(ACampos: array of string); override;
    procedure actNovoExecute(Sender: TObject);
    procedure actAlterarExecute(Sender: TObject);
    procedure actExcluirExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    ATab: TUsuario;
  public
    { Public declarations }
  end;

var
  frmUsuarios: TfrmUsuarios;

implementation

{$R *.dfm}

uses uDM;

procedure TfrmUsuarios.limpar;
var i: Integer;
begin
  inherited;
  for i := frmUsuarios.ComponentCount -1 downto 0 do
  begin
    if (frmUsuarios.Components[i] is TLabeledEdit) then
       (frmUsuarios.Components[i] as TLabeledEdit).Clear;
  end;
end;

procedure TfrmUsuarios.carregar;
begin
  inherited;
  ATab.I_COD_USUARIO := dsConsulta.DataSet.FieldByName('I_COD_USUARIO').AsInteger;
  DM.Dao.Buscar(ATab);
  lbledtI_COD_USUARIO.Text := IntToStr(ATab.I_COD_USUARIO);
  lbledtS_NOME.Text := ATab.S_NOME;
  lbledtS_USUARIO.Text := ATab.S_USUARIO;
  lbledtS_SENHA.Text := ATab.S_SENHA;
end;

procedure TfrmUsuarios.FormCreate(Sender: TObject);
begin
  inherited;
  ATab := TUsuario.Create;
end;

procedure TfrmUsuarios.FormDestroy(Sender: TObject);
begin
  inherited;
  ATab.Free;
end;

procedure TfrmUsuarios.salvar;
var
  Registros: Integer;
begin
  try
    with ATab do
    begin
      I_COD_USUARIO := StrToInt(lbledtI_COD_USUARIO.Text);
      S_NOME        := lbledtS_NOME.Text;
      S_USUARIO     := lbledtS_USUARIO.Text;
      S_SENHA       := lbledtS_SENHA.Text;
    end;
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

procedure TfrmUsuarios.inserir;
var
  Registros: Integer;
begin
  try
    with ATab do
    begin
      I_COD_USUARIO := DM.Dao.GetID(ATab,'I_COD_USUARIO');
      S_NOME        := lbledtS_NOME.Text;
      S_USUARIO     := lbledtS_USUARIO.Text;
      S_SENHA       := lbledtS_SENHA.Text;
    end;

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

procedure TfrmUsuarios.actAlterarExecute(Sender: TObject);
begin
  inherited;
  lbledtS_NOME.SetFocus;
end;

procedure TfrmUsuarios.actExcluirExecute(Sender: TObject);
var
  Registros: Integer;
begin
  inherited;
  ATab.I_COD_USUARIO := dsConsulta.DataSet.FieldByName('I_COD_USUARIO').AsInteger;
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

procedure TfrmUsuarios.actNovoExecute(Sender: TObject);
begin
  inherited;
  lbledtS_NOME.SetFocus;
end;

procedure TfrmUsuarios.AtualizaDataset(ACampos: array of string);
var
  Registros: TDataset;
begin
  Registros := DM.Dao.ConsultaTab(ATab, ACampos);
  dsConsulta.DataSet := Registros;
  sbStatus.Panels[1].Text := 'Registros no DataSet: ' + IntToStr(Registros.RecordCount);
end;

end.
