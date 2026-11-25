CREATE DATABASE IF NOT EXISTS Countries;
USE Countries;


/* Creation des tables */
CREATE TABLE Continent(
    IdContinent INT PRIMARY KEY AUTO_INCREMENT,
    Nom VARCHAR(100) NOT NULL,
    SuperficieKm2 BIGINT NOT NULL
);

CREATE TABLE Pays(
    IdPays INT PRIMARY KEY AUTO_INCREMENT,
    Nom VARCHAR(100) NOT NULL,
    CodeIso VARCHAR(20),
    SuperficieKm2 BIGINT,
    Population BIGINT,
    PibUsd DECIMAL(15,2),
    IdContinent INT,
    FOREIGN KEY (IdContinent) REFERENCES Continent(IdContinent)
);

CREATE TABLE Ville(
    IdVille INT PRIMARY KEY AUTO_INCREMENT,
    NomVille VARCHAR(100) NOT NULL,
    IdPays INT,
    Population BIGINT,
    EstCapitale BOOLEAN,
    FOREIGN KEY (IdPays) REFERENCES Pays(IdPays)
);

CREATE TABLE Langue(
    IdLangue INT PRIMARY KEY AUTO_INCREMENT,
    Nom VARCHAR(100),
    FamilleLinguistique VARCHAR(100)
);

CREATE TABLE PaysLangue(
    IdPays INT,
    IdLangue INT,
    EstOfficielle BOOLEAN,
    PRIMARY KEY (IdPays, IdLangue),
    FOREIGN KEY (IdPays) REFERENCES Pays(IdPays),
    FOREIGN KEY (IdLangue) REFERENCES Langue(IdLangue)
);

CREATE TABLE Indicateur(
    IdIndicateur INT PRIMARY KEY AUTO_INCREMENT,
    IdPays INT,
    Annee YEAR,
    EsperanceVie DECIMAL(4,1),
    Idh DECIMAL(3,2),
    TauxAlphabetisation DECIMAL(5,2),
    FOREIGN KEY (IdPays) REFERENCES Pays(IdPays)
);
 
 /*Insertion des données dans les tables*/
 INSERT INTO Continent (Nom, SuperficieKm2) VALUES
('Afrique', 30370000),
('Asie', 44579000),
('Europe', 10530000),
('Amérique du Nord', 24709000),
('Amérique du Sud', 17840000),
('Océanie', 8526000);


INSERT INTO Pays (Nom, CodeIso, SuperficieKm2, Population, PibUsd, IdContinent) VALUES
('France', 'FR', 551695, 67000000, 2778000000000.00, 3),
('Allemagne', 'DE', 357114, 83000000, 3845000000000.00, 3),
('Espagne', 'ES', 505990, 47000000, 1418000000000.00, 3),
('Italie', 'IT', 301340, 60000000, 2001000000000.00, 3),
('Portugal', 'PT', 92212, 10000000, 237000000000.00, 3),
('Maroc', 'MA', 446550, 37000000, 134000000000.00, 1),
('Algérie', 'DZ', 2381741, 45000000, 163000000000.00, 1),
('Sénégal', 'SN', 196722, 17000000, 27000000000.00, 1),
('Nigeria', 'NG', 923768, 220000000, 440000000000.00, 1),
('Afrique du Sud', 'ZA', 1219090, 60000000, 351000000000.00, 1),
('Égypte', 'EG', 1001449, 104000000, 387000000000.00, 1),
('Kenya', 'KE', 580367, 55000000, 110000000000.00, 1),
('Chine', 'CN', 9596960, 1400000000, 17734000000000.00, 2),
('Inde', 'IN', 3287263, 1380000000, 3173000000000.00, 2),
('Japon', 'JP', 377975, 125000000, 4231000000000.00, 2),
('Corée du Sud', 'KR', 100210, 52000000, 1798000000000.00, 2),
('Indonésie', 'ID', 1904569, 273000000, 1119000000000.00, 2),
('Pakistan', 'PK', 881913, 225000000, 348000000000.00, 2),
('Arabie Saoudite', 'SA', 2149690, 35000000, 833000000000.00, 2),
('Turquie', 'TR', 783562, 84000000, 815000000000.00, 2),
('États-Unis', 'US', 9833517, 331000000, 23000000000000.00, 4),
('Canada', 'CA', 9984670, 38000000, 1988000000000.00, 4),
('Mexique', 'MX', 1964375, 130000000, 1293000000000.00, 4),
('Cuba', 'CU', 109884, 11000000, 107000000000.00, 4),
('Brésil', 'BR', 8515767, 213000000, 1608000000000.00, 5),
('Argentine', 'AR', 2780400, 45000000, 491000000000.00, 5),
('Colombie', 'CO', 1141748, 51000000, 314000000000.00, 5),
('Pérou', 'PE', 1285216, 33000000, 223000000000.00, 5),
('Chili', 'CL', 756102, 19000000, 317000000000.00, 5),
('Australie', 'AU', 7692024, 26000000, 1552000000000.00, 6),
('Nouvelle-Zélande', 'NZ', 270467, 5000000, 249000000000.00, 6),
('Russie', 'RU', 17098242, 144000000, 1776000000000.00, 3),
('Pologne', 'PL', 312696, 38000000, 674000000000.00, 3),
('Pays-Bas', 'NL', 41543, 17000000, 1012000000000.00, 3),
('Belgique', 'BE', 30528, 11000000, 594000000000.00, 3),
('Suède', 'SE', 450295, 10000000, 635000000000.00, 3),
('Éthiopie', 'ET', 1104300, 120000000, 111000000000.00, 1),
('Ghana', 'GH', 238533, 32000000, 77000000000.00, 1),
('Tanzanie', 'TZ', 945087, 62000000, 67000000000.00, 1),
('Vietnam', 'VN', 331212, 97000000, 362000000000.00, 2),
('Thaïlande', 'TH', 513120, 70000000, 506000000000.00, 2),
('Bangladesh', 'BD', 147570, 170000000, 416000000000.00, 2),
('Iran', 'IR', 1648195, 85000000, 191000000000.00, 2),
('Venezuela', 'VE', 916445, 28000000, 47000000000.00, 5),
('Équateur', 'EC', 283561, 18000000, 99000000000.00, 5);

INSERT INTO Ville (NomVille, IdPays, Population, EstCapitale) VALUES
('Paris', (SELECT IdPays FROM Pays WHERE CodeIso = 'FR'), 2161000, TRUE),
('Marseille', (SELECT IdPays FROM Pays WHERE CodeIso = 'FR'), 861000, FALSE),
('Lyon', (SELECT IdPays FROM Pays WHERE CodeIso = 'FR'), 515000, FALSE),
('Berlin', (SELECT IdPays FROM Pays WHERE CodeIso = 'DE'), 3645000, TRUE),
('Munich', (SELECT IdPays FROM Pays WHERE CodeIso = 'DE'), 1472000, FALSE),
('Hambourg', (SELECT IdPays FROM Pays WHERE CodeIso = 'DE'), 1841000, FALSE),
('Madrid', (SELECT IdPays FROM Pays WHERE CodeIso = 'ES'), 3223000, TRUE),
('Barcelone', (SELECT IdPays FROM Pays WHERE CodeIso = 'ES'), 1620000, FALSE),
('Rome', (SELECT IdPays FROM Pays WHERE CodeIso = 'IT'), 2873000, TRUE),
('Milan', (SELECT IdPays FROM Pays WHERE CodeIso = 'IT'), 1352000, FALSE),
('Rabat', (SELECT IdPays FROM Pays WHERE CodeIso = 'MA'), 577000, TRUE),
('Casablanca', (SELECT IdPays FROM Pays WHERE CodeIso = 'MA'), 3752000, FALSE),
('Alger', (SELECT IdPays FROM Pays WHERE CodeIso = 'DZ'), 3415000, TRUE),
('Dakar', (SELECT IdPays FROM Pays WHERE CodeIso = 'SN'), 3137000, TRUE),
('Lagos', (SELECT IdPays FROM Pays WHERE CodeIso = 'NG'), 14862000, FALSE),
('Abuja', (SELECT IdPays FROM Pays WHERE CodeIso = 'NG'), 3464000, TRUE),
('Le Caire', (SELECT IdPays FROM Pays WHERE CodeIso = 'EG'), 10107000, TRUE),
('Alexandrie', (SELECT IdPays FROM Pays WHERE CodeIso = 'EG'), 5200000, FALSE),
('Nairobi', (SELECT IdPays FROM Pays WHERE CodeIso = 'KE'), 4397000, TRUE),
('Pékin', (SELECT IdPays FROM Pays WHERE CodeIso = 'CN'), 21542000, TRUE),
('Shanghai', (SELECT IdPays FROM Pays WHERE CodeIso = 'CN'), 24870000, FALSE),
('New Delhi', (SELECT IdPays FROM Pays WHERE CodeIso = 'IN'), 31181000, TRUE),
('Mumbai', (SELECT IdPays FROM Pays WHERE CodeIso = 'IN'), 20667000, FALSE),
('Tokyo', (SELECT IdPays FROM Pays WHERE CodeIso = 'JP'), 13960000, TRUE),
('Osaka', (SELECT IdPays FROM Pays WHERE CodeIso = 'JP'), 2691000, FALSE),
('Séoul', (SELECT IdPays FROM Pays WHERE CodeIso = 'KR'), 9776000, TRUE),
('Jakarta', (SELECT IdPays FROM Pays WHERE CodeIso = 'ID'), 10562000, TRUE),
('Washington', (SELECT IdPays FROM Pays WHERE CodeIso = 'US'), 689545, TRUE),
('New York', (SELECT IdPays FROM Pays WHERE CodeIso = 'US'), 8336817, FALSE),
('Los Angeles', (SELECT IdPays FROM Pays WHERE CodeIso = 'US'), 3979576, FALSE),
('Ottawa', (SELECT IdPays FROM Pays WHERE CodeIso = 'CA'), 994837, TRUE),
('Toronto', (SELECT IdPays FROM Pays WHERE CodeIso = 'CA'), 2731571, FALSE),
('Mexico', (SELECT IdPays FROM Pays WHERE CodeIso = 'MX'), 9209944, TRUE),
('Brasilia', (SELECT IdPays FROM Pays WHERE CodeIso = 'BR'), 3055149, TRUE),
('São Paulo', (SELECT IdPays FROM Pays WHERE CodeIso = 'BR'), 12325232, FALSE),
('Rio de Janeiro', (SELECT IdPays FROM Pays WHERE CodeIso = 'BR'), 6747815, FALSE),
('Buenos Aires', (SELECT IdPays FROM Pays WHERE CodeIso = 'AR'), 3075646, TRUE),
('Sydney', (SELECT IdPays FROM Pays WHERE CodeIso = 'AU'), 5312000, FALSE),
('Canberra', (SELECT IdPays FROM Pays WHERE CodeIso = 'AU'), 462213, TRUE),
('Moscou', (SELECT IdPays FROM Pays WHERE CodeIso = 'RU'), 12506468, TRUE),
('Stockholm', (SELECT IdPays FROM Pays WHERE CodeIso = 'SE'), 975904, TRUE),
('Varsovie', (SELECT IdPays FROM Pays WHERE CodeIso = 'PL'), 1790658, TRUE),
('Amsterdam', (SELECT IdPays FROM Pays WHERE CodeIso = 'NL'), 921402, TRUE),
('Bruxelles', (SELECT IdPays FROM Pays WHERE CodeIso = 'BE'), 1208542, TRUE),
('Lisbonne', (SELECT IdPays FROM Pays WHERE CodeIso = 'PT'), 505526, TRUE),
('Ankara', (SELECT IdPays FROM Pays WHERE CodeIso = 'TR'), 5503985, TRUE),
('Istanbul', (SELECT IdPays FROM Pays WHERE CodeIso = 'TR'), 15462452, FALSE),
('Téhéran', (SELECT IdPays FROM Pays WHERE CodeIso = 'IR'), 9259009, TRUE),
('Bogota', (SELECT IdPays FROM Pays WHERE CodeIso = 'CO'), 7743955, TRUE),
('Santiago', (SELECT IdPays FROM Pays WHERE CodeIso = 'CL'), 6310000, TRUE);

INSERT INTO Ville (NomVille, IdPays, Population, EstCapitale) VALUES
('Paris', (SELECT IdPays FROM Pays WHERE CodeIso = 'FR'), 2161000, TRUE),
('Marseille', (SELECT IdPays FROM Pays WHERE CodeIso = 'FR'), 861000, FALSE),
('Lyon', (SELECT IdPays FROM Pays WHERE CodeIso = 'FR'), 515000, FALSE),
('Berlin', (SELECT IdPays FROM Pays WHERE CodeIso = 'DE'), 3645000, TRUE),
('Munich', (SELECT IdPays FROM Pays WHERE CodeIso = 'DE'), 1472000, FALSE),
('Hambourg', (SELECT IdPays FROM Pays WHERE CodeIso = 'DE'), 1841000, FALSE),
('Madrid', (SELECT IdPays FROM Pays WHERE CodeIso = 'ES'), 3223000, TRUE),
('Barcelone', (SELECT IdPays FROM Pays WHERE CodeIso = 'ES'), 1620000, FALSE),
('Rome', (SELECT IdPays FROM Pays WHERE CodeIso = 'IT'), 2873000, TRUE),
('Milan', (SELECT IdPays FROM Pays WHERE CodeIso = 'IT'), 1352000, FALSE),
('Rabat', (SELECT IdPays FROM Pays WHERE CodeIso = 'MA'), 577000, TRUE),
('Casablanca', (SELECT IdPays FROM Pays WHERE CodeIso = 'MA'), 3752000, FALSE),
('Alger', (SELECT IdPays FROM Pays WHERE CodeIso = 'DZ'), 3415000, TRUE),
('Dakar', (SELECT IdPays FROM Pays WHERE CodeIso = 'SN'), 3137000, TRUE),
('Lagos', (SELECT IdPays FROM Pays WHERE CodeIso = 'NG'), 14862000, FALSE),
('Abuja', (SELECT IdPays FROM Pays WHERE CodeIso = 'NG'), 3464000, TRUE),
('Le Caire', (SELECT IdPays FROM Pays WHERE CodeIso = 'EG'), 10107000, TRUE),
('Alexandrie', (SELECT IdPays FROM Pays WHERE CodeIso = 'EG'), 5200000, FALSE),
('Nairobi', (SELECT IdPays FROM Pays WHERE CodeIso = 'KE'), 4397000, TRUE),
('Pékin', (SELECT IdPays FROM Pays WHERE CodeIso = 'CN'), 21542000, TRUE),
('Shanghai', (SELECT IdPays FROM Pays WHERE CodeIso = 'CN'), 24870000, FALSE),
('New Delhi', (SELECT IdPays FROM Pays WHERE CodeIso = 'IN'), 31181000, TRUE),
('Mumbai', (SELECT IdPays FROM Pays WHERE CodeIso = 'IN'), 20667000, FALSE),
('Tokyo', (SELECT IdPays FROM Pays WHERE CodeIso = 'JP'), 13960000, TRUE),
('Osaka', (SELECT IdPays FROM Pays WHERE CodeIso = 'JP'), 2691000, FALSE),
('Séoul', (SELECT IdPays FROM Pays WHERE CodeIso = 'KR'), 9776000, TRUE),
('Jakarta', (SELECT IdPays FROM Pays WHERE CodeIso = 'ID'), 10562000, TRUE),
('Washington', (SELECT IdPays FROM Pays WHERE CodeIso = 'US'), 689545, TRUE),
('New York', (SELECT IdPays FROM Pays WHERE CodeIso = 'US'), 8336817, FALSE),
('Los Angeles', (SELECT IdPays FROM Pays WHERE CodeIso = 'US'), 3979576, FALSE),
('Ottawa', (SELECT IdPays FROM Pays WHERE CodeIso = 'CA'), 994837, TRUE),
('Toronto', (SELECT IdPays FROM Pays WHERE CodeIso = 'CA'), 2731571, FALSE),
('Mexico', (SELECT IdPays FROM Pays WHERE CodeIso = 'MX'), 9209944, TRUE),
('Brasilia', (SELECT IdPays FROM Pays WHERE CodeIso = 'BR'), 3055149, TRUE),
('São Paulo', (SELECT IdPays FROM Pays WHERE CodeIso = 'BR'), 12325232, FALSE),
('Rio de Janeiro', (SELECT IdPays FROM Pays WHERE CodeIso = 'BR'), 6747815, FALSE),
('Buenos Aires', (SELECT IdPays FROM Pays WHERE CodeIso = 'AR'), 3075646, TRUE),
('Sydney', (SELECT IdPays FROM Pays WHERE CodeIso = 'AU'), 5312000, FALSE),
('Canberra', (SELECT IdPays FROM Pays WHERE CodeIso = 'AU'), 462213, TRUE),
('Moscou', (SELECT IdPays FROM Pays WHERE CodeIso = 'RU'), 12506468, TRUE),
('Stockholm', (SELECT IdPays FROM Pays WHERE CodeIso = 'SE'), 975904, TRUE),
('Varsovie', (SELECT IdPays FROM Pays WHERE CodeIso = 'PL'), 1790658, TRUE),
('Amsterdam', (SELECT IdPays FROM Pays WHERE CodeIso = 'NL'), 921402, TRUE),
('Bruxelles', (SELECT IdPays FROM Pays WHERE CodeIso = 'BE'), 1208542, TRUE),
('Lisbonne', (SELECT IdPays FROM Pays WHERE CodeIso = 'PT'), 505526, TRUE),
('Ankara', (SELECT IdPays FROM Pays WHERE CodeIso = 'TR'), 5503985, TRUE),
('Istanbul', (SELECT IdPays FROM Pays WHERE CodeIso = 'TR'), 15462452, FALSE),
('Téhéran', (SELECT IdPays FROM Pays WHERE CodeIso = 'IR'), 9259009, TRUE),
('Bogota', (SELECT IdPays FROM Pays WHERE CodeIso = 'CO'), 7743955, TRUE),
('Santiago', (SELECT IdPays FROM Pays WHERE CodeIso = 'CL'), 6310000, TRUE);

INSERT INTO Indicateur (IdPays, Annee, EsperanceVie, Idh, TauxAlphabetisation) VALUES
((SELECT IdPays FROM Pays WHERE CodeIso='FR'), 2020, 82.3, 0.90, 99.00),
((SELECT IdPays FROM Pays WHERE CodeIso='DE'), 2020, 81.2, 0.94, 99.00),
((SELECT IdPays FROM Pays WHERE CodeIso='ES'), 2020, 83.5, 0.90, 98.40),
((SELECT IdPays FROM Pays WHERE CodeIso='IT'), 2020, 83.0, 0.89, 99.20),
((SELECT IdPays FROM Pays WHERE CodeIso='PT'), 2020, 81.9, 0.86, 96.10),
((SELECT IdPays FROM Pays WHERE CodeIso='MA'), 2020, 74.5, 0.68, 73.80),
((SELECT IdPays FROM Pays WHERE CodeIso='DZ'), 2020, 76.3, 0.75, 81.40),
((SELECT IdPays FROM Pays WHERE CodeIso='SN'), 2020, 67.9, 0.51, 51.90),
((SELECT IdPays FROM Pays WHERE CodeIso='NG'), 2020, 54.7, 0.54, 62.00),
((SELECT IdPays FROM Pays WHERE CodeIso='ZA'), 2020, 64.1, 0.71, 87.00),
((SELECT IdPays FROM Pays WHERE CodeIso='EG'), 2020, 71.8, 0.73, 73.10),
((SELECT IdPays FROM Pays WHERE CodeIso='KE'), 2020, 66.7, 0.60, 82.60),
((SELECT IdPays FROM Pays WHERE CodeIso='CN'), 2020, 76.9, 0.76, 96.80),
((SELECT IdPays FROM Pays WHERE CodeIso='IN'), 2020, 69.7, 0.65, 74.40),
((SELECT IdPays FROM Pays WHERE CodeIso='JP'), 2020, 84.3, 0.93, 99.00),
((SELECT IdPays FROM Pays WHERE CodeIso='KR'), 2020, 83.0, 0.92, 99.00),
((SELECT IdPays FROM Pays WHERE CodeIso='ID'), 2020, 71.7, 0.71, 96.00),
((SELECT IdPays FROM Pays WHERE CodeIso='PK'), 2020, 67.3, 0.54, 57.90),
((SELECT IdPays FROM Pays WHERE CodeIso='SA'), 2020, 75.1, 0.85, 97.10),
((SELECT IdPays FROM Pays WHERE CodeIso='TR'), 2020, 77.7, 0.84, 96.70),
((SELECT IdPays FROM Pays WHERE CodeIso='US'), 2020, 78.9, 0.93, 99.00),
((SELECT IdPays FROM Pays WHERE CodeIso='CA'), 2020, 82.3, 0.93, 99.00),
((SELECT IdPays FROM Pays WHERE CodeIso='MX'), 2020, 75.1, 0.78, 95.20),
((SELECT IdPays FROM Pays WHERE CodeIso='CU'), 2020, 78.8, 0.76, 99.70),
((SELECT IdPays FROM Pays WHERE CodeIso='BR'), 2020, 75.9, 0.75, 93.20),
((SELECT IdPays FROM Pays WHERE CodeIso='AR'), 2020, 76.7, 0.84, 99.00),
((SELECT IdPays FROM Pays WHERE CodeIso='CO'), 2020, 77.1, 0.75, 95.10),
((SELECT IdPays FROM Pays WHERE CodeIso='PE'), 2020, 76.7, 0.76, 94.50),
((SELECT IdPays FROM Pays WHERE CodeIso='CL'), 2020, 80.2, 0.86, 96.40),
((SELECT IdPays FROM Pays WHERE CodeIso='AU'), 2020, 83.4, 0.94, 99.00),
((SELECT IdPays FROM Pays WHERE CodeIso='NZ'), 2020, 82.3, 0.93, 99.00),
((SELECT IdPays FROM Pays WHERE CodeIso='RU'), 2020, 72.6, 0.82, 99.70),
((SELECT IdPays FROM Pays WHERE CodeIso='PL'), 2020, 77.8, 0.88, 99.80),
((SELECT IdPays FROM Pays WHERE CodeIso='NL'), 2020, 82.3, 0.94, 99.00),
((SELECT IdPays FROM Pays WHERE CodeIso='BE'), 2020, 81.4, 0.92, 99.00),
((SELECT IdPays FROM Pays WHERE CodeIso='SE'), 2020, 82.8, 0.95, 99.00),
((SELECT IdPays FROM Pays WHERE CodeIso='ET'), 2020, 65.5, 0.49, 51.80),
((SELECT IdPays FROM Pays WHERE CodeIso='GH'), 2020, 64.1, 0.61, 79.00),
((SELECT IdPays FROM Pays WHERE CodeIso='TZ'), 2020, 65.5, 0.55, 77.90),
((SELECT IdPays FROM Pays WHERE CodeIso='VN'), 2020, 75.4, 0.70, 95.80),
((SELECT IdPays FROM Pays WHERE CodeIso='TH'), 2020, 77.2, 0.80, 93.80),
((SELECT IdPays FROM Pays WHERE CodeIso='BD'), 2020, 72.6, 0.63, 74.90),
((SELECT IdPays FROM Pays WHERE CodeIso='IR'), 2020, 76.7, 0.78, 85.50),
((SELECT IdPays FROM Pays WHERE CodeIso='VE'), 2020, 72.1, 0.69, 97.10),
((SELECT IdPays FROM Pays WHERE CodeIso='EC'), 2020, 77.0, 0.74, 94.40);


/*Requetes*/
-- Afficher tous les pays avec leur capitale et leur population
SELECT DISTINCT p.Population AS PopulationPays,v.NomVille AS CapitaleDuPays
FROM Pays AS p
INNER JOIN Ville AS v ON v.IdPays=p.IdPays
WHERE v.EstCapitale IS TRUE;

-- Lister les pays dont la population est supérieure à 100 millions



SELECT *
FROM Ville;


 
 
 
 






