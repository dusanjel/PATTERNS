-- =============================================
-- Kreiraj Bazu podataka
-- =============================================
USE master
GO

-- Obrisi bazu podataka ukoliko postoji
IF  EXISTS (SELECT name FROM sys.databases WHERE name = 'JAT')
DROP DATABASE JAT
GO

CREATE DATABASE JAT
GO

-- =============================================
-- Omoguci CLR
-- =============================================

-- CLR -------------------------------------------------------
sp_configure 'clr enabled', 1
GO
RECONFIGURE
GO

USE JAT
GO

-- Distinct tip
CREATE TYPE dbo.Adresa FROM varchar(80)
GO
-- DROP TYPE dbo.Adresa

-- Kreiraj ASSEMBLY
CREATE ASSEMBLY Valuta
FROM
'C:\Users\Dusan\Desktop\SQL Script FON\StruktuiraniTipFile\CLRValuta\CLRValuta\bin\Debug\CLRValuta.dll'
GO

-- Kreiraj struktuirani korisnicki definisani tip
CREATE TYPE dbo.Valuta
EXTERNAL NAME Valuta.Valuta
GO

/* Testiraj */
DECLARE @i [Valuta]
SET @i = [Valuta]::[KreirajValutu]('USD', 0.53)
PRINT CONVERT([varchar], @i)

/* Iskoristi instanciranu mutator metodu da promenis simbol: */
SET @i = [Valuta]::[KreirajValutu]('USD', 0.53)
SET @i.IzmeniSimbol('RSD')
PRINT CONVERT([varchar], @i)

/* Vrati znak valute*/
SET @i = [Valuta]::[KreirajValutu]('RSD', 0.53)
PRINT @i.Simbol

-- CLR -------------------------------------------------------

-- =========================================
-- Kreiraj tabele
-- =========================================
USE JAT
GO

-- Tabela Klijent pocetak -------------------------------------------------------

IF OBJECT_ID('dbo.Klijent', 'U') IS NOT NULL
  DROP TABLE dbo.Klijent
GO

CREATE TABLE dbo.Klijent
(
KlijentID int NOT NULL,
Ime varchar(255),
Adresa Adresa,
CONSTRAINT pk_KlijentID PRIMARY KEY (KlijentID)
)

-- Tabela Klijent kraj ----------------------------------------------------------

-- Tabela KlijentKontakt pocetak -------------------------------------------------------

IF OBJECT_ID('dbo.KlijentKontakt', 'U') IS NOT NULL
  DROP TABLE dbo.KlijentKontakt
GO

CREATE TABLE dbo.KlijentKontakt
(
KlijentKontaktID int NOT NULL,
Telefon varchar(255),
fax varchar(255),
email varchar(255),
webAdresa varchar(255),
KontaktOsoba varchar(255),
CallCenter varchar(255),
CONSTRAINT pk_KlijentKontaktID PRIMARY KEY (KlijentKontaktID)
)

ALTER TABLE dbo.KlijentKontakt
    ADD  FOREIGN KEY (KlijentKontaktID) REFERENCES dbo.Klijent(KlijentID)
    	ON DELETE CASCADE
    	ON UPDATE CASCADE
go

-- Tabela KlijentKontakt kraj ----------------------------------------------------------

-- Tabela Avion pocetak ---------------------------------------------------------

IF OBJECT_ID('dbo.Avion', 'U') IS NOT NULL
  DROP TABLE dbo.Avion
GO

CREATE TABLE dbo.Avion
(
RegBr int NOT NULL,
AvNaziv varchar(255),
Ime varchar(255),
Neisdelova int,
KlijentID int FOREIGN KEY REFERENCES dbo.Klijent(KlijentID),
CONSTRAINT pk_AvionID PRIMARY KEY (RegBr)
)

-- Tabela  Avion kraj -----------------------------------------------------------

-- Tabela Proizvodjac pocetak ---------------------------------------------------

IF OBJECT_ID('dbo.Proizvodjac', 'U') IS NOT NULL
  DROP TABLE dbo.Proizvodjac
GO

CREATE TABLE dbo.Proizvodjac
(
ProizvID int NOT NULL,
Ime varchar(255),
CONSTRAINT pk_ProizvodjacID PRIMARY KEY (ProizvID)
)

-- Tabela  Proizvodjac kraj -----------------------------------------------------

-- Tabela TipDela pocetak -------------------------------------------------------

IF OBJECT_ID('dbo.TipDela', 'U') IS NOT NULL
  DROP TABLE dbo.TipDela
GO

CREATE TABLE dbo.TipDela
(
TipID int NOT NULL,
Tip varchar(255),
CONSTRAINT pk_TipDelaID PRIMARY KEY (TipID)
)

-- Tabela TipDela kraj ----------------------------------------------------------

-- Tabela  Radnik pocetak -------------------------------------------------------

IF OBJECT_ID('dbo.Radnik', 'U') IS NOT NULL
  DROP TABLE dbo.Radnik
GO

CREATE TABLE dbo.Radnik
(
JMBG int NOT NULL,
Ime varchar(255),
Prezime varchar(255),
Delatnost varchar(255),
Status varchar(255),
CONSTRAINT pk_RadnikID PRIMARY KEY (JMBG)
)

-- Tabela Radnik kraj -----------------------------------------------------------

-- Tabela Sektor pocetak --------------------------------------------------------

IF OBJECT_ID('dbo.Sektor', 'U') IS NOT NULL
  DROP TABLE dbo.Sektor
GO

CREATE TABLE dbo.Sektor
(
SektorID int NOT NULL,
Tip varchar(255),
CONSTRAINT pk_SektorID PRIMARY KEY (SektorID)
)

-- Tabela  Sektor kraj ----------------------------------------------------------

-- Tabela KartonStatusDela pocetak ----------------------------------------------

IF OBJECT_ID('dbo.KartonStatusDela', 'U') IS NOT NULL
  DROP TABLE dbo.KartonStatusDela
GO

CREATE TABLE dbo.KartonStatusDela
(
TagNo int NOT NULL,
Primedba varchar(255),
MagacLoka varchar(255),
MagacVek date,
Zahtev varchar(255),
VremePos time,
UkupVrem time,
Razlog varchar(255),
Nalaz varchar(255),
Stanje varchar(255),
Pozicija varchar(255),
datum date,
KlijentID int FOREIGN KEY REFERENCES dbo.Klijent(KlijentID),
RegBr int FOREIGN KEY REFERENCES dbo.Avion(RegBr),
ProizvID int FOREIGN KEY REFERENCES dbo.Proizvodjac(ProizvID),
JMBG int FOREIGN KEY REFERENCES dbo.Radnik(JMBG),
SektorID int FOREIGN KEY REFERENCES dbo.Sektor(SektorID),
CONSTRAINT pk_KartonStatusDelaID PRIMARY KEY (TagNo)
)

-- Tabela KartonStatusDela kraj -------------------------------------------------

-- Tabela Deo pocetak -----------------------------------------------------------

IF OBJECT_ID('dbo.Deo', 'U') IS NOT NULL
  DROP TABLE dbo.Deo
GO

CREATE TABLE dbo.Deo
(
DeoSeBr int NOT NULL,
Naziv varchar(255),
AvNaziv varchar(255),
ProizvID int FOREIGN KEY REFERENCES dbo.Proizvodjac(ProizvID),
TipID int FOREIGN KEY REFERENCES dbo.TipDela(TipID),
TagNo int FOREIGN KEY REFERENCES dbo.KartonStatusDela(TagNo),
RegBr int FOREIGN KEY REFERENCES dbo.Avion(RegBr),
CONSTRAINT pk_DeoID PRIMARY KEY (DeoSeBr,RegBr)
)

-- Tabela Deo kraj -------------------------------------------------------------

-- Tabela ZahtevOtvaranjeNaloga  pocetak ---------------------------------------

IF OBJECT_ID('dbo.ZahtevOtvaranjeNaloga', 'U') IS NOT NULL
  DROP TABLE dbo.ZahtevOtvaranjeNaloga
GO

CREATE TABLE dbo.ZahtevOtvaranjeNaloga
(
BrNaloga int NOT NULL,
Datum date,
VrstaRada varchar(255),
IzvrsRadov varchar(255),
Rok date,
DeoSeBr int,
RegBr int,
JMBG int FOREIGN KEY REFERENCES dbo.Radnik(JMBG),
RegBrAv int FOREIGN KEY REFERENCES dbo.Avion(RegBr),
SektorID int FOREIGN KEY REFERENCES dbo.Sektor(SektorID),
CONSTRAINT pk_ZahtevOtvaranjeNalogaID PRIMARY KEY (BrNaloga)
)

ALTER TABLE dbo.ZahtevOtvaranjeNaloga
  ADD CONSTRAINT fk_ZahtevOtvaranjeNalogaID
  FOREIGN KEY(DeoSeBr,RegBr) REFERENCES Deo(DeoSeBr,RegBr)

-- Tabela ZahtevOtvaranjeNaloga kraj -------------------------------------------

-- Tabela IspitnaLista pocetak -------------------------------------------------

IF OBJECT_ID('dbo.IspitnaLista', 'U') IS NOT NULL
  DROP TABLE dbo.IspitnaLista
GO

CREATE TABLE dbo.IspitnaLista
(
IspitID int NOT NULL,
IzvorPodat varchar(255),
IspitOprem varchar(255),
Revizija int,
Nalaz varchar(255),
Parametri varchar(255),
DeoSeBr int,
RegBr int,
KlijentID int FOREIGN KEY REFERENCES dbo.Klijent(KlijentID),
JMBG int FOREIGN KEY REFERENCES dbo.Radnik(JMBG),
BrNaloga int FOREIGN KEY REFERENCES dbo.ZahtevOtvaranjeNaloga(BrNaloga),
ProizvID int FOREIGN KEY REFERENCES dbo.Proizvodjac(ProizvID),
CONSTRAINT pk_IspitnaListaID PRIMARY KEY (IspitID)
)

ALTER TABLE dbo.IspitnaLista
  ADD CONSTRAINT fk_IspitnaListaID
  FOREIGN KEY(DeoSeBr,RegBr) REFERENCES Deo(DeoSeBr,RegBr)

-- Tabela IspitnaLista kraj ---------------------------------------------------

-- Tabela Trebovanje pocetak --------------------------------------------------

IF OBJECT_ID('dbo.Trebovanje', 'U') IS NOT NULL
  DROP TABLE dbo.Trebovanje
GO

CREATE TABLE dbo.Trebovanje
(
TrebID int NOT NULL,
Datum date,
CONSTRAINT pk_TrebovanjeID PRIMARY KEY (TrebID)
)

-- Tabela Trebovanje kraj -----------------------------------------------------

-- Tabela StavkaTrebovanja pocetak --------------------------------------------

IF OBJECT_ID('dbo.StavkaTrebovanja', 'U') IS NOT NULL
  DROP TABLE dbo.StavkaTrebovanja
GO

CREATE TABLE dbo.StavkaTrebovanja
(
RB int NOT NULL,
Tip varchar(255),
Servis varchar(255),
Izlaz varchar(255),
Komentar varchar(255),
Status varchar(255),
Cena Valuta,
DeoSeBr int,
RegBr int,
TrebID int FOREIGN KEY REFERENCES dbo.Trebovanje(TrebID),
CONSTRAINT pk_StavkaTrebovanjaID PRIMARY KEY (RB,TrebID)
)

ALTER TABLE dbo.StavkaTrebovanja
  ADD CONSTRAINT fk_StavkaTrebovanjaID
  FOREIGN KEY(DeoSeBr,RegBr) REFERENCES Deo(DeoSeBr,RegBr)

-- Tabela StavkaTrebovanja kraj -----------------------------------------------

-- Tabela OdobrenSertifikat pocetak -------------------------------------------

IF OBJECT_ID('dbo.OdobrenSertifikat', 'U') IS NOT NULL
  DROP TABLE dbo.OdobrenSertifikat
GO

CREATE TABLE dbo.OdobrenSertifikat
(
SertID int NOT NULL,
Autoritet varchar(255),
Datum date,
OrgIme varchar(255),
KlijentID int FOREIGN KEY REFERENCES dbo.Klijent(KlijentID),
JMBG int FOREIGN KEY REFERENCES dbo.Radnik(JMBG),
BrNaloga int FOREIGN KEY REFERENCES dbo.ZahtevOtvaranjeNaloga(BrNaloga),
RegBr int FOREIGN KEY REFERENCES dbo.Avion(RegBr),
ProizvID int FOREIGN KEY REFERENCES dbo.Proizvodjac(ProizvID),
CONSTRAINT pk_OdobrenSertifikatID PRIMARY KEY (SertID)
)

-- Tabela OdobrenSertifikat kraj ----------------------------------------------

--======================================
--  Kreiraj T-SQL Triger
--======================================

-- Denormalizacija 2NF Pocetak ================================================

-- Trigeri tabela avion Pocetak -----------------------------------------------

IF OBJECT_ID ('[dbo].[T_IZMENA_AVNAZIV]','TR') IS NOT NULL
   DROP TRIGGER [dbo].[T_IZMENA_AVNAZIV] 
GO

CREATE TRIGGER [dbo].[T_IZMENA_AVNAZIV] ON [dbo].[AVION]
AFTER UPDATE AS
IF UPDATE (AVNAZIV)
BEGIN	
	DECLARE @KursorRegBr AS int;
	DECLARE @KursorAvNaziv varchar(255);
	
	DECLARE KURSOR_IZMENA_AVNAZIV CURSOR FOR
		SELECT [REGBR], [AVNAZIV] FROM INSERTED;	
	
	OPEN KURSOR_IZMENA_AVNAZIV;
	
	FETCH NEXT FROM KURSOR_IZMENA_AVNAZIV INTO @KursorRegBr, @KursorAvNaziv;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		ALTER TABLE [dbo].[DEO] DISABLE TRIGGER [NE_BRISI_AVNAZIV];

		UPDATE [dbo].[DEO]
		SET [AVNAZIV] = (SELECT [AVNAZIV] FROM [dbo].[AVION] WHERE [REGBR] = @KursorRegBr)		
		WHERE [REGBR] = @KursorRegBr;		

		FETCH NEXT FROM KURSOR_IZMENA_AVNAZIV INTO @KursorRegBr, @KursorAvNaziv;
		
		ALTER TABLE [dbo].[DEO] ENABLE TRIGGER [NE_BRISI_AVNAZIV];		
	END
	
	CLOSE KURSOR_IZMENA_AVNAZIV;
	
	DEALLOCATE KURSOR_IZMENA_AVNAZIV;	
END
GO

-- Trigeri tabela avion kraj --------------------------------------------------


-- Trigeri tabela deo Pocetak -------------------------------------------------

IF OBJECT_ID ('[dbo].[T_AZUR_NAZIV]','TR') IS NOT NULL
   DROP TRIGGER [dbo].[T_AZUR_NAZIV] 
GO

CREATE TRIGGER [dbo].[T_AZUR_NAZIV] ON [DBO].[DEO]
AFTER INSERT AS
BEGIN	
	DECLARE @KursorRegBr AS int;
	DECLARE @KursorAvNaziv AS varchar(255);

	DECLARE KURSOR_AZUR_NAZIV CURSOR FOR
		SELECT [REGBR], [AVNAZIV] FROM INSERTED;
	
	OPEN KURSOR_AZUR_NAZIV;
	
	FETCH NEXT FROM KURSOR_AZUR_NAZIV INTO @KursorRegBr, @KursorAvNaziv;
		
	WHILE @@FETCH_STATUS = 0
	BEGIN	
		ALTER TABLE [dbo].[DEO] DISABLE TRIGGER [NE_BRISI_AVNAZIV];

		UPDATE [DBO].[DEO]
		SET [AVNAZIV] = (SELECT [AVNAZIV] FROM [DBO].[AVION] WHERE [REGBR] = @KursorRegBr)
		WHERE [REGBR] = @KursorRegBr
		
		ALTER TABLE [dbo].[DEO] ENABLE TRIGGER [NE_BRISI_AVNAZIV];		
	END	

	CLOSE KURSOR_AZUR_NAZIV;

	DEALLOCATE KURSOR_AZUR_NAZIV;	
END
GO
-------------------------------------------------------------------------------

IF OBJECT_ID ('[dbo].[NE_BRISI_AVNAZIV]','TR') IS NOT NULL
   DROP TRIGGER [dbo].[NE_BRISI_AVNAZIV] 
GO

CREATE TRIGGER [dbo].[NE_BRISI_AVNAZIV] ON [DBO].[DEO]
AFTER UPDATE AS
IF UPDATE (AVNAZIV)
BEGIN
	RAISERROR('Zabranjeno direktno azuriranje kolone AVNAZIV', 16, -1)
	ROLLBACK TRAN
	RETURN
END
GO
 
-- Trigeri tabela deo kraj ----------------------------------------------------

-- Denormalizacija 2NF Kraj ===================================================

-- Denormalizacija 3NF Pocetak ================================================

-- Trigeri tabela Klijent Pocetak ---------------------------------------------

IF OBJECT_ID ('[dbo].[T_IZMENA_IME]','TR') IS NOT NULL
   DROP TRIGGER [dbo].[T_IZMENA_IME] 
GO

CREATE TRIGGER [dbo].[T_IZMENA_IME] ON [dbo].[KLIJENT]
AFTER UPDATE AS
IF UPDATE (IME)
BEGIN
	DECLARE @KursorKlijentID AS int;
	DECLARE @KursorIme AS varchar(255);

	DECLARE KURSOR_IZMENA_IME CURSOR FOR
		SELECT [KLIJENTID], [IME] FROM INSERTED;
	
	OPEN KURSOR_IZMENA_IME;
	
	FETCH NEXT FROM KURSOR_IZMENA_IME INTO @KursorKlijentID, @KursorIme;
		
	WHILE @@FETCH_STATUS = 0
	BEGIN
		ALTER TABLE [dbo].[AVION] DISABLE TRIGGER [NE_BRISI_IME];
		
		UPDATE [dbo].[AVION]
		SET [IME] = (SELECT [IME] FROM [dbo].[KLIJENT] WHERE [KLIJENTID] = @KursorKlijentID)
		WHERE [KLIJENTID] = @KursorKlijentID;

		ALTER TABLE [dbo].[AVION] ENABLE TRIGGER [NE_BRISI_IME];
	END	
	
	CLOSE KURSOR_IZMENA_IME;

	DEALLOCATE KURSOR_IZMENA_IME;	
END
GO

-- Trigeri tabela Klijent kraj ------------------------------------------------

-- Trigeri tabela Avion Pocetak -----------------------------------------------

IF OBJECT_ID ('[dbo].[T_AZUR_IME_INSERT]','TR') IS NOT NULL
   DROP TRIGGER [dbo].[T_AZUR_IME_INSERT] 
GO

CREATE TRIGGER [dbo].[T_AZUR_IME_INSERT] ON [DBO].[AVION]
AFTER INSERT AS
BEGIN
	DECLARE @KursorKlijentID AS int;
	DECLARE @KursorIme AS varchar(255);
	
	DECLARE KURSOR_AZUR_IME_INSERT CURSOR FOR
		SELECT [KLIJENTID], [IME] FROM INSERTED;	
	
	OPEN KURSOR_AZUR_IME_INSERT;
	
	FETCH NEXT FROM KURSOR_AZUR_IME_INSERT INTO @KursorKlijentID, @KursorIme;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN	
		ALTER TABLE [dbo].[AVION] DISABLE TRIGGER [NE_BRISI_IME];

		UPDATE [DBO].[AVION]
		SET [IME] = (SELECT [IME] FROM [dbo].[KLIJENT] WHERE [KLIJENTID] = @KursorKlijentID)
		WHERE [KLIJENTID] = @KursorKlijentID;		

		FETCH NEXT FROM KURSOR_AZUR_IME_INSERT INTO @KursorKlijentID, @KursorIme;
		
		ALTER TABLE [dbo].[AVION] ENABLE TRIGGER [NE_BRISI_IME];		
	END
	
	CLOSE KURSOR_AZUR_IME_INSERT;

	DEALLOCATE KURSOR_AZUR_IME_INSERT;	
END
GO

------------------------------------------------------------------------------

IF OBJECT_ID ('[dbo].[T_AZUR_IME_UPDATE]','TR') IS NOT NULL
   DROP TRIGGER [dbo].[T_AZUR_IME_UPDATE] 
GO

CREATE TRIGGER [dbo].[T_AZUR_IME_UPDATE] ON [DBO].[AVION]
AFTER UPDATE AS
IF UPDATE (IME)
BEGIN	
	DECLARE @KursorKlijentID AS int;
	DECLARE @KursorIme AS varchar(255);

	DECLARE KURSOR_AZUR_IME_UPDATE CURSOR FOR
		SELECT [KLIJENTID], [IME] FROM INSERTED;
	
	OPEN KURSOR_AZUR_IME_UPDATE;
	
	FETCH NEXT FROM KURSOR_AZUR_IME_UPDATE INTO @KursorKlijentID, @KursorIme;
		
	WHILE @@FETCH_STATUS = 0
	BEGIN
		ALTER TABLE [dbo].[AVION] DISABLE TRIGGER [NE_BRISI_IME];

		UPDATE [DBO].[AVION]
		SET [IME] = (SELECT [IME] FROM [dbo].[KLIJENT] WHERE [KLIJENTID] = @KursorKlijentID)
		WHERE [KLIJENTID] = @KursorKlijentID;		

		FETCH NEXT FROM KURSOR_AZUR_IME_UPDATE INTO @KursorKlijentID, @KursorIme;
		
		ALTER TABLE [dbo].[AVION] ENABLE TRIGGER [NE_BRISI_IME];		
	END

	CLOSE KURSOR_AZUR_IME_UPDATE;

	DEALLOCATE KURSOR_AZUR_IME_UPDATE;	
END
GO

------------------------------------------------------------------------------

IF OBJECT_ID ('[dbo].[NE_BRISI_IME]','TR') IS NOT NULL
   DROP TRIGGER [dbo].[NE_BRISI_IME] 
GO

CREATE TRIGGER [dbo].[NE_BRISI_IME] ON [DBO].[AVION]
AFTER UPDATE AS
IF UPDATE (IME)
BEGIN
	RAISERROR('Zabranjeno direktno azuriranje kolone IME', 16, -1)
	ROLLBACK TRAN
	RETURN
END
GO
 
-- Trigeri tabela Avion kraj -------------------------------------------------

-- Denormalizacija 3NF Kraj ===================================================

-- ===================================
-- Kreiraj Index
-- ===================================

-- Index Tabela Avion pocetak -------------------------------------------------

CREATE INDEX klijentID_index 
   ON dbo.Avion (KlijentID); 
GO

-- Index Tabela  Avion kraj ----------------------------------------------------

-- Index Tabela KartonStatusDela pocetak ---------------------------------------

CREATE INDEX klijentID_index 
   ON dbo.KartonStatusDela (KlijentID); 
GO

CREATE INDEX RegBr_index 
   ON dbo.KartonStatusDela (RegBr);
GO

CREATE INDEX ProizvID_index 
   ON dbo.KartonStatusDela (ProizvID);
GO

CREATE INDEX JMBG_index 
   ON dbo.KartonStatusDela (JMBG);
GO

CREATE INDEX SektorID_index 
   ON dbo.KartonStatusDela (SektorID);
GO

-- Index Tabela KartonStatusDela kraj ------------------------------------------

-- Index Tabela Deo pocetak ----------------------------------------------------

CREATE INDEX ProizvID_index 
   ON dbo.Deo (ProizvID);
GO

CREATE INDEX TipID_index 
   ON dbo.Deo (TipID);
GO

CREATE INDEX TagNo_index 
   ON dbo.Deo (TagNo);
GO

CREATE INDEX RegBr_index 
   ON dbo.Deo (RegBr);
GO

-- Index Tabela Deo kraj -------------------------------------------------------

-- Index Tabela ZahtevOtvaranjeNaloga  pocetak ---------------------------------

CREATE INDEX JMBG_index 
   ON dbo.ZahtevOtvaranjeNaloga (JMBG);
GO

CREATE INDEX RegBrAv_index 
   ON dbo.ZahtevOtvaranjeNaloga (RegBrAv);
GO

CREATE INDEX SektorID_index 
   ON dbo.ZahtevOtvaranjeNaloga (SektorID);
GO

-- Index Tabela ZahtevOtvaranjeNaloga kraj -------------------------------------

-- Index Tabela IspitnaLista pocetak -------------------------------------------

CREATE INDEX KlijentID_index 
   ON dbo.IspitnaLista (KlijentID);
GO

CREATE INDEX JMBG_index 
   ON dbo.IspitnaLista (JMBG);
GO

CREATE INDEX BrNaloga_index 
   ON dbo.IspitnaLista (BrNaloga);
GO

CREATE INDEX ProizvID_index 
   ON dbo.IspitnaLista (ProizvID);
GO

-- Index Tabela IspitnaLista kraj ----------------------------------------------

-- Index Tabela StavkaTrebovanja pocetak ---------------------------------------

CREATE INDEX TrebID_index 
   ON dbo.StavkaTrebovanja (TrebID);
GO

-- Index Tabela StavkaTrebovanja kraj ------------------------------------------

-- Index Tabela OdobrenSertifikat pocetak --------------------------------------

CREATE INDEX KlijentID_index 
   ON dbo.OdobrenSertifikat (KlijentID);
GO

CREATE INDEX JMBG_index 
   ON dbo.OdobrenSertifikat (JMBG);
GO

CREATE INDEX BrNaloga_index 
   ON dbo.OdobrenSertifikat (BrNaloga);
GO

CREATE INDEX RegBr_index 
   ON dbo.OdobrenSertifikat (RegBr);
GO

CREATE INDEX ProizvID_index 
   ON dbo.OdobrenSertifikat (ProizvID);
GO

-- Index Tabela OdobrenSertifikat kraj -----------------------------------------

-- =============================================
-- Vertikalno particionisanje
-- =============================================

-- Index Tabela OdobrenSertifikat pocetak --------------------------------------

CREATE VIEW dbo.klijentView AS
SELECT A.KlijentID, A.Ime, A.Adresa, B.Telefon, B.fax, B.email, B.webAdresa, B.KontaktOsoba, B.CallCenter
FROM Klijent A, KlijentKontakt B
WHERE A.KlijentID = B.KlijentKontaktID
GO

-- Index Tabela OdobrenSertifikat kraj -----------------------------------------

-- Instead of triger pocetak ---------------------------------------------------

CREATE TRIGGER Instead_of_ins_tr_klijentView ON dbo.klijentView
INSTEAD OF INSERT
AS
BEGIN
	SET NOCOUNT ON
	-- Insert u tabelu Klijent
	IF (NOT EXISTS (SELECT P.KlijentID FROM Klijent P, inserted I WHERE P.KlijentID = I.KlijentID))
	BEGIN
		INSERT INTO Klijent
		SELECT KlijentID, Ime, Adresa
		FROM INSERTED
	END
	-- Insert u tabelu KlijentKontakt
	IF (NOT EXISTS (SELECT P.KlijentKontaktID FROM KlijentKontakt P, inserted I WHERE P.KlijentKontaktID = I.KlijentID))
	BEGIN
		INSERT INTO KlijentKontakt
		SELECT KlijentID, Telefon, fax, email, webAdresa, KontaktOsoba, CallCenter
		FROM INSERTED
	END	
END
GO

-- Instead of triger kraj -------------------------------------------------------

-- Storing Derivable Values tehnika optimizacije Pocetak ------------------------

CREATE PROCEDURE [dbo].[neispravnihDelova]
@RegBr int
AS
BEGIN
    SET NOCOUNT ON

	-- Implementacija ovde
	ALTER TABLE [dbo].[AVION] DISABLE TRIGGER [NE_BRISI_NEISDELOVA];

	UPDATE [dbo].[Avion]
	SET Neisdelova= (SELECT COUNT([STANJE]) AS NeisDelova FROM KARTONSTATUSDELA
					WHERE [STANJE] = 'Neispravan'
					AND REGBR = @RegBr)
	WHERE RegBr = @RegBr;
		
	ALTER TABLE [dbo].[AVION] ENABLE TRIGGER [NE_BRISI_NEISDELOVA];	
END
GO

---------------------------------------------------------------------------------

CREATE TRIGGER [dbo].[NEISPRAVNI_DELOVI_AVION] ON [DBO].[KARTONSTATUSDELA]
AFTER INSERT,UPDATE, DELETE  AS
BEGIN	
	DECLARE @RegBr AS int;
	
	IF EXISTS(SELECT * FROM INSERTED)
	BEGIN
		DECLARE KURSOR_NEISPRAVNI_DELOVI_AVION CURSOR FOR
			SELECT [REGBR] FROM INSERTED
			PRINT 'INSERTED-UPDATED' -- Tokom insert i update transakcije
	END
	ELSE
	BEGIN
		DECLARE KURSOR_NEISPRAVNI_DELOVI_AVION CURSOR FOR
			SELECT [REGBR] FROM DELETED
			PRINT 'DELETED' -- Tokom delete transakcije
	END
		
	OPEN KURSOR_NEISPRAVNI_DELOVI_AVION;
	
	FETCH NEXT FROM KURSOR_NEISPRAVNI_DELOVI_AVION INTO @RegBr
		
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC neispravnihDelova @RegBr
		FETCH NEXT FROM KURSOR_NEISPRAVNI_DELOVI_AVION INTO @RegBr		
	END

	CLOSE KURSOR_NEISPRAVNI_DELOVI_AVION;

	DEALLOCATE KURSOR_NEISPRAVNI_DELOVI_AVION;	
END
GO

---------------------------------------------------------------------------------

IF OBJECT_ID ('[dbo].[NE_BRISI_NEISDELOVA]','TR') IS NOT NULL
   DROP TRIGGER [dbo].[NE_BRISI_NEISDELOVA] 
GO

CREATE TRIGGER [dbo].[NE_BRISI_NEISDELOVA] ON [DBO].[AVION]
AFTER UPDATE AS
IF UPDATE (NEISDELOVA)
BEGIN
	RAISERROR('Zabranjeno direktno azuriranje kolone NEISDELOVA', 16, -1)
	ROLLBACK TRAN
	RETURN
END
GO

-- Storing Derivable Values tehnika optimizacije Kraj ---------------------------