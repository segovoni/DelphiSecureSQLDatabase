------------------------------------------------------------------------
-- Project:      Delphi Secure SQL Database!                          --
--                                                                    --
-- Script:       Setup databases (reset DB)                           --
-- Author:       Sergio Govoni                                        --
-- Notes:        --                                                   --
------------------------------------------------------------------------

USE [master];
GO

-- Drop sample database
IF (DB_ID('SecureSQLDatabase') IS NOT NULL)
BEGIN
  ALTER DATABASE [SecureSQLDatabase]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

  DROP DATABASE [SecureSQLDatabase];
END;
GO

-- Create login with SID
IF EXISTS (SELECT principal_id FROM sys.sql_logins WHERE name = 'Delphi_User')
  DROP LOGIN [Delphi_User];

CREATE LOGIN [Delphi_User] WITH
  PASSWORD = 'DelphiSecureSQLDatabase!'
  ,SID = 0x7427B4ADC1F5F041AAD461C29DCDA151;

SELECT
  [name]
  ,principal_id
  ,[sid]
  ,[type_desc]
FROM
  sys.sql_logins
WHERE [name] = 'Delphi_User';
GO

CREATE DATABASE [SecureSQLDatabase]
 ON  PRIMARY 
 (
   NAME = N'SecureSQLDatabase'
   ,FILENAME = N'C:\SQL\DBs\SecureSQLDatabase.mdf'
   ,SIZE = 8192KB
   ,FILEGROWTH = 65536KB
 )
 LOG ON 
 (
   NAME = N'SecureSQLDatabase_log'
   ,FILENAME = N'C:\SQL\DBs\SecureSQLDatabase_log.ldf'
   ,SIZE = 8192KB
   ,FILEGROWTH = 65536KB
  )
GO

USE [SecureSQLDatabase];
GO

CREATE TABLE dbo.Persons
(
  ID INTEGER IDENTITY(1, 1) NOT NULL
  ,FirstName NVARCHAR(16) NOT NULL
  ,LastName NVARCHAR(16) NOT NULL
  ,BirthDate DATETIME2 NOT NULL
  ,SocialSecurityNumber CHAR(10) NOT NULL
   -- COLLATE Latin1_General_BIN2 NOT NULL
  ,CreditCardNumber CHAR(15)
   -- COLLATE Latin1_General_BIN2 NOT NULL
  ,Salary DECIMAL(19, 4) NOT NULL
   -- COLLATE Latin1_General_BIN2 NOT NULL
);
GO

INSERT INTO dbo.Persons
  (FirstName, LastName, BirthDate, SocialSecurityNumber, CreditCardNumber, Salary)
VALUES
  ('Rob', 'Walters', '1975-09-17 11:02:51', '1520273859', '372305256328259', 31692)
  ,('Gail', 'Erickson', '1978-09-18 15:03:55', '4520283752', '502301225345239', 40984);
GO

SELECT
  ID
  ,FirstName
  ,LastName
  ,BirthDate
  ,SocialSecurityNumber
  ,CreditCardNumber
  ,Salary
FROM
  dbo.Persons;
GO

/*  _             _                   _        _     _      
 | |    ___  __| | __ _  ___ _ __  | |_ __ _| |__ | | ___ 
 | |   / _ \/ _` |/ _` |/ _ \ '__| | __/ _` | '_ \| |/ _ \
 | |__|  __/ (_| | (_| |  __/ |    | || (_| | |_) | |  __/
 |_____\___|\__,_|\__, |\___|_|     \__\__,_|_.__/|_|\___|
                  |___/                                   
*/

CREATE SCHEMA [Ledger];
GO

-- Updatable ledger table
CREATE TABLE [Ledger].[Updatable_Invoices]
(
  ID INTEGER IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED
  ,CustomerName NVARCHAR(128) NOT NULL
  ,InvoiceNumber NVARCHAR(64) NOT NULL
  ,InvoiceDate DATE NOT NULL
  ,TotalDue DECIMAL(18, 2) NOT NULL
)
WITH
(
  SYSTEM_VERSIONING = ON
  ,LEDGER = ON
);
GO

-- Insert one row in a transaction
INSERT INTO [Ledger].[Updatable_Invoices]
(
  CustomerName
  ,InvoiceNumber
  ,InvoiceDate
  ,TotalDue
)
VALUES
(
  'Sergio Govoni'
  ,'1/A'
  ,GETDATE()
  ,100.00
);
GO

-- Insert three rows in a transaction
INSERT INTO [Ledger].[Updatable_Invoices]
(
  CustomerName
  ,InvoiceNumber
  ,InvoiceDate
  ,TotalDue
)
VALUES
(
  'Mario Rossi'
  ,'2/A'
  ,GETDATE()
  ,200.00
)
GO

SELECT * FROM [Ledger].[Updatable_Invoices];
GO

-- Ledger hidded columns must be selected esplicitly
SELECT
  [ledger_start_transaction_id]
  ,[ledger_end_transaction_id]
  ,[ledger_start_sequence_number]
  ,[ledger_end_sequence_number]
  ,*
FROM
  [Ledger].[Updatable_Invoices];
GO

-- Update values in a updatable ladger table
UPDATE
  [Ledger].[Updatable_Invoices]
SET
  TotalDue = 110.00
WHERE
  (ID = 1);
GO

-- Query ledger view
SELECT
  TS.name + '.' + T.name AS ledger_table_name
  ,HS.name + '.' + H.name AS history_table_name
  ,VS.name + '.' + VW.name AS ledger_view_name
FROM
  sys.tables AS T
JOIN
  sys.tables AS H ON H.object_id = T.history_table_id
JOIN
  sys.views AS VW ON VW.object_id = T.ledger_view_id
JOIN
  sys.schemas AS TS ON TS.schema_id = T.schema_id
JOIN
  sys.schemas AS HS ON HS.schema_id = H.schema_id
JOIN
  sys.schemas AS VS ON VS.schema_id = VW.schema_id;
GO

SELECT
  [ledger_start_transaction_id]
  ,[ledger_end_transaction_id]
  ,[ledger_start_sequence_number]
  ,[ledger_end_sequence_number]
  ,*
FROM
  [Ledger].[Updatable_Invoices];
GO

/*
SELECT * FROM Ledger.MSSQL_LedgerHistoryFor_917578307
SELECT * FROM [Ledger].[Updatable_Invoices_Ledger] ORDER BY ledger_transaction_id;
GO
*/

-- Append-only ledger table
CREATE TABLE [Ledger].[AppendOnly_Invoices]
(
  ID INTEGER IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED
  ,CustomerName NVARCHAR(128) NOT NULL
  ,InvoiceNumber NVARCHAR(64) NOT NULL
  ,InvoiceDate DATE NOT NULL
  ,TotalDue DECIMAL(18, 2) NOT NULL
)
WITH
(
  LEDGER = ON (APPEND_ONLY = ON)
);
GO

-- Insert one row in a transaction
INSERT INTO [Ledger].[AppendOnly_Invoices]
(
  CustomerName
  ,InvoiceNumber
  ,InvoiceDate
  ,TotalDue
)
VALUES
(
  'Mario Bianchi'
  ,'37/A'
  ,GETDATE()
  ,851.00
);
GO

SELECT
  *
  ,ledger_start_transaction_id
  ,ledger_start_sequence_number
FROM
  [Ledger].[AppendOnly_Invoices];
GO

/*
UPDATE
  [Ledger].[AppendOnly_Invoices]
SET 
  TotalDue = 1000
WHERE ID = 1;
*/

-- Ledger system table
SELECT * FROM sys.database_ledger_transactions;
SELECT * FROM sys.database_ledger_blocks;
SELECT * FROM sys.database_ledger_digest_locations;
GO

-- Digest
EXEC sp_generate_database_ledger_digest;
GO

/*
  ____       _            _             _     
 |  _ \ _ __(_)_ __   ___(_)_ __   __ _| |___ 
 | |_) | '__| | '_ \ / __| | '_ \ / _` | / __|
 |  __/| |  | | | | | (__| | |_) | (_| | \__ \
 |_|   |_|  |_|_| |_|\___|_| .__/ \__,_|_|___/
                           |_|                
*/

-- Create database user from login
CREATE USER [Delphi_User] FOR LOGIN [Delphi_User]
  WITH DEFAULT_SCHEMA = dbo;

EXEC sp_addrolemember 'db_datareader', 'Delphi_User';
EXEC sp_addrolemember 'db_datawriter', 'Delphi_User';

SELECT * FROM master.sys.server_principals WHERE [sid] = 0x7427B4ADC1F5F041AAD461C29DCDA151
GO

-- Database master key (CMK)
SELECT * FROM sys.column_master_keys;

-- Column encryption keys (CEK)
SELECT * FROM sys.column_encryption_keys;
GO