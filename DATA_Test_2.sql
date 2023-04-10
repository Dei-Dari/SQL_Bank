USE [BANK]
GO


DECLARE @i INT = 0,
		@N INT = 10,
		@j INT = 0,
		@Nj INT = 10,
		@k INT = 0,
		@TestName NVARCHAR(100) = 'Name_',
		@TestAddress NVARCHAR(100) = 'Address_',
		@TestPass VARCHAR(100),
		--@TestPassSeries VARCHAR(4),
		--@TestPassNumber VARCHAR(6),
		@TestDate DATE = GETDATE(),
		@RangeYear INT = 50,
		@CurrentDate DATE = GETDATE(),
		@TestPreviousDate DATE,
		@TestProductType INT,
		@TestProductTypeName VARCHAR(100),
		@TestClientCount INT,
		@TestClientID INT,
		@TestB NVARCHAR(25) = '40817810',
		@TestBIC NVARCHAR(12) = '040000000',
		@TestExNum NVARCHAR(15) = '00000000000',
		@BankWC NVARCHAR(5) = '713',		
		@TestACC NVARCHAR(25) = '',
		@total INT = 0,
		@TestACCID NVARCHAR(9),
		@TestProductID INT,
		@TestSaldo NUMERIC(10,2),
		@TestDT NUMERIC(1) = 0,
		@TestRecordDT NUMERIC(1) = 0,
		@KEY NVARCHAR(1) = '0',
		@DT NUMERIC(1) = 0,
		@SUMOperate NUMERIC(10,2) = 0.0,
		@DTInfo VARCHAR(20) = '',
		@SUMResult NUMERIC(10,2) = 0.0,
		@LIMIT NUMERIC(10,2) = 25000.0

DECLARE @TestTable TABLE ([NN] INT, [WC] INT)


----INSERT INTO [CLIENTS] Обслуживание клиента в банке начинается с заведения карточки клиента (таблица CLIENTS),
--SET @TestPreviousDate = DATEADD(YEAR,-@RangeYear,@CurrentDate)

--WHILE (@i < @N)
--BEGIN
--	SET @TestDate = DATEADD(DAY, FLOOR(RAND()*DATEDIFF(DAY,@TestPreviousDate,@CurrentDate)),@TestPreviousDate);	
--	SET @TestPass = @i
--	--УНИКАЛЬНОСТЬ ПАСПОРТА (СЕРИЯ НОМЕР)

--	INSERT INTO [CLIENTS]
--	VALUES (@TestName + CHAR(ASCII(@i)), @TestAddress + CHAR(ASCII(@i)), @TestDate, @TestAddress + CHAR(ASCII(@i)), @TestPass)
--	SET @i = @i + 1;
--END;
--GO


----INSERT INTO [PRODUCTS] далее клиент выражает завести тот или иной продукт в банке - КРЕДИТ, ДЕПОЗИТ, КАРТА (таблица PRODUCT_TYPE) 
----После оформления документов в банке создается экземпляр продукта (таблица PRODUCTS)
--SET @i = 0
--WHILE (@i < @N)
--BEGIN
--	SET @TestProductType = 1 + RAND() * 3
--	SET @TestProductTypeName = CASE @TestProductType
--		WHEN '1' THEN 'Кредитный договор с: '
--		WHEN '2' THEN 'Депозитный договор с: '
--		WHEN '3' THEN 'Карточный договор с: '
--	END;
--	SET @TestClientID = (SELECT TOP 1 [ID] FROM [CLIENTS] ORDER BY NEWID())
--	SET @TestName = (SELECT [NAME] FROM [CLIENTS] WHERE [CLIENTS].[ID] = @TestClientID)
--	SET @TestProductTypeName = @TestProductTypeName + @TestName
--	SET @TestPreviousDate = (SELECT [BEGIN_DATE] FROM [PRODUCT_TYPE] WHERE [PRODUCT_TYPE].[ID] = @TestProductType)
--	SET @TestDate = DATEADD(DAY, FLOOR(RAND()*DATEDIFF(DAY,@TestPreviousDate,@CurrentDate)),@TestPreviousDate)
--	SET @i = @i + 1;

--	INSERT INTO [PRODUCTS] VALUES (@TestProductType, @TestProductTypeName, @TestClientID, @TestDate, NULL)
--END;


----INSERT INTO [ACCOUNTS] в рамках продукта открывается один или несколько счетов (таблица ACCOUNTS) с остатком равным 0
----Пример: 40817810099910004312, в котором 408 — означает, что это счёт физического лица, 17 — счёт резидента РФ, бессрочный, 810 — валюта рубли РФ, 0 — контрольная цифра в данном случае, 9991 — код подразделения банка (иногда - часть номера счёта), 0004312 — сам номер счёта.
----БИК 040000000
--SET @i = 1
--SET @TestB = SUBSTRING(@TestBIC,LEN(@TestBIC) - 3 + 1, 3) + @TestB
--SET @j = 1
--SET @k = 1
--SET @TestB = @TestB + @KEY
--SET @TestACC = @TestB + @TestExNum
--SET @N = (SELECT COUNT(*) FROM [PRODUCTS])



--WHILE (@i <= @N)
--BEGIN
--	SET @TestProductType = (SELECT [PRODUCT_TYPE_ID] FROM [PRODUCTS] WHERE [PRODUCTS].[ID] = @i)
--	SET @TestProductTypeName = CASE @TestProductType
--		WHEN '1' THEN 'Кредитный счет: '
--		WHEN '2' THEN 'Депозитный счет: '
--		WHEN '3' THEN 'Карточный счет: '
--	END;
--	SET @TestClientID = (SELECT [CLIENT_REF] FROM [PRODUCTS] WHERE [PRODUCTS].[ID] = @i)
--	SET @TestName = (SELECT [NAME] FROM [CLIENTS] WHERE [CLIENTS].[ID] = @TestClientID)
--	SET @TestProductTypeName = @TestProductTypeName + @TestName
--	SET @TestACCID = @TestClientID
--	SET @TestACC = SUBSTRING(@TestACC,0,LEN(@TestACC)-LEN(@TestACCID)+1) + @TestACCID

--	--KEY
--	WHILE (@j <= LEN(@TestACC))
--	BEGIN
--	  INSERT INTO @TestTable([NN],[WC]) VALUES (SUBSTRING(@TestACC, @j, 1), SUBSTRING(@BankWC,@k,1))
--	  SET @total = @total + CONVERT(INT,SUBSTRING(@TestACC, @j, 1)) * CONVERT(INT, SUBSTRING(@BankWC,@k,1))  
--	  SET @j = @j + 1
--	  IF (@k = 3) SET @k = 1
--	  ELSE SET @k = @k + 1
--	END;

--	SET @KEY = CONVERT(NVARCHAR, ((@total % 10) * 3) % 10)
--	SET @TestACC = SUBSTRING(@TestACC,0,12) + @KEY + SUBSTRING(@TestACC,13,23)
--	SET @TestACC = SUBSTRING(@TestACC,4,23)
--	SET @TestProductID = (SELECT [ID] FROM [PRODUCTS] WHERE [ID] = @i)
--	SET @TestPreviousDate = (SELECT [OPEN_DATE] FROM [PRODUCTS] WHERE [ID] = @i)
--	SET @TestDate = DATEADD(DAY, FLOOR(RAND()*DATEDIFF(DAY,@TestPreviousDate,@CurrentDate)),@TestPreviousDate)

--	INSERT INTO [ACCOUNTS] VALUES (@TestProductTypeName, 0, @TestClientID, @TestDate, NULL, @TestProductID, @TestACC)

--	DELETE FROM @TestTable
--	SET @total = 0
--	SET @j = 0
--	SET @i = @i + 1
--	SET @TestACC = @TestB + @TestExNum
--END;



--INSERT INTO [RECORDS] Далее в случае, если оформлен продукт типа КРЕДИТ по счету продукта проходит
--дебетовая операция – банк выдает деньги клиенту (в таблице RECORDS появляется запись с
--полем DT = 1 и суммой зачисления, запись в таблице RECORDS влияет на поле SALDO таблицы
--ACCOUNTS). Если оформлен продукт ДЕПОЗИТ или КАРТА по счету клиента проходит
--кредитовая операция – клиент вносит средства на счета (в таблице RECORDS появляется
--запись с полем DT = 0 и суммой зачисления, запись в таблице RECORDS влияет на поле SALDO
--таблицы ACCOUNTS).
--После чего клиент в случае, если ему открыт продукт типа КРЕДИТ, вносит средства на
--счет, погашая кредит, а если продукт типа ДЕПОЗИТ или КАРТА, может списывать средства
--со счета. После полного погашения продукта типа КРЕДИТ, выдача кредита может
--происходить снова, и клиент нужно опять осуществлять погашения. Если у клиента
--продукта типа ДЕПОЗИТ или КАРТА, клиент в любое время может внести средства.

SET @i = 4
SET @N = (SELECT COUNT(*) FROM [ACCOUNTS])	--кол-во счетов
SET @j = 1
SET @Nj = 5	--кол-во записей
INSERT INTO @TestTable SELECT row_number() OVER(ORDER BY [ID]) AS [I] , RID.[ID] AS [ACC_REF] FROM [ACCOUNTS] AS RID
--select * FROM @TestTable
DECLARE @IID INT = 1

PRINT '@N ' + CONVERT(VARCHAR, @N)
PRINT '---'

WHILE (@i <= @N)
BEGIN
	--SELECT [WC] FROM @TestTable WHERE NN = @i
	--SELECT [PRODUCT_REF], [NAME], [SALDO] FROM [ACCOUNTS] WHERE [ID] = (SELECT [WC] FROM @TestTable WHERE NN = @i)
	--SET @TestProductType = (SELECT [PRODUCT_REF] FROM [ACCOUNTS] WHERE [ID] = (SELECT [WC] FROM @TestTable WHERE NN = @i))
	SET @IID = (SELECT [WC] FROM @TestTable WHERE NN = @i)
	SET @TestProductType = (SELECT [PRODUCT_TYPE_ID] FROM [PRODUCTS]
		WHERE [ID] = (SELECT [PRODUCT_REF] FROM [ACCOUNTS] WHERE [ID] = @IID))
	--PRINT 'ACC_TYPE ' + CONVERT(NVARCHAR, @TestProductType)
	SET @TestName = (SELECT [NAME] FROM [ACCOUNTS] WHERE [ID] = @IID)
	--PRINT 'NAME ACC ' + @TestName
	--SET @TestSaldo = (SELECT [SALDO] FROM [ACCOUNTS] WHERE [ID] = @IID)
	--СЧЕТА С НУЛЕВЫМ САЛЬДО
	SET @TestSaldo = 0.00
	PRINT @TestProductType
	PRINT @TestSaldo
	SET @TestACCID = (SELECT [ID] FROM [ACCOUNTS] WHERE [ID] = @IID)
	PRINT CONVERT(VARCHAR, @TestACCID)
	SET @TestPreviousDate = (SELECT [OPEN_DATE] FROM [ACCOUNTS] WHERE [ID] = @IID)
	PRINT @TestPreviousDate

	SET @TestDT = CASE @TestProductType
			WHEN '1' THEN 1
			WHEN '2' THEN 0
			WHEN '3' THEN 0
		END;
	--PRINT '@i ' + CONVERT(VARCHAR, @i)
	PRINT '@TestDT ' + CONVERT(VARCHAR, @TestDT)
	--PRINT ''

	WHILE (@j <= @Nj)
	BEGIN	
		PRINT '@i ' + CONVERT(VARCHAR, @i) + ' @j ' + CONVERT(VARCHAR, @j) + ' ' + @TestName
		IF (@TestDT = 0)	--ДЕПОЗИТ или КАРТА, клиент в любое время может внести средства, с 0.00
		BEGIN
			SET @SUMOperate = RAND() * (@LIMIT / 10)
			
			--SET @DT = 0	--клиент вносит средства на счета, 0 – остаток по счету увеличивается
			SET @DT = RAND()
			SET @TestRecordDT = CASE @DT
					WHEN '1' THEN -1
					WHEN '0' THEN 1
			END

				
			SET @SUMResult = @TestSaldo + (@TestRecordDT * @SUMOperate)
			PRINT '@SUMOperate ' + CONVERT(VARCHAR, @SUMOperate)
			
			--PRINT '@SUMResult ' + CONVERT(VARCHAR, @SUMResult)
			IF (@SUMResult > 0)
				BEGIN
					SET @TestSaldo = @SUMResult
					PRINT '@TestSaldo ' + CONVERT(VARCHAR, @TestSaldo)
				END
				ELSE
				BEGIN
					SET @SUMOperate = 0.00
				END
			
			PRINT '@SUMOperate ' + CONVERT(VARCHAR, @SUMOperate)
		END
		ELSE 
		BEGIN	
			PRINT '@TestSaldo ' + CONVERT(VARCHAR, @TestSaldo)
			IF (@TestSaldo = 0.00) --КРЕДИТ, выдача
			BEGIN
				SET @SUMOperate = CONVERT(INT,((RAND() * @LIMIT)/1000.00)) * 1000.00
				SET @TestSaldo = @SUMOperate
				SET @DT	= 1 --банк выдает деньги, 1 – остаток по счету уменьшается
				SET @DTInfo = 'ВЫДАЧА КРЕДИТА'
				PRINT 'CREDIT ' + '@TestSaldo ' + CONVERT(VARCHAR, @TestSaldo)
			END
			ELSE
			BEGIN
				SET @SUMOperate = RAND() * (@TestSaldo / 10)
				SET @DT = RAND()
				

				--PRINT 'DATA ' + @TestACCID
				
				SET @TestRecordDT = CASE @DT
					WHEN '1' THEN -1
					WHEN '0' THEN 1
				END

				
				SET @SUMResult = @TestSaldo + (@TestRecordDT * @SUMOperate)
				IF @SUMResult < @LIMIT
				BEGIN
					SET @TestSaldo = @SUMResult
				END
				ELSE
				BEGIN
					SET @SUMOperate = 0.00 
				END
			END
		END;
		IF @DTInfo =''
		BEGIN
			SET @DTInfo = CASE @DT
				WHEN '1' THEN 'СНЯТИЕ'
				WHEN '0' THEN 'ВНЕСЕНИЕ'
			END
		END
		PRINT '@DT ' + CONVERT(VARCHAR, @DT) + ' @DTInfo ' + CONVERT(VARCHAR, @DTInfo) + ' @TestRecordDT ' + CONVERT(VARCHAR, @TestRecordDT)
		PRINT '@SUMOperate ' + CONVERT(VARCHAR, @SUMOperate)
		SET @TestDate = DATEADD(DAY, FLOOR(RAND()*DATEDIFF(DAY,@TestPreviousDate,@CurrentDate)),@TestPreviousDate)
		PRINT '@TestDate ' + CONVERT(VARCHAR, @TestDate)
		PRINT '@TestSaldo ' + CONVERT(VARCHAR, @TestSaldo)
					
		INSERT INTO [RECORDS] VALUES (@DT, @SUMOperate, @TestACCID, @TestDate);	---тест
		UPDATE [ACCOUNTS] SET [SALDO] = @TestSaldo WHERE [ID] = @IID
		
		SET @j = @j + 1
		SET @TestPreviousDate = @TestDate
		SET @DTInfo = ''
	END;

	PRINT '---'
	SET @i = @i + 1
	SET @j = 1
	SET @TestProductType = 0
END;
--ДЛЯ КАЖДОГО СЧЕТА ЗАПИСИ (J)
--перебор записей не по id а по колву строк
--@DT операция, не зависит от типа продукта: + @DT0, - @DT1
--тестовые суммы операций без проверки выхода лимита кредита, ограничение на лимит операции
--вывод дополнительных сведений

