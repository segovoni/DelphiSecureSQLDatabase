program DelphiSecureSQLDatabase;

uses
  Vcl.Forms,
  DelphiSecureSQLDatabase.DataModule in 'DataModules\DelphiSecureSQLDatabase.DataModule.pas' {DM: TDataModule},
  DelphiSecureSQLDatabase.Interfaces in 'Interfaces\DelphiSecureSQLDatabase.Interfaces.pas',
  DelphiSecureSQLDatabase.Base.ActiveRecord in 'Models\DelphiSecureSQLDatabase.Base.ActiveRecord.pas',
  DelphiSecureSQLDatabase.Person.ActiveRecord in 'Models\DelphiSecureSQLDatabase.Person.ActiveRecord.pas',
  DelphiSecureSQLDatabase.MainPresenter in 'Presenters\DelphiSecureSQLDatabase.MainPresenter.pas',
  DelphiSecureSQLDatabase.FMain in 'Views\DelphiSecureSQLDatabase.FMain.pas' {MainForm},
  DelphiSecureSQLDatabase.UpdatableInvoice.ActiveRecord in 'Models\DelphiSecureSQLDatabase.UpdatableInvoice.ActiveRecord.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
