
insert into Grade values(1,'ING Principal'); --oui
insert into Grade values(2,'ING SI');  -- oui
insert into Grade values(3,'INGENIEUR'); --non contrainte INGENIEUR existe pas
insert into Grade values(NULL,'ING SYS');  --la cle primaire n'est pas null
insert into Grade values(5,'TS');  --oui


insert into Examen values(12,'BDD',to_date('12-03-2023','dd-mm-yyyy'),to_date('25-04-2025','dd-mm-yyyy')); --oui
insert into Examen values(13,'SI',to_date('13-03-2023','dd-mm-yyyy'),null); -- oui
insert into Examen values(14,'SYS',to_date('20-03-2023','dd-mm-yyyy'),to_date('25-03-2022','dd-mm-yyyy')); --non
insert into Examen values(15,'GL',to_date('21-03-2023','dd-mm-yyyy'),to_date('25-04-2023','dd-mm-yyyy')); --oui
insert into Examen values(15,'Culture generale',to_date('22-2023','dd-mm-yyyy'),to_date('25-04-2023','dd-mm-yyyy')); --non


insert into Participant values(2044,'BENALIA','AHMED',1);  --oui
insert into Participant values(3456,'HADJ MOUSSA','ILYES',1); --oui
insert into Participant values(3457,'FELLAH','WISSEM',3);
insert into Participant values(3458,'SLIMANI','ROFAIDA',5); --oui
insert into Participant values(3458,'KHOUDJA','ALI',6);
