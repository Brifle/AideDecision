%% Donn�es
t1 = [8  7 8 2 5 5 5;
      15 1 1 10 0 5 3;
      0 2 11 5 0 3 5;
      5 15 0 4 7 12 8;
      0 7 10 13 10 8 0;
      10 12 25 7 25 0 7];

t2 = [1 2 1 5 0 2;
      2 2 1 2 2 1;
      1 0 3 2 2 0];
 
t3 = [350 620 485];

t4a = [20 27 26 30 45 40];

t4b = [3 4 2];

t5 = [2 2 1 1 2 3 3];

t6 = [6 5 5 5;
      5 4 9 3;
      3 4 7 3;
      3 7 5 4;
      5 4 3 9;
      2 5 7 3;
      5 4 2 9;
      3 5 7 4];
  
%% Probl�me 1 : Le comptable

A = [t2; t1'];

tempsParSemaine = ones(7,1) * 60 * 8 * 2 * 5;

b = [t3'; tempsParSemaine];

%   Co�t MP + Co�t Machine - CA;
f = t4b * t2 + (t1 * t5' / 60)' - t4a;

x = linprog(f, A, b, [], [], zeros(6, 1));