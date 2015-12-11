/*---- Multiplicar matrices -----*/
multL([],[],R) :- R is 0.
multL([H|T],[H0|T0],R) :- C is H*H0,multL(T,T0,Q),R is C + Q.

/*multiplicar una fila por todas las columnas*/
multFC(_,[],[]).
multFC(L,[H0|T0],[H1|T1]) :- multL(L,H0,H1), multFC(L,T0,T1).

/*multiplicar una lista de filas por una lista de columnas*/
multM([],_,[]).
multM([H|T],N,[H0|T0]) :- multFC(H,N,H0),multM(T,N,T0).

/*cantidad de elementos*/
cant([],0).
cant([_|T],R) :- cant(T,Q), R is Q+1.

cantCol([H|_],R) :- cant(H,R).

obtElm([H|_],0,H).
obtElm([_|T],C,R) :- D is C - 1, obtElm(T,D,R).

obtCol([],_,[]).
obtCol([H|T],C,[H0|T0]) :- obtElm(H,C,H0),obtCol(T,C,T0).

/*ver la matriz como una lista de columnas dada representada como 
una lista de filas*/
matFC(M,C,R) :- cantCol(M,D),D==C, R = [].
matFC(M,C,[H|T]) :- cantCol(M,D),D \= C,obtCol(M,C,H),E is C+1,matFC(M,E,T).

/*multipicar matrices*/
multMat(M,N,R) :- matFC(N,0,C), multM(M,C,R).
/*----------------*/

/*Imprimir arbol*/
arbol(0,[arbol(1,[arbol(2,[]),arbol(3,[])])]).
arbol(0,[arbol(1,[arbol(2,[arbol(4,[arbol(5,[]), arbol(6,[]), arbol(7,[])])]),arbol(3,[])])]).

imprimir(arbol(A,[])) :- write(A),nl.
imprimir(arbol(A,L)) :- write(A),nl,imprimeL(L).

imprimeL([]).
imprimeL([H|T]) :- imprimir(H),imprimeL(T).

/* Peso camino */
/*grafo(nodos([a,b,c,d]),[arco(a,b,1),arco(a,c,2),arco(b,c,3),arco(c,d,4)])*/
/* grafo(nodos([a,b,c,d,e,f]),[arco(a,b,1),arco(a,c,3), arco(a,d,5), arco(c,d,6), arco(d,e, 1), arco(c,e,4), arco(b,e,2), arco(e,f,7)]) */
/*Sacar los adyacentes de un nodo dado.*/

adyacentes(grafo(_,[]),_,[]).
adyacentes(grafo(_,[arco(X,Y,_)|T]),N,[H|R]) :- N==X,H = Y,adyacentes(grafo(_,T),N,R).
adyacentes(grafo(_,[arco(X,_,_)|T]),N,R) :- N\=X,adyacentes(grafo(_,T),N,R).

/*Sacar de una lista cual es el minimo que no es -1*/
minDifL1([],A,A).
minDifL1([H|T],A,R) :- mdf1(H,A,S),minDifL1(T,S,R).

/* Minimo diferente de -1 entre dos numeros */
mdf1(H,-1,H).
mdf1(-1,L,L).
mdf1(H,L,H) :- H =< L,!.
mdf1(_,L,L).

/* Obtener el peso de una arista A,B */
obtPeso(_,_,grafo(_,[]),-1).
obtPeso(A,B,grafo(_,[arco(A,B,P)|_]),P):-!.
obtPeso(A,B,grafo(N,[_|T]),P) :- obtPeso(A,B,grafo(N,T),P).

/* Hallarle a todos los adyacentes, el peso del camino desde cada uno al nodo destino */
recorrer(_,_,[],_,_,_,[]).
recorrer(A,B,[H|T],L,G,AC,[H0|T0]) :- obtPeso(A,H,G,P),P \= -1,NAC is AC+P,
	pesoCam(H,B,G,[A|L],NAC,H0),recorrer(A,B,T,L,G,AC,T0).
recorrer(A,B,[H|T],L,G,AC,[-1|T0]) :- obtPeso(A,H,G,P),P == -1, recorrer(A,B,T,L,G,AC,T0).

/* El peso de todos caminos que parten de los adyacentes hasta el destino, y se queda con el minimo diferente a -1 */
/*
	S -> Adyacentes a A
*/
pesoHs(A,B,S,L,G,AC,R) :- recorrer(A,B,S,L,G,AC,[H|T]), minDifL1(T,H,R).

/* Pertenece un elemento a una lista */
pertenece(A,[A|_]).
pertenece(A,[_|T]) :- pertenece(A,T).

/* Peso del camino entre un par de nodos */
/*
	AC -> Peso acumulado
	L  -> Lista de nodos visitados
*/
pesoCam(A,A,_,_,AC,AC).
pesoCam(A,_,_,L,_,-1) :- pertenece(A,L).
pesoCam(A,B,G,L,AC,R) :- adyacentes(G,A,S),pesoHs(A,B,S,L,G,AC,R).

/* Procedure */
camMin(A,B,G,R) :- pesoCam(A,B,G,[],0,R).

