--1-Ecrire un code PL/SQL qui permet d’afficher pour chaque catégorie le nombre total de ses produits.
--Exemple : La catégorie « Produits laitiers » possède 4 produits. 
declare 
cursor cr is
select nomcateg, count(*) as 
from categorie , produit
where categorie.codecateg =produit.codecateg
group by nomcateg;
v_nom categorie.nomcateg%type;
v_nb number;

begin
open cr;
fetch cr into v_nom,v_nb;
while (cr%found )loop 
  DBMS_OUTPUT.PUT_LINE('la categorie ' ||v_nom|| 'possede'||v_nb||'produits.');
   fetch cr  into  v_nom,v_nb;
end loop;
end;
/
--pour pouvoir afficher (set serverout on)!!
-- 2-Ecrire une procédure qui supprime les produits qui n’étaient jamais commandés.

create or replace procedure supp as
cursor cr is
select refprod
from produit where refprod not in (SELECT DISTINCT refprod from detailcommande);
v_refprod produit.refprod%TYPE;
nb_prod_suppr integer := 0; 
begin
open cr;
fetch cr into v_refprod;
while (cr%FOUND) loop
Delete from Produit 
where refprod = v_refprod;
 commit;
  dbms_output.put_line('le produit N' ||v_refprod );
fetch cr into v_refprod;
  end loop;
  close cr;
end Supp;
/


--commit pour pouvoir enregistrer les changements sur le disque
--show error ,permet d afficher les erreur
-- execute supp ,pour executer la procedure

--3. Ecrire une procédure qui affiche le nom, la fonction et le chiffre d'affaire généré des employés dont le chiffre d'affaire généré par ses commandes est entre 10000DA et 8000DA.

create or replace procedure AfficherEmployesCA AS
  cursor cA is
    select e.nom, e.fonction, sum(d.prixunit * d.qte - (d.prixunit * d.qte * d.remise)) As chiffreaffaire
    from employe e
    join commande c on e.noemp = c.noemp
    join detailcommande d on c.nocom = d.nocom
    group by e.nom, e.fonction
    having sum(d.prixunit * d.qte - (d.prixunit * d.qte * d.remise)) between 8000 and 10000
    order by chiffreaffaire desc;
  v_nom employe.nom%type;
  v_fonction employe.fonction%type;
  v_chf_a number;

begin
  open cA;
  loop
    fetch cA into v_nom, v_fonction, v_chf_a;  -- Correspondance exacte avec les colonnes du SELECT
    exit when cA%NOTFOUND;
    dbms_output.put_line('Nom : ' || v_nom || ', Fonction : ' || v_fonction || ', Chiffre d Affaires : ' || v_chf_a || ' DA');
  end loop;
  close cA;
end;
/


--4- Ecrire une fonction qui retourne , pour chaque client donne, le nombre de ses commandes.Executer la fonction pour plusieurs clients


CREATE OR REPLACE FUNCTION QUESTION4 (p_nom VARCHAR2) 
RETURN NUMBER IS
  v_order_count NUMBER;
BEGIN

  SELECT COUNT(*) 
  INTO v_order_count
  FROM clients c , commandes cd
  WHERE c.code_client = cd.code_client AND cd.Destinataire=p_nom;
DBMS_OUTPUT.PUT_LINE('LE CLIENT'p_nom 'a'v_order_count'commandes');

  RETURN v_order_count;

END QUESTION4;


















 --a: Exemple: le client frankenversand a 5 commandes .
--RMQ-- verifier le numero de commande s'il existe ->  oui: on recupere (select into) definier une variable 
  --                                                    si la requete donne une valeurs.
   ---                                                 non (null): error ne pas inserer  raise application.
                                                   
create or replace procedure ajout
(
  nocom%type ,
  codecli varchar(4)%type ,
  noemp integer%type ,
  datecom date%type ,
  alivavant date%type ,
  dateenv date%type ,
  nomess int%type,
  port varchar(30) ,
  destinataire varchar(30)  ,
  adrliv varchar(30)  ,
  villeliv varchar(30),
  regionliv varchar(30) ,
  codepostalliv varchar(30) ,
  paysliv varchar(30)
 no_com in commande.nocom%type;
 
 
is erreur boolean :=false;
nom_commande com commande.nocom%type;
num client
num employe
num message

begin 
declare 
num commande null    exception 
num commande existe exception 
begin 
if(no com is null) then
raise numm commande null
else 
select  nomcom into num com from commande 
where
nocom = num com
raise numcommande_existe;
end if
exception 
when  num commande null then 
dbms ("error: le numero de la commande est obligatoire
erreur:= true;
when  num commande existe then 
dbms("error:le numero
when no data found then null
end 

--verifier le code de client
declare 
client null exception 
begin 
if  code_clu is null
then raise client null
else 
select codecli into num client 
from client 
where codecli=code_cli;
end if
exception 
             
             
             
.............................
if (erreur = false) then 
insert nto commande values 
commit ;
dbms ( la commande est bien ajouter)

else 

                                                   
 
--5. Créer une procédure qui permet d’ajouter une commande à partir de tous les attributs nécessaires.
--N’oublier pas de vérifier l’unicité de la clé et l’existence de clé étrangère vers les tables référencées. Affichez
--les messages d’erreurs en cas de problèmes.




