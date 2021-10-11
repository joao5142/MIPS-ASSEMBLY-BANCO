#PROJETO  GERENCIADOR DE SAQUE E DEPOSITO

.data

msgSaldoInicial:  .asciiz "Informe o saldo inicial(inteiro): "
msgMenu:      	  .asciiz "\n######MENU######\n1-Mostrar saldo\n2-Depositar\n3-Efetuar Saque\n0-Sair\n"
msgSaldo:   	  .asciiz "Saldo= "
novoSaldo: 	  .asciiz "Seu novo saldo é de = " 
msgDeposito:      .asciiz "Informe um valor para depositar(inteiro): "
msgSaque:         .asciiz "Informe seu saque : "
msgSair:          .asciiz "Sistema Finalizado!\n"


.macro print (%str)      #Macro para imprimir qualquer string na tela

     .data
        msg:    .asciiz %str
     .text 
        
        li $v0,4
        la $a0,msg
        syscall
   
.end_macro

.text #Diretiva de texto
.globl main #Diretava global

main:
#Mostro a mensagem na tela e leio o saldo inicial
li $v0,4
la $a0,msgSaldoInicial       #a0=msgSaldoInicial
syscall
li $v0,5            #Prepara o processador para ler um inteiro
syscall
move $t0,$v0        #t0=valor do saldo inicial
jal menu                #Chamo o bloco de codigo menu

menu:
li $v0,4
la $a0,msgMenu         #a0 = menu 
syscall             #Executa a instrução e apresenta o menu na tela
li $v0,5            #Prepara o processador para ler um inteiro
syscall
move $t7,$v0        #t7 vai conter o valor da escolha do usuario

#VERIFICAÇOES PARA DESVIAR PARA UM BLOCO DE CODIGO CONFORME O VALOR DO USUARIO
beq  $t7,1,mostrarSaldo
beq  $t7,2,depositar
beq  $t7,3,saque
beq  $t7,0,sair




#BLOCO DE CODIGO PARA DEPOSITAR
# t0 contem o valor do saldo inicial
depositar:
li $v0,4
la $a0,msgDeposito
syscall
li $v0,5
syscall
move $t1,$v0

add  $t0,$t0,$t1            #t0= t0+t1

#mostra o novo saldo na tela

li $v0,4
la $a0,novoSaldo
syscall
li $v0,1
la $a0,($t0)          #a0 = variavel que contem o saldo incrementado
syscall
jal menu               #Por fim retorna para o menu      


#BLOCO DE CODIGO PARA SAQUE 
#REGRA DE NEGOCIO : O SAQUE NAO PODE SER MAIOR QUE 400 E  NAO PODE SACAR UMA QUANTIA MAIOR QUE O SALDO
saque:
li $v0,4
la $a0,msgSaque        #a0= mensagem de saque
syscall             #executa as instruçoes e apresenta na tela a mensagem contida na variavel saque
li $v0,5
syscall
move $t1,$v0       #T1 vai conter o valor do saque

#Verificaçoes para saber se é possivel realizar o saque

bge  $t1,400,saqueMaior400   #Desvia para o bloco de codigo saqueMaior400 se o valor digitado for maior que 400

#Se nao foi desviado ira para a instrução abaixo

bge  $t1,$t0,saqueMaiorSaldo     #Se o saque for maior que o saldo entao desvia para o bloco saqueMaiorSaldo

#Se nao foi desviado ira para a instrução abaixo que ira fazer o saque

sub  $t0, $t0,$t1       #t0=t0-t1

#Mostra o novo saldo na tela
li $v0,4
la $a0,novoSaldo
syscall
li $v0,1
la $a0,($t0)          #a0 = variavel que contem o saldo incrementado
syscall
jal menu               #Por fim retorna para o menu      


#BLOCO DE CODIGO PARA VERIFICAÇÕES SAQUE

saqueMaior400:
#Chamo o macro 'print' para imprimir uma  mensagem 
print("Não foi possivel realizar o saque digite um numero menor que 400")       
jal menu      #Volto para o menu

saqueMaiorSaldo:
print("Não foi possivel realizar o saque ,saque maior que o saldo disponivel")       
jal menu      #Volto para o menu



#BLOCO PARA MOSTRAR O SALDO

mostrarSaldo:
li $v0,4
la $a0,msgSaldo         #a0= msgSaldo
syscall                 #Executa a instrução e mostra a mensagem gravada na variavel msgSaldo
li $v0,1
la $a0,($t0)
syscall
jal menu   #Volta para o menu   



#BLOCO DE CODIGO PARA SAIR
sair:
li $v0,10
syscall
