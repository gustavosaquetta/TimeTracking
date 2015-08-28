unit uTipo;

interface

uses PrsBase, PrsAtributos;

Type
  [AttTabela('TIPO')]
  TTipo = class (TTabela)
  private
    FS_NOME: String;
    FI_COD_TIPO: Integer;
    procedure SetI_COD_TIPO(const Value: Integer);
    procedure SetS_NOME(const Value: String);
  public
    [AttPK]
    [AttNotNull('Código do Tipo')]
    property I_COD_TIPO:Integer read FI_COD_TIPO write SetI_COD_TIPO;
    property S_NOME:String read FS_NOME write SetS_NOME;
  end;

implementation

{ TTipo }

procedure TTipo.SetI_COD_TIPO(const Value: Integer);
begin
  FI_COD_TIPO := Value;
end;

procedure TTipo.SetS_NOME(const Value: String);
begin
  FS_NOME := Value;
end;

end.
