unit DelphiSecureSQLDatabase.UpdatableInvoice.ActiveRecord;

interface

uses
  DelphiSecureSQLDatabase.Base.ActiveRecord, System.Generics.Collections,
  FireDAC.Comp.Client;

type

  TUpdatableInvoices = class;

  TUpdatableInvoiceActiveRecord = class(TBaseActiveRecord)
  const
    SQL_INSERT =
      'INSERT INTO [Ledger].[Updatable_Invoices] ' +
      '(CustomerName, InvoiceNumber, InvoiceDate, TotalDue) ' +
      'VALUES ' +
      '(:CustomerName, :InvoiceNumber, :InvoiceDate, :TotalDue)';
    SQL_UPDATE =
      'UPDATE [Ledger].[Updatable_Invoices] SET ' +
        'CustomerName = :CustomerName ' +
        ',InvoiceNumber = :InvoiceNumber ' +
        ',InvoiceDate = :InvoiceDate ' +
        ',TotalDue = :TotalDue ' +
      'WHERE ' +
        '(ID = :ID)';
    SQL_FIND_ALL =
      'SELECT ID, CustomerName, InvoiceNumber, InvoiceDate, TotalDue FROM [Ledger].[Updatable_Invoices]';
    SQL_FIND_BY_PK =
      'SELECT ID, CustomerName, InvoiceNumber, InvoiceDate, TotalDue FROM [Ledger].[Updatable_Invoices] WHERE (ID = %d)';
    SQL_DELETE =
      'DELETE FROM [Ledger].[Updatable_Invoices] WHERE (ID = %d)';
    SQL_DELETE_ALL =
      'DELETE FROM [Ledger].[Updatable_Invoices]';
  private
    FTotalDue: Currency;
    FCustomerName: string;
    FInvoiceNumber: string;
    FID: Integer;
    FInvoiceDate: TDateTime;
    procedure SetCustomerName(const Value: string);
    procedure SetInvoiceDate(const Value: TDateTime);
    procedure SetInvoiceNumber(const Value: string);
    procedure SetTotalDue(const Value: Currency);
  private
    class function LoadUpdatableInvoice(AReader: TFDAdaptedDataSet): TUpdatableInvoiceActiveRecord;
    class function FillUpdatableInvoiceList(const ASQL: string): TUpdatableInvoices;
  public
    class function Get(AID: Integer): TUpdatableInvoiceActiveRecord;
    class function GetAll: TUpdatableInvoices;
    class procedure DeleteAll;
    // A procedure for each DML command
    procedure Insert;
    procedure Update;
    procedure Delete;
    // A propery for each field
    property ID: Integer read FID;
    property CustomerName: string read FCustomerName write SetCustomerName;
    property InvoiceNumber: string read FInvoiceNumber write SetInvoiceNumber;
    property InvoiceDate: TDateTime read FInvoiceDate write SetInvoiceDate;
    property TotalDue: Currency read FTotalDue write SetTotalDue;
  end;

  TUpdatableInvoices = class(TObjectList<TUpdatableInvoiceActiveRecord>);

implementation

uses
  DelphiSecureSQLDatabase.DataModule, System.SysUtils, Data.DB, FireDAC.Stan.Param;


{ TUpdatableInvoicesActiveRecord }

procedure TUpdatableInvoiceActiveRecord.Delete;
begin

end;

class procedure TUpdatableInvoiceActiveRecord.DeleteAll;
begin

end;

class function TUpdatableInvoiceActiveRecord.FillUpdatableInvoiceList(
  const ASQL: string): TUpdatableInvoices;
var
  LQry: TFDQuery;
begin
  Result := TUpdatableInvoices.Create(True);
  LQry := TFDQuery.Create(nil);

  try
    LQry.Connection := DM.FDConnection;
    LQry.SQL.Text := ASQL;
    LQry.Open();

    while (not LQry.Eof) do
    begin
      Result.Add(LoadUpdatableInvoice(LQry));
      LQry.Next;
    end;

  finally
    LQry.Free;
  end;
end;

class function TUpdatableInvoiceActiveRecord.Get(
  AID: Integer): TUpdatableInvoiceActiveRecord;
var
  LQry: TFDQuery;
begin
  result := nil;

  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := DM.FDConnection;
    LQry.SQL.Text := Format(SQL_FIND_BY_PK, [AID]);
    LQry.Open();
    if (not LQry.Eof) then
      result := LoadUpdatableInvoice(LQry);
  finally
    LQry.Free;
  end;
end;

class function TUpdatableInvoiceActiveRecord.GetAll: TUpdatableInvoices;
begin
  Result := FillUpdatableInvoiceList(SQL_FIND_ALL);
end;

procedure TUpdatableInvoiceActiveRecord.Insert;
begin

end;

class function TUpdatableInvoiceActiveRecord.LoadUpdatableInvoice(
  AReader: TFDAdaptedDataSet): TUpdatableInvoiceActiveRecord;
begin
  result := TUpdatableInvoiceActiveRecord.Create;

  result.FID := AReader.Fields[0].AsInteger;
  result.FCustomerName := AReader.Fields[1].AsString;
  result.FInvoiceNumber := AReader.Fields[2].AsString;
  result.FInvoiceDate := AReader.Fields[3].AsDateTime;
  result.FTotalDue := AReader.Fields[4].AsCurrency;
end;

procedure TUpdatableInvoiceActiveRecord.SetCustomerName(const Value: string);
begin
  FCustomerName := Value;
end;

procedure TUpdatableInvoiceActiveRecord.SetInvoiceDate(const Value: TDateTime);
begin
  FInvoiceDate := Value;
end;

procedure TUpdatableInvoiceActiveRecord.SetInvoiceNumber(const Value: string);
begin
  FInvoiceNumber := Value;
end;

procedure TUpdatableInvoiceActiveRecord.SetTotalDue(const Value: Currency);
begin
  FTotalDue := Value;
end;

procedure TUpdatableInvoiceActiveRecord.Update;
var
  LQry: TFDQuery;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := DM.FDConnection;
    LQry.SQL.Text := SQL_UPDATE;

    LQry.ParamByName('CustomerName').DataType := ftString;

    LQry.ParamByName('InvoiceNumber').DataType := ftString;
    LQry.ParamByName('InvoiceDate').DataType := ftDate;
    LQry.ParamByName('TotalDue').DataType := ftCurrency;
    LQry.ParamByName('ID').DataType := ftInteger;

    LQry.Prepare;

    LQry.ParamByName('CustomerName').AsString := CustomerName;
    LQry.ParamByName('InvoiceNumber').AsString := InvoiceNumber;
    LQry.ParamByName('InvoiceDate').AsDate := InvoiceDate;
    LQry.ParamByName('TotalDue').AsCurrency := TotalDue;
    LQry.ParamByName('ID').AsInteger := ID;

    LQry.ExecSQL;
  finally
    LQry.free
  end;

end;

end.
