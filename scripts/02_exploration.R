# Analyse exploratoire du jeu de données SOPK
# Charger les bibliothèques nécessaires
library(readxl)
library(dplyr)
library(ggplot2)
library(corrplot)

# Importer les données nettoyées
donnees_sopk <- read_excel("data/PCOS_data_without_infertility.xlsx")
donnees_sopk <- na.omit(donnees_sopk)
donnees_sopk$`II    beta-HCG(mIU/mL)` <- as.numeric(donnees_sopk$`II    beta-HCG(mIU/mL)`)
donnees_sopk$`AMH(ng/mL)` <- as.numeric(donnees_sopk$`AMH(ng/mL)`)
donnees_sopk$`Cycle(R/I)` <- as.factor(donnees_sopk$`Cycle(R/I)`)
donnees_sopk$`Blood Group` <- as.factor(donnees_sopk$`Blood Group`)

# Résumé des données
summary(donnees_sopk)

# Statistiques descriptives par groupe SOPK
stats_groupes <- donnees_sopk %>%
  group_by(`PCOS (Y/N)`) %>%
  summarise(
    age_median = median(`Age (yrs)`, na.rm = TRUE),
    age_mean = mean(`Age (yrs)`, na.rm = TRUE),
    IMC_median = median(BMI, na.rm = TRUE),
    IMC_mean = mean(BMI, na.rm = TRUE),
    poids_median = median(`Weight (Kg)`, na.rm = TRUE),
    poids_mean = mean(`Weight (Kg)`, na.rm = TRUE),
    TSH_median = median(`TSH (mIU/L)`, na.rm = TRUE),
    TSH_mean = mean(`TSH (mIU/L)`, na.rm = TRUE),
    follicules_L_median = median(`Follicle No. (L)`, na.rm = TRUE),
    follicules_R_median = median(`Follicle No. (R)`, na.rm = TRUE),
    cycle_length_mean = mean(`Cycle length(days)`, na.rm = TRUE)
  )

print(stats_groupes)

# Analyse exploratoire des variables qualitatives les plus corrélées
# Table de fréquences croisées
table(donnees_sopk$`Weight gain(Y/N)`, donnees_sopk$`PCOS (Y/N)`)
table(donnees_sopk$`Skin darkening (Y/N)`, donnees_sopk$`PCOS (Y/N)`)
table(donnees_sopk$`Fast food (Y/N)`, donnees_sopk$`PCOS (Y/N)`)

# Barplot pour pigmentation
ggplot(donnees_sopk, aes(x = factor(`Skin darkening (Y/N)`), fill = factor(`PCOS (Y/N)`))) +
  geom_bar(position = "dodge") +
  labs(title = "Pigmentation de la peau selon SOPK", 
       x = "Pigmentation (0=Non, 1=Oui)", 
       y = "Nombre de patientes", 
       fill = "SOPK") +
  theme_minimal()

# Barplot pour gain de poids
ggplot(donnees_sopk, aes(x = factor(`Weight gain(Y/N)`), fill = factor(`PCOS (Y/N)`))) +
  geom_bar(position = "dodge") +
  labs(title = "Gain de poids selon SOPK",
       x = "Gain de poids (0=Non, 1=Oui)",
       y = "Nombre de patientes",
       fill = "SOPK") +
  theme_minimal()

# Barplot pour fast food
ggplot(donnees_sopk, aes(x = factor(`Fast food (Y/N)`), fill = factor(`PCOS (Y/N)`))) +
  geom_bar(position = "dodge") +
  labs(title = "Consommation de fast food selon SOPK",
       x = "Fast food (0=Non, 1=Oui)",
       y = "Nombre de patientes",
       fill = "SOPK") +
  theme_minimal()

# Heatmap
# Choisir les variables numériques
donnees_numeriques <- donnees_sopk %>%
  select(-`Sl. No`, -`Patient File No.`) %>%
  select(where(is.numeric))

# Utiliser une matrice de corrélation sans NA
matrice_correlation <- cor(donnees_numeriques, use = "complete.obs")

# Afficher le heatmap
corrplot(matrice_correlation,
        method = "color",
        type = "upper",
        order = "hclust",
        tl.cex = 0.6,
        tl.col = "black",
        addCoef.col = "black",
        number.cex = 0.5,
        sig.level = 0.3,
        insig = "blank",
        diag = FALSE)

# Barplot ciblé pour montrer celles liées à PCOS
# Extraire uniquement la corrélation avec la variable cible
corr_pcos <- matrice_correlation["PCOS (Y/N)", ]

# Trier par ordre décroissant
corr_pcos_sorted <- sort(corr_pcos, decreasing = TRUE)

# Afficher le barplot
df_corr <- data.frame(
  Variable = names(corr_pcos_sorted),
  Correlation = corr_pcos_sorted
)

# Exclure la variable PCOS
df_corr <- df_corr[df_corr$Variable != "PCOS (Y/N)", ]
ggplot(df_corr, aes(x = reorder(Variable, Correlation), y = Correlation)) +
  geom_bar(stat = "identity", fill = "orange") +
  coord_flip() +
  labs(title = "Corrélation des variables avec le SOPK",
       x = "Variable",
       y = "Corrélation avec PCOS (Y/N)") +
  theme_minimal()
