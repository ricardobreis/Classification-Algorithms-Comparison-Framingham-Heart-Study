################################################################################################
#
# MODELAGEM PREDITIVA - MBA Business Analytics e Big Data
#
# CASE AULA 5 - EMPLOYEE TURNOVER
#
################################################################################################
# LENDO OS DADOS

path <- "~/Downloads/"

baseBRF <- read.csv(paste(path,"dataset-framingham-heart-study.csv",sep=""), 
                 sep=",",header = T,stringsAsFactors = T)

################################################################################################
# ANALISANDO AS VARIÁVEIS DA BASE DE DADOS
# ANALISE UNIVARIADA
summary(baseBRF)

# Checando Missing Values
library("VIM")
matrixplot(baseBRF)
aggr(baseBRF)

#Estratégia Adotada:
#Excluindo linhas com Missing Values
index_glucose     <- which(is.na(baseBRF$glucose))
index_heartRate   <- which(is.na(baseBRF$heartRate))
index_BMI         <- which(is.na(baseBRF$BMI))
index_totChol     <- which(is.na(baseBRF$totChol))
index_BPMeds      <- which(is.na(baseBRF$BPMeds))
index_cigsPerDay  <- which(is.na(baseBRF$cigsPerDay))
index_education   <- which(is.na(baseBRF$education))

baseBRF_sem_mv <- baseBRF[-c(index_glucose,index_heartRate,index_BMI,index_totChol,index_BPMeds,index_cigsPerDay,index_education),]
matrixplot(baseBRF_sem_mv)
aggr(baseBRF_sem_mv)

# ANALISE BIVARIADA
# Variáveis quantitativas 
boxplot(baseBRF_sem_mv$male            ~ baseBRF_sem_mv$TenYearCHD)
boxplot(baseBRF_sem_mv$age             ~ baseBRF_sem_mv$TenYearCHD)
boxplot(baseBRF_sem_mv$education       ~ baseBRF_sem_mv$TenYearCHD)
boxplot(baseBRF_sem_mv$currentSmoker   ~ baseBRF_sem_mv$TenYearCHD)
boxplot(baseBRF_sem_mv$cigsPerDay      ~ baseBRF_sem_mv$TenYearCHD)
boxplot(baseBRF_sem_mv$BPMeds          ~ baseBRF_sem_mv$TenYearCHD)
boxplot(baseBRF_sem_mv$prevalentStroke ~ baseBRF_sem_mv$TenYearCHD)
boxplot(baseBRF_sem_mv$prevalentHyp    ~ baseBRF_sem_mv$TenYearCHD)
boxplot(baseBRF_sem_mv$diabetes        ~ baseBRF_sem_mv$TenYearCHD)
boxplot(baseBRF_sem_mv$totChol         ~ baseBRF_sem_mv$TenYearCHD)
boxplot(baseBRF_sem_mv$sysBP           ~ baseBRF_sem_mv$TenYearCHD)
boxplot(baseBRF_sem_mv$diaBP           ~ baseBRF_sem_mv$TenYearCHD)
boxplot(baseBRF_sem_mv$BMI             ~ baseBRF_sem_mv$TenYearCHD)
boxplot(baseBRF_sem_mv$heartRate       ~ baseBRF_sem_mv$TenYearCHD)
boxplot(baseBRF_sem_mv$glucose         ~ baseBRF_sem_mv$TenYearCHD)

#Variáveis quantitativas e quali
prop.table(table(baseBRF_sem_mv$TenYearCHD))
prop.table(table(baseBRF_sem_mv$male,       baseBRF_sem_mv$TenYearCHD),1)
prop.table(table(baseBRF_sem_mv$age,   baseBRF_sem_mv$TenYearCHD),1)
prop.table(table(baseBRF_sem_mv$education, baseBRF_sem_mv$TenYearCHD),1)
prop.table(table(baseBRF_sem_mv$currentSmoker,   baseBRF_sem_mv$TenYearCHD),1)
prop.table(table(baseBRF_sem_mv$cigsPerDay,   baseBRF_sem_mv$TenYearCHD),1)
prop.table(table(baseBRF_sem_mv$BPMeds,      baseBRF_sem_mv$TenYearCHD),1)
prop.table(table(baseBRF_sem_mv$prevalentStroke,   baseBRF_sem_mv$TenYearCHD),1)
prop.table(table(baseBRF_sem_mv$prevalentHyp,     baseBRF_sem_mv$TenYearCHD),1)
prop.table(table(baseBRF_sem_mv$diabetes,  baseBRF_sem_mv$TenYearCHD),1)
prop.table(table(baseBRF_sem_mv$totChol, baseBRF_sem_mv$TenYearCHD),1)
prop.table(table(baseBRF_sem_mv$sysBP, baseBRF_sem_mv$TenYearCHD),1)
prop.table(table(baseBRF_sem_mv$diaBP, baseBRF_sem_mv$TenYearCHD),1)
prop.table(table(baseBRF_sem_mv$BMI, baseBRF_sem_mv$TenYearCHD),1)
prop.table(table(baseBRF_sem_mv$heartRate, baseBRF_sem_mv$TenYearCHD),1)
prop.table(table(baseBRF_sem_mv$glucose, baseBRF_sem_mv$TenYearCHD),1)

################################################################################################
# AMOSTRAGEM DO DADOS
library(caret)

set.seed(12345)
index <- createDataPartition(baseBRF_sem_mv$TenYearCHD, p= 0.7,list = F)

data.train <- baseBRF_sem_mv[index, ] # base de desenvolvimento: 70%
data.test  <- baseBRF_sem_mv[-index,] # base de teste: 30%

# Checando se as proporções das amostras são próximas à base original
prop.table(table(baseBRF_sem_mv$TenYearCHD))
prop.table(table(data.train$TenYearCHD))
prop.table(table(data.test$TenYearCHD))

# Algoritmos de arvore necessitam que a variável resposta num problema de classificação seja 
# um factor; convertendo aqui nas amostras de desenvolvimento e teste
data.train$TenYearCHD <- as.factor(data.train$TenYearCHD)
data.test$TenYearCHD  <- as.factor(data.test$TenYearCHD)

################################################################################################
# MODELAGEM DOS DADOS - M?TODOS DE ENSEMBLE

names  <- names(data.train) # salva o nome de todas as vari?veis e escreve a f?rmula
f_full <- as.formula(paste("TenYearCHD ~",
                           paste(names[!names %in% "TenYearCHD"], collapse = " + ")))

# a) Random Forest
library(randomForest)
# Aqui come?amos a construir um modelo de random forest usando sqrt(n var) | mtry = default
# Construimos 500 ?rvores, e permitimos n?s finais com no m?nimo 50 elementos
rndfor <- randomForest(f_full,data= data.train,importance = T, nodesize =50, ntree = 500)
rndfor

# Avaliando a evolu??o do erro com o aumento do n?mero de ?rvores no ensemble
plot(rndfor, main= "Mensura??o do erro")
legend("topright", c('Out-of-bag',"1","0"), lty=1, col=c("black","green","red"))

# Uma avalia??o objetiva indica que a partir de ~30 ?rvores n?o mais ganhos expressivos
rndfor2 <- randomForest(f_full,data= data.train,importance = T, nodesize =50, ntree = 30)
rndfor2

# Import?ncia das vari?veis
varImpPlot(rndfor2, sort= T, main = "Import?ncia das Vari?veis")

# Aplicando o modelo nas amostras  e determinando as probabilidades
rndfor2.prob.train <- predict(rndfor2, type = "prob")[,2]
rndfor2.prob.test  <- predict(rndfor2,newdata = data.test, type = "prob")[,2]

# Comportamento da saida do modelo
hist(rndfor2.prob.test, breaks = 25, col = "lightblue",xlab= "Probabilidades",
     ylab= "Frequ?ncia",main= "Random Forest")

boxplot(rndfor2.prob.test ~ data.test$TenYearCHD,col= c("green", "red"), horizontal= T)

#-------------------------------------------------------------------------------------------
# b) Boosted trees
library(adabag)
# Aqui construimos inicialmente um modelo boosting com 1000 itera??es, profundidade 1
# e minbucket 50, os pesos das ?rvores ser? dado pelo algortimo de Freund
boost <- boosting(f_full, data= data.train, mfinal= 12, 
                  coeflearn = "Freund", 
                  control = rpart.control(minbucket= 200,maxdepth = 1))

# Avaliando a evolu??o do erro conforme o n?mero de itera??es aumenta
plot(errorevol(boost, data.train))

# podemos manter em 200 itera??es

# Import?ncia das vari?veis
var_importance <- boost$importance[order(boost$importance,decreasing = T)]
var_importance
importanceplot(boost)

# Aplicando o modelo na amostra de teste e determinando as probabilidades
boost.prob.train <- predict.boosting(boost, data.train)$prob[,2]
boost.prob.test  <- predict.boosting(boost, data.test)$prob[,2]

# Comportamento da saida do modelo
hist(boost.prob.test, breaks = 25, col = "lightblue",xlab= "Probabilidades",
     ylab= "Frequ?ncia",main= "Boosting")

boxplot(boost.prob.test ~ data.test$y_empleft,col= c("green", "red"), horizontal= T)

################################################################################################
# AVALIANDO A PERFORMANCE

# Matricas de discrimina??o para ambos modelos
library(hmeasure) 

rndfor.train  <- HMeasure(data.train$y_empleft,rndfor2.probtrain)
rndfor.test  <- HMeasure(data.test$y_empleft,rndfor2.probtest)
summary(rndfor.train)
summary(rndfor.test)

boost.train <- HMeasure(data.train$y_empleft,boost.prob.train)
boost.test  <- HMeasure(data.test$y_empleft,boost.prob.test)
summary(boost.train)
summary(boost.test)


library(pROC)
roc1 <- roc(data.test$TenYearCHD,rndfor2.prob.test)
y1 <- roc1$sensitivities
x1 <- 1-roc1$specificities

roc2 <- roc(data.test$y_empleft,boost.prob.test)
y2 <- roc2$sensitivities
x2 <- 1-roc2$specificities


plot(x1,y1, type="n",
     xlab = "1 - Especificidade", 
     ylab= "Sensitividade")
lines(x1, y1,lwd=3,lty=1, col="purple") 
lines(x2, y2,lwd=3,lty=1, col="blue") 
legend("topright", c('Random Forest',"Boosting"), lty=1, col=c("purple","blue"))

################################################################################################
################################################################################################

