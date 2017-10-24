clear all
close all
clc

%% Informações fornecidas pelo "Paper"
w=1;
beta=0;
lambda=beta;
delta=.05;
I=2;
J=2;
theta=[.5 .5]; %% Probabilidade de X
pi=[.5 .5]; %% Probabilidade de N
u=@(x)(x^(1/2));
g=@(x)((1/2)*x^(1/2));
In=@(x)(2*x*(-(x)+((x^2)+1)^(1/2))); %% Inversa da função f (Está errada essa função)
%% Funções Auxiliares ;
N=ones(1,I);
X=ones(1,J);
Z=ones(1,J+I-1);
for i=1:I
    N(i)=exp(beta+delta*i);
end
for k=1:J+I-1
    ZA(k)=exp((lambda-beta)+delta*(k-I));
end
%% Item A
%%Exemplo A
%%Calculando o phi de k, que representa a probabilidade de Z
aux=ones(I,J);
phik=ones(1,J+I-1);
for k=1:J+I-1 
    for i=1:I
        for j=1:J
            if j-i==k-I
            aux(i,j)=theta(j)*pi(i);
            else
            aux(i,j)=0;
            end
    phik(k)=sum(sum(aux));
        end
    end
end
%%Calculando o phi de k e i.
phiki=ones(J+I-1,I);
for i=1:I
    for k=1:J+I-1
        if k-I+i<=J && k-I+i>=1
        phiki(k,i)=pi(i)*theta(i+k-I)/phik(k);
        else
        phiki(k,i)=0;
        end
    end
end
%%De acordo com o autor do paper a equação 9 se trata de uma contração, por
%%isso para obter o resultado iremos itera-lá até achar seu ponto fixo.
%% Iteração 
tol=10^-20000;
it=0;
erro=1;
y=ones(1,I+J-1);
Ty=ones(1,I+J-1);
aux3=Ty;
aux4=ones(I+J-1,I);
while erro>tol && it<=100000
    for k=1:I+J-1
       for i=1:I
           for h=1:I+J-1
               aux3(h)=phik(h)*g(y(h)/(ZA(h)*N(i)));
           end
       aux4(k,i)=phiki(k,i)*sum(aux3);
       aux4trans=aux4';
       end
    aux5=(sum(aux4trans)); 
    Ty(k)=In(aux5(k)); 
    end
    erro=max(abs(Ty-y));
    y=Ty;
    it=it+1;
end
yA=y
%%Exemplo B
clearvars -except yA w beta lambda delta I pi u g In N tol ZA 
J=4;
theta=[.25 .25 .25 .25];
for k=1:J+I-1
    ZB(k)=exp((lambda-beta)+delta*(k-I));
end
%%Calculando o phi de k, que representa a probabilidade de Z
aux=ones(I,J);
phik=ones(1,J+I-1);
for k=1:J+I-1 
    for i=1:I
        for j=1:J
            if j-i==k-I
            aux(i,j)=theta(j)*pi(i);
            else
            aux(i,j)=0;
            end
    phik(k)=sum(sum(aux));
        end
    end
end
%%Calculando o phi de k e i.
phiki=ones(J+I-1,I);
for i=1:I
    for k=1:J+I-1
        if k-I+i<=J && k-I+i>=1
        phiki(k,i)=pi(i)*theta(i+k-I)/phik(k);
        else
        phiki(k,i)=0;
        end
    end
end
%%Iterando
it=0;
erro=1;
y=ones(1,I+J-1);
Ty=ones(1,I+J-1);
aux3=Ty;
aux4=ones(I+J-1,I);
while erro>tol && it<=100000
    for k=1:I+J-1
       for i=1:I
           for h=1:I+J-1
               aux3(h)=phik(h)*g(y(h)/(ZB(h)*N(i)));
           end
       aux4(k,i)=phiki(k,i)*sum(aux3);
       aux4trans=aux4';
       end
    aux5=(sum(aux4trans)); 
    Ty(k)=In(aux5(k)); 
    end
    erro=max(abs(Ty-y));
    y=Ty;
    it=it+1;
end
yB=y

clearvars -except ZA ZB yA yB beta w delta u g In

lambda=1;
I=2;
J=2;
theta=[.5 .5]; %% Probabilidade de X
pi=[.5 .5]; %% Probabilidade de N

%% Funções Auxiliares ;
N=ones(1,I);
X=ones(1,J);
Z=ones(1,J+I-1);
for i=1:I
    N(i)=exp(beta+delta*i);
end
for k=1:J+I-1
    ZAC(k)=exp((lambda-beta)+delta*(k-I));
end
%%Exemplo A
%%Calculando o phi de k, que representa a probabilidade de Z
aux=ones(I,J);
phik=ones(1,J+I-1);
for k=1:J+I-1 
    for i=1:I
        for j=1:J
            if j-i==k-I
            aux(i,j)=theta(j)*pi(i);
            else
            aux(i,j)=0;
            end
    phik(k)=sum(sum(aux));
        end
    end
end
%%Calculando o phi de k e i.
phiki=ones(J+I-1,I);
for i=1:I
    for k=1:J+I-1
        if k-I+i<=J && k-I+i>=1
        phiki(k,i)=pi(i)*theta(i+k-I)/phik(k);
        else
        phiki(k,i)=0;
        end
    end
end
%%De acordo com o autor do paper a equação 9 se trata de uma contração, por
%%isso para obter o resultado iremos itera-lá até achar seu ponto fixo.
%% Iteração 
tol=10^-20000;
it=0;
erro=1;
y=ones(1,I+J-1);
Ty=ones(1,I+J-1);
aux3=Ty;
aux4=ones(I+J-1,I);
while erro>tol && it<=100000
    for k=1:I+J-1
       for i=1:I
           for h=1:I+J-1
               aux3(h)=phik(h)*g(y(h)/(ZAC(h)*N(i)));
           end
       aux4(k,i)=phiki(k,i)*sum(aux3);
       aux4trans=aux4';
       end
    aux5=(sum(aux4trans)); 
    Ty(k)=In(aux5(k)); 
    end
    erro=max(abs(Ty-y));
    y=Ty;
    it=it+1;
end
yAC=y
%%Exemplo B
clearvars -except ZA ZB yA yB beta w delta u g In yAC lambda I pi u g In N tol ZAC 
J=4;
theta=[.25 .25 .25 .25];
for k=1:J+I-1
    ZBC(k)=exp((lambda-beta)+delta*(k-I));
end
%%Calculando o phi de k, que representa a probabilidade de Z
aux=ones(I,J);
phik=ones(1,J+I-1);
for k=1:J+I-1 
    for i=1:I
        for j=1:J
            if j-i==k-I
            aux(i,j)=theta(j)*pi(i);
            else
            aux(i,j)=0;
            end
    phik(k)=sum(sum(aux));
        end
    end
end
%%Calculando o phi de k e i.
phiki=ones(J+I-1,I);
for i=1:I
    for k=1:J+I-1
        if k-I+i<=J && k-I+i>=1
        phiki(k,i)=pi(i)*theta(i+k-I)/phik(k);
        else
        phiki(k,i)=0;
        end
    end
end
%%Iterando
it=0;
erro=1;
y=ones(1,I+J-1);
Ty=ones(1,I+J-1);
aux3=Ty;
aux4=ones(I+J-1,I);
while erro>tol && it<=100000
    for k=1:I+J-1
       for i=1:I
           for h=1:I+J-1
               aux3(h)=phik(h)*g(y(h)/(ZBC(h)*N(i)));
           end
       aux4(k,i)=phiki(k,i)*sum(aux3);
       aux4trans=aux4';
       end
    aux5=(sum(aux4trans)); 
    Ty(k)=In(aux5(k)); 
    end
    erro=max(abs(Ty-y));
    y=Ty;
    it=it+1;
end
yBC=y

%% Item B
for k=1:3
A(k)=ZA(k)/yA(k);
end
for k=1:5
B(k)=ZB(k)/yB(k);
end
for k=1:3
    AC(k)=ZAC(k)/yAC(k);
end
for k=1:5
    BC(k)=ZBC(k)/yBC(k);
end

subplot(2,2,1);plot(ZA,A);
title('Exemplo A, original')
subplot(2,2,2);plot(ZB,B);
title('Exemplo B, original')
subplot(2,2,3);plot(ZAC,AC);
title('Exemplo A, Lambda=1')
subplot(2,2,4);plot(ZBC,BC);
title('Exemplo B, Lambda=1')


