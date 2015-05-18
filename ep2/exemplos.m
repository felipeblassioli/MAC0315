function run(A,b,c,m,n,base)

printf("------------- run begin -----------\n");

x = zeros(n , 1);
x(base) = A(:,base) \ b;
[ind, v] = simplex(A,b,c,m,n,x)
if(ind == 0)
	best_c = c*v;
	printf("\nSolucao otima encontrada com custo : %f\n",best_c);
	for k=1:n
		printf("%d %f\n", k, v(k));
endfor
else
	printf("\nCusto otimo menos infinito\n");
	printf("\nDirecao viavel : \n");
	for i=1:n
		printf("%d %f\n",i,v(i));
	endfor
endif

printf("GLPK Result:\n\n")
[xopt,zmx]=glpk(c,A,b)

printf("------------- run end -----------\n");
endfunction

A = [2,1,1,0;1,3,0,1];
b = [4;8];
c = [-1, -1, 0, 0];
m = 2; 
n = 4;
base = [3,4];

run(A,b,c,m,n,base)

A = [1,-1];
b = [1];
c = -[1, 1];
m = 1;
n = 2;
base = [1];

run(A,b,c,m,n,base)