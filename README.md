# PCOS-Data-Analysis
Projet d'analyse du SOPK

## Objectif
Ce projet a été réalisé dans le cadre d'un cours universitaire et vise à analyser les données cliniques de femmes atteintes ou pas du SOPK pour identifier les facteurs prédictifs les plus fiables de ce syndrome.

## Structure
data/
PCOS_data_without_infertility.xlsx

scripts/
nettoyage.R # Nettoyage et préparation des données
exploration.R # Analyse exploratoire et visualisations
analyse.R # Tests statistiques (khi² et t)

resultats/
graphiques/ # Graphiques exportés
pigment peau.jpeg
gain poids.jpeg
fast food.jpeg
heatmap.jpeg
correlation.jpeg
top10 corr.jpeg
distribution BMI.jpeg
distribution AMH.jpeg
BMI vs follicules.jpeg
LH vs FSH.jpeg

README.md

## Données sources
Les données proviennent d’un jeu de données Kaggle : [https://www.kaggle.com/datasets/prasoonkottarathil/polycystic-ovary-syndrome-pcos]
(J'ai seulement utilisé le tableur *PCOS_data_without_infertility.xlsx*)

## Étapes réalisées 
### Nettoyage
- Conversion des colonnes erronées (AMH, beta-HCG) en numériques
- Suppression des valeurs manquantes
- Conversion de certaines variables en facteur (Blood Group, Cycle(R/I))

### Exploration
- Résumé statistique par groupe (SOPK vs non SOPK)
- Graphiques :
  - Barplots : pigmentation, gain de poids, fast food
  - Heatmap des corrélations entre variables numériques
  - Top 10 des variables les plus corrélées avec le SOPK
 
### Analyses
- Tests du **khi²** pour les variables qualitatives les plus liées au SOPK
- Tests **t de Student** pour comparer les moyennes
- Calcul des corrélations avec la variable cible PCOS (Y/N)
