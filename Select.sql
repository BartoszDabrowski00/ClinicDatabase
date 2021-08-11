USE BD_2020;
-- Punktacja: 0-niewykonywalne 1-zbytSkomplikowane/megaProste 2-sensowne ale bez $ 3-git

	--DARUK:
	--Wypisz wszystkie wolne terminy (Data, Godzina) u lekarza X w ci¹gu najbli¿szych 7 dni.   
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
	--przez które przechodzi³ pacjent X w ci¹gu ostatnich 2 lat wraz z Imieniem i Nazwiskiem lekarza,
	--który przeprowadza³ dan¹ wizytê(data i godzina wizyty).
	--3PKT - funkcja czasu, joiny, dostatecznie skomplikowane, sensowne zastosowanie
SELECT Imiê, Nazwisko, Choroby.Nazwa, Objawy, Data_terminu, Godzina
FROM Wizyty JOIN Lekarze ON Wizyty.Nr_licencji = Lekarze.Nr_licencji 
JOIN Zdiagnozowane_Choroby ON Zdiagnozowane_Choroby.Id_wizyty = Wizyty.Id_wizyty
JOIN Choroby ON Choroby.Nazwa = Zdiagnozowane_Choroby.Nazwa
JOIN Terminy ON Terminy.Id_terminu = Wizyty.Id_terminu
WHERE Wizyty.Pesel = '23456789102' AND DATEDIFF(YEAR, (SELECT CAST( GETDATE() AS Date)), Data_terminu) <=2;

	--Wypisz wszystkie wizyty (Data, godzina, status),
	--które mia³ lekarz X w poprzednim miesi¹cu wraz z nazwiskiem pacjenta, którego dotyczy wizyta.
	--3PKT - subquerry, join, jest sens biznesowy
SELECT Data_terminu, Godzina, Status_terminu, Imie, Nazwisko 
FROM Terminy JOIN Wizyty ON Terminy.Id_terminu = Wizyty.Id_terminu JOIN Pacjenci ON Pacjenci.Pesel = Wizyty.Pesel
	WHERE Terminy.Nr_licencji = 1111111
		AND DATEDIFF(month, (SELECT CAST( GETDATE() AS Date)), Terminy.Data_terminu) BETWEEN -1 AND 0


	--TOMASZEWSKI:
	--Podczas której wizyty u pacjenta X zdiagnozowano chorobê Y?
	--3PKT - kilka subquerry, dostatecznie skomplikowane, jest sens biznesowy
SELECT Data_terminu, Godzina FROM Terminy
	WHERE Id_terminu IN
		(SELECT Id_terminu FROM Wizyty
			WHERE Wizyty.Pesel = 23456789104
				AND Id_wizyty IN
					(SELECT Id_wizyty FROM Zdiagnozowane_Choroby
						WHERE Nazwa = 'Udar mózgu'));

	--Ile wynosi suma kwot rachunków  z dnia YYYY-MM-DD?
	--3PKT - krótke, lecz jest funkcja agreguj¹ca, subquerry i sens biznesowy
SELECT ROUND(SUM(Kwota),2) AS "Total" FROM Rachunki
	WHERE Id_wizyty IN 
		(SELECT Id_wizyty FROM Wizyty WHERE Id_terminu IN 
			(SELECT Id_terminu FROM Terminy WHERE Data_terminu = '2020-12-08'));

	--Ilu jest lekarzy, którzy kiedykolwiek leczyli pacjenta X?
	--3PKT - to samo co wy¿ej
SELECT COUNT(Nr_licencji) AS "Ilosc lekarzy" FROM Lekarze
	WHERE Nr_licencji IN (SELECT Nr_licencji FROM Wizyty WHERE Pesel = '23456789104');

	--W³asne:
	-- Wypisz wszystkie nieop³acone rachunki z ostatnich 2 miesiecy wraz danymi p³atników
SELECT Imie, Nazwisko, Nr_rachunku, Kwota, Status_rachunku=
	CASE
		WHEN Status_rachunku = '0' THEN 'Nieop³acony'
		ELSE 'Op³acony'
	END
FROM Rachunki JOIN Pacjenci ON Rachunki.Pesel = Pacjenci.Pesel
	WHERE Pacjenci.Pesel IN
		(SELECT Pesel FROM Wizyty
			WHERE Id_terminu IN
				(SELECT Id_terminu FROM Terminy
					WHERE DATEDIFF(month, (SELECT CAST( GETDATE() AS Date)), Terminy.Data_terminu) <=2))
	AND Rachunki.Status_rachunku = 0
	ORDER BY Kwota DESC;


	--Wypisz wszystkie leki jakie kiedykolwiek zosta³y przepisane pacjentowi X wraz z ich sk³adem
WITH WIZYTY_PACJENTA(Id_wizyty) AS (SELECT Id_wizyty FROM Wizyty WHERE Pesel = '23456789102')
SELECT Leki.Nazwa, Sk³ad FROM Leki JOIN Wypisane_Leki ON Leki.Nazwa = Wypisane_Leki.Nazwa
	WHERE Nr_recepty IN 
		(SELECT Nr_recepty FROM Recepty 
			WHERE Id_wizyty IN
				(SELECT* FROM WIZYTY_PACJENTA))
	GROUP BY Leki.Nazwa, Sk³ad;


	--Wypisz nazwy leków wraz z numerami recept wypisane przez lekarza X w przeci¹gu ostatnich 2 miesiêcy
SELECT Recepty.Nr_recepty, Nazwa FROM Recepty JOIN Wypisane_Leki ON Recepty.Nr_recepty = Wypisane_Leki.Nr_recepty
	WHERE Id_wizyty IN
		(SELECT Id_wizyty FROM Wizyty
			WHERE Id_terminu IN
				(SELECT Id_terminu FROM Terminy
					WHERE Nr_licencji = 1111111
					AND DATEDIFF(month, (SELECT CAST( GETDATE() AS Date)), Terminy.Data_terminu) <=2))
	GROUP BY Nazwa, Recepty.Nr_recepty;