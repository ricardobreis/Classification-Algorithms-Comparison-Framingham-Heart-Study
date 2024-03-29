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

baseRL <- read.csv(paste(path,"framingham.csv",sep=""), 
                 sep=",",header = T,stringsAsFactors = T)

# Checando Missing Values
summary(baseRL)

library("VIM")
matrixplot(baseRL)
aggr(baseRL)

#Estratégia Adotada:
#Excluindo linhas com Missing Values
index_glucose     <- which(is.na(baseRL$glucose))
index_heartRate   <- which(is.na(baseRL$heartRate))
index_BMI         <- which(is.na(baseRL$BMI))
index_totChol     <- which(is.na(baseRL$totChol))
index_BPMeds      <- which(is.na(baseRL$BPMeds))
index_cigsPerDay  <- which(is.na(baseRL$cigsPerDay))
index_education   <- which(is.na(baseRL$education))

baseRL_sem_mv <- baseRL[-c(index_glucose,index_heartRate,index_BMI,index_totChol,index_BPMeds,index_cigsPerDay,index_education),]
matrixplot(baseRL_sem_mv)
aggr(baseRL_sem_mv)

# ANALISE BIVARIADA
# Variáveis quantitativas 
boxplot(baseRL_sem_mv$male            ~ baseRL_sem_mv$TenYearCHD)
boxplot(baseRL_sem_mv$age             ~ baseRL_sem_mv$TenYearCHD)
boxplot(baseRL_sem_mv$education       ~ baseRL_sem_mv$TenYearCHD)
boxplot(baseRL_sem_mv$currentSmoker   ~ baseRL_sem_mv$TenYearCHD)
boxplot(baseRL_sem_mv$cigsPerDay      ~ baseRL_sem_mv$TenYearCHD)
boxplot(baseRL_sem_mv$BPMeds          ~ baseRL_sem_mv$TenYearCHD)
boxplot(baseRL_sem_mv$prevalentStroke ~ baseRL_sem_mv$TenYearCHD)
boxplot(baseRL_sem_mv$prevalentHyp    ~ baseRL_sem_mv$TenYearCHD)
boxplot(baseRL_sem_mv$diabetes        ~ baseRL_sem_mv$TenYearCHD)
boxplot(baseRL_sem_mv$totChol         ~ baseRL_sem_mv$TenYearCHD)
boxplot(baseRL_sem_mv$sysBP           ~ baseRL_sem_mv$TenYearCHD)
boxplot(baseRL_sem_mv$diaBP           ~ baseRL_sem_mv$TenYearCHD)
boxplot(baseRL_sem_mv$BMI             ~ baseRL_sem_mv$TenYearCHD)
boxplot(baseRL_sem_mv$heartRate       ~ baseRL_sem_mv$TenYearCHD)
boxplot(baseRL_sem_mv$glucose         ~ baseRL_sem_mv$TenYearCHD)

#Variáveis quantitativas e quali
prop.table(table(baseRL_sem_mv$TenYearCHD))
prop.table(table(baseRL_sem_mv$male,       baseRL_sem_mv$TenYearCHD),1)
prop.table(table(baseRL_sem_mv$age,   baseRL_sem_mv$TenYearCHD),1)
prop.table(table(baseRL_sem_mv$education, baseRL_sem_mv$TenYearCHD),1)
prop.table(table(baseRL_sem_mv$currentSmoker,   baseRL_sem_mv$TenYearCHD),1)
prop.table(table(baseRL_sem_mv$cigsPerDay,   baseRL_sem_mv$TenYearCHD),1)
prop.table(table(baseRL_sem_mv$BPMeds,      baseRL_sem_mv$TenYearCHD),1)
prop.table(table(baseRL_sem_mv$prevalentStroke,   baseRL_sem_mv$TenYearCHD),1)
prop.table(table(baseRL_sem_mv$prevalentHyp,     baseRL_sem_mv$TenYearCHD),1)
prop.table(table(baseRL_sem_mv$diabetes,  baseRL_sem_mv$TenYearCHD),1)
prop.table(table(baseRL_sem_mv$totChol, baseRL_sem_mv$TenYearCHD),1)
prop.table(table(baseRL_sem_mv$sysBP, baseRL_sem_mv$TenYearCHD),1)
prop.table(table(baseRL_sem_mv$diaBP, baseRL_sem_mv$TenYearCHD),1)
prop.table(table(baseRL_sem_mv$BMI, baseRL_sem_mv$TenYearCHD),1)
prop.table(table(baseRL_sem_mv$heartRate, baseRL_sem_mv$TenYearCHD),1)
prop.table(table(baseRL_sem_mv$glucose, baseRL_sem_mv$TenYearCHD),1)

################################################################################################
# AMOSTRAGEM DO DADOS
library(caret)

set.seed(12345)
index <- createDataPartition(baseRL_sem_mv$TenYearCHD, p= 0.7,list = F)

data.train <- baseRL_sem_mv[index, ] # base de desenvolvimento: 70%
data.test  <- baseRL_sem_mv[-index,] # base de teste: 30%

# Checando se as proporções das amostras são próximas à base original
prop.table(table(baseRL_sem_mv$TenYearCHD))
prop.table(table(data.train$TenYearCHD))
prop.table(table(data.test$TenYearCHD))

################################################################################################
# MODELAGEM DOS DADOS - REGRESSÃO LOGISTICA

# Avaliando multicolinearidade - vars quantitativas
library(mctest)
vars.quant <- data.train[,c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)]

imcdiag(vars.quant,data.train$TenYearCHD)

names  <- names(data.train) # salva o nome de todas as variáveis e escreve a fórmula
f_full <- as.formula(paste("TenYearCHD ~",
                           paste(names[!names %in% "TenYearCHD"], collapse = " + ")))

glm.full <- glm(f_full, data= data.train, family= binomial(link='logit'))
summary(glm.full)

# observam-se variáveis não significantes, podemos remover uma de cada vez e testar, ou
# usar o método stepwise que escolhe as variáveis que minimizem o AIC

library(MASS)
# seleção de variáveis
glm.step <- stepAIC(glm.full,direction = 'both', trace = TRUE)
summary(glm.step)
# O método manteve apenas variáveis que minimizaram o AIC

# Aplicando o modelo nas amostras  e determinando as probabilidades
glm.prob.train <- predict(glm.step,type = "response")

glm.prob.test <- predict(glm.step, newdata = data.test, type= "response")
#length(glm.prob.train)

# Verificando a aderência do ajuste logístico
library(rms)
val.prob(glm.prob.train, data.train$TenYearCHD, smooth = F)
# p valor > 5%, não podemos rejeitar a hipotese nula

# Comportamento da saida do modelo
hist(glm.prob.test, breaks = 25, col = "lightblue",xlab= "Probabilidades",
     ylab= "Frequência",main= "Regressão Logística")

boxplot(glm.prob.test ~ data.test$TenYearCHD,col= c("red", "green"), horizontal= T)

#guardando o histograma
hist <- hist(glm.prob.test, breaks= 20, probability= T, ylim= c(0,5))
score_1 <- density(baseRL_sem_mv$TenYearCHD[baseRL_sem_mv$TenYearCHD == 1], na.rm = T)
score_0 <- density(baseRL_sem_mv$TenYearCHD[baseRL_sem_mv$TenYearCHD == 0], na.rm = T)
lines(score_1,col = 'red')
lines(score_0,col = 'blue')

################################################################################################
# AVALIANDO A PERFORMANCE

# Métricas de discriminação para ambos modelos
library(hmeasure) 

glm.train <- HMeasure(data.train$TenYearCHD,glm.prob.train)
glm.test  <- HMeasure(data.test$TenYearCHD, glm.prob.test)
summary(glm.train)
summary(glm.test)

glm.train$metrics
glm.test$metrics

library(pROC)
roc1 <- roc(data.test$TenYearCHD,glm.prob.test)
y1 <- roc1$sensitivities
x1 <- 1-roc1$specificities

plot(x1,y1, type="n",
     xlab = "1 - Especificidade", 
     ylab= "Sensitividade")
lines(x1, y1,lwd=3,lty=1, col="purple") 
abline(0,1, lty=2)

################################################################################################
################################################################################################


################################################################################################
# MATRIZ DE CONFUSAO

observado <- as.factor(data.test$TenYearCHD)
modelado  <- as.factor(ifelse(glm.prob.test >= 0.2, 1.0, 0.0))

library(gmodels)
CrossTable(observado, modelado, prop.c= F, prop.t= F, prop.chisq= F)

library(caret)
confusionMatrix(modelado,observado, positive = "1")

################################################################################################
################################################################################################

