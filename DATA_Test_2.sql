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


----INSERT INTO [CLIENTS] ������������ ������� � ����� ���������� � ��������� �������� ������� (������� CLIENTS),
--SET @TestPreviousDate = DATEADD(YEAR,-@RangeYear,@CurrentDate)

--WHILE (@i < @N)
--BEGIN
--	SET @TestDate = DATEADD(DAY, FLOOR(RAND()*DATEDIFF(DAY,@TestPreviousDate,@CurrentDate)),@TestPreviousDate);	
--	SET @TestPass = @i
--	--������������ �������� (����� �����)

--	INSERT INTO [CLIENTS]
--	VALUES (@TestName + CHAR(ASCII(@i)), @TestAddress + CHAR(ASCII(@i)), @TestDate, @TestAddress + CHAR(ASCII(@i)), @TestPass)
--	SET @i = @i + 1;
--END;
--GO


----INSERT INTO [PRODUCTS] ����� ������ �������� ������� ��� ��� ���� ������� � ����� - ������, �������, ����� (������� PRODUCT_TYPE) 
----����� ���������� ���������� � ����� ��������� ��������� �������� (������� PRODUCTS)
--SET @i = 0
--WHILE (@i < @N)
--BEGIN
--	SET @TestProductType = 1 + RAND() * 3
--	SET @TestProductTypeName = CASE @TestProductType
--		WHEN '1' THEN '��������� ������� �: '
--		WHEN '2' THEN '���������� ������� �: '
--		WHEN '3' THEN '��������� ������� �: '
--	END;
--	SET @TestClientID = (SELECT TOP 1 [ID] FROM [CLIENTS] ORDER BY NEWID())
--	SET @TestName = (SELECT [NAME] FROM [CLIENTS] WHERE [CLIENTS].[ID] = @TestClientID)
--	SET @TestProductTypeName = @TestProductTypeName + @TestName
--	SET @TestPreviousDate = (SELECT [BEGIN_DATE] FROM [PRODUCT_TYPE] WHERE [PRODUCT_TYPE].[ID] = @TestProductType)
--	SET @TestDate = DATEADD(DAY, FLOOR(RAND()*DATEDIFF(DAY,@TestPreviousDate,@CurrentDate)),@TestPreviousDate)
--	SET @i = @i + 1;

--	INSERT INTO [PRODUCTS] VALUES (@TestProductType, @TestProductTypeName, @TestClientID, @TestDate, NULL)
--END;


----INSERT INTO [ACCOUNTS] � ������ �������� ����������� ���� ��� ��������� ������ (������� ACCOUNTS) � �������� ������ 0
----������: 40817810099910004312, � ������� 408 � ��������, ��� ��� ���� ����������� ����, 17 � ���� ��������� ��, ����������, 810 � ������ ����� ��, 0 � ����������� ����� � ������ ������, 9991 � ��� ������������� ����� (������ - ����� ������ �����), 0004312 � ��� ����� �����.
----��� 040000000
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
--		WHEN '1' THEN '��������� ����: '
--		WHEN '2' THEN '���������� ����: '
--		WHEN '3' THEN '��������� ����: '
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



--INSERT INTO [RECORDS] ����� � ������, ���� �������� ������� ���� ������ �� ����� �������� ��������
--��������� �������� � ���� ������ ������ ������� (� ������� RECORDS ���������� ������ �
--����� DT = 1 � ������ ����������, ������ � ������� RECORDS ������ �� ���� SALDO �������
--ACCOUNTS). ���� �������� ������� ������� ��� ����� �� ����� ������� ��������
--���������� �������� � ������ ������ �������� �� ����� (� ������� RECORDS ����������
--������ � ����� DT = 0 � ������ ����������, ������ � ������� RECORDS ������ �� ���� SALDO
--������� ACCOUNTS).
--����� ���� ������ � ������, ���� ��� ������ ������� ���� ������, ������ �������� ��
--����, ������� ������, � ���� ������� ���� ������� ��� �����, ����� ��������� ��������
--�� �����. ����� ������� ��������� �������� ���� ������, ������ ������� �����
--����������� �����, � ������ ����� ����� ������������ ���������. ���� � �������
--�������� ���� ������� ��� �����, ������ � ����� ����� ����� ������ ��������.

SET @i = 4
SET @N = (SELECT COUNT(*) FROM [ACCOUNTS])	--���-�� ������
SET @j = 1
SET @Nj = 5	--���-�� �������
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
	--����� � ������� ������
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
		IF (@TestDT = 0)	--������� ��� �����, ������ � ����� ����� ����� ������ ��������, � 0.00
		BEGIN
			SET @SUMOperate = RAND() * (@LIMIT / 10)
			
			--SET @DT = 0	--������ ������ �������� �� �����, 0 � ������� �� ����� �������������
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
			IF (@TestSaldo = 0.00) --������, ������
			BEGIN
				SET @SUMOperate = CONVERT(INT,((RAND() * @LIMIT)/1000.00)) * 1000.00
				SET @TestSaldo = @SUMOperate
				SET @DT	= 1 --���� ������ ������, 1 � ������� �� ����� �����������
				SET @DTInfo = '������ �������'
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
				WHEN '1' THEN '������'
				WHEN '0' THEN '��������'
			END
		END
		PRINT '@DT ' + CONVERT(VARCHAR, @DT) + ' @DTInfo ' + CONVERT(VARCHAR, @DTInfo) + ' @TestRecordDT ' + CONVERT(VARCHAR, @TestRecordDT)
		PRINT '@SUMOperate ' + CONVERT(VARCHAR, @SUMOperate)
		SET @TestDate = DATEADD(DAY, FLOOR(RAND()*DATEDIFF(DAY,@TestPreviousDate,@CurrentDate)),@TestPreviousDate)
		PRINT '@TestDate ' + CONVERT(VARCHAR, @TestDate)
		PRINT '@TestSaldo ' + CONVERT(VARCHAR, @TestSaldo)
					
		INSERT INTO [RECORDS] VALUES (@DT, @SUMOperate, @TestACCID, @TestDate);	---����
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
--��� ������� ����� ������ (J)
--������� ������� �� �� id � �� ����� �����
--@DT ��������, �� ������� �� ���� ��������: + @DT0, - @DT1
--�������� ����� �������� ��� �������� ������ ������ �������, ����������� �� ����� ��������
--����� �������������� ��������

