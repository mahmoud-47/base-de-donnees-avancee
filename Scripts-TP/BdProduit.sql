CREATE TABLE Produit(	
	idProduit NUMERIC(2), 
	nomProduit VARCHAR(50), 
	description VARCHAR(2000), 
	categorie VARCHAR(30), 
	disponible VARCHAR(1), 
	prix NUMERIC(7,2),
	CONSTRAINT Produit_PK PRIMARY KEY (idProduit)
 );

INSERT INTO Produit VALUES (	1,'Ordinateur de Bureau 3.2 GHz','Toutes les options, cette machine est ultra-performante!','Ordinateur','Y','1200'	);
INSERT INTO Produit VALUES (	2,'Lecteur MP3','Stocker plus de 1000 chansons et emmenez-les avec vous','Audio','Y','199'	);
INSERT INTO Produit VALUES (	3,'Ecouteur  Bluetooth','Mains libres, sans fils!','Téléphones','Y','40'	);
INSERT INTO Produit VALUES (	4,'Téléphone PDA','Combinez votre téléphone portable et votre PDA en un seul appareil','Téléphones','Y','250'	);
INSERT INTO Produit VALUES (	5,'Lecteur DVD portable','Assez petit pour l''emporter partout!','Video','Y','500'	);
INSERT INTO Produit VALUES (	6,'Barrette mémoire 512 MB DIMM','Augmentez la mémoire de votre PC et gagnez en performances','Ordinateur','Y','200'	);
INSERT INTO Produit VALUES (	7,'Ecran Plat Plasma 54','Montez au mur ou au plafond, l''image est limpide!','Video','Y','3995'	);
INSERT INTO Produit VALUES (	8,'Projecteur','N''inclut pas les transparents ni les crayons gras','Video','Y','50'	);
INSERT INTO Produit VALUES (	9,'Ordinateur Portable Ultra slim','La puissance d''un ordinateur de bureau dans un design portable','Ordinateur','Y','1999'	);
INSERT INTO Produit VALUES (	10,'Ecouteurs Stéréo','Casque antibruit parfait pour le voyageur','Audio','Y','150'	);

COMMIT;
  