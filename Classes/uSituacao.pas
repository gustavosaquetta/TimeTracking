unit uSituacao;

interface

uses PrsBase, PrsAtributos;

Type
  [AttTabela('SITUACAO')]
  TSituacao = class (TTabela)
  private
    FS_NOME: String;
    FI_COD_SITUACAO: Integer;
    procedure SetI_COD_SITUACAO(const Value: Integer);
    procedure SetS_NOME(const Value: String);
  public
    [AttPK]
    [AttNotNull('Código da Situação')]
    property I_COD_SITUACAO:Integer read FI_COD_SITUACAO write SetI_COD_SITUACAO;
    property S_NOME:String read FS_NOME write SetS_NOME;
  end;

implementation

{ TSituacao }

procedure TSituacao.SetI_COD_SITUACAO(const Value: Integer);
begin
  FI_COD_SITUACAO := Value;
end;

procedure TSituacao.SetS_NOME(const Value: String);
begin
  FS_NOME := Value;
end;

end.
