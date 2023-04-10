--https://learn.microsoft.com/ru-ru/sql/relational-databases/performance/joins?view=sql-server-ver15
--https://learn.microsoft.com/ru-ru/sql/t-sql/functions/first-value-transact-sql?view=sql-server-ver16
--https://learn.microsoft.com/ru-ru/sql/mdx/distinct-mdx?view=sql-server-ver16

USE [BANK]
GO


----4. ����������� �����, ������� �������� ��� �����, ����������� � ��������� ����
----�������, ������������� ��������, � ������� ��� �������� ��������� ����
----������.

--SELECT [ACCOUNTS].* FROM [ACCOUNTS]
--	JOIN (SELECT [PRODUCTS].* FROM [PRODUCTS]
--		LEFT JOIN (SELECT [PRODUCTS].[CLIENT_REF] FROM [PRODUCTS]
--			JOIN [PRODUCT_TYPE]
--			ON [PRODUCTS].[PRODUCT_TYPE_ID] = [PRODUCT_TYPE].[ID]
--			WHERE [PRODUCT_TYPE].[NAME] = '������' AND ([PRODUCTS].[CLOSE_DATE] > GETDATE() OR [PRODUCTS].[CLOSE_DATE] IS NULL))
--		AS CR
--		ON [PRODUCTS].[CLIENT_REF] = CR.[CLIENT_REF]
--		WHERE CR.[CLIENT_REF] IS NULL 
--			AND [PRODUCTS].[PRODUCT_TYPE_ID] = (SELECT [PRODUCT_TYPE].[ID] FROM [PRODUCT_TYPE]
--				WHERE [PRODUCT_TYPE].[NAME] = '�������'))		
--		AS AP
--	ON [ACCOUNTS].[PRODUCT_REF] = AP.[ID]


----5. ����������� �������, ������� �������� ������� �������� �� ������ � ������
----������ ������������� ���, � ������� ���� ��������.
----?? ������� -> ���� + ������� ��������/������ � ������������ ����

--DECLARE @TestDate DATE = '2023-03-26'

------������������ ���� ��� ���� ��������
----DECLARE @TestPreviousDate DATE = (SELECT MIN([PRODUCT_TYPE].[BEGIN_DATE]) FROM [PRODUCT_TYPE])
----SET @TestDate = DATEADD(DAY, FLOOR(RAND()*DATEDIFF(DAY,@TestPreviousDate,GETDATE())),@TestPreviousDate)

----������������ ���� �� ������������ ��������
--SET @TestDate = (SELECT TOP 1 [RECORDS].[OPER_DATE] FROM [RECORDS] ORDER BY NEWID())

--SELECT RD.[NAME], @TestDate AS 'DATE', CAST(ROUND(AVG(RD.[SUM] * (CASE RD.[DT] WHEN '1' THEN -1 WHEN '0' THEN 1 END)), 2) AS MONEY) AS 'AVG_SUM'
--FROM (SELECT [RECORDS].[ID] AS 'ID', [RECORDS].[DT] AS 'DT', [RECORDS].[SUM] AS 'SUM', [ACCOUNTS].[PRODUCT_REF], [PRODUCTS].[PRODUCT_TYPE_ID], [PRODUCT_TYPE].[NAME] AS 'NAME' FROM [RECORDS] JOIN [ACCOUNTS]
--	ON [RECORDS].[ACC_REF] = [ACCOUNTS].[ID] JOIN [PRODUCTS]
--		ON [ACCOUNTS].[PRODUCT_REF] = [PRODUCTS].[ID] JOIN [PRODUCT_TYPE]
--			ON [PRODUCTS].[PRODUCT_TYPE_ID] = [PRODUCT_TYPE].[ID]
--		WHERE [RECORDS].[OPER_DATE] = @TestDate) AS RD
--		GROUP BY RD.[NAME]

----��� ��������			
--SELECT * FROM (SELECT [RECORDS].*, [ACCOUNTS].[PRODUCT_REF], [PRODUCTS].[PRODUCT_TYPE_ID], [PRODUCT_TYPE].[NAME] AS 'NAME' FROM [RECORDS] JOIN [ACCOUNTS]
--	ON [RECORDS].[ACC_REF] = [ACCOUNTS].[ID] JOIN [PRODUCTS]
--		ON [ACCOUNTS].[PRODUCT_REF] = [PRODUCTS].[ID] JOIN [PRODUCT_TYPE]
--			ON [PRODUCTS].[PRODUCT_TYPE_ID] = [PRODUCT_TYPE].[ID]
--		WHERE [RECORDS].[OPER_DATE] = @TestDate) AS RD
--		ORDER BY RD.[NAME]


----6. ����������� �������, � ������� ������� �������, � ������� ���� �������� ��
----������ �� ��������� ����� �� ������� ����. �������� ������� � ����� ��������
----�� ���� � ������� ����.
----?? ���� -> ������ + ����� (��������/������)

--SELECT DC.[DATE], DC.[CLIENT], DC.[NAME], DC.[SUM] FROM
--	(SELECT [RECORDS].[OPER_DATE] AS 'DATE', [ACCOUNTS].[CLIENT_REF] AS 'CLIENT', [CLIENTS].[NAME], SUM([RECORDS].[SUM] * (CASE [RECORDS].[DT] WHEN '1' THEN -1 WHEN '0' THEN 1 END)) AS 'SUM' FROM [RECORDS] JOIN [ACCOUNTS]
--			ON [RECORDS].[ACC_REF] = [ACCOUNTS].[ID] JOIN [CLIENTS]
--				ON [ACCOUNTS].[CLIENT_REF] = [CLIENTS].[ID]
--				WHERE (DATEDIFF(MONTH,[RECORDS].[OPER_DATE], GETDATE()) = 1)
--			GROUP BY [RECORDS].[OPER_DATE], [ACCOUNTS].[CLIENT_REF], [CLIENTS].[NAME]) AS DC
--		GROUP BY DC.[DATE], DC.[SUM], DC.[CLIENT], DC.[NAME]
--	ORDER BY DC.[DATE]

------��� ��������	2023-03-12, 2023-03-26
--SELECT [RECORDS].*, [ACCOUNTS].[CLIENT_REF], [CLIENTS].[NAME] FROM [RECORDS] JOIN [ACCOUNTS]
--	ON [RECORDS].[ACC_REF] = [ACCOUNTS].[ID] JOIN [CLIENTS]
--		ON [ACCOUNTS].[CLIENT_REF] = [CLIENTS].[ID]
--	WHERE (DATEDIFF(MONTH,[RECORDS].[OPER_DATE], GETDATE()) = 1)
--	ORDER BY [RECORDS].[OPER_DATE], [ACCOUNTS].[CLIENT_REF]


----7. � ���������� ���� � ���� ������ ����������� ���������� ����� ��������� �
----���������� �� ������. �������� ������������ (��������� �������������
----������), ������� ������ ����� ����� � ����������� ������� �� �����.
----?? ��� ��������, �������������� �������� ������ 0.00
----?? ����� ����� � ������ 0.00

--SELECT [ACCOUNTS].*, RS.[ID], RS.[SUM] FROM [ACCOUNTS] JOIN 
--	(SELECT [RECORDS].[ACC_REF] AS 'ID', SUM([RECORDS].[SUM] * (CASE [RECORDS].[DT] WHEN '1' THEN -1 WHEN '0' THEN 1 END)) AS 'SUM' FROM [RECORDS]
--	GROUP BY [RECORDS].[ACC_REF]) AS RS	
--	ON [ACCOUNTS].[ID] = RS.[ID]


--SELECT [ACCOUNTS].*, RS.[ID], RS.[SUM], FVS.* , RS.[SUM] - FVS.[BEGINSUM] FROM [ACCOUNTS] JOIN 
--	(SELECT [RECORDS].[ACC_REF] AS 'ID', 
--	(SUM([RECORDS].[SUM] * (CASE [RECORDS].[DT] WHEN '1' THEN -1 WHEN '0' THEN 1 END))) AS 'SUM' FROM [RECORDS]
--	GROUP BY [RECORDS].[ACC_REF]) AS RS	
--	ON [ACCOUNTS].[ID] = RS.[ID] JOIN
--		(SELECT [SUM] AS 'BEGINSUM', [DT], [ACC] FROM [RECORDS] JOIN
--			(SELECT DISTINCT [RECORDS].[ACC_REF] AS 'ACC', FIRST_VALUE([RECORDS].[OPER_DATE]) OVER (PARTITION BY [RECORDS].[ACC_REF] ORDER BY [RECORDS].[OPER_DATE] ASC ROWS UNBOUNDED PRECEDING) AS 'DATE' FROM [RECORDS]) AS FV
--			ON [RECORDS].[ACC_REF] = FV.[ACC]
--			WHERE [RECORDS].[OPER_DATE] = FV.[DATE]) AS FVS
--		ON [ACCOUNTS].[ID] = FVS.[ACC]
--	WHERE [ACCOUNTS].[SALDO] != RS.[SUM]


----SELECT RS.[ID], RS.[SUM] FROM [ACCOUNTS] JOIN 
----	(SELECT [RECORDS].[ACC_REF] AS 'ID', FIRST_VALUE([RECORDS].[SUM]) OVER (ORDER BY (SELECT [RECORDS].[ACC_REF] AS 'ID', SUM([RECORDS].[SUM] * (CASE [RECORDS].[DT] WHEN '1' THEN -1 WHEN '0' THEN 1 END)) AS 'SUM' FROM [RECORDS]
----	GROUP BY [RECORDS].[ACC_REF]) AS 'SUM' FROM [RECORDS]
----	GROUP BY [RECORDS].[ACC_REF], [RECORDS].[SUM]) AS RS	
----	ON [ACCOUNTS].[ID] = RS.[ID]

	
--SELECT * FROM [RECORDS] LEFT JOIN
--	(SELECT DISTINCT [RECORDS].[ACC_REF], FIRST_VALUE([RECORDS].[OPER_DATE]) OVER (PARTITION BY [RECORDS].[ACC_REF] ORDER BY [RECORDS].[OPER_DATE] ASC ROWS UNBOUNDED PRECEDING) AS 'DATE' FROM [RECORDS]) AS FV
--	ON [RECORDS].[ACC_REF] = FV.[ACC_REF]
--	WHERE [RECORDS].[OPER_DATE] = FV.[DATE]


----SELECT DISTINCT [RECORDS].[ACC_REF], FIRST_VALUE([RECORDS].[OPER_DATE]) OVER (PARTITION BY [RECORDS].[ACC_REF] ORDER BY [RECORDS].[OPER_DATE] ASC ROWS UNBOUNDED PRECEDING) AS 'DATE' FROM [RECORDS] 
----	GROUP BY [RECORDS].[OPER_DATE], [RECORDS].[ACC_REF]
	




--8. ����������� �������, ������� �������� ���������� � ��������, �������
--��������� �������� ������, �� ��� ���� �� ������� ������� � ���������� ��
--������ (�� �������� ���� �������� ����� ������ �������).

SELECT * FROM [PRODUCTS]
	WHERE [PRODUCTS].[PRODUCT_TYPE_ID] = 1 AND ([PRODUCTS].[CLOSE_DATE] > GETDATE() OR [PRODUCTS].[CLOSE_DATE] IS NULL) 

SELECT [RECORDS].[ACC_REF], MIN([RECORDS].[SUM]) FROM [RECORDS]	
	GROUP BY [RECORDS].[ACC_REF], [RECORDS].[SUM]



--9. �������� �������� (���������� ���� �������� ������ �������) ���� ������, �
--������� ��������� ������ ���������, �� ��� ���� �� ���� ��������� ������.


--10. �������� ����������� �������� (���������� ���� ��������� ��������) ��� �����
--���������, �� ������ ��������� �������, �� ���� �������� ����� ������ ������.


--11. � ������ ������ �������� ����� �������� �� ��������. ��������� ���� ��� ����
--��������� ������ ������������ ��������� �������� �� ����� ��� �������� ����
--������, � ������ ������������ ���������� �������� �� ����� �������� ���
--�������� ���� ������� ��� �����.