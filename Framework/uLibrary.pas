unit uLibrary;

interface

uses System.Classes,System.SysUtils, Forms, Vcl.ExtCtrls, Vcl.StdCtrls,
Vcl.DBCtrls;

function AbreForm(aClasseForm: TComponentClass;var aForm):Boolean;

implementation

function AbreForm(aClasseForm: TComponentClass;var aForm):Boolean;
begin
  Application.CreateForm(aClasseForm,aForm);
  try
    Tform(aForm).ShowModal;
  finally
    FreeAndNil(Tform(aForm));
    Result := True;
  end;
end;

end.
