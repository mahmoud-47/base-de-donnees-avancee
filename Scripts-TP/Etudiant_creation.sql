DROP TABLE IF EXISTS Notation;
DROP TABLE IF EXISTS Epreuve;
DROP TABLE IF EXISTS Matiere;
DROP TABLE IF EXISTS Etudiant;

CREATE TABLE IF NOT EXISTS Etudiant (
  numetu INT PRIMARY KEY,
  nom VARCHAR(45),
  prenom VARCHAR(45),
  datenaiss DATE,
  rue VARCHAR(100),
  cp INT,
  ville VARCHAR(100) );

CREATE TABLE IF NOT EXISTS Matiere (
  codemat VARCHAR(3) PRIMARY KEY,
  libelle VARCHAR(45),
  coef REAL );

CREATE TABLE IF NOT EXISTS Epreuve (
  numepreuve INT PRIMARY KEY,
  datepreuve DATE,
  lieu VARCHAR(100),
  codemat VARCHAR(3) REFERENCES Matiere (codemat) );

CREATE TABLE IF NOT EXISTS Notation (
  numetu INT REFERENCES Etudiant (numetu),
  numepreuve INT REFERENCES Epreuve (numepreuve),
  note REAL,
  PRIMARY KEY(numetu, numepreuve) );
