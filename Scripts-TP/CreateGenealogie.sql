

-- ----------------------------------------------------------------------
-- TABLE : Personne
-- ----------------------------------------------------------------------
CREATE TABLE Personne ( 
	numPers integer NOT NULL
	, nomPers VARCHAR(20)
	, prenomPers VARCHAR(20)
	, sexePers VARCHAR(1)	CHECK (sexePers IN ('F','M'))
	, CONSTRAINT PK_Personne PRIMARY KEY (numPers)  
);

-- ----------------------------------------------------------------------
-- TABLE : MereDe
-- ----------------------------------------------------------------------
CREATE TABLE MereDe ( 
	numPersEnfant integer NOT NULL
	, numPersMere integer
	, CONSTRAINT PK_MereDe PRIMARY KEY (numPersEnfant)
) ;

-- ----------------------------------------------------------------------
-- TABLE : PereDe
-- ----------------------------------------------------------------------
CREATE TABLE PereDe ( 
	numPersEnfant integer NOT NULL
	, numPersPere integer
	, CONSTRAINT PK_PereDe PRIMARY KEY (numPersEnfant)
) ;

-- ----------------------------------------------------------------------
-- CREATION DES REFERENCES DE TABLE
-- ----------------------------------------------------------------------
ALTER TABLE MereDe ADD 
	CONSTRAINT FK_MereDe_PersonneEnfant FOREIGN KEY (numPersEnfant)
		REFERENCES Personne (numPers) ;

ALTER TABLE MereDe ADD 
	CONSTRAINT FK_MereDe_PersonneMere FOREIGN KEY (numPersMere)
		REFERENCES Personne (numPers);

ALTER TABLE PereDe ADD 
	CONSTRAINT FK_PereDe_PersonneEnfant FOREIGN KEY (numPersEnfant)
		REFERENCES Personne (numPers) ;

ALTER TABLE PereDe ADD 
	CONSTRAINT FK_PereDe_PersonnePere FOREIGN KEY (numPersPere)
		REFERENCES Personne (numPers) ;
