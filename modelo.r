################################################################################################
#
# MODELAGEM PREDITIVA - MBA Business Analytics e Big Data
# Por: RICARDO REIS
#
# CASE - FRAMINGHAM HEART STUDY
#
################################################################################################
# LENDO OS DADOS
path <- "C:/Users/Ricardo/Documents/R-Projetos/FraminghamHeartStudy/"

base <- read.csv(paste(path,"framingham.csv",sep=""), 
                 sep=",",header = T,stringsAsFactors = T)

# Checando Missing Values
summary(base)

library("VIM")
matrixplot(base)
aggr(base)

#Estratégia Adotada:
#Excluindo linhas com Missing Values
index_glucose     <- which(is.na(base$glucose))
index_heartRate   <- which(is.na(base$heartRate))
index_BMI         <- which(is.na(base$BMI))
index_totChol     <- which(is.na(base$totChol))
index_BPMeds      <- which(is.na(base$BPMeds))
index_cigsPerDay  <- which(is.na(base$cigsPerDay))
index_education   <- which(is.na(base$education))

base_sem_mv <- base[-c(index_glucose,index_heartRate,index_BMI,index_totChol,index_BPMeds,index_cigsPerDay,index_education),]
matrixplot(base_sem_mv)
aggr(base_sem_mv)

# ANALISE BIVARIADA
# Variáveis quantitativas 
boxplot(base_sem_mv$male            ~ base_sem_mv$TenYearCHD)
boxplot(base_sem_mv$age             ~ base_sem_mv$TenYearCHD)
boxplot(base_sem_mv$education       ~ base_sem_mv$TenYearCHD)
boxplot(base_sem_mv$currentSmoker   ~ base_sem_mv$TenYearCHD)
boxplot(base_sem_mv$cigsPerDay      ~ base_sem_mv$TenYearCHD)
boxplot(base_sem_mv$BPMeds          ~ base_sem_mv$TenYearCHD)
boxplot(base_sem_mv$prevalentStroke ~ base_sem_mv$TenYearCHD)
boxplot(base_sem_mv$prevalentHyp    ~ base_sem_mv$TenYearCHD)
boxplot(base_sem_mv$diabetes        ~ base_sem_mv$TenYearCHD)
boxplot(base_sem_mv$totChol         ~ base_sem_mv$TenYearCHD)
boxplot(base_sem_mv$sysBP           ~ base_sem_mv$TenYearCHD)
boxplot(base_sem_mv$diaBP           ~ base_sem_mv$TenYearCHD)
boxplot(base_sem_mv$BMI             ~ base_sem_mv$TenYearCHD)
boxplot(base_sem_mv$heartRate       ~ base_sem_mv$TenYearCHD)
boxplot(base_sem_mv$glucose         ~ base_sem_mv$TenYearCHD)

#Variáveis quantitativas e quali
prop.table(table(base_sem_mv$TenYearCHD))
prop.table(table(base_sem_mv$male,       base_sem_mv$TenYearCHD),1)
prop.table(table(base_sem_mv$age,   base_sem_mv$TenYearCHD),1)
prop.table(table(base_sem_mv$education, base_sem_mv$TenYearCHD),1)
prop.table(table(base_sem_mv$currentSmoker,   base_sem_mv$TenYearCHD),1)
prop.table(table(base_sem_mv$cigsPerDay,   base_sem_mv$TenYearCHD),1)
prop.table(table(base_sem_mv$BPMeds,      base_sem_mv$TenYearCHD),1)
prop.table(table(base_sem_mv$prevalentStroke,   base_sem_mv$TenYearCHD),1)
prop.table(table(base_sem_mv$prevalentHyp,     base_sem_mv$TenYearCHD),1)
prop.table(table(base_sem_mv$diabetes,  base_sem_mv$TenYearCHD),1)
prop.table(table(base_sem_mv$totChol, base_sem_mv$TenYearCHD),1)
prop.table(table(base_sem_mv$sysBP, base_sem_mv$TenYearCHD),1)
prop.table(table(base_sem_mv$diaBP, base_sem_mv$TenYearCHD),1)
prop.table(table(base_sem_mv$BMI, base_sem_mv$TenYearCHD),1)
prop.table(table(base_sem_mv$heartRate, base_sem_mv$TenYearCHD),1)
prop.table(table(base_sem_mv$glucose, base_sem_mv$TenYearCHD),1)

################################################################################################
# AMOSTRAGEM DO DADOS
library(caret)

set.seed(12345)
index <- createDataPartition(base_sem_mv$TenYearCHD, p= 0.7,list = F)

data.train <- base_sem_mv[index, ] # base de desenvolvimento: 70%
data.test  <- base_sem_mv[-index,] # base de teste: 30%

# Checando se as proporções das amostras são próximas à base original
prop.table(table(base_sem_mv$TenYearCHD))
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

# seleção de variáveis
glm.step <- stepAIC(glm.full,direction = 'both', trace = TRUE)
summary(glm.step)
# O método manteve apenas variáveis que minimizaram o AIC

# Aplicando o modelo nas amostras  e determinando as probabilidades
glm.prob.train <- predict(glm.step,type = "response")

glm.prob.test <- predict(glm.step, newdata = data.test, type= "response")

# Verificando a aderência do ajuste logístico
library(rms)
val.prob(glm.prob.train, data.train$TenYearCHD, smooth = F)
# p valor > 5%, não podemos rejeitar a hipotese nula

# Comportamento da saida do modelo
hist(glm.prob.test, breaks = 25, col = "lightblue",xlab= "Probabilidades",
     ylab= "Frequência",main= "Regressão Logística")

boxplot(glm.prob.test ~ data.test$TenYearCHD,col= c("red", "green"), horizontal= T)

################################################################################################
# AVALIANDO A PERFORMANCE

# Métricas de discriminação para ambos modelos
library(hmeasure) 

glm.train <- HMeasure(data.train$TenYearCHD,glm.prob.train)
glm.test  <- HMeasure(data.test$TenYearCHD, glm.prob.test)
summary(glm.train)
summary(glm.test)


library(pROC)
roc1 <- roc(data.test$TenYearCHD,glm.prob.test)
y1 <- roc1$sensitivities
x1 <- 1-roc1$specificities

plot(x1,y1, type="n",
     xlab = "1 - Especificidade", 
     ylab= "Sensitividade")
lines(x1, y1,lwd=3,lty=1, col="purple") 

################################################################################################
################################################################################################

