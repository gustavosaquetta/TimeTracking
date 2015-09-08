unit PrsDaoFDB;

interface

uses Db, PrsBase, Rtti, PrsAtributos, system.SysUtils, system.Classes,
  system.Generics.Collections,FireDAC.Comp.UI, FireDAC.Phys.IBBase, FireDAC.Phys.FB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.VCLUI.Wait,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.DBCtrls,Vcl.ComCtrls;

type
  TTransacaoFDB = class(TTransacaoBase)
  private
    // transação para crud
    FTransaction: TFDTransaction;

  public
    constructor Create(ABanco: TFDConnection);
    destructor Destroy; override;

    function InTransaction: Boolean; override;
    procedure Snapshot;
    procedure Read_Commited;
    procedure StartTransaction; override;
    procedure Commit; override;
    procedure RollBack; override;

    property Transaction: TFDTransaction read FTransaction write FTransaction;
  end;

  TConexaoFDB = class(TConexaoBase)
  private
    // conexao com o banco de dados
    FDatabase: TFDConnection;
    // transação para consultas
    FTransQuery: TFDTransaction;
    FPhysFBDriverLink: TFDPhysFBDriverLink;
  public
    constructor Create();
    destructor Destroy; override;

    function Conectado: Boolean; override;

    procedure Conecta; override;

    property Database: TFDConnection read FDatabase write FDatabase;
    property TransQuery: TFDTransaction read FTransQuery write FTransQuery;
  end;

  TDaoFDB = class(TDaoBase)
  private
    FConexao: TConexaoFDB;
    // query para execução dos comandos crud
    Qry: TFDQuery;

    Function DbToTabela<T: TTabela>(ATabela: TTabela; ADataSet: TDataSet)
      : TObjectList<T>;
  protected
    // métodos responsáveis por setar os parâmetros
    procedure QryParamInteger(ARecParams: TRecParams); override;
    procedure QryParamString(ARecParams: TRecParams); override;
    procedure QryParamDate(ARecParams: TRecParams); override;
    procedure QryParamCurrency(ARecParams: TRecParams); override;
    procedure QryParamVariant(ARecParams: TRecParams); override;

    // métodos para setar os variados tipos de campos
    procedure SetaCamposInteger(ARecParams: TRecParams); override;
    procedure SetaCamposString(ARecParams: TRecParams); override;
    procedure SetaCamposDate(ARecParams: TRecParams); override;
    procedure SetaCamposCurrency(ARecParams: TRecParams); override;

    function ExecutaQuery: Integer; override;
  public
    constructor Create(AConexao: TConexaoFDB; ATransacao: TTransacaoFDB);
    destructor Destroy; override;

    // dataset para as consultas
    function ConsultaSql(ASql: string): TDataSet; override;
    function ConsultaTab(ATabela: TTabela; ACampos: array of string)
      : TDataSet; override;
    function ConsultaGen<T: TTabela>(ATabela: TTabela; ACampos: array of string)
      : TObjectList<T>;

    // pega campo autoincremento
    function GetID(ATabela: TTabela): Integer; override;
    function GetMax(ATabela: TTabela; ACampo: string): Integer; overload;
    function GetMax(ATabela: TTabela; ACampo,AFiltro: string): Integer; overload;

    // recordcount
    function GetRecordCount(ATabela: TTabela; ACampos: array of string)
      : Integer; override;

    // crud
    function Inserir(ATabela: TTabela): Integer; override;
    function Salvar(ATabela: TTabela): Integer; override;
    function Excluir(ATabela: TTabela): Integer; override;
    function Buscar(ATabela: TTabela): Integer; override;
    procedure CarregaObjeto(ATabela: TTabela; aTipo: Integer; var vaForm);
  end;

implementation

uses Vcl.forms, dialogs, system.TypInfo;

{ TTransFDB }

constructor TTransacaoFDB.Create(ABanco: TFDConnection);
begin
  inherited Create;

  FTransaction := TFDTransaction.Create(Application);
  with FTransaction do
  begin
    Connection := ABanco;
    Read_Commited;
  end;
end;

destructor TTransacaoFDB.Destroy;
begin
  inherited;
end;

function TTransacaoFDB.InTransaction: Boolean;
begin
  Result := FTransaction.Connection.InTransaction;
end;

procedure TTransacaoFDB.Snapshot;
begin
  with FTransaction.Options do
  begin
    Params.Clear;
    Params.Add('concurrency');
    Params.Add('nowait');
  end;
end;

procedure TTransacaoFDB.StartTransaction;
begin
  if not FTransaction.Connection.InTransaction then
    FTransaction.StartTransaction;
end;

procedure TTransacaoFDB.Read_Commited;
begin
  with FTransaction.Options do
  begin
    Params.Clear;
    Params.Add('read_committed');
    Params.Add('rec_version');
    Params.Add('nowait');
  end;
end;

procedure TTransacaoFDB.RollBack;
begin
  FTransaction.RollBack;
end;

procedure TTransacaoFDB.Commit;
begin
  FTransaction.Commit;
end;

constructor TConexaoFDB.Create();
begin
  inherited Create;
  FDatabase := TFDConnection.Create(Application);
  FDatabase.DriverName := 'FB';
  FDatabase.LoginPrompt := false;
  FPhysFBDriverLink:= TFDPhysFBDriverLink.Create(Application);
end;

destructor TConexaoFDB.Destroy;
begin
  inherited;
end;

function TConexaoFDB.Conectado: Boolean;
begin
  Result := Database.Connected;
end;

procedure TConexaoFDB.Conecta;
begin
  inherited;
  with Database do
  begin
    Params.Clear;
    Params.Add('DriverID=FB');
    Params.Add('Database=' + LocalBD);
    Params.Add('user_name=' + Usuario);
    Params.Add('password=' + Senha);
    FPhysFBDriverLink.Release;
    FPhysFBDriverLink.VendorLib := 'C:\Windows\SysWOW64\fbclient.dll';
    Connected := True;
  end;
end;

{ TDaoFDB }

constructor TDaoFDB.Create(AConexao: TConexaoFDB; ATransacao: TTransacaoFDB);
var
  MeuDataSet: TFDQuery;
begin
  inherited Create;

  FConexao := AConexao;

  with FConexao do
  begin
    // configurações iniciais da transacao para consultas
    FTransQuery := TFDTransaction.Create(Application);

    with TransQuery do
    begin
      Connection := Database;
      Options.Params.Add('read_committed');
      Options.Params.Add('rec_version');
      Options.Params.Add('nowait');
    end;

    Database.Transaction := TransQuery;
  end;

  Qry := TFDQuery.Create(Application);
  Qry.Connection := FConexao.Database;
  Qry.Transaction := ATransacao.Transaction;

  MeuDataSet := TFDQuery.Create(Application);
  MeuDataSet.Connection := FConexao.Database;

  DataSet := MeuDataSet;
end;

destructor TDaoFDB.Destroy;
begin
  inherited;
end;

procedure TDaoFDB.QryParamCurrency(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    TFDQuery(Qry).ParamByName(Campo).AsCurrency := Prop.GetValue(Tabela).AsCurrency;
  end;
end;

procedure TDaoFDB.QryParamDate(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    if Prop.GetValue(Tabela).AsType<TDateTime> = 0 then
      TFDQuery(Qry).ParamByName(Campo).Clear
    else
      TFDQuery(Qry).ParamByName(Campo).AsDateTime := Prop.GetValue(Tabela).AsType<TDateTime>;
  end;
end;

procedure TDaoFDB.QryParamInteger(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    TFDQuery(Qry).ParamByName(Campo).AsInteger := Prop.GetValue(Tabela)
      .AsInteger;
  end;
end;

procedure TDaoFDB.QryParamString(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    TFDQuery(Qry).ParamByName(Campo).AsString := Prop.GetValue(Tabela).AsString;
  end;
end;

procedure TDaoFDB.QryParamVariant(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    TFDQuery(Qry).ParamByName(Campo).Value := Prop.GetValue(Tabela).AsVariant;
  end;
end;

procedure TDaoFDB.SetaCamposCurrency(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    Prop.SetValue(Tabela, TFDQuery(Qry).FieldByName(Campo).AsCurrency);
  end;
end;

procedure TDaoFDB.SetaCamposDate(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    Prop.SetValue(Tabela, TFDQuery(Qry).FieldByName(Campo).AsDateTime);
  end;
end;

procedure TDaoFDB.SetaCamposInteger(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    Prop.SetValue(Tabela, TFDQuery(Qry).FieldByName(Campo).AsInteger);
  end;
end;

procedure TDaoFDB.SetaCamposString(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    Prop.SetValue(Tabela, TFDQuery(Qry).FieldByName(Campo).AsString);
  end;
end;

function TDaoFDB.DbToTabela<T>(ATabela: TTabela; ADataSet: TDataSet)
  : TObjectList<T>;
var
  AuxValue: TValue;
  TipoRtti: TRttiType;
  Contexto: TRttiContext;
  PropRtti: TRttiProperty;
  DataType: TFieldType;
  Campo: String;
begin
  Result := TObjectList<T>.Create;

  while not ADataSet.Eof do
  begin
    AuxValue := GetTypeData(PTypeInfo(TypeInfo(T)))^.ClassType.Create;
    TipoRtti := Contexto.GetType(AuxValue.AsObject.ClassInfo);
    for PropRtti in TipoRtti.GetProperties do
    begin
      Campo := PropRtti.Name;
      DataType := ADataSet.FieldByName(Campo).DataType;

      case DataType of
        ftInteger:
          begin
            PropRtti.SetValue(AuxValue.AsObject,
              TValue.FromVariant(ADataSet.FieldByName(Campo).AsInteger));
          end;
        ftString, ftWideString, ftWideMemo:
          begin
            PropRtti.SetValue(AuxValue.AsObject,
              TValue.FromVariant(ADataSet.FieldByName(Campo).AsString));
          end;
        ftBCD, ftFloat:
          begin
            PropRtti.SetValue(AuxValue.AsObject,
              TValue.FromVariant(ADataSet.FieldByName(Campo).AsFloat));
          end;
        ftDate, ftDateTime:
          begin
            PropRtti.SetValue(AuxValue.AsObject,
              TValue.FromVariant(ADataSet.FieldByName(Campo).AsDateTime));
          end;
      else
        raise Exception.Create('Tipo de campo não conhecido: ' +
          PropRtti.PropertyType.ToString);
      end;
    end;
    Result.Add(AuxValue.AsType<T>);

    ADataSet.Next;
  end;
end;

function TDaoFDB.ConsultaGen<T>(ATabela: TTabela; ACampos: array of string)
  : TObjectList<T>;
var
  Dados: TFDQuery;
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
begin
  Dados := TFDQuery.Create(Application);
  try
    Contexto := TRttiContext.Create;
    try
      TipoRtti := Contexto.GetType(ATabela.ClassType);
      with Dados do
      begin
        Connection := FConexao.Database;
        sql.Text := GerarSqlSelect(ATabela, ACampos);

        for Campo in ACampos do
        begin
          if not PropExiste(Campo, PropRtti, TipoRtti) then
            raise Exception.Create('Campo ' + Campo + ' não existe no objeto!');

          // setando os parâmetros
          for PropRtti in TipoRtti.GetProperties do
          begin
            if CompareText(PropRtti.Name, Campo) = 0 then
            begin
              ConfiguraParametro(PropRtti, Campo, ATabela, Dados);
            end;
          end;
        end;

        Open;

        Result := DbToTabela<T>(ATabela, Dados);
      end;
    finally
      Contexto.Free;
    end;
  finally
    Dados.Free;
  end;
end;

function TDaoFDB.ConsultaSql(ASql: string): TDataSet;
var
  AQry: TFDQuery;
begin
  AQry := TFDQuery.Create(Application);
  with AQry do
  begin
    Connection := FConexao.Database;
    sql.Clear;
    sql.Add(ASql);
    Open;
  end;
  Result := AQry;
end;

function TDaoFDB.ConsultaTab(ATabela: TTabela; ACampos: array of string)
  : TDataSet;
var
  Dados: TFDQuery;
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
begin
  Dados := TFDQuery.Create(Application);
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);

    with Dados do
    begin
      Connection := FConexao.Database;
      sql.Text := GerarSqlSelect(ATabela, ACampos);

      for Campo in ACampos do
      begin
        // setando os parâmetros
        for PropRtti in TipoRtti.GetProperties do
          if CompareText(PropRtti.Name, Campo) = 0 then
          begin
            ConfiguraParametro(PropRtti, Campo, ATabela, Dados);
          end;
      end;
      Open;
      Result := Dados;
    end;
  finally
    Contexto.Free;
  end;
end;

function TDaoFDB.GetID(ATabela: TTabela): Integer;
var
  AQry: TFDQuery;
  sTextSql:String;
begin
  AQry := TFDQuery.Create(Application);
  sTextSql := Format('SELECT CAST(nextval(''seq_%s'') as numeric) as i_sequence', [PegaNomeTab(ATabela)]);
  with AQry do
  begin
    Connection := FConexao.Database;
    sql.Clear;
    //sql.Add('select max(' + ACampo + ') from ' + PegaNomeTab(ATabela));
	sql.Add(sTextSql);
    Open;
    Result := fields[0].AsInteger;
  end;
end;

function TDaoFDB.GetMax(ATabela: TTabela; ACampo, AFiltro: string): Integer;
var
  AQry: TFDQuery;
  Filtro: string;
  NumMax: Integer;
begin
  AQry := TFDQuery.Create(Application);
  try
    with AQry do
    begin
      Connection := FConexao.Database;
      sql.Clear;
      sql.Add('select max(' + ACampo + ') from ' + PegaNomeTab(ATabela) + ' where ' + Filtro);

      Open;

      NumMax := Fields[0].AsInteger;

      Result := NumMax;
    end;
  finally
    AQry.Free;
  end;
end;

function TDaoFDB.GetMax(ATabela: TTabela; ACampo: string): Integer;
var
  AQry: TFDQuery;
  NumMax: Integer;
begin
  AQry := TFDQuery.Create(Application);
  try
    with AQry do
    begin
      Connection := FConexao.Database;
      sql.Clear;
      sql.Add('select max(' + ACampo + ') from ' + PegaNomeTab(ATabela));

      Open;

      NumMax := Fields[0].AsInteger;

      Result := NumMax;
    end;
  finally
    AQry.Free;
  end;
end;

function TDaoFDB.GetRecordCount(ATabela: TTabela;
  ACampos: array of string): Integer;
var
  AQry: TFDQuery;
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
begin
  AQry := TFDQuery.Create(Application);

  with AQry do
  begin
    Contexto := TRttiContext.Create;
    try
      TipoRtti := Contexto.GetType(ATabela.ClassType);
      Connection := FConexao.Database;

      sql.Clear;

      sql.Add('select count(*) from ' + PegaNomeTab(ATabela));

      if High(ACampos) >= 0 then
        sql.Add('where 1=1');

      for Campo in ACampos do
        sql.Add('and ' + Campo + '=:' + Campo);

      for Campo in ACampos do
      begin
        for PropRtti in TipoRtti.GetProperties do
          if CompareText(PropRtti.Name, Campo) = 0 then
          begin
            ConfiguraParametro(PropRtti, Campo, ATabela, AQry);
          end;
      end;

      Open;

      Result := fields[0].AsInteger;
    finally
      Contexto.Free;
    end;
  end;
end;

function TDaoFDB.ExecutaQuery: Integer;
begin
  with Qry do
  begin
    Prepare();
    ExecSQL;
    Result := RowsAffected;
  end;
end;

function TDaoFDB.Excluir(ATabela: TTabela): Integer;
var
  Comando: TFuncReflexao;
begin
  // crio uma variável do tipo TFuncReflexao - um método anônimo
  Comando := function(ACampos: TCamposAnoni): Integer
    var
      Campo: string;
      PropRtti: TRttiProperty;
    begin
      Qry.close;
      Qry.sql.Clear;
      Qry.sql.Text := GerarSqlDelete(ATabela);
      // percorrer todos os campos da chave primária
      for Campo in PegaPks(ATabela) do
      begin
        // setando os parâmetros
        for PropRtti in ACampos.TipoRtti.GetProperties do
          if CompareText(PropRtti.Name, Campo) = 0 then
          begin
            ConfiguraParametro(PropRtti, Campo, ATabela, Qry);
          end;
      end;
      Result := ExecutaQuery;
    end;

  // reflection da tabela e execução da query preparada acima.
  Result := ReflexaoSQL(ATabela, Comando);
end;

function TDaoFDB.Inserir(ATabela: TTabela): Integer;
var
  Comando: TFuncReflexao;
begin
  try
    ValidaTabela(ATabela);

    Comando := function(ACampos: TCamposAnoni): Integer
      var
        Campo: string;
        PropRtti: TRttiProperty;
      begin
        with Qry do
        begin
          close;
          sql.Clear;
          sql.Text := GerarSqlInsert(ATabela, ACampos.TipoRtti);
          // valor dos parâmetros
          for PropRtti in ACampos.TipoRtti.GetProperties do
          begin
            Campo := PropRtti.Name;
            ConfiguraParametro(PropRtti, Campo, ATabela, Qry);
          end;
        end;
        Result := ExecutaQuery;
      end;

    // reflection da tabela e execução da query preparada acima.
    Result := ReflexaoSQL(ATabela, Comando);
  except
    raise;
  end;
end;

function TDaoFDB.Salvar(ATabela: TTabela): Integer;
var
  Comando: TFuncReflexao;
begin
  try
    ValidaTabela(ATabela);

    Comando := function(ACampos: TCamposAnoni): Integer
      var
        Campo: string;
        PropRtti: TRttiProperty;
      begin
        with Qry do
        begin
          close;
          sql.Clear;
          sql.Text := GerarSqlUpdate(ATabela, ACampos.TipoRtti);
          // valor dos parâmetros
          for PropRtti in ACampos.TipoRtti.GetProperties do
          begin
            Campo := PropRtti.Name;
            ConfiguraParametro(PropRtti, Campo, ATabela, Qry);
          end;
        end;
        Result := ExecutaQuery;
      end;

    // reflection da tabela e execução da query preparada acima.
    Result := ReflexaoSQL(ATabela, Comando);
  except
    raise;
  end;
end;

function TDaoFDB.Buscar(ATabela: TTabela): Integer;
var
  Comando: TFuncReflexao;
  Dados: TFDQuery;
begin
  Dados := TFDQuery.Create(nil);
  try
    // crio uma variável do tipo TFuncReflexao - um método anônimo
    Comando := function(ACampos: TCamposAnoni): Integer
      var
        Campo: string;
        PropRtti: TRttiProperty;
      begin
        with Dados do
        begin
          Connection := FConexao.Database;
          sql.Text := GerarSqlSelect(ATabela);

          for Campo in ACampos.PKs do
          begin
            // setando os parâmetros
            for PropRtti in ACampos.TipoRtti.GetProperties do
              if CompareText(PropRtti.Name, Campo) = 0 then
              begin
                ConfiguraParametro(PropRtti, Campo, ATabela, Dados);
              end;
          end;
          Open;
          Result := RecordCount;
          if Result > 0 then
          begin
            for PropRtti in ACampos.TipoRtti.GetProperties do
            begin
              Campo := PropRtti.Name;
              SetaDadosTabela(PropRtti, Campo, ATabela, Dados);
            end;
          end;
        end;
      end;

    // reflection da tabela e abertura da query preparada acima.
    Result := ReflexaoSQL(ATabela, Comando);
  finally
    Dados.Free;
  end;
end;

procedure TDaoFDB.CarregaObjeto(ATabela: TTabela; aTipo: Integer; var vaForm);
var
  i: Integer;
  Contexto: TRttiContext;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  Campo: string;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);
    // setando os parâmetros
    for i := Tform(vaForm).ComponentCount -1 downto 0 do
      for PropRtti in TipoRtti.GetProperties do
      begin
        if (Tform(vaForm).Components[i] is TLabeledEdit) then
          if aTipo = 0 then //0 = form / objeto, 1 = objeto / form
          begin
            if CompareText(PropRtti.Name, (Tform(vaForm).Components[i] as TLabeledEdit).Name) = 0 then
            begin
              case PropRtti.PropertyType.TypeKind of
                tkInt64, tkInteger:
                  begin
                    if (StrToIntDef((Tform(vaForm).Components[i] as TLabeledEdit).Text, 0)> 0) then
                      PropRtti.SetValue(ATabela, TValue.FromVariant(StrToInt((Tform(vaForm).Components[i] as TLabeledEdit).Text)))
                    else
                      PropRtti.SetValue(ATabela, TValue.FromVariant(GetID(ATabela)));
                  end;
                tkFloat:
                  begin
                    PropRtti.SetValue(ATabela, TValue.FromVariant(StrToFloat((Tform(vaForm).Components[i] as TLabeledEdit).Text)));
                  end;
                tkChar, tkString, tkUString:
                  begin
                    PropRtti.SetValue(ATabela, TValue.FromVariant((Tform(vaForm).Components[i] as TLabeledEdit).Text));
                  end;
              else
                raise Exception.Create('Tipo de campo não conhecido: ' + PropRtti.PropertyType.ToString);
              end;
              Break;
            end;
          end
          else
          begin
            if CompareText(PropRtti.Name, (Tform(vaForm).Components[i] as TLabeledEdit).Name) = 0 then
            begin
              case PropRtti.PropertyType.TypeKind of
                tkInt64, tkInteger:
                  begin
                    (Tform(vaForm).Components[i] as TLabeledEdit).Text := IntToStr(PropRtti.GetValue(ATabela).AsInteger);
                  end;
                tkFloat:
                  begin
                    (Tform(vaForm).Components[i] as TLabeledEdit).Text := FloatToStr(PropRtti.GetValue(ATabela).AsVariant);
                  end;
                tkChar, tkString, tkUString:
                  begin
                    (Tform(vaForm).Components[i] as TLabeledEdit).Text := PropRtti.GetValue(ATabela).AsString;
                  end;
              else
                raise Exception.Create('Tipo de campo não conhecido: ' + PropRtti.PropertyType.ToString);
              end;
              Break;
            end;
          end;
		  
        if (Tform(vaForm).Components[i] is TMemo) then
          if aTipo = 0 then //0 = form / objeto, 1 = objeto / form
          begin
            if CompareText(PropRtti.Name, (Tform(vaForm).Components[i] as TMemo).Name) = 0 then
            begin
              PropRtti.SetValue(ATabela, TValue.FromVariant((Tform(vaForm).Components[i] as TMemo).Text));
              Break;
            end;
          end
          else
          begin
            if CompareText(PropRtti.Name, (Tform(vaForm).Components[i] as TMemo).Name) = 0 then
            begin
              (Tform(vaForm).Components[i] as TMemo).Text := PropRtti.GetValue(ATabela).AsString;
              Break;
            end;
          end;
		  
        if (Tform(vaForm).Components[i] is TDBLookupComboBox) then
          if aTipo = 0 then //0 = form / objeto, 1 = objeto / form
          begin
            if CompareText(PropRtti.Name, (Tform(vaForm).Components[i] as TDBLookupComboBox).Name) = 0 then
            begin
              PropRtti.SetValue(ATabela, TValue.FromVariant((Tform(vaForm).Components[i] as TDBLookupComboBox).KeyValue));
              Break;
            end;
          end
          else
          begin
            if CompareText(PropRtti.Name, (Tform(vaForm).Components[i] as TDBLookupComboBox).Name) = 0 then
            begin
              (Tform(vaForm).Components[i] as TDBLookupComboBox).KeyValue := PropRtti.GetValue(ATabela).AsInteger;
              Break;
            end;
          end;
		  
        if (Tform(vaForm).Components[i] is TDateTimePicker) then
          if aTipo = 0 then //0 = form / objeto, 1 = objeto / form
          begin
            if CompareText(PropRtti.Name, (Tform(vaForm).Components[i] as TDateTimePicker).Name) = 0 then
            begin
              PropRtti.SetValue(ATabela, TValue.FromVariant((Tform(vaForm).Components[i] as TDateTimePicker).DateTime));
              Break;
            end;
          end
          else
          begin
            if CompareText(PropRtti.Name, (Tform(vaForm).Components[i] as TDateTimePicker).Name) = 0 then
            begin
              (Tform(vaForm).Components[i] as TDateTimePicker).DateTime := PropRtti.GetValue(ATabela).AsVariant;
              Break;
            end;
          end;
      end;
  finally
    Contexto.Free;
  end;
end;

end.
