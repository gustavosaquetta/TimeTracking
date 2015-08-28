unit uEvento;

interface

uses PrsBase, PrsAtributos;

Type
  [AttTabela('EVENTO')]
  TEvento = class (TTabela)
  private
    FI_COD_TAREFA: Integer;
    FDT_INI: TDateTime;
    FDT_FIN: TDateTime;
    FHR_TEMPO: TDateTime;
    FS_OBS_PARADA: String;
    FI_COD_EVENTO: Integer;
    FI_COD_TIPO: Integer;
    procedure SetDT_FIN(const Value: TDateTime);
    procedure SetDT_INI(const Value: TDateTime);
    procedure SetHR_TEMPO(const Value: TDateTime);
    procedure SetI_COD_EVENTO(const Value: Integer);
    procedure SetI_COD_TAREFA(const Value: Integer);
    procedure SetS_OBS_PARADA(const Value: String);
    procedure SetI_COD_TIPO(const Value: Integer);

  public
    [AttPK]
    [AttNotNull('Código da Evento')]
    property I_COD_EVENTO: Integer read FI_COD_EVENTO write SetI_COD_EVENTO;
    [AttNotNull('Código da Tarefa')]
    property I_COD_TAREFA: Integer read FI_COD_TAREFA write SetI_COD_TAREFA;
    [AttNotNull('Código do Tipo')]
    property I_COD_TIPO: Integer read FI_COD_TIPO write SetI_COD_TIPO;
    property DT_INI: TDateTime read FDT_INI write SetDT_INI;
    property DT_FIN: TDateTime read FDT_FIN write SetDT_FIN;
    property HR_TEMPO: TDateTime read FHR_TEMPO write SetHR_TEMPO;
    property S_OBS_PARADA: String read FS_OBS_PARADA write SetS_OBS_PARADA;
  end;

implementation

{ TEvento }

procedure TEvento.SetDT_FIN(const Value: TDateTime);
begin
  FDT_FIN := Value;
end;

procedure TEvento.SetDT_INI(const Value: TDateTime);
begin
  FDT_INI := Value;
end;

procedure TEvento.SetHR_TEMPO(const Value: TDateTime);
begin
  FHR_TEMPO := Value;
end;

procedure TEvento.SetI_COD_EVENTO(const Value: Integer);
begin
  FI_COD_EVENTO := Value;
end;

procedure TEvento.SetI_COD_TAREFA(const Value: Integer);
begin
  FI_COD_TAREFA := Value;
end;

procedure TEvento.SetI_COD_TIPO(const Value: Integer);
begin
  FI_COD_TIPO := Value;
end;

procedure TEvento.SetS_OBS_PARADA(const Value: String);
begin
  FS_OBS_PARADA := Value;
end;

end.
