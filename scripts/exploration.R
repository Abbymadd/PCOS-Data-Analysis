# Analyse exploratoire du jeu de données SOPK

library(readxl)
library(dplyr)
library(ggplot2)
library(corrplot)

donnees_sopk <- read_excel("data/PCOS_data_without_infertility.xlsx")
donnees_sopk <- na.omit(donnees_sopk)
donnees_sopk$`II    beta-HCG(mIU/mL)` <- as.numeric(donnees_sopk$`II    beta-HCG(mIU/mL)`)
donnees_sopk$`AMH(ng/mL)` <- as.numeric(donnees_sopk$`AMH(ng/mL)`)
donnees_sopk$`Cycle(R/I)` <- as.factor(donnees_sopk$`Cycle(R/I)`)
donnees_sopk$`Blood Group` <- as.factor(donnees_sopk$`Blood Group`)

summary(donnees_sopk)

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

cat("\nFréquence de gain de poids selon SOPK :\n")
print(table(donnees_sopk$`Weight gain(Y/N)`, donnees_sopk$`PCOS (Y/N)`))

cat("\nFréquence de pigmentation de la peau selon SOPK :\n")
print(table(donnees_sopk$`Skin darkening (Y/N)`, donnees_sopk$`PCOS (Y/N)`))

cat("\nFréquence de consommation de fast food selon SOPK :\n")
print(table(donnees_sopk$`Fast food (Y/N)`, donnees_sopk$`PCOS (Y/N)`))

ggplot(donnees_sopk, aes(x = factor(`Skin darkening (Y/N)`), fill = factor(`PCOS (Y/N)`))) +
  geom_bar(position = "dodge") +
  labs(title = "Pigmentation de la peau selon SOPK", 
       x = "Pigmentation (0=Non, 1=Oui)", 
       y = "Nombre de patientes", 
       fill = "SOPK") +
  theme_minimal()

donnees_numeriques <- donnees_sopk %>%
  select(-`Sl. No`, -`Patient File No.`) %>%
  select(where(is.numeric))

matrice_correlation <- cor(donnees_numeriques, use = "complete.obs")

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

corr_pcos <- matrice_correlation["PCOS (Y/N)", ]

corr_pcos_sorted <- sort(corr_pcos, decreasing = TRUE)

df_corr <- data.frame(
  Variable = names(corr_pcos_sorted),
  Correlation = corr_pcos_sorted
)

df_corr <- df_corr[df_corr$Variable != "PCOS (Y/N)", ]

ggplot(df_corr, aes(x = reorder(Variable, Correlation), y = Correlation)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Corrélation des variables avec le SOPK",
       x = "Variable",
       y = "Corrélation avec PCOS (Y/N)") +
  theme_minimal()
