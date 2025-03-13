-- Suppression des tables si elles existent déjà
DROP TABLE Resultat CASCADE CONSTRAINTS;
DROP TABLE Participant CASCADE CONSTRAINTS;
DROP TABLE Examen CASCADE CONSTRAINTS;
DROP TABLE Grade CASCADE CONSTRAINTS;

--1. Ecrire la requête SQL qui permet de créer les table de cette base de données.

Grade (NumGrade, IntiuléGrade)
Examen (NumExam, NomExam, DateExam, DateResut)
Participant (NumParticipant, Nomp, Prenomparticipant, NumGrade*)
Résultat ( NumParticipant*, NumExam*, Note)

create table Grade (
NumGrade integer primary key , 
IntiuleGrade char(50)
);

CREATE TABLE Examen (
    NumExam INTEGER PRIMARY KEY,
    NomExam CHAR(20) ,
    DateExam DATE,
    DateResult DATE
);


CREATE TABLE  Participant (
NumParticipant integer primary key,
Nomp char (50)  , 
Prenomparticipant char(50), 
NumGrade INTEGER ,--cle etrangere 
 CONSTRAINT fk_NumGrade FOREIGN KEY (NumGrade) REFERENCES Grade(NumGrade)
);

CREATE TABLE Resultat (
    NumParticipant INTEGER,
    NumExam INTEGER,
    Note FLOAT,
    CONSTRAINT pk_res PRIMARY KEY (NumParticipant, NumExam),
    CONSTRAINT ck_note CHECK (Note >= 0 AND Note <= 20),
    CONSTRAINT fk_numpp FOREIGN KEY (NumParticipant) REFERENCES Participants(NumParticipant),
    CONSTRAINT fk_numee FOREIGN KEY (NumExam) REFERENCES Examen(NumExam)
);

--2. Supprimer l’attribut DateExam de la relation Examen. Vérifier la suppression

alter table Examen 
drop column DateExam;
--desc pour verifier les attributs et les contraintes d'une table 
DESCRIBE Examen 

--3. Ajouter la contrainte not null pour les attributs :
---• IntiuleGrade dans la relation Grade,
--• Nomparticipant, Prénomparticipant dans la relation participants
--• et NomExam la relation Examen.

alter table grade
modify IntiuleGrade varchar2(50) not null;

alter table participants
modify nomp char(50) not null;

alter table participants
modify prenomparticipant char(50) not null;

alter table examen
modify nomexam char(20) not null;


--4. Modifier la longueur de l’attribut IntiuleGrade (agrandir, réduire).
--agrandir
alter table Grade 
modify IntiuleGrade char(10);
--reduire
alter table Grade 
modify IntiuleGrade varchar2(100);

--6. Renommer la colonne NomP dans la table Participants par NomParticipant. Vérifier

alter table Participants
RENAME COLUMN NomP TO NomParticipant;
 


DESCRIBE Participants

--7. Ajouter la contrainte suivante : L’attribut IntiuleGrade de la table Grade prend ses valeurs dans le
--domaine { ' ING Principal ', ' ING SI ', ' ING SYS ', ' TS ' }.

alter table grade 
add constraints   ck_IntituleGrade check   ( IntiuleGrade in ('ING Principal', 'ING SI', 'ING SYS', 'TS' ));

--8-Ajouter la contrainte suivante : L’attribut NomExam de la table Examen prend ses valeurs dans le
--domaine { ' BDD ', 'SI ', 'SYS ', ' GL ', ' Culture générale ', }

alter table Examen 
add constraint ck_NomExam CHECK (NomExam IN ('BD', 'SI', 'Culture générale'));


--9-Ajouter la contrainte suivante : La date de l’affichage du résultat représentée par l’attribut
--DateResut doit être supérieur à celle de l’examen ( représentée par l’attribut DateExam)

alter table Resultat
add  DateResut date check( DateResut > DateExam);
--Remarque
---Les contraintes CHECK ne peuvent pas impliquer des colonnes d'autres tables en Oracle.
--Cela inclut la comparaison entre DateResut et DateExam. Une alternative serait d'utiliser un trigger pour valider cette contrainte.
















