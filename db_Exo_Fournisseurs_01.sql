


ALTER TABLE ligne_bon_de_livraion
RENAME ligne_bon_de_livraison

/* 1. Sélectionner tous les employés (codeEmpl, nom, salaire) triés par nom et par ordre alphabétique */

SELECT codeEmpl, nom, salaire, 
FROM employe
ORDER BY nom ASC;


/* 2. Sélectionner tous les employés (codeEmpl, nom, salaire) avec, pour chaque employé, le nom du rayon dans lequel il travaille */ 
 
SELECT codeEmpl, nom, salaire, nomR
FROM employe;


/* 3. Sélectionner tous les fournisseurs (codeFourn, nom) et le nombre de produits qu'ils fournissent, triés par nombre de produits décroissant */

SELECT 
F.codeF, 
nomF,
-- L.quantité,
/*CONVERT(quantité, INT) AS Q,
CAST(quantité as INT) AS Q2
FROM fournisseurs AS F
INNER JOIN ligne_bon_de_livraion AS L
ON F.codeF = L.codeF
ORDER BY Q DESC;*/ 

SELECT fournisseurs.codeF, nomF, 
COUNT(ligne_bon_de_livraion.codeA) AS nb_produits
FROM fournisseurs
INNER JOIN ligne_bon_de_livraion
ON ligne_bon_de_livraion.codeF = fournisseurs.codeF 
GROUP BY fournisseurs.codeF
ORDER BY nb_produits DESC; 



/* 4. Sélectionner le nom des produits, leur prix et le nom du fournisseur associé */

SELECT nomA, prix, F.nomF
FROM articles as A 
INNER JOIN ligne_bon_de_livraion AS L ON A.codeA = L.codeA
INNER JOIN fournisseurs AS F ON L.codeF = F.codeF;



/* ajouter une colonne a article */
ALTER table articles ADD COLUMN prix DECIMAL(5,2) NOT NULL DEFAULT '0';

 
/* mise a jour des prix */
UPDATE articles set prix=120 WHERE codeA='A0000001';
UPDATE articles set prix=50 WHERE codeA='A0000002';
UPDATE articles set prix=10 WHERE codeA='A0000003';
UPDATE articles set prix=1 WHERE codeA='A0000004';
UPDATE articles set prix=12 WHERE codeA='A0000005';
UPDATE articles set prix=500 WHERE codeA='A0000006';
UPDATE articles set prix=20 WHERE codeA='A0000007';
UPDATE articles set prix=40 WHERE codeA='A0000008';
UPDATE articles set prix=1.5 WHERE codeA='A0000009';
UPDATE articles set prix=3 WHERE codeA='A0000010';


/* 5. Sélectionner le nom des produits, leur prix, et le nom du fournisseur */ /*pour chaque produit dont le prix est supérieur à la moyenne des prix des produits */

SELECT nomA, prix,nomF/*, (SELECT AVG(prix) FROM articles*/
FROM articles as A 
INNER JOIN ligne_bon_de_livraion AS L ON A.codeA = L.codeA
INNER JOIN fournisseurs AS F ON L.codeF = F.codeF
WHERE prix > (SELECT AVG(prix) FROM articles)
GROUP BY nomA, nomF;


/* 6. Sélectionner tous les employés (codeEmpl, nom). 
Pour chaque employé, indiquer le nom du rayon, 
le nombre d'articles associés au rayon  */

/*SELECT
 codeEmpl, 
 nom, 
 employe.nomR, 
 COUNT(codeA)
 FROM employe
 INNER JOIN	rayon ON	employe.nomR = rayon.nomR
 INNER JOIN articles ON rayon.nomR = articles.nomR
 GROUP BY codeEmpl;*/
 

SELECT
 codeEmpl, 
 nom, 
 employe.nomR, 
 COUNT(codeA)
 FROM employe
 INNER JOIN articles ON employe.nomR = articles.nomR
 GROUP BY codeEmpl;

/* 7. Sélectionner tous les articles (codeA, nomA). 
Pour chaque article, indiquer le nombre de livraisons 
et la quantité totale livrée. */

SELECT
 ligne_bon_de_livraion.codeA,
 articles.nomA,
 SUM(quantité),
 COUNT(ligne_bon_de_livraion.codeA)
 FROM	ligne_bon_de_livraion
 INNER JOIN	articles ON ligne_bon_de_livraion.codeA = articles.codeA
 GROUP BY ligne_bon_de_livraion.codeA
 ;
 

/* 8. Sélectionner tous les articles (codeA, nomA). Pour chaque article, indiquer le nom du fournisseur, le nom et l'étage du rayon où il est stocké, et l'employé qui y travaille (codeEmpl, nom). */
SELECT 
articles.codeA, 
nomA,
fournisseurs.nomF,
rayon.nomR,
rayon.etage,
employe.codeEmpl,
employe.nom
FROM	articles
INNER JOIN ligne_bon_de_livraion ON ligne_bon_de_livraion.codeA = articles.codeA
INNER JOIN fournisseurs ON fournisseurs.codeF = ligne_bon_de_livraion.codeF
INNER JOIN rayon ON rayon.nomR = articles.nomR
INNER JOIN employe ON employe.nomR = rayon.nomR;

SELECT CONCAT(codeA, '-', nomA, '', nomR,) FROM articles;

SELECT CONCAT(codeA, '-', nomA, '', (SELECT etage FROM rayon WHERE rayon.nomR ) FROM articles;

SELECT 
articles.codeA, 
nomA,
fournisseurs.nomF,
GROUP_CONCAT(nomF) AS nomDesFournisseurs,
rayon.etage,
employe.codeEmpl,
employe.nom
FROM	articles
INNER JOIN ligne_bon_de_livraion ON ligne_bon_de_livraion.codeA = articles.codeA
INNER JOIN fournisseurs ON fournisseurs.codeF = ligne_bon_de_livraion.codeF
INNER JOIN rayon ON rayon.nomR = articles.nomR
INNER JOIN employe ON employe.nomR = rayon.nomR
GROUP BY codeA
	  