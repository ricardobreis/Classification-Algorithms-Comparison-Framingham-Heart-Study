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
# ANALISANDO AS VARiÁVEIS DA BASE DE DADOS
# ANÁLISE UNIVARIADA
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

# ANÁLISE BIVARIADA
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

# Algoritmos de árvore necessitam que a variável resposta num problema de classificação seja 
# um factor; convertendo aqui nas amostras de desenvolvimento e teste
data.train$TenYearCHD <- as.factor(data.train$TenYearCHD)
data.test$TenYearCHD  <- as.factor(data.test$TenYearCHD)

################################################################################################
# MODELAGEM DOS DADOS - MÉTODOS DE ENSEMBLE

names  <- names(data.train) # salva o nome de todas as variáveis e escreve a fórmula
f_full <- as.formula(paste("TenYearCHD ~",
                           paste(names[!names %in% "TenYearCHD"], collapse = " + ")))

# a) Random Forest
library(randomForest)
# Aqui começamos a construir um modelo de random forest usando sqrt(n var) | mtry = default
# Construimos 500 árvores, e permitimos nós finais com no mínimo 50 elementos
rndfor <- randomForest(f_full,data= data.train,importance = T, nodesize =5, ntree = 500)
rndfor

# Avaliando a evolução do erro com o aumento do número de árvores no ensemble
plot(rndfor, main= "Mensuração do erro")
legend("topright", c('Out-of-bag',"1","0"), lty=1, col=c("black","green","red"))

# Uma avaliação objetiva indica que a partir de ~30 árvores não há mais ganhos expressivos
rndfor2 <- randomForest(f_full,data= data.train,importance = T, nodesize =5, ntree = 50)
rndfor2

plot(rndfor2, main= "Mensuração do erro")
legend("topright", c('Out-of-bag',"1","0"), lty=1, col=c("black","green","red"))

# Importância das variáveis
varImpPlot(rndfor2, sort= T, main = "Importância das Variáveis")

# Aplicando o modelo nas amostras  e determinando as probabilidades
rndfor2.prob.train <- predict(rndfor2, type = "prob")[,2]
rndfor2.prob.test  <- predict(rndfor2,newdata = data.test, type = "prob")[,2]

# Comportamento da saida do modelo
hist(rndfor2.prob.test, breaks = 25, col = "lightblue",xlab= "Probabilidades",
     ylab= "Frequência",main= "Random Forest")

boxplot(rndfor2.prob.test ~ data.test$TenYearCHD,col= c("green", "red"), horizontal= T)

#-------------------------------------------------------------------------------------------
# b) Boosted trees
library(adabag)
# Aqui construimos inicialmente um modelo boosting com 1000 iterações, profundidade 1
# e minbucket 50, os pesos das árvores serão dados pelo algoritimo de Freund
boost <- boosting(f_full, data= data.train, mfinal= 110, 
                  coeflearn = "Freund", 
                  control = rpart.control(minbucket= 5,maxdepth = 12))

# Avaliando a evolução do erro conforme o número de iterações aumenta
plot(errorevol(boost, data.train))

# podemos manter em 200 iterações

# Importância das variáveis
var_importance <- boost$importance[order(boost$importance,decreasing = T)]
var_importance
importanceplot(boost)

# Aplicando o modelo na amostra de teste e determinando as probabilidades
boost.prob.train <- predict.boosting(boost, data.train)$prob[,2]
boost.prob.test  <- predict.boosting(boost, data.test)$prob[,2]

# Comportamento da saída do modelo
hist(boost.prob.test, breaks = 25, col = "lightblue",xlab= "Probabilidades",
     ylab= "Frequ?ncia",main= "Boosting")

boxplot(boost.prob.test ~ data.test$TenYearCHD,col= c("green", "red"), horizontal= T)

################################################################################################
# AVALIANDO A PERFORMANCE

# Métricas de discriminação para ambos modelos
library(hmeasure) 

rndfor.train  <- HMeasure(data.train$TenYearCHD,rndfor2.prob.train)
rndfor.test  <- HMeasure(data.test$TenYearCHD,rndfor2.prob.test)
rndfor.train$metrics
rndfor.test$metrics

boost.train <- HMeasure(data.train$TenYearCHD,boost.prob.train)
boost.test  <- HMeasure(data.test$TenYearCHD,boost.prob.test)
boost.train$metrics
boost.test$metrics

library(pROC)
roc3 <- roc(data.test$TenYearCHD,rndfor2.prob.test)
y3 <- roc3$sensitivities
x3 <- 1-roc3$specificities

roc4 <- roc(data.test$TenYearCHD,boost.prob.test)
y4 <- roc4$sensitivities
x4 <- 1-roc4$specificities

plot(x3,y3, type="n",
     xlab = "1 - Especificidade", 
     ylab= "Sensitividade")
lines(x3, y3,lwd=3,lty=1, col="pink") 
lines(x4, y4,lwd=3,lty=1, col="blue") 
legend("topright", c('Random Forest',"Boosting"), lty=1, col=c("pink","blue"))

################################################################################################
################################################################################################

