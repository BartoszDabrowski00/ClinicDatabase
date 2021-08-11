USE BD_2020;
-- Punktacja: 0-niewykonywalne 1-zbytSkomplikowane/megaProste 2-sensowne ale bez $ 3-git

	--DARUK:
	--Wypisz wszystkie wolne terminy (Data, Godzina) u lekarza X w ci�gu najbli�szych 7 dni.   
	--3PKT - widok, sens biznesowy, funkcja czasu
GO
CREATE VIEW [WOLNE TERMINY] AS
	SELECT Data_terminu, Godzina, Nr_licencji FROM Terminy
		WHERE Status_terminu = 'Wolny';
GO
SELECT Godzina,Data_terminu
FROM [WOLNE TERMINY]
	WHERE Nr_licencji = 1111111
	AND DATEDIFF(day, (SELECT CAST( GETDATE() AS Date)), Data_terminu) BETWEEN 0 AND 7;
DROP VIEW [WOLNE TERMINY];

	--Wypisz wszystkie choroby (Nazwa choroby, objawy)
	--przez kt�re przechodzi� pacjent X w ci�gu ostatnich 2 lat wraz z Imieniem i Nazwiskiem lekarza,
	--kt�ry przeprowadza� dan� wizyt�(data i godzina wizyty).
	--3PKT - funkcja czasu, joiny, dostatecznie skomplikowane, sensowne zastosowanie
SELECT Imi�, Nazwisko, Choroby.Nazwa, Objawy, Data_terminu, Godzina
FROM Wizyty JOIN Lekarze ON Wizyty.Nr_licencji = Lekarze.Nr_licencji 
JOIN Zdiagnozowane_Choroby ON Zdiagnozowane_Choroby.Id_wizyty = Wizyty.Id_wizyty
JOIN Choroby ON Choroby.Nazwa = Zdiagnozowane_Choroby.Nazwa
JOIN Terminy ON Terminy.Id_terminu = Wizyty.Id_terminu
WHERE Wizyty.Pesel = '23456789102' AND DATEDIFF(YEAR, (SELECT CAST( GETDATE() AS Date)), Data_terminu) <=2;

	--Wypisz wszystkie wizyty (Data, godzina, status),
	--kt�re mia� lekarz X w poprzednim miesi�cu wraz z nazwiskiem pacjenta, kt�rego dotyczy wizyta.
	--3PKT - subquerry, join, jest sens biznesowy
SELECT Data_terminu, Godzina, Status_terminu, Imie, Nazwisko 
FROM Terminy JOIN Wizyty ON Terminy.Id_terminu = Wizyty.Id_terminu JOIN Pacjenci ON Pacjenci.Pesel = Wizyty.Pesel
	WHERE Terminy.Nr_licencji = 1111111
		AND DATEDIFF(month, (SELECT CAST( GETDATE() AS Date)), Terminy.Data_terminu) BETWEEN -1 AND 0


	--TOMASZEWSKI:
	--Podczas kt�rej wizyty u pacjenta X zdiagnozowano chorob� Y?
	--3PKT - kilka subquerry, dostatecznie skomplikowane, jest sens biznesowy
SELECT Data_terminu, Godzina FROM Terminy
	WHERE Id_terminu IN
		(SELECT Id_terminu FROM Wizyty
			WHERE Wizyty.Pesel = 23456789104
				AND Id_wizyty IN
					(SELECT Id_wizyty FROM Zdiagnozowane_Choroby
						WHERE Nazwa = 'Udar m�zgu'));

	--Ile wynosi suma kwot rachunk�w  z dnia YYYY-MM-DD?
	--3PKT - kr�tke, lecz jest funkcja agreguj�ca, subquerry i sens biznesowy
SELECT ROUND(SUM(Kwota),2) AS "Total" FROM Rachunki
	WHERE Id_wizyty IN 
		(SELECT Id_wizyty FROM Wizyty WHERE Id_terminu IN 
			(SELECT Id_terminu FROM Terminy WHERE Data_terminu = '2020-12-08'));

	--Ilu jest lekarzy, kt�rzy kiedykolwiek leczyli pacjenta X?
	--3PKT - to samo co wy�ej
SELECT COUNT(Nr_licencji) AS "Ilosc lekarzy" FROM Lekarze
	WHERE Nr_licencji IN (SELECT Nr_licencji FROM Wizyty WHERE Pesel = '23456789104');

	--W�asne:
	-- Wypisz wszystkie nieop�acone rachunki z ostatnich 2 miesiecy wraz danymi p�atnik�w
SELECT Imie, Nazwisko, Nr_rachunku, Kwota, Status_rachunku=
	CASE
		WHEN Status_rachunku = '0' THEN 'Nieop�acony'
		ELSE 'Op�acony'
	END
FROM Rachunki JOIN Pacjenci ON Rachunki.Pesel = Pacjenci.Pesel
	WHERE Pacjenci.Pesel IN
		(SELECT Pesel FROM Wizyty
			WHERE Id_terminu IN
				(SELECT Id_terminu FROM Terminy
					WHERE DATEDIFF(month, (SELECT CAST( GETDATE() AS Date)), Terminy.Data_terminu) <=2))
	AND Rachunki.Status_rachunku = 0
	ORDER BY Kwota DESC;


	--Wypisz wszystkie leki jakie kiedykolwiek zosta�y przepisane pacjentowi X wraz z ich sk�adem
WITH WIZYTY_PACJENTA(Id_wizyty) AS (SELECT Id_wizyty FROM Wizyty WHERE Pesel = '23456789102')
SELECT Leki.Nazwa, Sk�ad FROM Leki JOIN Wypisane_Leki ON Leki.Nazwa = Wypisane_Leki.Nazwa
	WHERE Nr_recepty IN 
		(SELECT Nr_recepty FROM Recepty 
			WHERE Id_wizyty IN
				(SELECT* FROM WIZYTY_PACJENTA))
	GROUP BY Leki.Nazwa, Sk�ad;


	--Wypisz nazwy lek�w wraz z numerami recept wypisane przez lekarza X w przeci�gu ostatnich 2 miesi�cy
SELECT Recepty.Nr_recepty, Nazwa FROM Recepty JOIN Wypisane_Leki ON Recepty.Nr_recepty = Wypisane_Leki.Nr_recepty
	WHERE Id_wizyty IN
		(SELECT Id_wizyty FROM Wizyty
			WHERE Id_terminu IN
				(SELECT Id_terminu FROM Terminy
					WHERE Nr_licencji = 1111111
					AND DATEDIFF(month, (SELECT CAST( GETDATE() AS Date)), Terminy.Data_terminu) <=2))
	GROUP BY Nazwa, Recepty.Nr_recepty;