USE BD_2020
CREATE TABLE Pacjenci
(	Nazwisko VARCHAR(30) not null,
	Imie VARCHAR(30) not null,
	Adres VARCHAR(50) not null,
	Pesel VARCHAR(11) PRIMARY KEY CHECK( LEN(Pesel)=11 and Pesel  like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);
CREATE TABLE Lekarze(
	Nr_licencji VARCHAR(7) PRIMARY KEY CHECK(LEN(Nr_licencji)=7 and Nr_licencji like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	Specjalizacja VARCHAR(30) not null,
	Imiê VARCHAR(30) not null,
	Nazwisko VARCHAR(30) not null
);
CREATE TABLE Terminy(
	Id_terminu INT IDENTITY(1,1) PRIMARY KEY,
	Data_terminu DATE not null,
	Status_terminu VARCHAR(15) not null,
	Godzina TIME(0) not null,
	Nr_licencji VARCHAR(7) CHECK(LEN(Nr_licencji)=7 and Nr_licencji like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
		FOREIGN KEY (Nr_licencji) REFERENCES Lekarze(Nr_licencji) ON DELETE CASCADE not null
);
CREATE TABLE Wizyty(
	Id_wizyty INT IDENTITY(1,1) primary key,
	Pesel VARCHAR(11) CHECK( LEN(Pesel)=11 and Pesel like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
		FOREIGN KEY (Pesel) REFERENCES Pacjenci(Pesel) ON DELETE CASCADE not null,
	Id_terminu INT FOREIGN KEY (Id_terminu) REFERENCES Terminy(Id_terminu) ON DELETE CASCADE not null UNIQUE,
	Nr_licencji varchar(7) CHECK(LEN(Nr_licencji)=7 and Nr_licencji like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
		FOREIGN KEY (Nr_licencji) REFERENCES Lekarze(Nr_licencji)   not null
);
CREATE TABLE Rachunki(
	Nr_rachunku INT IDENTITY(1,1) PRIMARY KEY,
	Status_rachunku BIT not null,
	Kwota FLOAT(24) not null,
	Metoda VARCHAR(30) not null,
	Id_wizyty INT FOREIGN KEY (Id_wizyty) REFERENCES Wizyty(Id_wizyty)  ON DELETE CASCADE not null UNIQUE,
	Pesel varchar(11) CHECK( LEN(Pesel)=11 and Pesel like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
		FOREIGN KEY (Pesel) REFERENCES Pacjenci(Pesel) not null
);
CREATE TABLE Recepty(
	Nr_recepty INT IDENTITY(1,1) PRIMARY KEY,
	Id_wizyty INT FOREIGN KEY (Id_wizyty) REFERENCES Wizyty(Id_wizyty) ON DELETE CASCADE not null
);
CREATE TABLE Leki(
	Nazwa varchar(30) PRIMARY KEY,
	Sk³ad varchar(100),
);
CREATE TABLE Choroby(
	Nazwa varchar(30) PRIMARY KEY,
	Objawy varchar(100),
);
CREATE TABLE Zdiagnozowane_Choroby(
	Id_wizyty INT FOREIGN KEY (Id_wizyty) REFERENCES Wizyty(Id_wizyty) ON DELETE CASCADE not null,
	Nazwa VARCHAR(30) FOREIGN KEY (Nazwa) REFERENCES Choroby(Nazwa) ON DELETE CASCADE  not null,
	PRIMARY KEY(Id_wizyty, Nazwa)
);

CREATE TABLE Wypisane_Leki(
	Nr_recepty INT FOREIGN KEY(Nr_recepty) REFERENCES Recepty(Nr_recepty) ON DELETE CASCADE not null,
	Nazwa VARCHAR(30) FOREIGN KEY(Nazwa) REFERENCES Leki(Nazwa) ON DELETE CASCADE not null,
	PRIMARY KEY(Nr_recepty, Nazwa)
);
