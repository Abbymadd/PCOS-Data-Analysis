# PCOS-Data-Analysis
Projet d'analyse du syndrome des ovaires polykystiques (SOPK ou PCOS)

## Objectif
Ce projet a été réalisé dans le cadre d'un cours universitaire et vise à analyser les données cliniques de femmes atteintes ou pas du SOPK pour identifier les facteurs prédictifs les plus fiables de ce syndrome.

## Structure
data/
PCOS_data_without_infertility.xlsx

scripts/
nettoyage.R # pour le nettoyage et la préparation des données
exploration.R # pour l'analyse exploratoire et certaines visualisations
analyse.R # pour les tests statistiques (khi², shapiro, levene et t)

resultats/
graphiques/ # Graphiques exportés
LH.jpeg
IMC.jpeg
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
- Conversion des colonnes erronées (AMH, beta-HCG) en données numériques
- Suppression des valeurs manquantes
- Conversion de certaines variables en facteur (Blood Group, Cycle(R/I))

### Exploration
- Statistiques descriptives par groupe (SOPK vs non SOPK) incluant les moyennes et médianes
- Visualisations :
  - Barplots : pigmentation, gain de poids, fast food
  - Diagrammes de dispersion : IMC vs follicules, LH vs FSH
  - Heatmap des corrélations entre variables numériques
  - Barplot : Top 10 des variables les plus corrélées avec le SOPK
 
### Analyses
- **Tests de normalité** shapiro et **d'homogénéité des variances** levene
- **Tests du khi²** pour les variables qualitatives les plus liées au SOPK
- **Tests t de Student** pour comparer les moyennes entre patientes
- Calcul des corrélations (Pearson) avec la variable cible PCOS (Y/N)
