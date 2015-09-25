unit uDM;

interface

uses
  System.SysUtils, System.Classes, PrsDaoFDB, FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Stan.Intf, FireDAC.Phys,
  FireDAC.Phys.IBBase, FireDAC.Phys.FB, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uUsuario, inifiles, Vcl.Forms,
  FireDAC.Phys.PGDef, FireDAC.Phys.PG;

type
  TDM = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Conexao: TConexaoFDB;
    Dao: TDaoFDB;
    Transacao: TTransacaoFDB;
    Usuario: TUsuario;
  end;
  function ConexaoBD(Arquivo : String; var aslConexao: TStringList): Boolean;

var
  DM: TDM;
  //gsLocalBD: string;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function ConexaoBD(Arquivo : String; var aslConexao: TStringList): Boolean;
var
  vArqIni  : TiniFile;
  Aplicativo, Caminho: String;
begin
  Result := False;
  Aplicativo := Arquivo;
  Caminho    := ExtractFilePath(Application.ExeName);

  if not(fileexists( Caminho + Aplicativo + '.Ini')) then
    begin
      vArqIni := TIniFile.Create(Caminho + Aplicativo +  '.Ini');
      try
        vArqIni.WriteString('DATABASE', 'Servidor','localhost');
        vArqIni.WriteString('DATABASE', 'Porta','5432');
        vArqIni.WriteString('DATABASE', 'Banco','timetracking');
        aslConexao.Add('localhost');
        aslConexao.Add('5432');
        aslConexao.Add('timetracking');
      finally
        vArqIni.Free;
      end;
    end
  else
  begin
    vArqIni   := TIniFile.Create(Caminho + Aplicativo +  '.Ini');
    try
      aslConexao.Add(vArqIni.ReadString('DATABASE', 'Servidor', ''));
      aslConexao.Add(vArqIni.ReadString('DATABASE', 'Porta', ''));
      aslConexao.Add(vArqIni.ReadString('DATABASE', 'Banco', ''));
    finally
      vArqIni.Free;
    end;
  end;
  Result := True;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
var
  slConexao: TStringList;
begin
  // configuração da conexão - utilizando IBX
  Conexao := TConexaoFDB.Create;
  Transacao := TTransacaoFDB.Create(Conexao.Database);
  slConexao:= TStringList.Create;
  with Conexao do
  begin
    if ConexaoBD('TIMETRACKING', slConexao) then
    begin
      LocalBD := slConexao[0];
      Porta   := slConexao[1];
      Banco   := slConexao[2];
      Usuario := 'postgres';
      Senha   := 'postgres';
    end;
    Conecta;
  end;

  Dao := TDaoFDB.Create(Conexao, Transacao);
  usuario:= TUsuario.Create;
  FreeAndNil(slConexao);
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  Usuario.Free;
  Transacao.Free;
  Conexao.Free;
  Dao.Free;
end;

end.
