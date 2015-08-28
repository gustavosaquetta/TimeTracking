unit uTarefa;

interface

uses PrsBase, PrsAtributos;

Type
  [AttTabela('TAREFAS')]
  TTarefa = class (TTabela)
  private
    FI_COD_SITUACAO: Integer;
    FI_COD_TAREFA: Integer;
    FDT_INI: TDateTime;
    FI_ESTIMATIVA: Integer;
    FI_PERC_CONCLUSAO: Integer;
    FI_REALIZADO: Integer;
    FS_DESCRICAO: String;
    FI_COD_USUARIO: Integer;
    FS_NOME: String;
    FS_VERSAO: string;
    procedure SetDT_INI(const Value: TDateTime);
    procedure SetI_COD_TAREFA(const Value: Integer);
    procedure SetI_ESTIMATIVA(const Value: Integer);
    procedure SetI_PERC_CONCLUSAO(const Value: Integer);
    procedure SetI_REALIZADO(const Value: Integer);
    procedure SetS_DESCRICAO(const Value: String);
    procedure SetI_COD_SITUACAO(const Value: Integer);
    procedure SetI_COD_USUARIO(const Value: Integer);
    procedure SetS_NOME(const Value: String);
    procedure SetS_VERSAO(const Value: string);

  public
    [AttPK]
    [AttNotNull('Código da Tarefa')]
    property I_COD_TAREFA: Integer read FI_COD_TAREFA write SetI_COD_TAREFA;
    property I_COD_USUARIO: Integer read FI_COD_USUARIO write SetI_COD_USUARIO;
    property S_NOME: String read FS_NOME write SetS_NOME;
    property S_DESCRICAO: String read FS_DESCRICAO write SetS_DESCRICAO;
    [AttNotNull('Código da Situação')]
    property I_COD_SITUACAO: Integer read FI_COD_SITUACAO write SetI_COD_SITUACAO;
    property DT_INI: TDateTime read FDT_INI write SetDT_INI;
    property I_ESTIMATIVA: Integer read FI_ESTIMATIVA write SetI_ESTIMATIVA;
    property I_REALIZADO: Integer read FI_REALIZADO write SetI_REALIZADO;
    property I_PERC_CONCLUSAO: Integer read FI_PERC_CONCLUSAO write SetI_PERC_CONCLUSAO;
    property S_VERSAO: string read FS_VERSAO write SetS_VERSAO;
  end;

implementation

{ TTarefa }

procedure TTarefa.SetDT_INI(const Value: TDateTime);
begin
  FDT_INI := Value;
end;

procedure TTarefa.SetI_COD_TAREFA(const Value: Integer);
begin
  FI_COD_TAREFA := Value;
end;

procedure TTarefa.SetI_COD_USUARIO(const Value: Integer);
begin
  FI_COD_USUARIO := Value;
end;

procedure TTarefa.SetI_ESTIMATIVA(const Value: Integer);
begin
  FI_ESTIMATIVA := Value;
end;

procedure TTarefa.SetI_PERC_CONCLUSAO(const Value: Integer);
begin
  FI_PERC_CONCLUSAO := Value;
end;

procedure TTarefa.SetI_REALIZADO(const Value: Integer);
begin
  FI_REALIZADO := Value;
end;

procedure TTarefa.SetS_DESCRICAO(const Value: String);
begin
  FS_DESCRICAO := Value;
end;

procedure TTarefa.SetS_NOME(const Value: String);
begin
  FS_NOME := Value;
end;

procedure TTarefa.SetS_VERSAO(const Value: string);
begin
  FS_VERSAO := Value;
end;

procedure TTarefa.SetI_COD_SITUACAO(const Value: Integer);
begin
  FI_COD_SITUACAO := Value;
end;

end.
