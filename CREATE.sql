USE [BANK]
GO

--[CLIENTS] – таблица содержит основную информацию по клиентам Банка:
--ID – уникальный идентификатор (первичный ключ);
--NAME – ФИО клиента;
--PLACE_OF_BIRTH – место рождения клиента;
--DATE_OF_BIRTH – дата рождения клиента;
--ADDRESS – адрес проживания клиента;
--PASSPORT – паспортные данные клиента;
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

--[PRODUCTS] – таблица содержит информацию о продуктах, открытых для клиента в
--Банке:
--ID – уникальный идентификатор (первичный ключ);
--PRODUCT_TYPE_ID – ссылка на тип продукта;
--NAME – наименование продукта;
--CLIENT_REF – ссылка на клиента;
--OPEN_DATE – дата открытия продукта;
--CLOSE_DATE – дата закрытия продукта;
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

--[PRODUCT_TYPE] - таблица содержит информацию о типах продуктов, которые
--доступны для открытия клиенту:
--ID – уникальный идентификатор (первичный ключ);
--NAME – наименование типа продукта;
--BEGIN_DATE – дата начала действия типа продукта;
--END_DATE – дата окончания действия типа продукта;
--TARIF_REF – ссылка на тариф;
CREATE TABLE [PRODUCT_TYPE]
(
	[ID] NUMERIC(10) IDENTITY(1,1) NOT NULL CONSTRAINT [PRODUCT_TYPE_PK] PRIMARY KEY ([ID]),
	[NAME] VARCHAR(100),
	[BEGIN_DATE] DATE,
	[END_DATE] DATE,
	[TARIF_REF] NUMERIC(10)
);
GO

--[ACCOUNTS] - таблица содержит информацию о счетах, открытых для клиента в
--Банке:
--ID – уникальный идентификатор (первичный ключ);
--NAME – наименование счета;
--SALDO – остаток по счету;
--CLIENT_REF – ссылка на клиента;
--OPEN_DATE – дата открытия счета;
--CLOSE_DATE – дата закрытия счета;
--PRODUCT_REF – ссылка на продукт, в рамках которого открыт счет;
--ACC_NUM – номер счета
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

--[RECORDS] – таблица содержит информацию операциях по счетам:
--ID – уникальный идентификатор (первичный ключ);
--DT – признак дебетования счета, может принимать значения 1 и 0, в случае
--когда значение равно 1 – остаток по счету уменьшается (дебет), в случае
--когда значение равно 0 – остаток по счету увеличивается (кредит);
--ACC_REF – ссылка на счет, по которому происходит движение;
--OPER_DATE – дата операции;
--SUM – сумма операции;
CREATE TABLE [RECORDS]
(
	[ID] NUMERIC(10) IDENTITY(1,1) NOT NULL CONSTRAINT [RECORDS_PK] PRIMARY KEY ([ID]),
	[DT] NUMERIC(1),
	[SUM] NUMERIC(10,2),
	[ACC_REF] NUMERIC(10),
	[OPER_DATE] DATE
);
GO

--[TARIFS] – таблица содержит информацию о тарифах за операции по счетам:
--ID – уникальный идентификатор (первичный ключ);
--NAME – наименование тарифа;
--COST – сумма тарифа.
CREATE TABLE [TARIFS]
(
	[ID] NUMERIC(10) IDENTITY(1,1) NOT NULL CONSTRAINT [TARIFS_PK] PRIMARY KEY ([ID]),
	[NAME] VARCHAR(100),
	[COST] NUMERIC(10,2)
);
GO


-- Добавление внешних ключей в таблицы
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

-- Добавление ограничений
ALTER TABLE [PRODUCTS]
	ADD CONSTRAINT [CK__PRODUCTS__CLOSE_DATE] CHECK ([CLOSE_DATE] >= [OPEN_DATE])

ALTER TABLE [PRODUCT_TYPE]
	ADD CONSTRAINT [CK__PRODUCT_TYPE__END_DATE] CHECK ([END_DATE] >= [BEGIN_DATE])

ALTER TABLE [ACCOUNTS]
	ADD CONSTRAINT [CK__ACCOUNTS__CLOSE_DATE] CHECK ([CLOSE_DATE] >= [OPEN_DATE])
