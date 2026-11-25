CREATE DATABASE IF NOT EXISTS Clinique;
USE Clinique;

CREATE TABLE Patient (
    IdPatient INT PRIMARY KEY AUTO_INCREMENT,
    Nom VARCHAR(100),
    Prenom VARCHAR(100),
    DateNaissance DATE,
    Telephone VARCHAR(20)
);

CREATE TABLE Medecin (
    IdMedecin INT PRIMARY KEY AUTO_INCREMENT,
    Nom VARCHAR(100),
    Prenom VARCHAR(100),
    Specialite VARCHAR(100),
    DateEmbauche DATE
);

CREATE TABLE RendezVous (
    IdRdv INT PRIMARY KEY AUTO_INCREMENT,
    IdPatient INT,
    IdMedecin INT,
    DateRdv DATETIME,
    Motif VARCHAR(200),
    Statut VARCHAR(20),
    FOREIGN KEY (IdPatient) REFERENCES Patient(IdPatient),
    FOREIGN KEY (IdMedecin) REFERENCES Medecin(IdMedecin)
);


INSERT INTO Patient (Nom, Prenom, DateNaissance, Telephone) VALUES
('Martin', 'Lucas', '1985-03-15', '514-111-2222'),
('Dupont', 'Marie', '1992-07-22', '514-333-4444'),
('Tremblay', 'Jean', '1978-11-08', '438-555-6666'),
('Bouchard', 'Sophie', '2000-01-30', '450-777-8888'),
('Gagnon', 'Pierre', '1965-09-12', '514-999-0000'),
('Lavoie', 'Isabelle', '1990-04-25', '438-222-3333'),
('Côté', 'Marc', '1955-12-03', '514-444-5555'),
('Fortin', 'Julie', '1998-06-18', '450-666-7777'),
('Bergeron', 'Antoine', '1973-08-27', '514-888-9999'),
('Leblanc', 'Camille', '2003-02-14', '438-000-1111');

INSERT INTO Medecin (Nom, Prenom, Specialite, DateEmbauche) VALUES
('Bernard', 'Claire', 'Cardiologie', '2015-09-01'),
('Rousseau', 'Paul', 'Pédiatrie', '2018-03-15'),
('Lemaire', 'Anne', 'Dermatologie', '2010-06-01'),
('Fontaine', 'Jacques', 'Neurologie', '2020-01-10'),
('Mercier', 'Lucie', 'Généraliste', '2012-11-20');

INSERT INTO RendezVous (IdPatient, IdMedecin, DateRdv, Motif, Statut) VALUES
((SELECT IdPatient FROM Patient WHERE Nom='Martin'), (SELECT IdMedecin FROM Medecin WHERE Nom='Bernard'), '2024-01-10 09:00:00', 'Consultation cardiaque', 'Terminé'),
((SELECT IdPatient FROM Patient WHERE Nom='Dupont'), (SELECT IdMedecin FROM Medecin WHERE Nom='Rousseau'), '2024-01-22 14:30:00', 'Suivi pédiatrique', 'Terminé'),
((SELECT IdPatient FROM Patient WHERE Nom='Tremblay'), (SELECT IdMedecin FROM Medecin WHERE Nom='Lemaire'), '2024-03-05 10:00:00', 'Problème de peau', 'Terminé'),
((SELECT IdPatient FROM Patient WHERE Nom='Bouchard'), (SELECT IdMedecin FROM Medecin WHERE Nom='Fontaine'), '2024-04-18 11:30:00', 'Maux de tête', 'Terminé'),
((SELECT IdPatient FROM Patient WHERE Nom='Gagnon'), (SELECT IdMedecin FROM Medecin WHERE Nom='Mercier'), '2024-06-02 08:00:00', 'Bilan général', 'Terminé'),
((SELECT IdPatient FROM Patient WHERE Nom='Lavoie'), (SELECT IdMedecin FROM Medecin WHERE Nom='Bernard'), '2025-01-15 13:00:00', 'Douleurs thoraciques', 'Terminé'),
((SELECT IdPatient FROM Patient WHERE Nom='Côté'), (SELECT IdMedecin FROM Medecin WHERE Nom='Lemaire'), '2025-03-20 09:30:00', 'Allergie cutanée', 'Terminé'),
((SELECT IdPatient FROM Patient WHERE Nom='Fortin'), (SELECT IdMedecin FROM Medecin WHERE Nom='Rousseau'), '2026-04-28 15:00:00', 'Vaccination', 'Terminé'),
((SELECT IdPatient FROM Patient WHERE Nom='Bergeron'), (SELECT IdMedecin FROM Medecin WHERE Nom='Fontaine'), '2026-05-01 10:00:00', 'IRM cérébrale', 'Confirmé'),
((SELECT IdPatient FROM Patient WHERE Nom='Leblanc'), (SELECT IdMedecin FROM Medecin WHERE Nom='Mercier'), '2026-05-10 11:00:00', 'Grippe', 'Confirmé'),
((SELECT IdPatient FROM Patient WHERE Nom='Martin'), (SELECT IdMedecin FROM Medecin WHERE Nom='Mercier'), '2026-05-12 09:00:00', 'Suivi tension', 'Confirmé'),
((SELECT IdPatient FROM Patient WHERE Nom='Dupont'), (SELECT IdMedecin FROM Medecin WHERE Nom='Lemaire'), '2026-05-30 14:00:00', 'Contrôle annuel', 'Prévu');

SELECT *
FROM RendezVous;

/*
Afficher la date du jour

*/
SELECT CURRENT_DATE();

/*
Afficher l'heure actuelle
*/
SELECT CURRENT_TIME();

/*
Afficher la date et l'heure complètes avec 
*/
SELECT NOW();

/*Extraire l'année de naissance de chaque patient*/
SELECT DateNaissance, EXTRACT(YEAR FROM(DateNaissance)) AS AnneeDeNaissance
FROM Patient;

/*Extraire le mois de chaque rendez-vous*/
SELECT DateRdv, EXTRACT(MONTH FROM(DateRdv)) AS MoisDuRendezVous
FROM RendezVous;

/*Compter le nombre de rendez-vous par mois avec EXTRACT*/

SELECT  DateRdv,EXTRACT(MONTH FROM(DateRdv)) AS MoisDuRendezVous, COUNT(IdPatient) AS NombreRendezVous
FROM RendezVous
GROUP BY IdPatient;

SELECT TIMESTAMPDIFF(YEAR ,DateNaissance,CURDATE()) AS Age,Nom AS NomPatient
FROM Patient;

SELECT TIMESTAMPDIFF(YEAR,DateEmbauche,CURDATE()) AS NombreAnneeEmbauche,DateEmbauche
FROM Medecin;

SELECT TIMESTAMPDIFF(DAY,DateRdv,CURDATE()) AS NombreJourRendezVous
FROM RendezVous;

SELECT STR_TO_DATE('15-03-1985','%d-%m-%Y');

INSERT INTO RendezVous (IdPatient, IdMedecin, DateRdv, Motif, Statut) VALUES
((SELECT IdPatient FROM Patient WHERE Nom='Fortin'), (SELECT IdMedecin FROM Medecin WHERE Nom='Bernard'), STR_TO_DATE('2024-01-10 09:00:00', '%Y-%m-%d %H:%i:%s'), 'Consultation cardiaque', 'Terminé');


SELECT DATE_FORMAT(DateRdv,'%d-%m-%Y')
FROM RendezVous;


SELECT DATE_FORMAT(MONTHNAME(DateNaissance),'%Y')
FROM Patient;

SELECT DAYNAME(DateRdv)
FROM RendezVous;

SELECT Nom, DATE_FORMAT(DateNaissance, '%M %Y') AS DateFormatee
FROM Patient;


SELECT DATEDIFF(NOW(),DateRdv) AS JourDifference
FROM RendezVous
WHERE DATEDIFF(NOW(),DateRdv) <= 7;

SELECT DateNaissance, EXTRACT(MONTH FROM(DateNaissance))
FROM Patient
WHERE EXTRACT(MONTH FROM(DateNaissance)) =  MONTH(CURDATE()) ;



SELECT Nom,DateEmbauche, TIMESTAMPDIFF(YEAR, DateEmbauche, CURDATE()) AS age
FROM Medecin
WHERE TIMESTAMPDIFF(YEAR, DateEmbauche, CURDATE()) >=10;



 








SELECT *
FROM Medecin;









