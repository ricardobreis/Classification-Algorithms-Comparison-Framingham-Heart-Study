plot(x1,y1, type="n",
     xlab = "1 - Especificidade", 
     ylab= "Sensitividade")
lines(x1, y1,lwd=3,lty=1, col="purple")
lines(x2, y2,lwd=3,lty=1, col="red")
lines(x3, y3,lwd=3,lty=1, col="pink") 
lines(x4, y4,lwd=3,lty=1, col="blue") 
abline(0,1, lty=2)
legend(0.8, 0.3, legend=c("Árvore de Classificação", "Regressão Logística", 'Random Forest', "Boosting"),
       col=c("red", "purple", "pink", "blue"), lty=1:1, cex=0.8)
