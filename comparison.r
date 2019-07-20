plot(x1,y1, type="n",
     xlab = "1 - Especificidade", 
     ylab= "Sensitividade")
lines(x1, y1,lwd=3,lty=1, col="purple")
lines(x2, y2,lwd=3,lty=1, col="red")
abline(0,1, lty=2)
