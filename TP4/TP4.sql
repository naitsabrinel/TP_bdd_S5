--1- creez un trigger qui affiche "'un nouveau employe est ajoute" apres chaque insertion d un emplote 
--repetez la meme chose pour la modification et laa suppression

create or replace trigger T1
after insert on Employe
For each row 
declare
nb int;

begin
dbms_output.put_line('un nouveau employe est ajoute'|| :new.noemp);
commit; --- ajouter le commit l insertion elle doit etre valider sinon elle affiche une erreur lors de l insertion 
select count(*) into nb from employe;
dbms_output.put_line('le nombre d employe existants est '||nb);

end;
/
--2- Creez un trigger qui affiche " un produit est ajouté a la categorie [nom de la categorie]"
--apres chaque insertion dans la table produit

-- quand? affichage
--afficher le nbr de produit de la categorie insert 
create or replace trigger T2
after insert on produit
For each row 
declare 
v_nomcateg categorie.nomcateg%type;
nb int;
begin 
select count(*) into nb from produit;
 --recuperer le nom de la categorie--
 select nomcateg into v_nomcateg
 from categorie
 where codecateg=:new.codecateg ;
 dbms_output.put_line('un nouveau produit est ajoute'|| v_nomcateg ||'le nbr de produit est '|| nb );

end;
/

-- and produit.codecateg = categorie.codecateg ;


--3--Créer un triggers qui vérifie avant modification du l’attribut code client dans la table commande que la
nouvelle valeur existe réellement, sinon, il refuse l’opération.


CREATE OR REPLACE TRIGGER trg_check_codecli
BEFORE UPDATE OF codecli ON commande
FOR EACH ROW
DECLARE
  v_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_exists FROM client WHERE codecli = :NEW.codecli;
  IF v_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Le code client n’existe pas.');
  END IF;
END;
/

4. L’administrateur veut, pour un besoin interne, avoir le chiffre d’affaire généré par chaque produit.
Pour cela, il ajoute un attribut : CHIFFRE_AFFAIRE dans la table produit.
a. Ajouter l’attribut.

ALTER TABLE produit ADD chiffre_affaire NUMBER DEFAULT 0;

b. Créer un trigger CHIFFRE_AFFAIRE_TRIGGER qui mit à jour l’attribut CHIFFRE_AFFAIRElors d'une
insertion, d'une modification et une suppressiondans la table DETAILCOMMANDE. 


CREATE OR REPLACE TRIGGER chiffre_affaire_trigger
AFTER INSERT OR UPDATE OR DELETE ON detailcommande
FOR EACH ROW
BEGIN
  -- Mise à jour après une insertion
  IF INSERTING THEN
    UPDATE produit
    SET chiffre_affaire = chiffre_affaire + 
                          (:NEW.prixunit * :NEW.qte - (:NEW.prixunit * :NEW.qte * NVL(:NEW.remise, 0)))
    WHERE refprod = :NEW.refprod;
  END IF;

  -- Mise à jour après une modification
  IF UPDATING THEN
    UPDATE produit
    SET chiffre_affaire = chiffre_affaire - 
                          (:OLD.prixunit * :OLD.qte - (:OLD.prixunit * :OLD.qte * NVL(:OLD.remise, 0)))
                          + 
                          (:NEW.prixunit * :NEW.qte - (:NEW.prixunit * :NEW.qte * NVL(:NEW.remise, 0)))
    WHERE refprod = :NEW.refprod;
  END IF;

  -- Mise à jour après une suppression
  IF DELETING THEN
    UPDATE produit
    SET chiffre_affaire = chiffre_affaire - 
                          (:OLD.prixunit * :OLD.qte - (:OLD.prixunit * :OLD.qte * NVL(:OLD.remise, 0)))
    WHERE refprod = :OLD.refprod;
  END IF;
END;
/


5. L’administrateur veut sauvegarder pour chaque date le nombre de commandes passées. A chaque
fois une commande est ajoutée, on ajoute une ligne dans la table Historique_commande (DateC,
total_commande) ou bien on mit à jour l’attribut total_commande.
a. Ajouter la table.
CREATE TABLE Historique_commande (
  DateC DATE PRIMARY KEY,           -- Date des commandes
  total_commande INT DEFAULT 0      -- Nombre total de commandes pour la date
);

b. Vérifier cette contrainte lors d'une insertion, d'une modification et une
suppression.

CREATE OR REPLACE TRIGGER Historique_commande_trigger
AFTER INSERT OR UPDATE OR DELETE ON commande
FOR EACH ROW
DECLARE
  nb INT;  -- Variable pour stocker le nombre de commandes
BEGIN
  -- Cas d'une insertion
  IF INSERTING THEN
    -- Compter le nombre de commandes pour la date de la nouvelle commande
    SELECT COUNT(*) INTO nb FROM commande WHERE datecom = :NEW.datecom;
    BEGIN
      -- Vérifier si la date existe déjà dans Historique_commande
      -- Si elle n'existe pas, l'insérer
      INSERT INTO Historique_commande (DateC, total_commande)
      VALUES (:NEW.datecom, nb)
      ON CONFLICT (DateC) DO UPDATE
      SET total_commande = total_commande + 1;
    END;
  END IF;

  -- Cas d'une mise à jour
  IF UPDATING THEN
    IF :OLD.datecom != :NEW.datecom THEN
      -- Réduire le total pour l'ancienne date
      UPDATE Historique_commande
      SET total_commande = total_commande - 1
      WHERE DateC = :OLD.datecom;

      -- Supprimer l'entrée si le total_commande devient 0
      DELETE FROM Historique_commande
      WHERE total_commande = 0;

      -- Ajouter le total pour la nouvelle date
      SELECT COUNT(*) INTO nb FROM commande WHERE datecom = :NEW.datecom;
      BEGIN
        INSERT INTO Historique_commande (DateC, total_commande)
        VALUES (:NEW.datecom, nb)
        ON CONFLICT (DateC) DO UPDATE
        SET total_commande = total_commande + 1;
      END;
    END IF;
  END IF;

  -- Cas d'une suppression
  IF DELETING THEN
    -- Réduire le total pour la date de la commande supprimée
    UPDATE Historique_commande
    SET total_commande = total_commande - 1
    WHERE DateC = :OLD.datecom;

    -- Supprimer l'entrée si le total_commande devient 0
    DELETE FROM Historique_commande
    WHERE total_commande = 0;
  END IF;
END;
/
