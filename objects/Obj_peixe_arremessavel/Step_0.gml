var imam = 1 //é o tamanho minimo do peixe

var imao = 2 //isso é a altura maxima dele
var imac = imao / tempo //isso é pra ver quando q ele vai descer por frame
var imax = imam  + imao    - imac    * (abs(timer-tempo)+1) //e isso é pra fazer o tamanho dele ir diminuindo