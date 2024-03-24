


-- Table etudiants

CREATE TABLE etudiants (
  NET 		 SERIAL PRIMARY KEY ,
  nom 		 varchar(50),
  prenom 	 varchar(50),
  email  	 varchar(100)
) ;


-- Table examens

CREATE TABLE examens (
  NEX 		 SERIAL PRIMARY KEY,
  matiere 	 varchar(50) ,
  professeur 	 varchar(50),
  session 	 varchar(20),
  annee 	 int,
  niveau 	 int,
  typeex 		 varchar(20),
  duree 	 numeric
) ;


-- Table groupes

CREATE TABLE groupes (
  NGR 		 SERIAL PRIMARY KEY,
  promo		 int,
  annee		 int,
  groupe	 varchar(10),
  UNIQUE (Promo, annee, groupe)
) ;


-- Table epreuves

CREATE TABLE epreuves (
  NEP 			 SERIAL PRIMARY KEY,
  salle 		 int,
  dateHeure 		 timestamp,
  NEX 			 int not NULL, FOREIGN KEY (NEX) REFERENCES examens (NEX) ON UPDATE CASCADE,
  NGR 			 int, FOREIGN KEY (NGR) REFERENCES groupes (NGR) ON DELETE SET NULL ON UPDATE CASCADE,
  UNIQUE (NGR, dateHeure)
) ;




-- Table evaluer

CREATE TABLE evaluer(
  NET 		 int,FOREIGN KEY (NET) REFERENCES etudiants (NET) ON DELETE CASCADE ON UPDATE CASCADE,
  NEP 		 int,FOREIGN KEY (NEP) REFERENCES epreuves (NEP) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY 	 (NET,NEP),
  note 		 int not NULL
) ;


-- Table participer

CREATE TABLE participer (
  NGR 		 int,
  NET 		 int,
  CONSTRAINT participer_ngr_fk FOREIGN KEY (NGR) REFERENCES groupes (NGR) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT participer_net_pk FOREIGN KEY (NET) REFERENCES etudiants (NET) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY 	(NGR,NET)
) ;

-- Remarque : on nomme les clés étrangères avec le CONSTRAINT : participer_ngr_fk et participer_net_fk


-- Tuples etudiants

INSERT INTO etudiants VALUES 
(1,'Dupont','Jean','jeandupont@yahoo.fr'),(2,'Durand','Marie','maried@hotmail.com'),
(3,'Dupont','Pierre','dupontp@caramail.com'),(4,'David','Marc','marcdavid@yahoo.com'),
(5,'Dupuis','Vanessa','vaness632@caramail.com'),(6,'Carlier','Stephane','steph@carlier.com'),
(7,'Merlot','Stephane','merlot@yahoo.fr'),(8,'Chenu','Caroline','carochenu@laposte.net'),
(9,'Michelin','Baptiste','bap@mymail.com'),(10,'Nerval','Marie-Ange','man@email.com'),
(11,'Janset','Nicole','nicolejanset@yahoo.fr'),(12,'Brulard','Nicolas','nico@brulard.com'),
(13,'Jordan','Jacques','jak@myemail.com'),(14,'Chamblard','Philippe',NULL),
(15,'Etienne','Paul','paulot@today.com'),(16,'Decroix','Johann','johann2x@yahoo.com'),
(17,'Lutece','Stephanie',NULL),(18,'Tourette','Carmen','carmenita@yahoo.fr'),
(19,'Leonin','Jean-Sebastien','jsl@mydomain.com'),(20,'Vassal','Helene','helene_vassal@hotmail.com'),
(21,'Dumont','Xavier',NULL),(22,'Williot','Claire','claire_w@caramail.com'),(23,'Cremant','Gregory','greg@cremant.fr'),
(24,'Mauroit','Sandra',NULL),(25,'Guyard','Bertrand','tranber18@caramail.com'),
(26,'Dupret','Jean-Francois','jfdupret@hotmail.com'),(27,'Allard','Severine','sevallard@hotmail.com'),
(28,'Chetty','Stanislas','stan@chetty.com'),(29,'Laury','Etienne','etiennelaury@yahoo.com'),
(30,'Mironton','Claude','claudemironton@yahoo.fr'),(31,'Ghilain','Sophie',NULL),
(32,'Genty','Aurore','auroregenty@laposte.net'),(33,'Thibault','Jeremy','jerem45@yahoo.fr'),
(34,'Lorrain','Michel','mlorrain@aol.com'),(35,'Parclos','Celine','celineparclos@hotmail.com'),
(36,'Cadet','Alexandre',NULL);


-- Tuples examens

INSERT INTO examens VALUES 
(1,'mathematiques','Martin','juin',2006,1, 'ecrit',3),
(2,'mathematiques','Martin','septembre',2006,1,'oral',1),
(3,'anglais','Jones','juin',2006,1,'ecrit',2),
(4,'anglais','Jones','septembre',2006,1,'oral',0.5),
(5,'culture generale','Dupuis','juin',2006,1,'ecrit',1),
(6,'culture generale','Dupuis','septembre',2006,1,'oral',0.5),
(7,'mathematiques','Martin','juin',2006,2,'ecrit',1),
(8,'mathematiques','Martin','septembre',2006,2,'ecrit',1),
(9,'mathematiques','Martin','juin',2006,3,'ecrit',1),
(10,'mathematiques','Martin','septembre',2006,3,'ecrit',1),
(11,'anglais','Jones','juin',2006,2,'ecrit',1),
(12,'anglais','Jones','septembre',2006,2,'ecrit',1),
(13,'anglais','Jones','juin',2006,3,'ecrit',1),
(14,'anglais','Jones','septembre',2008,3,'ecrit',1);


-- Tuples groupes

INSERT INTO groupes VALUES 
(1, 2011, 1, 'A'),
(2, 2011, 1, 'B'),
(3,2010, 2, 'SIGL'),
(4,2010, 2, 'SRT'),
(5, 2009, 3,'SIGL'), 
(6, 2009, 3,'SRT'),
(7,2010, 1, 'A'), 
(8,2010, 1, 'B'),
(9, 2009, 1,'A'), 
(10, 2009, 1,'B'),
(11,2009, 2, 'SIGL'),
(12 ,2009, 2, 'SRT');


-- Tuples epreuves

INSERT INTO epreuves VALUES 
(1,301, '2006-10-17 17:30:00',1,1),
(2,302, '2006-10-17 17:30:00',1,2),
(3,302, '2006-10-21 9:00:00',2,1),
(4,302, '2006-10-21 14:00:00',2,2),
(5,101, '2006-11-10 9:00:00',3,1),
(6,101, '2006-11-10 14:00:00',3,2),
(7,106, '2006-11-20 9:00:00',4,1),
(8,107, '2006-11-21 9:00:00',4,2),
(9,302, '2007-01-12 9:00:00',6,1),
(10,301, '2007-01-12 9:00:00',6,2),
(11,302, '2007-01-25 15:00:00',5,1),
(12,303, '2007-01-25 15:00:00',5,2);


-- Tuples evaluer

INSERT INTO evaluer VALUES (1,1,14),(1,5,11),(1,7,7),(1,9,12),(1,11,13),(2,1,6),(2,3,10),
(2,5,14),(2,7,12),(2,11,15),(3,1,17),(3,5,5),(3,7,7),(3,9,9),(3,11,10),(4,1,8),
(4,3,13),(4,5,9),(4,7,10),(4,9,12),(4,11,12),(5,1,10),(5,5,12),(5,7,13),(5,11,18),
(6,1,6),(6,3,10),(6,5,8),(6,7,11),(6,9,10),(6,11,10),(7,4,13),(7,6,9),(7,8,11),
(7,12,14),(8,2,13),(8,6,13),(8,8,13),(8,12,13),(9,2,6),(9,4,8),(9,6,4),(9,8,5),
(9,10,5),(9,12,7),(10,2,4),(10,4,9),(10,6,10),(10,8,11),(10,12,11),(11,2,14),
(11,6,4),(11,8,8),(11,10,5),(11,12,9),(12,2,9),(12,4,11),(12,6,3),(12,10,7),(12,12,10),
(13,2,11),(13,6,11),(13,8,12),(13,12,16);


-- Tuples participer

INSERT INTO participer VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),
(2,7),(2,8),(2,9),(2,10),(2,11),(2,12),(2,13),
(3,14),(3,15),(3,16),(3,17),(3,18),(3,19),(3,20),
(4,21),(4,22),(4,23),(4,24),(4,25),(4,26),(4,27),
(7,14),(8,15),(7,16),(8,17),(7,18),(8,19),(7,20),
(8,21),(7,22),(8,23),(7,24),(8,25),(7,26),(8,27),(7,28),
(5,30),(5,31),(5,32),(5,33),(5,34),(5,35),(5,36),
(11,29),(11,30),(11,31),(11,32),(11,33),(11,34),(11,35),(11,36),
(9,29),(9,30),(9,31),(9,32),(10,33),(10,34),(10,35),(10,36);
