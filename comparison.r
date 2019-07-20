plot(x1,y1, type="n",
     xlab = "1 - Especificidade", 
     ylab= "Sensitividade")
lines(x1, y1,lwd=3,lty=1, col="purple")
lines(x2, y2,lwd=3,lty=1, col="red")
abline(0,1, lty=2)
legend(0.6, 0.2, legend=c("Árvore de Classificação", "Regressão Logística"),
       col=c("red", "purple"), lty=1:1, cex=0.8)
