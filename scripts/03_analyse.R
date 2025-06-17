# Analyse statistique comparative entre SOPK et non SOPK

library(readxl)
library(dplyr)
library(ggplot2)

# Importer les données nettoyées
donnees_sopk <- read_excel("data/PCOS_data_without_infertility.xlsx")
donnees_sopk <- na.omit(donnees_sopk)
donnees_sopk$`II    beta-HCG(mIU/mL)` <- as.numeric(donnees_sopk$`II    beta-HCG(mIU/mL)`)
donnees_sopk$`AMH(ng/mL)` <- as.numeric(donnees_sopk$`AMH(ng/mL)`)

# Rendre la variable PCOS numérique
donnees_sopk$`PCOS (Y/N)` <- as.numeric(as.character(donnees_sopk$`PCOS (Y/N)`))

# Sélectionner les variables numériques sans les identifiants
donnees_numeriques <- donnees_sopk %>%
  select(-`Sl. No`, -`Patient File No.`) %>%
  select(where(is.numeric))

# Calculer la corrélation avec SOPK pour toutes les autres variables
correlations <- sapply(donnees_numeriques, function(var) {
  if (all(is.na(var))) return(NA)
  cor(donnees_sopk$`PCOS (Y/N)`, var, use = "complete.obs")
})

# Créer un dataframe
cor_df <- data.frame(
  Variable = names(correlations),
  Correlation = correlations
)

# Exclure PCOS et trier par ordre décroissant
cor_df <- cor_df[cor_df$Variable != "PCOS (Y/N)", ]
cor_df <- cor_df[order(abs(cor_df$Correlation), decreasing = TRUE), ]

# Afficher les 10 variables les plus corrélées
head(cor_df, 10)

# Afficher le graphique
top_vars <- head(cor_df, 10)

ggplot(top_vars, aes(x = reorder(Variable, Correlation), y = Correlation)) +
  geom_bar(stat = "identity", fill = "orange") +
  coord_flip() +
  labs(
    title = "Top 10 des corrélations avec le SOPK",
    x = "Variable",
    y = "Corrélation avec PCOS (Y/N)"
  ) +
  theme_minimal()

# Tests du Khi2
# Gain de poids
chisq.test(table(donnees_sopk$`Weight gain(Y/N)`, donnees_sopk$`PCOS (Y/N)`))

# Consommation de fast food
chisq.test(table(donnees_sopk$`Fast food (Y/N)`, donnees_sopk$`PCOS (Y/N)`))

# Pigmentation de la peau
chisq.test(table(donnees_sopk$`Skin darkening (Y/N)`, donnees_sopk$`PCOS (Y/N)`))

# Pilosité
chisq.test(table(donnees_sopk$`hair growth(Y/N)`, donnees_sopk$`PCOS (Y/N)`))

# Acné
chisq.test(table(donnees_sopk$`Pimples(Y/N)`, donnees_sopk$`PCOS (Y/N)`))

# Tests T
# Test t pour BMI
t.test(BMI ~ `PCOS (Y/N)`, data = donnees_sopk)

# Test t pour follicule gauche
t.test(`Follicle No. (L)` ~ `PCOS (Y/N)`, data = donnees_sopk)

# Test t pour follicule droite 
t.test(`Follicle No. (R)` ~ `PCOS (Y/N)`, data = donnees_sopk)

# Test t pour AMH
t.test(`AMH(ng/mL)` ~ `PCOS (Y/N)`, data = donnees_sopk)

# Test t pour poids 
t.test(`Weight (Kg)` ~ `PCOS (Y/N)`, data = donnees_sopk)
