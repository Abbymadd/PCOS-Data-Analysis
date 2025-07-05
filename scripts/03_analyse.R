# Analyse statistique comparative entre SOPK et non SOPK

library(readxl)
library(dplyr)
library(ggplot2)
library(car)

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

# Calculer la corrélation avec SOPK pour toutes les variables
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
vars_qualitatives <- c(
  "Weight gain(Y/N)",
  "Fast food (Y/N)",
  "Skin darkening (Y/N)",
  "hair growth(Y/N)",
  "Pimples(Y/N)"
)

for (var in vars_qualitatives) {
  cat("\nTest du khi² :", var, "vs SOPK\n")
  table_var <- table(donnees_sopk[[var]], donnees_sopk$`PCOS (Y/N)`)
  print(chisq.test(table_var))
}

# Tester sur les résidus de chaque groupe pour BMI et AMH
# Groupe non PCOS
shapiro.test(donnees_sopk$BMI[donnees_sopk$`PCOS (Y/N)` == 0])
shapiro.test(donnees_sopk$`AMH(ng/mL)`[donnees_sopk$`PCOS (Y/N)` == 0])
shapiro.test(donnees_sopk$`Weight (Kg)`[donnees_sopk$`PCOS (Y/N)`==0])
shapiro.test(donnees_sopk$`Follicle No. (L)`[donnees_sopk$`PCOS (Y/N)`==0])
shapiro.test(donnees_sopk$`Follicle No. (R)`[donnees_sopk$`PCOS (Y/N)`==0])

#Groupe PCOS
shapiro.test(donnees_sopk$BMI[donnees_sopk$`PCOS (Y/N)` == 1])
shapiro.test(donnees_sopk$`AMH(ng/mL)`[donnees_sopk$`PCOS (Y/N)` == 1])
shapiro.test(donnees_sopk$`Weight (Kg)`[donnees_sopk$`PCOS (Y/N)`==1])
shapiro.test(donnees_sopk$`Follicle No. (L)`[donnees_sopk$`PCOS (Y/N)`==1])
shapiro.test(donnees_sopk$`Follicle No. (R)`[donnees_sopk$`PCOS (Y/N)`==1])

# Homogénéité des variances
leveneTest(BMI ~ factor(`PCOS (Y/N)`), data = donnees_sopk)
leveneTest(`AMH(ng/mL)` ~ factor(`PCOS (Y/N)`), data = donnees_sopk)

# Boîtes à moustaches
ggplot(donnees_sopk, aes(x = factor(`PCOS (Y/N)`), y = BMI)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Distribution de l'IMC selon SOPK", x = "SOPK", y = "IMC") +
  theme_minimal()

summary(donnees_sopk$`AMH(ng/mL)`)
ggplot(donnees_sopk, aes(x = factor(`PCOS (Y/N)`), y = `AMH(ng/mL)`)) +
  geom_boxplot(fill = "darkgreen") +
  coord_cartesian(ylim = c(0, 35)) +
  labs(title = "Distribution de l'AMH selon SOPK",
       x = "SOPK", y = "AMH (ng/mL)") +
  theme_minimal()

# Diagrammes de dispersion
summary(donnees_sopk$`LH(mIU/mL)`)
summary(donnees_sopk$`FSH(mIU/mL)`)

ggplot(donnees_sopk, aes(x = BMI, y = `Follicle No. (L)`, color = factor(`PCOS (Y/N)`))) +
  geom_point(alpha = 0.6) +
  labs(title = "BMI vs Nombre de follicules (gauche)", x = "IMC", y = "Follicules (L)", color = "SOPK") +
  theme_minimal()

ggplot(donnees_sopk, aes(x = `LH(mIU/mL)`, y = `FSH(mIU/mL)`, color = factor(`PCOS (Y/N)`))) +
  geom_point(alpha = 0.6) +
  labs(title = "LH vs FSH selon SOPK", x = "LH (mIU/mL)", y = "FSH (mIU/mL)", color = "SOPK") +
  coord_cartesian(xlim = c(0, 20), ylim = c(0, 20)) + # j'ai ajusté pour pouvoir visualiser l'ensemble principal
  theme_minimal()

# Tests T
vars <- c("BMI", "Weight (Kg)", "AMH(ng/mL)", "Follicle No. (L)", "Follicle No. (R)")
for (v in vars) {
  print(v)
  print(t.test(donnees_sopk[[v]] ~ donnees_sopk$`PCOS (Y/N)`))
}

# Tests de Wilcoxon
# BMI
print(wilcox.test(BMI ~ `PCOS (Y/N)`, data=donnees_sopk))

# AMH
print(wilcox.test(`AMH(ng/mL)` ~ `PCOS (Y/N)`, data=donnees_sopk))

# Poids
print(wilcox.test(`Weight (Kg)` ~ `PCOS (Y/N)`, data=donnees_sopk))

# Follicule gauche
print(wilcox.test(`Follicle No. (L)` ~ `PCOS (Y/N)`, data=donnees_sopk))

# Follicule droite
print(wilcox.test(`Follicle No. (R)` ~ `PCOS (Y/N)`, data=donnees_sopk))
