unit DelphiSecureSQLDatabase.FMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, Vcl.CategoryButtons,
  DelphiSecureSQLDatabase.Interfaces, DelphiSecureSQLDatabase.MainPresenter,
  Vcl.CheckLst, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TMainForm = class(TForm, IMainView)
    cpgAlwaysEncrypted: TCategoryPanelGroup;
    cpConnection: TCategoryPanel;
    lbledtDriverID: TLabeledEdit;
    lbledtServerName: TLabeledEdit;
    lbledtDatabaseName: TLabeledEdit;
    lbledtUserName: TLabeledEdit;
    lbledtPassword: TLabeledEdit;
    chkTrustServerCertificate: TCheckBox;
    chkColumnEncryption: TCheckBox;
    btnConnect: TButton;
    cpQueryEncryptedData: TCategoryPanel;
    pnlQueryEncryptedDataButtons: TPanel;
    dbgQueryEncryptedData: TDBGrid;
    memoSELECT: TMemo;
    dsQueryEncryptedData: TDataSource;
    btnOpenQuery: TButton;
    pnlModifyEncryptedData: TPanel;
    lbledtFirstName: TLabeledEdit;
    lbledtLastName: TLabeledEdit;
    dtpBirthDate: TDateTimePicker;
    lblBirthDate: TLabel;
    lbledtSocialSecurityNumber: TLabeledEdit;
    lbledtCreditCardNumber: TLabeledEdit;
    lbledtSalary: TLabeledEdit;
    btnUpdate: TButton;
    cpUpdatableLedgerTable: TCategoryPanel;
    dsQueryUpdatableInvoices: TDataSource;
    dbgUpdatableInvoices: TDBGrid;
    pnlModifyUpdatableInvoice: TPanel;
    lbledtCustomerName: TLabeledEdit;
    lbledtInvoiceNumber: TLabeledEdit;
    dtpInvoiceDate: TDateTimePicker;
    lblInvoiceDate: TLabel;
    lbledtTotalDue: TLabeledEdit;
    btnUpdateUpdatableInvoices: TButton;
    btnOpenQueryUpdatableInvoices: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOpenQueryClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure dsQueryEncryptedDataDataChange(Sender: TObject; Field: TField);
    procedure btnOpenQueryUpdatableInvoicesClick(Sender: TObject);
    procedure dsQueryUpdatableInvoicesDataChange(Sender: TObject; Field: TField);
    procedure btnUpdateUpdatableInvoicesClick(Sender: TObject);
  private
    FSecureSQLDatabaseMainPresenter: TSecureSQLDatabaseMainPresenter;
    // View utility
    procedure SetConnection;
  public
    // Input (function) column encryption
    function GetDriverID: string;
    function GetServerName: string;
    function GetDatabaseName: string;
    function GetUserName: string;
    function GetPassword: string;
    function GetTrustServerCertificate: Boolean;
    function GetColumnEncryption: Boolean;
    function GetSELECTSQLText: string;
    function GetdsQueryEncryptedData: TDataSource;
    function GetFirstName: string;
    function GetLastName: string;
    function GetBirthDate: TDateTime;
    function GetSocialSecurityNumber: string;
    function GetCreditCardNumber: string;
    function GetSalary: Currency;
    // Input (function) ledger
    function GetSELECTUpdatableInvoicesSQLText: string;
    function GetdsUpdatableInvoices: TDataSource;
    function GetCustomerName: string;
    function GetInvoiceNumber: string;
    function GetInvoiceDate: TDateTime;
    function GetTotalDue: Currency;
    // Output (procedure) column encryption
    procedure Connect;
    procedure OpenQuery;
    procedure UpdatePerson;
    procedure DisplayFirstName(AValue: string);
    procedure DisplayLastName(AValue: string);
    procedure DisplayBirthDate(AValue: TDateTime);
    procedure DisplaySocialSecurityNumber(AValue: string);
    procedure DisplayCreditCardNumber(AValue: string);
    procedure DisplaySalary(AValue: Currency);
    // Output (procedure) ledger
    procedure UpdateUpdatableInvoice;
    procedure DisplayCustomerName(AValue: string);
    procedure DisplayInvoiceNumber(AValue: string);
    procedure DisplayInvoiceDate(AValue: TDateTime);
    procedure DisplayTotalDue(AValue: Currency);
    procedure OpenQueryUpdatableInvoices;
    // Output (procedure) general
    procedure DisplayMessage(AValue: string);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

const
  APPTITLE = 'Delphi Secure SQL Database';

{ TfrmAlwaysEncryptedMain }

procedure TMainForm.btnConnectClick(Sender: TObject);
begin
  Connect;
end;

procedure TMainForm.btnOpenQueryClick(Sender: TObject);
begin
  OpenQuery;
end;

procedure TMainForm.btnOpenQueryUpdatableInvoicesClick(
  Sender: TObject);
begin
  OpenQueryUpdatableInvoices;
end;

procedure TMainForm.btnUpdateClick(Sender: TObject);
begin
  UpdatePerson;
end;

procedure TMainForm.btnUpdateUpdatableInvoicesClick(Sender: TObject);
begin
  UpdateUpdatableInvoice;
end;

procedure TMainForm.Connect;
begin
  FSecureSQLDatabaseMainPresenter.Connect;
end;

procedure TMainForm.DisplayCreditCardNumber(
  AValue: string);
begin
  lbledtCreditCardNumber.Text := AValue;
end;

procedure TMainForm.DisplayCustomerName(AValue: string);
begin
  lbledtCustomerName.Text := AValue;
end;

procedure TMainForm.DisplayFirstName(AValue: string);
begin
  lbledtFirstName.Text := AValue;
end;

procedure TMainForm.DisplayInvoiceDate(AValue: TDateTime);
begin
  dtpInvoiceDate.DateTime := AValue;
end;

procedure TMainForm.DisplayInvoiceNumber(AValue: string);
begin
  lbledtInvoiceNumber.Text := AValue;
end;

procedure TMainForm.DisplayBirthDate(AValue: TDateTime);
begin
  dtpBirthDate.DateTime := AValue;
end;

procedure TMainForm.DisplayLastName(AValue: string);
begin
  lbledtLastName.Text := AValue;
end;

procedure TMainForm.DisplayMessage(AValue: string);
begin
  Application.MessageBox(PChar(AValue), APPTITLE, MB_OK);
end;

procedure TMainForm.DisplaySalary(AValue: Currency);
begin
  lbledtSalary.Text := AValue.ToString();
end;

procedure TMainForm.DisplaySocialSecurityNumber(
  AValue: string);
begin
  lbledtSocialSecurityNumber.Text := AValue
end;

procedure TMainForm.DisplayTotalDue(AValue: Currency);
begin
  lbledtTotalDue.Text := AValue.ToString();
end;

procedure TMainForm.dsQueryEncryptedDataDataChange(
  Sender: TObject; Field: TField);
begin
  FSecureSQLDatabaseMainPresenter.DisplayPerson;
end;

procedure TMainForm.dsQueryUpdatableInvoicesDataChange(Sender: TObject;
  Field: TField);
begin
  FSecureSQLDatabaseMainPresenter.DisplayInvoice;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FSecureSQLDatabaseMainPresenter :=
    TSecureSQLDatabaseMainPresenter.Create(Self);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  SetConnection;
end;

function TMainForm.GetColumnEncryption: Boolean;
begin
  Result := chkColumnEncryption.Checked;
end;

function TMainForm.GetCreditCardNumber: string;
begin
  Result := lbledtCreditCardNumber.Text;
end;

function TMainForm.GetCustomerName: string;
begin
  Result := lbledtCustomerName.Text;
end;

function TMainForm.GetDatabaseName: string;
begin
  Result := lbledtDatabaseName.Text;
end;

function TMainForm.GetDriverID: string;
begin
  Result := lbledtDriverID.Text;
end;

function TMainForm.GetdsQueryEncryptedData: TDataSource;
begin
  Result := dsQueryEncryptedData;
end;

function TMainForm.GetdsUpdatableInvoices: TDataSource;
begin
  Result := dsQueryUpdatableInvoices;
end;

function TMainForm.GetFirstName: string;
begin
  Result := lbledtFirstName.Text;
end;

function TMainForm.GetInvoiceDate: TDateTime;
begin
  Result := dtpInvoiceDate.DateTime;
end;

function TMainForm.GetInvoiceNumber: string;
begin
  Result := lbledtInvoiceNumber.Text;
end;

function TMainForm.GetBirthDate: TDateTime;
begin
  Result := dtpBirthDate.DateTime;
end;

function TMainForm.GetLastName: string;
begin
  Result := lbledtLastName.Text;
end;

function TMainForm.GetPassword: string;
begin
  Result := lbledtPassword.Text;
end;

function TMainForm.GetSalary: Currency;
begin
  Result := StrToFloat(lbledtSalary.Text);
end;

function TMainForm.GetSELECTSQLText: string;
begin
  Result := memoSELECT.Text;
end;

function TMainForm.GetSELECTUpdatableInvoicesSQLText: string;
begin
  Result := 'SELECT ID, CustomerName, InvoiceNumber, InvoiceDate, TotalDue FROM [Ledger].[Updatable_Invoices]';
end;

function TMainForm.GetServerName: string;
begin
  Result := lbledtServerName.Text;
end;

function TMainForm.GetSocialSecurityNumber: string;
begin
  Result := lbledtSocialSecurityNumber.Text;
end;

function TMainForm.GetTotalDue: Currency;
begin
  Result := StrToFloat(lbledtTotalDue.Text);
end;

function TMainForm.GetTrustServerCertificate: Boolean;
begin
  Result := chkTrustServerCertificate.Checked;
end;

function TMainForm.GetUserName: string;
begin
  Result := lbledtUserName.Text;
end;

procedure TMainForm.OpenQuery;
begin
  FSecureSQLDatabaseMainPresenter.OpenQuery;
end;

procedure TMainForm.OpenQueryUpdatableInvoices;
begin
  FSecureSQLDatabaseMainPresenter.OpenQueryUpdatableInvoices;
end;

procedure TMainForm.SetConnection;
begin
  lbledtDriverID.Text := 'MSSQL';
  lbledtServerName.Text := 'decision-making';
  lbledtDatabaseName.Text := 'SecureSQLDatabase';
  lbledtUserName.Text := 'Delphi_User';
  lbledtPassword.Text := 'DelphiSecureSQLDatabase!';
end;

procedure TMainForm.UpdatePerson;
begin
  FSecureSQLDatabaseMainPresenter.UpdatePerson;
end;

procedure TMainForm.UpdateUpdatableInvoice;
begin
  FSecureSQLDatabaseMainPresenter.UpdateInvoice;
end;

end.
