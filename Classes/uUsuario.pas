unit uUsuario;

interface

uses PrsBase, PrsAtributos;

Type
  [AttTabela('USUARIOS')]
  TUsuario = class (TTabela)
  private
    FS_SENHA: String;
    FS_USUARIO: String;
    FS_NOME: String;
    FI_COD_USUARIO: Integer;
    procedure SetI_COD_USUARIO(const Value: Integer);
    procedure SetS_NOME(const Value: String);
    procedure SetS_SENHA(const Value: String);
    procedure SetS_USUARIO(const Value: String);
  public
    [AttPK]
    [AttNotNull('Código da Usuário')]
    property I_COD_USUARIO: Integer read FI_COD_USUARIO write SetI_COD_USUARIO;
    [AttNotNull('Nome da Usuário')]
    property S_NOME: String read FS_NOME write SetS_NOME;
    [AttNotNull('Usuário')]
    property S_USUARIO: String read FS_USUARIO write SetS_USUARIO;
    property S_SENHA: String read FS_SENHA write SetS_SENHA;
  end;

implementation

{ TUsuario }

procedure TUsuario.SetI_COD_USUARIO(const Value: Integer);
begin
  FI_COD_USUARIO := Value;
end;

procedure TUsuario.SetS_NOME(const Value: String);
begin
  FS_NOME := Value;
end;

procedure TUsuario.SetS_SENHA(const Value: String);
begin
  FS_SENHA := Value;
end;

procedure TUsuario.SetS_USUARIO(const Value: String);
begin
  FS_USUARIO := Value;
end;

end.
