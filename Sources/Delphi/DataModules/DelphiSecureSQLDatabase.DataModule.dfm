object DM: TDM
  Height = 449
  Width = 673
  PixelsPerInch = 144
  object FDConnection: TFDConnection
    Left = 96
    Top = 24
  end
  object FDQrySelectEncryptedData: TFDQuery
    AutoCalcFields = False
    Connection = FDConnection
    Left = 412
    Top = 40
  end
  object FDQryUpdateEncryptedData: TFDQuery
    Connection = FDConnection
    Left = 96
    Top = 120
  end
  object FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink
    Left = 96
    Top = 228
  end
  object FDQrySelectUpdatableInvoices: TFDQuery
    Connection = FDConnection
    Left = 412
    Top = 160
  end
end
