
function [ind v] = simplex(A, b, c, m, n, x)

% NAIVE simplex with non degeneracy assumption

printf("Simplex: Fase 2\n\n");

iter = 0;
while(true);
	printf("Iterando %d\n", iter);

	% Step 1: We start with a basic feasible solution x and an associated basis
	
	B_ind = find( x > 0 );
	B = A(:, B_ind);

	for idx = 1:numel(B_ind)
		printf("%d %f\n", B_ind(idx), x(B_ind(idx)));
	endfor

	fobj = c(B_ind) * x(B_ind);
	printf("\nValor da funcao objetivo : %f\n\n", fobj);

	% Step 2: Calculate reduced_costs

	tmp = setdiff( 1:n , B_ind );
	reduced_costs = c(tmp) - c(B_ind)*inv(B)*A(:,tmp);
	
	printf("\nCustos reduzidos\n");
	for idx = 1:numel(reduced_costs)
		printf("%d %f\n", tmp(idx), reduced_costs(idx) );
	endfor

	if( all( reduced_costs >= 0) )
	
		% The current basic feasible solution is optimal

		ind = 0;
		v = zeros(n,1);
		v(B_ind) = x(B_ind);
		break;
	else
		% Step 3: Compute u 
		find( reduced_costs < 0 );

		j = tmp( find( reduced_costs < 0 )(1) );
		u = inv(B) * A(:,j);

		printf("\nEntra na base : %d\n", j);
		printf("\nDirecao\n");
		for idx =  1:numel(u)
			printf("%d %f\n", B_ind(idx), u(idx) )
		endfor

		if( all( u < 0 ) )

			% If no component of u is positive, the optimal cost is -Inf

			ind = -1;
			v = zeros(n , 1);
			v(B_ind) = u;

			break;
		else

			% Step 4: Calculate theta

			idx = find( u > 0 );
			[theta, l] = min( x(B_ind(idx)) ./ u(idx) );

			printf("\nTheta*\n%f\n",theta);
			printf("\nSai da base: %d\n", B_ind(l) );

			% Step 5: Update basis and the current basic feasible solution
			
			A( :, B_ind(l) ) = A( :, j);
			x(B_ind) = x(B_ind) - theta*u;
			x(j) = theta;

		endif

	endif

	iter = iter + 1;
endwhile

endfunction

function run(A,b,c,m,n,base)

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

