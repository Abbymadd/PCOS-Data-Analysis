# Script pour importer et nettoyer les données SOPK

# Charger les bibliothèques nécessaires
library(readxl)
library(dplyr)
library(ggplot2)

# Importer les données
donnees_sopk <- read_excel("data/PCOS_data_without_infertility.xlsx")

# Structure des données
str(donnees_sopk)
summary(donnees_sopk)

# Vérifier les doublons
sum(duplicated(donnees_sopk))  # Résultat : 0

# Conversion de chaînes en numérique
donnees_sopk$`II    beta-HCG(mIU/mL)` <- as.numeric(donnees_sopk$`II    beta-HCG(mIU/mL)`)
donnees_sopk$`AMH(ng/mL)` <- as.numeric(donnees_sopk$`AMH(ng/mL)`)

# Supprimer les valeurs manquantes (NA)
donnees_sopk <- na.omit(donnees_sopk)

# Encodage de variables catégorielles
donnees_sopk$`Cycle(R/I)` <- as.factor(donnees_sopk$`Cycle(R/I)`)
donnees_sopk$`Blood Group` <- as.factor(donnees_sopk$`Blood Group`)

# Statistiques descriptives par groupe (médianes)
donnees_sopk %>%
  group_by(`PCOS (Y/N)`) %>%
  summarise(
    age_median = median(`Age (yrs)`),
    IMC_median = median(BMI),
    poids_median = median(`Weight (Kg)`),
    LH_median = median(`LH(mIU/mL)`),
    FSH_median = median(`FSH(mIU/mL)`),
    TSH_median = median(`TSH (mIU/L)`),
    endometrium_median = median(`Endometrium (mm)`),
    follicules_gauche_median = median(`Follicle No. (L)`),
    follicules_droit_median = median(`Follicle No. (R)`),
    cycle_median = median(`Cycle length(days)`)
  )

# Valeurs aberrantes - LH
summary(donnees_sopk$`LH(mIU/mL)`)
Q1 <- 1.030; Q3 <- 3.680
IQR <- Q3 - Q1
limite_sup <- Q3 + 3 * IQR  # [1] 11.63

# Boîte à moustaches LH
ggplot(donnees_sopk, aes(x = factor(`PCOS (Y/N)`), y = `LH(mIU/mL)`, fill = factor(`PCOS (Y/N)`))) +
  geom_boxplot(outlier.colour = "red", outlier.shape = 8) +
  scale_fill_manual(values = c("green", "blue")) +
  coord_cartesian(ylim = c(0, 20)) +
  labs(title = "LH selon SOPK", x = "SOPK (0=Non, 1=Oui)", y = "LH (mIU/mL)") +
  theme_minimal()

# Valeurs aberrantes - IMC
summary(donnees_sopk$BMI)
Q1 <- 21.83; Q3 <- 26.67
IQR <- Q3 - Q1
limite_sup <- Q3 + 3 * IQR  # [1] 41.19

# Boîte à moustaches IMC
ggplot(donnees_sopk, aes(x = factor(`PCOS (Y/N)`), y = BMI, fill = factor(`PCOS (Y/N)`))) +
  geom_boxplot(outlier.colour = "red", outlier.shape = 8) +
  scale_fill_manual(values = c("yellow", "purple")) +
  coord_cartesian(ylim = c(0, 45)) +
  labs(title = "IMC selon SOPK", x = "SOPK (0=Non, 1=Oui)", y = "IMC") +
  theme_minimal()
