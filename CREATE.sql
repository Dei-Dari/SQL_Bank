USE [BANK]
GO

--[CLIENTS] � ������� �������� �������� ���������� �� �������� �����:
--ID � ���������� ������������� (��������� ����);
--NAME � ��� �������;
--PLACE_OF_BIRTH � ����� �������� �������;
--DATE_OF_BIRTH � ���� �������� �������;
--ADDRESS � ����� ���������� �������;
--PASSPORT � ���������� ������ �������;
CREATE TABLE [CLIENTS]
(
	[ID] NUMERIC(10) IDENTITY(1,1) NOT NULL CONSTRAINT [CLIENTS_PK] PRIMARY KEY ([ID]) ,
	[NAME] NVARCHAR(100) NOT NULL CHECK ([NAME] <> ''),
	[PLACE_OF_BIRTH] NVARCHAR(100) NOT NULL,
	[DATE_OF_BIRTH] DATE NOT NULL,
	[ADDRESS] NVARCHAR(100) NOT NULL,
	[PASSPORT] VARCHAR(100) NOT NULL UNIQUE
);
GO

--[PRODUCTS] � ������� �������� ���������� � ���������, �������� ��� ������� �
--�����:
--ID � ���������� ������������� (��������� ����);
--PRODUCT_TYPE_ID � ������ �� ��� ��������;
--NAME � ������������ ��������;
--CLIENT_REF � ������ �� �������;
--OPEN_DATE � ���� �������� ��������;
--CLOSE_DATE � ���� �������� ��������;
CREATE TABLE [PRODUCTS]
(
	[ID] NUMERIC(10) IDENTITY(1,1) NOT NULL CONSTRAINT [PRODUCTS_PK] PRIMARY KEY ([ID]),
	[PRODUCT_TYPE_ID] NUMERIC(10),
	[NAME] VARCHAR(100),
	[CLIENT_REF] NUMERIC(10),
	[OPEN_DATE] DATE,
	[CLOSE_DATE] DATE
);
GO

--[PRODUCT_TYPE] - ������� �������� ���������� � ����� ���������, �������
--�������� ��� �������� �������:
--ID � ���������� ������������� (��������� ����);
--NAME � ������������ ���� ��������;
--BEGIN_DATE � ���� ������ �������� ���� ��������;
--END_DATE � ���� ��������� �������� ���� ��������;
--TARIF_REF � ������ �� �����;
CREATE TABLE [PRODUCT_TYPE]
(
	[ID] NUMERIC(10) IDENTITY(1,1) NOT NULL CONSTRAINT [PRODUCT_TYPE_PK] PRIMARY KEY ([ID]),
	[NAME] VARCHAR(100),
	[BEGIN_DATE] DATE,
	[END_DATE] DATE,
	[TARIF_REF] NUMERIC(10)
);
GO

--[ACCOUNTS] - ������� �������� ���������� � ������, �������� ��� ������� �
--�����:
--ID � ���������� ������������� (��������� ����);
--NAME � ������������ �����;
--SALDO � ������� �� �����;
--CLIENT_REF � ������ �� �������;
--OPEN_DATE � ���� �������� �����;
--CLOSE_DATE � ���� �������� �����;
--PRODUCT_REF � ������ �� �������, � ������ �������� ������ ����;
--ACC_NUM � ����� �����
CREATE TABLE [ACCOUNTS]
(
	[ID] NUMERIC(10) IDENTITY(1,1) NOT NULL CONSTRAINT [ACCOUNTS_PK] PRIMARY KEY ([ID]),
	[NAME] VARCHAR(100),
	[SALDO] NUMERIC(10,2),
	[CLIENT_REF] NUMERIC(10),
	[OPEN_DATE] DATE,
	[CLOSE_DATE] DATE,
	[PRODUCT_REF] NUMERIC(10),
	[ACC_NUM] VARCHAR(25)
);
GO

--[RECORDS] � ������� �������� ���������� ��������� �� ������:
--ID � ���������� ������������� (��������� ����);
--DT � ������� ����������� �����, ����� ��������� �������� 1 � 0, � ������
--����� �������� ����� 1 � ������� �� ����� ����������� (�����), � ������
--����� �������� ����� 0 � ������� �� ����� ������������� (������);
--ACC_REF � ������ �� ����, �� �������� ���������� ��������;
--OPER_DATE � ���� ��������;
--SUM � ����� ��������;
CREATE TABLE [RECORDS]
(
	[ID] NUMERIC(10) IDENTITY(1,1) NOT NULL CONSTRAINT [RECORDS_PK] PRIMARY KEY ([ID]),
	[DT] NUMERIC(1),
	[SUM] NUMERIC(10,2),
	[ACC_REF] NUMERIC(10),
	[OPER_DATE] DATE
);
GO

--[TARIFS] � ������� �������� ���������� � ������� �� �������� �� ������:
--ID � ���������� ������������� (��������� ����);
--NAME � ������������ ������;
--COST � ����� ������.
CREATE TABLE [TARIFS]
(
	[ID] NUMERIC(10) IDENTITY(1,1) NOT NULL CONSTRAINT [TARIFS_PK] PRIMARY KEY ([ID]),
	[NAME] VARCHAR(100),
	[COST] NUMERIC(10,2)
);
GO


-- ���������� ������� ������ � �������
ALTER TABLE [PRODUCTS]
	ADD CONSTRAINT [PROD_CL_FK] FOREIGN KEY ([CLIENT_REF]) REFERENCES [CLIENTS]([ID]),
		CONSTRAINT [PROD_PRODTYPE_FK] FOREIGN KEY ([PRODUCT_TYPE_ID]) REFERENCES [PRODUCT_TYPE]([ID])

ALTER TABLE [PRODUCT_TYPE]
	ADD CONSTRAINT [PROD_TYPE_TAR_FK] FOREIGN KEY ([TARIF_REF]) REFERENCES [TARIFS]([ID])

ALTER TABLE [ACCOUNTS]
	ADD CONSTRAINT [ACC_CL_FK] FOREIGN KEY ([CLIENT_REF]) REFERENCES [CLIENTS]([ID]),
		CONSTRAINT [ACC_PROD_FK] FOREIGN KEY ([PRODUCT_REF]) REFERENCES [PRODUCTS]([ID])

ALTER TABLE [RECORDS]
	ADD CONSTRAINT [REC_ACC_FK] FOREIGN KEY ([ACC_REF]) REFERENCES [ACCOUNTS]([ID])

GO

-- ���������� �����������
ALTER TABLE [PRODUCTS]
	ADD CONSTRAINT [CK__PRODUCTS__CLOSE_DATE] CHECK ([CLOSE_DATE] >= [OPEN_DATE])

ALTER TABLE [PRODUCT_TYPE]
	ADD CONSTRAINT [CK__PRODUCT_TYPE__END_DATE] CHECK ([END_DATE] >= [BEGIN_DATE])

ALTER TABLE [ACCOUNTS]
	ADD CONSTRAINT [CK__ACCOUNTS__CLOSE_DATE] CHECK ([CLOSE_DATE] >= [OPEN_DATE])
