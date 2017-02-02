#include<stdio.h>
#include<stdlib.h>
int main(){

int a,b,x,y,w,z;
  	 for (a= -10; a <= 0; a++){
		for (b= -9;b<=a;b++){
			printf ("*");
		}
		printf("*\n");
	}

		//aqui la parte de arriba de rombo , lado derecho 
	for (x=1;x <= 10;x++){
		for (y=2;y<=x;y++){
			printf ("*");
		}
		printf ("*\n");
	}
		//de aqui pa bajo se imprime la parte de abajo de rombo lado derecho
	for (w=1;w <= 10; w++){
		for (z=10;z >w ;z--){
			printf ("*");
		}
			printf ("*\n");		
	}	
	printf("\n Woow, this is an  intense flashback\n");
	return(0);
}
