--Exercice  les vues
--du coup a ce niveau la ^-^
--soit le schema de bd suivant , relatif a la gestion de location de véhicules:
--Voiture (Matricule, Modele,Marque , Couleur,Description,IdAgence*)
-----      __________
--Client (NumCI, Nom,Prenom,Genre,Adresse,Tel)
  ----     ______
--Agence (IdAgence ,Adresse,Responsable)
------  __________
--Louer(IdAgebce,NumCI,Matricule,DateDebut,Datefin,Prix,TypeLocation)
------____________________________________

--1- Creez la table voiture avec les contraintes d integrite statique propose les domaines de valeurs de votre choix


-- création de la table agence
create table agence (
    idagence int primary key,
    adresse varchar2(50),
    responsable char(15)
);

-- création de la table voiture
create table voiture (
    matricule number primary key,
    modele varchar2(50) not null,
    marque varchar2(50) not null,
    couleur char(15),
    description varchar2(50),
    idagence int,
    constraint fk_idagence foreign key (idagence) references agence(idagence)
);

-- création de la table client
create table client (
    numci number primary key,
    nom char(30),
    prenom char(30),
    genre char(1) check (genre in ('M', 'F')),
    adresse char(50),
    tel int
);

-- création de la table louer
create table louer (
    idagence int,
    numci int,
    matricule int,
    datedebut date,
    datefin date,
    prix int check (prix > 2000000),
    typelocation char(30),
    constraint fk_c1 foreign key (numci) references client(numci),
    constraint fk_agence foreign key (idagence) references agence(idagence),
    constraint fk_voiture foreign key (matricule) references voiture(matricule),
  --  constraint ck_date check (datedebut < datefin),
    constraint pk_louer primary key (idagence, numci, matricule, datedebut)
);

-- insertion des données dans les tables
insert into client values (12, 'Mohamed', 'Ahmed', 'M', 'Alger', 123456);
insert into client values (14, 'Moussa', 'Haroune', 'M', 'Oran', 123456);
insert into client values (15, 'ishak', 'yakoub', 'M', 'Oran', 123456);
insert into client values (16, 'zakaria', 'yahia', 'M', 'Oran', 123456);



insert into agence values (1, 'Alger', 'Ayoub');
insert into voiture values (1234, 'Clio', 'Renault', 'Grise', 'Voiture compacte', 1);

-- insertion d'une location
insert into louer values (1, 14, 1234, sysdate , sysdate+5, 200000, ' longue duree');
insert into louer values (1, 12, 1234, sysdate , sysdate+7, 210000, 'courte duree');
insert into louer values (1, 15, 1234, sysdate , sysdate+7, 210000, 'longue duree');


2-- Requête pour afficher les clients n ayant jamais effectue une location de type="longue durée"

SELECT Nom, Prenom
FROM Client
WHERE NumCI NOT IN (
    SELECT DISTINCT NumCI
    FROM Louer
    WHERE TypeLocation = 'longue duree'
);



--3--- Quelles sont les agences d alger qui offrent uniquement des voitures de marque =" Volkswagen" ou "BMW"
insert into agence values (2, 'Alger', 'Aissa');
insert into Voiture values (2222,'audi','BMW','Noir','aaa',1);
insert into Voiture values (3333,'audi','BMW','Noir','aaa',2);
insert into Voiture values (4444,'Y','Volkswagen','Noir','aaa',2);

--cette requette est fausse ! car elle me permet de ramener l agence N 1  est celle la assure la location de ...
select agence.IdAgence,Adresse from agence, voiture
where agence.IdAgence = voiture.IdAgence and marque ='Volkswagen' or marque ='BMW' (-- on peut faire marque in  ('Volkswagen','BMW'))

--correction 

select  distinct (agence.IdAgence,Adresse) from agence, voiture
where Adresse = 'ALGER'    and  agence.IdAgence = voiture.IdAgence and marque ='Volkswagen' or marque ='BMW'
and agence.IdAgence not in ( select voiture.idAgence from voiture
where marque not in   ('Volkswagen','BMW');)


--4-- creer et utiliser une vue V1 pour determiner les clients les plus fideles (qui effectuent le plus de location agnece) V1 est elle mettable a jour(c a d insertion au niveeau de la vue ce faire directement  surr la table)?

create  vues V1 as 
               select count(*) as nb,client.numcI
               from louer, client 
               where louer.numCI = client.numCI
               group by louer.numCI
               order by nb DESC;
--limit 0;

--5-- AJOUTER DE FACON PERMANENET   l information sur le nombre de locations par client
--que propose pour elimenter NBL de facon automatique a chaque insertion ou supprission 
--donner cette operation 

on doit ajouter un trigger qui me permet de mettre a jour le nbr , 
elle sera mise a jour directement

au niveau de la boucle  on peut ajouter le having pour recuper  directemnt le max

