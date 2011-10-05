%% Données
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
  
%% Problème 1 : Le comptable

A1 = [t2; t1'];

tempsParSemaine = ones(7,1) * 60 * 8 * 2 * 5;

b1 = [t3'; tempsParSemaine];

%   Coût MP + Coût Machine - CA;
f1 = t4b * t2 + (t1 * t5' / 60)' - t4a;

x1 = linprog(f1, A1, b1, [], [], zeros(6, 1));

beneficemax = - f1 * x1;

%% Problème 2 : l'Atelier

f2 = ones(1, 6) * -1;

x2 = linprog(f2, A1, b1, [], [], zeros(6, 1));

nbproduitmax = - f2 * x2;

%% Problème intermédiaire : stock max

stockParProduit = [5 5 6 10 5 4];

Asmax = A1;
fsmax = stockParProduit * -1;
bsmax = b1;

xsmax = linprog(fsmax, Asmax, bsmax, [], [], zeros(6, 1));

stockmax = - fsmax * xsmax;

%% Problème 3 : Le responsable des stocks


A3 = [A1; stockParProduit];
f3 = f1;

X = 0:stockmax/1000:stockmax;
Y = ones(size(X));
idx = 0;
for i = X,
    b3 = [b1; i];
    x3 = linprog(f3, A3, b3, [], [], zeros(6, 1));
    
    idx = idx + 1;
    Y(idx) = -f3 * x3;
end

subplot(2,1,1);
plot(X / stockmax * 100, Y);
title('Bénéfice selon utilisation de la capacité de stockage');
xlabel('Pourcentage d''utilisation de la capacité de stockage');
ylabel('Bénéfice en millions d''euros');
axis
subplot(2,1,2);
plot(X / stockmax * 100, Y./X);
title('Progression du bénéfice en fonction de l''utilisation de la capacité');
ylabel('Bénéfice / utilisation de la capacité de stockage');
xlabel('Pourcentage d''utilisation de la capacité de stockage');

%% Problème 4 : Le responsable commercial

cont4 = [1, 1, 1, -1, -1, -1;
         -1, -1, -1, 1, 1, 1]; 

A4 = [A1; cont4];
%f4 = f1; % <= Maximiser les bénéfices
f4 = f2; % <= Maximiser la production
X = 0:10:nbproduitmax;
Xp = ones(size(X)); 
Y = ones(size(X));
idx = 0;
for i = X,
    b4 = [b1; i; i];
    x4 = linprog(f4, A4, b4, [], [], zeros(6, 1));
    
    idx = idx + 1;
    Xp(idx) = [1, 1, 1, -1, -1, -1] * x4;
    Y(idx) = -f4 * x4;
end

subplot(2,1,1);
plot(X, Y);
title('Bénéfice par écart à l''égalité des deux groupes de produits');
xlabel('Ecart entre les deux groupes (en nombre de produits)');
ylabel('Bénéfice en millions d''euros');
subplot(2,1,2);
plot(X, Y./X);
title('Progression du bénéfice en fonction de l''écart entre les deux groupes');
xlabel('Ecart entre les deux groupes (en nombre de produits)');
ylabel('Bénéfice / écart entre les deux groupes');
figure;
plot(X, Xp);
title('Ecart réel par rapport à l''epsilon');
xlabel('Epsilon');
ylabel('<- Groupe D, E, F / Groupe A, B, C ->');

% On trouve ici que si la personne veut augmenter ses bénéfices en se
% séparant de l'égalité des groupes, il doit pencher vers le groupe ayant
% pour produits D, E et F.