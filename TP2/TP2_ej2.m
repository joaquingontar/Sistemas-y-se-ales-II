% Autor: Gonzalez Targon, Joaquin
% Legajo: G-5767/3
% Año: 2023

% 2) Control a lazo abierto del motor de corriente continua
%% 2.1) Caracteristicas de la respuesta al escalon de Gp
close all, clear, clc
nump=[400];
denp=[1,20,200];
Gp=tf(nump,denp)
[wn,e,P]=damp(Gp);
wn=wn(1)
e=e(1)

% ganancia estatica
K=dcgain(Gp)
% Tiempo de respuesta al 1%
tr1=-log(0.01)/(sqrt(200)*sqrt(2)/2)
% Periodo de oscilacion
wa=sqrt(200)*sqrt(1-(sqrt(2)/2)^2)
% sobrevalor
sv=exp((-pi*sqrt(2)/2)/sqrt(1-(sqrt(2)/2)^2))

%% 2.2) Grafica de la respuesta al escalon
clear,close all, clc
nump=[400];
denp=[1,20,200];
Gp=tf(nump,denp)

% Grafica de respuesta al escalon
figure(1)
step(Gp)
title('Respuesta al escalon unitario');

%% 2.3) Kp ganancia unitaria
clear,close all, clc
nump=[400];
denp=[1,20,200];
Gp=tf(nump,denp);
Kp=2;
Gp=Gp*(1/Kp)
dcgain(Gp)
step(Gp), grid on, hold on;
title ('Respuesta al escalon con 1/Kp')

%% 2.4) Rango de la ganancia cuando a0 varía un 10% y comparacion con el anterior
clear, close all, clc
Kp=2;
nump=(1/Kp)*[400];
% +10%
denp1=[1,20,220];
Gp1=tf(nump,denp1);
figure(1)
step(Gp1); hold on, grid on

% -10%
denp2=[1,20,180];
Gp2=tf(nump,denp2);hold on, grid on
figure(1)
step(Gp2);

% sin variacion-> a0=200
denp=[1,20,200];
Gp=tf(nump,denp);hold on, grid on
figure(1)
step(Gp);

%Ganancia +10%
G0min=dcgain(Gp1)
%Ganancia -10%
G0max=dcgain(Gp2)
