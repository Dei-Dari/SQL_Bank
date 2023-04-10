USE [BANK]
GO

INSERT INTO [TARIFS]([NAME],[COST]) VALUES ('Тариф за выдачу кредита', 10);
INSERT INTO [TARIFS]([NAME],[COST]) VALUES ('Тариф за открытие счета', 10);
INSERT INTO [TARIFS]([NAME],[COST]) VALUES ('Тариф за обслуживание карты', 10);

INSERT INTO [PRODUCT_TYPE]([NAME],[BEGIN_DATE],[END_DATE],[TARIF_REF]) VALUES ('КРЕДИТ', '01.01.2018', NULL, 1);
INSERT INTO [PRODUCT_TYPE]([NAME],[BEGIN_DATE],[END_DATE],[TARIF_REF]) VALUES ('ДЕПОЗИТ', '01.01.2018', NULL, 2);
INSERT INTO [PRODUCT_TYPE]([NAME],[BEGIN_DATE],[END_DATE],[TARIF_REF]) VALUES ('КАРТА', '01.01.2018', NULL, 3);

INSERT INTO [CLIENTS] VALUES ('Сидоров Иван Петрович', 'Россия, Московская облать, г. Пушкин', '01.01.2001', 'Россия, Московская облать, г. Пушкин, ул. Грибоедова, д. 5', '2222 555555, выдан ОВД г. Пушкин, 10.01.2015');
INSERT INTO [CLIENTS] VALUES ('Иванов Петр Сидорович', 'Россия, Московская облать, г. Клин', '01.01.2001', 'Россия, Московская облать, г. Клин, ул. Мясникова, д. 3', '4444 666666, выдан ОВД г. Клин, 10.01.2015');
INSERT INTO [CLIENTS] VALUES ('Петров Сиодр Иванович', 'Россия, Московская облать, г. Балашиха', '01.01.2001', 'Россия, Московская облать, г. Балашиха, ул. Пушкина, д. 7', '4444 666667, выдан ОВД г. Клин, 10.01.2015');

INSERT INTO [PRODUCTS] VALUES (1, 'Кредитный договор с Сидоровым И.П.', 1, '01.06.2015', NULL);
INSERT INTO [PRODUCTS] VALUES (2, 'Депозитный договор с Ивановым П.С.', 2, '01.08.2017', NULL);
INSERT INTO [PRODUCTS] VALUES (3, 'Карточный договор с Петровым С.И.', 3, '01.08.2017', NULL);


INSERT INTO [ACCOUNTS] VALUES ('Кредитный счет для Сидоровым И.П.', -2000, 1, '01.06.2015', NULL, 1, '45502810401020000022');
INSERT INTO [ACCOUNTS] VALUES ('Депозитный счет для Ивановым П.С.', 6000, 2, '01.08.2017', NULL, 2, '42301810400000000001');
INSERT INTO [ACCOUNTS] VALUES ('Карточный счет для Петровым С.И.', 8000, 3, '01.08.2017', NULL, 3, '40817810700000000001');

INSERT INTO [RECORDS] VALUES (1, 5000, 1, '01.06.2015');
INSERT INTO [RECORDS] VALUES (0, 1000, 1, '01.07.2015');
INSERT INTO [RECORDS] VALUES (0, 2000, 1, '01.08.2015');
INSERT INTO [RECORDS] VALUES (0, 3000, 1, '01.09.2015');
INSERT INTO [RECORDS] VALUES (1, 5000, 1, '01.10.2015');
INSERT INTO [RECORDS] VALUES (0, 3000, 1, '01.10.2015');

INSERT INTO [RECORDS] VALUES (0, 10000, 2, '01.08.2017');
INSERT INTO [RECORDS] VALUES (1, 1000, 2, '05.08.2017');
INSERT INTO [RECORDS] VALUES (1, 2000, 2, '21.09.2017');
INSERT INTO [RECORDS] VALUES (1, 5000, 2, '24.10.2017');
INSERT INTO [RECORDS] VALUES (0, 6000, 2, '26.11.2017');

INSERT INTO [RECORDS] VALUES (0, 120000, 3, '08.09.2017');
INSERT INTO [RECORDS] VALUES (1, 1000, 3, '05.10.2017');
INSERT INTO [RECORDS] VALUES (1, 2000, 3, '21.10.2017');
INSERT INTO [RECORDS] VALUES (1, 5000, 3, '24.10.2017');
