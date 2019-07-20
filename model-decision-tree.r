################################################################################################
#
# MODELAGEM PREDITIVA - MBA Business Analytics e Big Data
# Por: RICARDO REIS
#
# CASE - FRAMINGHAM HEART STUDY
#
# male: 0 = Female; 1 = Male
# age: Age at exam time.
# education: 1 = Some High School; 2 = High School or GED; 3 = Some College or Vocational School; 4 = college
# currentSmoker: 0 = nonsmoker; 1 = smoker
# cigsPerDay: number of cigarettes smoked per day (estimated average)
# BPMeds: 0 = Not on Blood Pressure medications; 1 = Is on Blood Pressure medications
# prevalentStroke: AVC
# prevalentHyp: Hipertensão
# diabetes: 0 = No; 1 = Yes
# totChol: Colesterol total mg/dL
# sysBP: Pressão sistólica mmHg
# diaBP: Pressão diastólica mmHg
# BMI: Body Mass Index calculated as: Weight (kg) / Height(meter-squared)
# heartRate: Beats/Min (Ventricular)
# glucose: Glicemia mg/dL
# TenYearCHD: Prever se o paciente vai ter doenças coronarianas em 10 anos
#
################################################################################################
# LENDO OS DADOS
path <- "C:/Users/Ricardo/Documents/R-Projetos/FraminghamHeartStudy/"

baseAD <- read.csv(paste(path,"framingham.csv",sep=""), 
                 sep=",",header = T,stringsAsFactors = T)

################################################################################################
# ANALISANDO AS VARIÁVEIS DA BASE DE DADOS
# ANALISE UNIVARIADA
summary(baseAD)

# Checando Missing Values
library("VIM")
matrixplot(baseAD)
aggr(baseAD)

#Estratégia Adotada:
#Excluindo linhas com Missing Values
index_glucose     <- which(is.na(baseAD$glucose))
index_heartRate   <- which(is.na(baseAD$heartRate))
index_BMI         <- which(is.na(baseAD$BMI))
index_totChol     <- which(is.na(baseAD$totChol))
index_BPMeds      <- which(is.na(baseAD$BPMeds))
index_cigsPerDay  <- which(is.na(baseAD$cigsPerDay))
index_education   <- which(is.na(baseAD$education))

baseAD_sem_mv <- baseAD[-c(index_glucose,index_heartRate,index_BMI,index_totChol,index_BPMeds,index_cigsPerDay,index_education),]
matrixplot(baseAD_sem_mv)
aggr(baseAD_sem_mv)

# ANALISE BIVARIADA
# Variáveis quantitativas 
boxplot(baseAD_sem_mv$male            ~ baseAD_sem_mv$TenYearCHD)
boxplot(baseAD_sem_mv$age             ~ baseAD_sem_mv$TenYearCHD)
boxplot(baseAD_sem_mv$education       ~ baseAD_sem_mv$TenYearCHD)
boxplot(baseAD_sem_mv$currentSmoker   ~ baseAD_sem_mv$TenYearCHD)
boxplot(baseAD_sem_mv$cigsPerDay      ~ baseAD_sem_mv$TenYearCHD)
boxplot(baseAD_sem_mv$BPMeds          ~ baseAD_sem_mv$TenYearCHD)
boxplot(baseAD_sem_mv$prevalentStroke ~ baseAD_sem_mv$TenYearCHD)
boxplot(baseAD_sem_mv$prevalentHyp    ~ baseAD_sem_mv$TenYearCHD)
boxplot(baseAD_sem_mv$diabetes        ~ baseAD_sem_mv$TenYearCHD)
boxplot(baseAD_sem_mv$totChol         ~ baseAD_sem_mv$TenYearCHD)
boxplot(baseAD_sem_mv$sysBP           ~ baseAD_sem_mv$TenYearCHD)
boxplot(baseAD_sem_mv$diaBP           ~ baseAD_sem_mv$TenYearCHD)
boxplot(baseAD_sem_mv$BMI             ~ baseAD_sem_mv$TenYearCHD)
boxplot(baseAD_sem_mv$heartRate       ~ baseAD_sem_mv$TenYearCHD)
boxplot(baseAD_sem_mv$glucose         ~ baseAD_sem_mv$TenYearCHD)

#Variáveis quantitativas e quali
prop.table(table(baseAD_sem_mv$TenYearCHD))
prop.table(table(baseAD_sem_mv$male,       baseAD_sem_mv$TenYearCHD),1)
prop.table(table(baseAD_sem_mv$age,   baseAD_sem_mv$TenYearCHD),1)
prop.table(table(baseAD_sem_mv$education, baseAD_sem_mv$TenYearCHD),1)
prop.table(table(baseAD_sem_mv$currentSmoker,   baseAD_sem_mv$TenYearCHD),1)
prop.table(table(baseAD_sem_mv$cigsPerDay,   baseAD_sem_mv$TenYearCHD),1)
prop.table(table(baseAD_sem_mv$BPMeds,      baseAD_sem_mv$TenYearCHD),1)
prop.table(table(baseAD_sem_mv$prevalentStroke,   baseAD_sem_mv$TenYearCHD),1)
prop.table(table(baseAD_sem_mv$prevalentHyp,     baseAD_sem_mv$TenYearCHD),1)
prop.table(table(baseAD_sem_mv$diabetes,  baseAD_sem_mv$TenYearCHD),1)
prop.table(table(baseAD_sem_mv$totChol, baseAD_sem_mv$TenYearCHD),1)
prop.table(table(baseAD_sem_mv$sysBP, baseAD_sem_mv$TenYearCHD),1)
prop.table(table(baseAD_sem_mv$diaBP, baseAD_sem_mv$TenYearCHD),1)
prop.table(table(baseAD_sem_mv$BMI, baseAD_sem_mv$TenYearCHD),1)
prop.table(table(baseAD_sem_mv$heartRate, baseAD_sem_mv$TenYearCHD),1)
prop.table(table(baseAD_sem_mv$glucose, baseAD_sem_mv$TenYearCHD),1)

################################################################################################
# AMOSTRAGEM DO DADOS
library(caret)

set.seed(12345)
index <- createDataPartition(baseAD_sem_mv$TenYearCHD, p= 0.7,list = F)

data.train <- baseAD_sem_mv[index, ] # base de desenvolvimento: 70%
data.test  <- baseAD_sem_mv[-index,] # base de teste: 30%

# Checando se as proporções das amostras são próximas à base original
prop.table(table(baseAD_sem_mv$TenYearCHD))
prop.table(table(data.train$TenYearCHD))
prop.table(table(data.test$TenYearCHD))

# Algoritmos de arvore necessitam que a variável resposta num problema de classificação seja 
# um factor; convertendo aqui nas amostras de desenvolvimento e teste
data.train$TenYearCHD <- as.factor(data.train$TenYearCHD)
data.test$TenYearCHD  <- as.factor(data.test$TenYearCHD)

################################################################################################
# MODELAGEM DOS DADOS - ÁRVORE DE CLASSIFICAÇÃO

names  <- names(data.train) # salva o nome de todas as variáveis e escreve a fórmula
f_full <- as.formula(paste("TenYearCHD ~",
                           paste(names[!names %in% "TenYearCHD"], collapse = " + ")))

library(rpart)
# Aqui começamos a construir uma árvore completa e permitimos apenas que as partições
# tenham ao menos 50 observações
tree.full <- rpart(data= data.train, f_full,
                   control = rpart.control(minbucket=50),
                   method = "class")

# saida da árvore
tree.full
summary(tree.full)

# Importância das variáveis
round(tree.full$variable.importance, 3)

# AValiando a necessidade de poda da árvore
printcp(tree.full)
plotcp(tree.full)

# Aqui conseguimos podar a árvore
tree.prune <- prune(tree.full, cp= tree.full$cptable[which.min(tree.full$cptable[,"xerror"]),"CP"])

# Plotando a árvore

library(rpart.plot)
rpart.plot(tree.full, cex = 1.3,type=0,
           extra=104, box.palette= "BuRd",
           branch.lty=3, shadow.col="gray", nn=TRUE, main="Árvore de Classificação")


rpart.plot(tree.prune, cex = 1.3,type=0,
           extra=104, box.palette= "BuRd",
           branch.lty=3, shadow.col="gray", nn=TRUE, main="Árvore de Classificação")

# Aplicando o modelo nas amostras  e determinando as probabilidades
tree.prob.train <- predict(tree.full, type = "prob")[,2]

tree.prob.test  <- predict(tree.full, newdata = data.test, type = "prob")[,2]

# Comportamento da saida do modelo
hist(tree.prob.test, breaks = 25, col = "lightblue",xlab= "Probabilidades",
     ylab= "Frequ?ncia",main= "Árvore de Classificação")

boxplot(tree.prob.test ~ data.test$TenYearCHD,col= c("green", "red"), horizontal= T)


################################################################################################
# AVALIANDO A PERFORMANCE

# Matricas de discriminação para ambos modelos
library(hmeasure) 

tree.train <- HMeasure(data.train$TenYearCHD,tree.prob.train)
tree.test  <- HMeasure(data.test$TenYearCHD, tree.prob.test)
summary(tree.train)
summary(tree.test)

tree.train$metrics
tree.test$metrics

library(pROC)
roc2 <- roc(data.test$TenYearCHD,tree.prob.test)
y2 <- roc2$sensitivities
x2 <- 1-roc2$specificities

plot(x2,y2, type="n",
     xlab = "1 - Especificidade", 
     ylab= "Sensitividade")
lines(x2, y2,lwd=3,lty=1, col="purple")
abline(0,1, lty=2)

################################################################################################
################################################################################################

################################################################################################
# MATRIZ DE CONFUSAO

observado <- as.factor(data.test$TenYearCHD)
modelado  <- as.factor(ifelse(tree.prob.test >= 0.2, 1.0, 0.0))

library(gmodels)
CrossTable(observado, modelado, prop.c= F, prop.t= F, prop.chisq= F)

library(caret)
confusionMatrix(modelado,observado, positive = "1")

################################################################################################
################################################################################################
