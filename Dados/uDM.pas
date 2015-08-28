unit uDM;

interface

uses
  System.SysUtils, System.Classes, PrsDaoFDB, FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Stan.Intf, FireDAC.Phys,
  FireDAC.Phys.IBBase, FireDAC.Phys.FB, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uUsuario, inifiles, Vcl.Forms;

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
  function ConexaoBD(Arquivo : String): String;

var
  DM: TDM;
  gsLocalBD: string;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function ConexaoBD(Arquivo : String): String;
var
  vArqIni  : TiniFile;
  Aplicativo, Caminho, ArqGdb, conexao: String;
begin
  Aplicativo := Arquivo;
  ArqGdb     := '\Dados\TIMETRACKING.FDB';
  Caminho    := ExtractFilePath(Application.ExeName);

  if not(fileexists( Caminho + Aplicativo + '.Ini')) then
    begin
      Conexao := Caminho + ArqGdb;
      vArqIni := TIniFile.Create(Caminho + Aplicativo +  '.Ini');
      try
        vArqIni.WriteString('SERVIDOR', 'Servidor',Conexao);
      finally
        vArqIni.Free;
      end;
    end
  else
  begin
    vArqIni   := TIniFile.Create(Caminho + Aplicativo +  '.Ini');
    try
      Conexao := vArqIni.ReadString('SERVIDOR', 'Servidor', '');
    finally
      vArqIni.Free;
    end;
  end;
  Result := conexao;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  // configuração da conexão - utilizando IBX
  Conexao := TConexaoFDB.Create;
  Transacao := TTransacaoFDB.Create(Conexao.Database);

  with Conexao do
  begin
    LocalBD := ConexaoBD('TIMETRACKING');
    Usuario := 'sysdba';
    Senha   := 'masterkey';
    Conecta;
  end;

  Dao := TDaoFDB.Create(Conexao, Transacao);
  usuario:= TUsuario.Create;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  Usuario.Free;
  Transacao.Free;
  Conexao.Free;
  Dao.Free;
end;

end.
