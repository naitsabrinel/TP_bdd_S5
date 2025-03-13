
/*Partie II : Langage de définition de données*/
/*4.	Créer les relations de la base de données avec toutes les contraintes d’intégrité.*/
----création des tables de la BD--------------
-- description de la table categorie
CREATE TABLE categorie (
  codecateg int,
  nomcateg varchar(30),
  description varchar(150),
 constraint pk_categorie PRIMARY KEY (codecateg)
);
-- description de la table client
CREATE TABLE client (
  codecli varchar(4),
  societe varchar(30),
  contact varchar(30),
  fonction varchar(30),
  adresse varchar(30),
  ville varchar(30),
  region varchar(30),
  codepostal varchar(30) ,
  pays varchar(30) ,
  tel varchar(30) ,
  fax varchar(30) ,
  constraint pk_client PRIMARY KEY (codecli)
);
--Structure de la table  fournisseur 
CREATE TABLE fournisseur  (
   nofour  int  ,
   societe  varchar(30) ,
   contact  varchar(30) ,
   fonction  varchar(30) ,
   adresse  varchar(30) ,
   ville  varchar(30),
   region  varchar(30) ,
   codepostal  varchar(30) ,
   pays  varchar(30) ,
   tel  varchar(30) ,
   fax  varchar(30) ,
   pageaccueil  varchar(30) ,
   constraint pk_fournisseur  PRIMARY KEY ( nofour )
);
-- description de la table messager
CREATE TABLE  messager (
   nomess  int,
   nommess  varchar(30),
   tel  varchar(30),
  constraint pk_messager PRIMARY KEY ( nomess )
);
-- Structure de la table produit
CREATE TABLE  produit (
   refprod  int,
   nomprod  varchar(100) ,
   nofour  int ,
   codecateg  int ,
   qteparunit  varchar(100) ,
   prixunit  number ,
   unitesstock  int ,
   unitescom  int ,
   niveaureap  int ,
   indisponible  int ,
   constraint pk_produit PRIMARY KEY ( refprod ),
   constraint fk_Categorie foreign key(codecateg) references categorie(codecateg) on delete cascade,
   constraint fk_fournisseur foreign key(nofour) references fournisseur(nofour) on delete cascade,
   constraint ck_indisponible check (indisponible in (0,1))
);

-- Structure de la table  employe 
CREATE TABLE   employe  (
   noemp  int ,
   nom  varchar(30) ,
   prenom  varchar(30) ,
   fonction  varchar(30) ,
   titrecourtoisie  varchar(30) ,
   datenaissance  date  ,
   dateembauche  date ,
   adresse  varchar(30) ,
   ville  varchar(30) ,
   region  varchar(30) ,
   codepostal  varchar(30) ,
   pays  varchar(30) ,
   teldom  varchar(30) ,
   extension  varchar(30)  ,
   rendcomptea   int ,
   constraint pk_employe PRIMARY KEY ( noemp ),
   constraint ck_date check (datenaissance<dateembauche), 
   constraint fk_employe foreign key(rendcomptea ) references employe (noemp) on delete CASCADE
);
-- Structure de la table commande
CREATE TABLE  commande (
  nocom int ,
  codecli varchar(4) ,
  noemp integer ,
  datecom date ,
  alivavant date ,
  dateenv date ,
  nomess int,
  port varchar(30) ,
  destinataire varchar(30)  ,
  adrliv varchar(30)  ,
  villeliv varchar(30),
  regionliv varchar(30) ,
  codepostalliv varchar(30) ,
  paysliv varchar(30) ,
  constraint pk_commande PRIMARY KEY (nocom),
  constraint fk_Client foreign key(codecli) references client(codecli) on delete cascade,
  constraint fk_employe_com foreign key(noemp) references employe(noemp) on delete cascade,
  constraint fk_messager foreign key(nomess) references messager(nomess) on delete cascade
) ;
-- Structure de la table detailcommande
CREATE TABLE  detailcommande (
  nocom int  ,
  refprod int  ,
  prixunit NUMBER  ,
  qte int  ,
  remise number ,
  constraint pk_detailcommande PRIMARY KEY (nocom,refprod),
  constraint fk_produit foreign key(refprod) references produit(refprod) on delete cascade,
  constraint fk_commande foreign key(nocom) references commande(nocom) on delete cascade
  ) ;
---structure table erreurs
CREATE TABLE TableErreurs   (adresse ROWID, utilisateur VARCHAR2(30), nomTable VARCHAR2(30),nomContrainte VARCHAR2(30));

