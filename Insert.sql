use BD_2020
INSERT INTO Lekarze (Nr_licencji, Specjalizacja, Imiê, Nazwisko)
VALUES  (1111111, 'Kardiologia', 'Jan', 'Kowalski'),
		(1111112, 'Neurologia', 'Jacek', 'Soplica'),
		(1111113, 'Alergologia', 'Henryk', 'Sienkiewicz'),
		(1111114, 'Diabetologia', 'Adam', 'Mickiewicz'),
		(2222222, 'Endokrynologia', 'Zbigniew', 'Wodecki'),
		(2222223, 'Epidemiologia', 'Mateusz', 'Morawiecki'),
		(2223456, 'Kardiochirurgia', 'Tadeusz', 'Koœciuszko'),
		(2224126, 'Neurochirurgia', 'Kazimierz', 'Pu³aski'),
		(1234567, 'Okulistyka', 'Stefan', 'Batory'),
		(7777777, 'Patomorfologia', 'Witold', 'Gombrowicz');

INSERT INTO Choroby (Nazwa, Objawy)
VALUES  ('Rak ¿o³¹dka', 'utrata ³aknienia, ubytek masy cia³a, bóle nadbrzusza'),
		('Nadciœnienie têtnicze', 'krwotoki z nosa, nerwowoœæ, zawroty g³owy'),
		('Udar mózgu', 'zaburzenia funkcji ruchowych, zaburzenia czucia, zaburzenia równowagi'),
		('Astma', 'dusznoœæ, kaszel, œciskanie w klatce piersiowej, œwiszcz¹cy oddech'),
		('Cukrzyca', 'czêste uczucie pragnienia, suchoœæ w ustach, apatia'),
		('Grypa', 'os³abienie, rozkojarzenie, ból miêœni i stawów'),
		('Depresja', 'zmniejszenie aktywnoœci, utrata zainteresowañ, zaburzenia snu'),
		('Kamica nerkowa', 'krwiomocz, nudnoœci, wymioty'),
		('Angina', 'ból gard³a, chrypka, katar');

INSERT INTO Pacjenci (Pesel, Imie, Nazwisko, Adres)
VALUES  ('12345678910', 'Jan', 'Test', 'ul.Brzozowa 3, Gdañsk'),
		('23456789100', 'Jakub', 'Teœcik', 'ul.Klonowa 4, Gdañsk'),
		('23456789101', 'Henryk', 'Pu³aski', 'ul.Brzozowa 5, Gdañsk'),
		('23456789102', 'Zbigniew', 'Sienkiewicz', 'ul.Brzozowa 6, Gdañsk'),
		('23456789103', 'Tadeusz', 'Wodecki', 'ul.Prawdziwa 10/2, Gdynia'),
		('23456789104', 'Kazimierz', 'Gombrowicz', 'ul.Zmyœlona 1/4, Sopot'),
		('23456789105', 'Witold', 'Mickiewicz', 'ul.Mo¿liwa 7/15, Warszawa'),
		('23456789106', 'Stefan', 'Kowalski', 'ul.Warszawska 20, Hel');

INSERT INTO Leki (Nazwa, Sk³ad)
VALUES  ('Apap', 'skrobia ¿elowana, makrogol, kwas stearynowy'),
		('Panadol', 'paracetamol, skrobia kukurydziana, kwas stearynowy'),
		('Ibuprom', 'makrogol 400, ibuprofen, krospowidon (typ A)'),
		('Kodeina', 'dusznoœæ, kaszel, œciskanie w klatce piersiowej, œwiszcz¹cy oddech'),
		('Vicebrol', 'laktoza jednowodna, celuloza mikrokrystaliczna, skrobia ¿elowana'),
		('Atoris', 'atorwastatyna, powidon, celuloza mikrokrystaliczna'),
		('Ketonal', 'krzemionka koloidalna, talk oczyszczony, ketoprofen'),
		('Altacet', 'octowinian glinu, etanol 96%, lewomentol'),
		('Opokan forte', 'meloksykam, laktoza');

INSERT INTO Terminy (Data_terminu, Godzina, Status_terminu, Nr_licencji)
VALUES  ('2020-12-06', '10:10:00', 'Wolny', 1111111),
		('2020-12-06', '10:10:00', 'Zajêty',1111111),
		('2020-12-06', '10:20:00', 'Zajêty', 2224126),
		('2020-12-07', '12:40:00', 'Zajêty', 1111111),
		('2020-12-07', '12:50:00', 'Wolny', 7777777),
		('2020-12-07', '12:50:00', 'Zajêty', 2224126),
		('2020-12-08', '13:45:00', 'Zajêty', 1234567),
		('2020-12-08', '13:50:00', 'Zajêty', 1111114),
		('2020-12-08', '14:00:00', 'Zajêty', 2223456),
		('2020-12-08', '14:10:00', 'Zajêty', 1234567);

INSERT INTO Wizyty (Pesel, Id_terminu, Nr_licencji)
VALUES  ('12345678910', 2, 1111111),
		('23456789104', 3, 2224126),
		('23456789102', 4, 1111111),
		('23456789106', 6, 2224126),
		('23456789101', 7, 1234567),
		('23456789103', 8, 1111114),
		('23456789102', 9, 2223456),
		('23456789104', 10, 1234567);

INSERT INTO Rachunki(Status_rachunku, Metoda, Kwota, Id_wizyty, Pesel)
VALUES  (0, 'Karta', 100.00, 1, '12345678910'),
		(0, 'Karta', 150.00, 2, '23456789104'),
		(0, 'Karta', 190.00, 3, '23456789102'),
		(1, 'Gotówka', 50.00, 4, '23456789106'),
		(1, 'Karta', 5.99, 5, '23456789101'),
		(1, 'Gotówka', 200.99, 6, '23456789103'),
		(1, 'Gotówka', 5219.97, 7, '23456789102'),
		(0, 'Karta', 123.12, 8, '23456789104');

INSERT INTO Zdiagnozowane_choroby(Id_wizyty, Nazwa)
VALUES  (1, 'Nadciœnienie têtnicze'),
		(2, 'Udar mózgu'),
		(3, 'Astma'),
		(3, 'Cukrzyca'),
		(4,'Grypa'),
		(5, 'Depresja'),
		(6, 'Kamica nerkowa'),
		(7, 'Angina'),
		(7, 'Astma'),
		(8, 'Rak ¿o³¹dka'),
		(8, 'Udar mózgu'),
		(8, 'Cukrzyca');

INSERT INTO Recepty (Id_wizyty)
VALUES  (1),
		(2),
		(3),
		(4),
		(5),
		(6),
		(7),
		(7),
		(1);

INSERT INTO Wypisane_Leki(Nr_recepty, Nazwa)
VALUES	(1, 'Panadol'),
		(1, 'Ibuprom'),
		(2, 'Kodeina'),
		(3, 'Vicebrol'),
		(4, 'Atoris'),
		(4, 'Ketonal'),
		(5,'Altacet'),
		(6,'Opokan forte'),
		(6, 'Ibuprom'),
		(7, 'Panadol'),
		(6, 'Atoris');

