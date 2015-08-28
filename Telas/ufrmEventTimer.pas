unit ufrmEventTimer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDM, uEvento, uLibrary, Vcl.ImgList,
  cxGraphics, AdvSmoothPanel, AdvSmoothExpanderPanel, Vcl.Graphics,
  AdvSmoothDock, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls, Data.DB, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.ComCtrls,
  uTarefa, uTipo;

type
  TfrmEventTimer = class(TForm)
    cximglst1: TcxImageList;
    advsmthdck1: TAdvSmoothDock;
    I_COD_TAREFA: TDBLookupComboBox;
    I_COD_EVENTO: TLabeledEdit;
    lbl1: TLabel;
    S_OBS_PARADA: TMemo;
    lbl2: TLabel;
    I_COD_TIPO: TDBLookupComboBox;
    lbl3: TLabel;
    HR_TEMPO: TLabeledEdit;
    tmr1: TTimer;
    dsTarefa: TDataSource;
    dsTipo: TDataSource;
    lbl4: TLabel;
    lbl5: TLabel;
    sbStatus: TStatusBar;
    lbl6: TLabel;
    DT_INI: TDateTimePicker;
    DT_FIN: TDateTimePicker;
    procedure tmr1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure advsmthdck1ItemClick(Sender: TObject; ItemIndex: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure limpar;
    procedure inserir;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    ATab: TEvento;
    ATabTarefa: TTarefa;
    ATabTipo:TTipo;
  public
    { Public declarations }
  end;

var
  frmEventTimer: TfrmEventTimer;
  s,m,h:Integer;

implementation

{$R *.dfm}

procedure TfrmEventTimer.advsmthdck1ItemClick(Sender: TObject;ItemIndex: Integer);
  function ValidaStart: Boolean;
  begin
    Result := True;
    if tmr1.Enabled then
    begin
      Result := False;
      Exit;
    end;
    if I_COD_TAREFA.KeyValue = -1 then
    begin
      Result := False;
      ShowMessage('Deve ser definido uma tarefa!');
    end;
  end;
  function ValidaStop: Boolean;
  begin
    Result := True;
    if tmr1.Enabled then
    begin
      Result := False;
      Exit;
    end;
    if I_COD_TIPO.KeyValue = -1 then
    begin
      ShowMessage('Deve ser definido um tipo de parada!');
      Result := False;
    end;
    if S_OBS_PARADA.Text = '' then
    begin
      ShowMessage('Deve ser informado uma observação para a parada!');
      Result := False;
    end;
  end;
begin
  case ItemIndex of
    0:begin
      if HR_TEMPO.Text = '00:00:00' then
        Exit;
      tmr1.Enabled := False;
      DT_FIN.DateTime := Now();
      I_COD_TIPO.Enabled := True;
      S_OBS_PARADA.Enabled := True;
    end;
    1:begin
      if HR_TEMPO.Text <> '00:00:00' then
        Exit;
      if ValidaStart then
      begin
        tmr1.Enabled := True;
        DT_INI.DateTime := Now();
        DT_FIN.DateTime := Now();
        I_COD_TAREFA.Enabled := False;
        I_COD_TIPO.Enabled := False;
        S_OBS_PARADA.Enabled := False;
      end;
    end;
    2:begin
      if ValidaStop then
      begin
        inserir;
        limpar;
        I_COD_TAREFA.Enabled := True;
      end;
    end;
  end;
end;

procedure TfrmEventTimer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmEventTimer.FormCreate(Sender: TObject);
begin
  ATab:= TEvento.Create;
  ATabTarefa:= TTarefa.Create;
  ATabTipo:= TTipo.Create;
end;

procedure TfrmEventTimer.FormDestroy(Sender: TObject);
begin
  ATab.Free;
  ATabTarefa.Free;
  ATabTipo.Free;
end;

procedure TfrmEventTimer.FormShow(Sender: TObject);
var
  Registros: TDataset;
begin
  tmr1.Enabled := False;
  I_COD_TIPO.Enabled := False;
  S_OBS_PARADA.Enabled := False;
  ATabTarefa.I_COD_USUARIO := DM.Usuario.I_COD_USUARIO;
  Registros := DM.Dao.ConsultaTab(ATabTarefa, ['I_COD_USUARIO']);
  //Carrega o dbloockup
  dsTarefa.DataSet := Registros;
  I_COD_TAREFA.ListSource := dsTarefa;
  I_COD_TAREFA.ListField := 'S_NOME';
  I_COD_TAREFA.KeyField := 'I_COD_TAREFA';

  Registros := DM.Dao.ConsultaTab(ATabTipo, []);
  //Carrega o dbloockup
  dsTipo.DataSet := Registros;
  I_COD_TIPO.ListSource := dsTipo;
  I_COD_TIPO.ListField := 'S_NOME';
  I_COD_TIPO.KeyField := 'I_COD_TIPO';
end;

procedure TfrmEventTimer.tmr1Timer(Sender: TObject);
begin
   inc(s);
   if (h = 24) then
   begin
     ShowMessage('24 horas é o máximo permitido');
     tmr1.Enabled := False;
   end;
   if (m = 60) then
   begin
     inc(h);
     m := 0;
   end;
   if (s = 60) then
   begin
     inc(m);
     s := 0;
   end;
   HR_TEMPO.Text := Format('%.2d:%.2d:%.2d',[h, m, s]);
end;

procedure TfrmEventTimer.limpar;
var i: Integer;
begin
  inherited;
  for i := frmEventTimer.ComponentCount -1 downto 0 do
  begin
    if (frmEventTimer.Components[i] is TLabeledEdit) then
       (frmEventTimer.Components[i] as TLabeledEdit).Clear;

    if (frmEventTimer.Components[i] is TMemo) then
       (frmEventTimer.Components[i] as TMemo).Clear;

    if (frmEventTimer.Components[i] is TDBLookupComboBox) then
       (frmEventTimer.Components[i] as TDBLookupComboBox).KeyValue := -1;

    if (frmEventTimer.Components[i] is TDateTimePicker) then
       (frmEventTimer.Components[i] as TDateTimePicker).DateTime := Now();
  end;
  HR_TEMPO.Text := '00:00:00';
  s:=0;
  m:=0;
  h:=0;
end;

procedure TfrmEventTimer.inserir;
var
  Registros: Integer;
begin
  try
    //DM.Dao.CarregaObjeto(ATab,0, frmEventTimer);
    ATab.I_COD_EVENTO := DM.Dao.GetID(ATab, 'I_COD_EVENTO');
    ATab.I_COD_TAREFA := I_COD_TAREFA.KeyValue;
    ATab.I_COD_TIPO := I_COD_TIPO.KeyValue;
    ATab.DT_INI := DT_INI.DateTime;
    ATab.DT_FIN := DT_FIN.DateTime;
    ATab.HR_TEMPO := StrToDateTime(HR_TEMPO.Text);
    ATab.S_OBS_PARADA := S_OBS_PARADA.Text;

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

end.
