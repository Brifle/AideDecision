clc;

%% Deuxieme partie

jugement = [6 5 5 5;
            5 4 9 3;
            3 7 5 4;
            5 4 3 9;
            3 5 7 4];

echelleMax = 10;

coef = [1 100 1 1];

s = 0.7;
v = 0.5;

%% Calcul de la matrice de concordance

c = ones(5, 5);

for i=1:5
    for j=1:5
        if i == j
            c(i, j) = -1;
        else
            c(i, j) = ((jugement(i, :) >= jugement(j, :)) * coef') / sum(coef);
        end
    end
end

%% Calcul de la matrice de discordance

d = ones(5, 5);

for i=1:5
    for j=1:5
        if i == j
            d(i, j) = -1;
        else
            d(i, j) = max(jugement(j, :) - jugement(i, :))/echelleMax;
        end
    end
end

%% Majoration

res = [];

for i=1:5
    for j=1:5
        if i ~= j && c(i,j) >= s && d(i, j) <= v
            res = [res; i j];
        end
    end
end

res

for i=1:size(jugement, 1)
    if sum(res(:, 1) == i) == size(jugement, 1)-1
        'domination'
        i
    end
end


%% Creation d'un graphe sous matlab

A = zeros(size(coef, 2));

for i=1:size(res, 1)
    A(res(i, 1), res(i, 2)) = 1;
end

xy = [1 1;
      2 1;
      2 2;
      1.5 3;
      1 2];

gplotd(A,xy);

%% Ecriture du resultat dans un fichier parsable

fid = fopen(strcat('graph_', int2str(coef), '_', num2str(s), '_', num2str(v), '.txt'),'w');

for i=1:size(coef, 2)
    fprintf(fid, '%i ', coef(1, i));
end

fprintf(fid,'\n\n');

fprintf(fid, '%f %f', s, v);

fprintf(fid,'\n\n');

for i=1:size(res, 1)
    fprintf(fid, '%i %i\n', res(i, 1), res(i, 2));
end

fclose(fid);
