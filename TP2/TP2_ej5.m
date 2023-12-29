% Autor: Gonzalez Targon, Joaquin
% Legajo: G-5767/3
% Año: 2023

% Control proporcional-integral de la velocidad
%% 5.1) Lugar de la raices, variando Kp
clear, close all, clc

nums=[100];
dens=[1,100];
Gs=tf(nums,dens)

nump=[200];
denp=[1,20,200];
Gp=tf(nump,denp)

Tr=0.1;
numc=[Tr,1];
denc=[Tr,0];
C=tf(numc,denc)

Gla=C*Gp*Gs
rlocus(Gla)

% Se observa que para Kp=0 el sistema es inestable, al aumentarlo empieza a
% ser estable hasta un determinado valor de K en el cual vuelve a ser
% inestable. Este valor de K puede obtenerlo con el diagrama de Nyquist

%% 5.2) Deteminar 3 valores de Kp donde el sistema es estable y se cumple...
% 1- Hay un polo dominante
% 2- Hay un par de polos complejos conjugados dominantes
% 3- Tres polos dominantes con parte real similar
clear, close all, clc

nums=[100];
dens=[1,100];
Gs=tf(nums,dens)

nump=[200];
denp=[1,20,200];
Gp=tf(nump,denp)

Tr=0.1;
numc=[Tr,1];
denc=[Tr,0];
C=tf(numc,denc)

Gla=C*Gp*Gs
rlocus(Gla)

%Buscar en diagrama LR
[Kp,polos1]=rlocfind(Gla)

% Grafica de las 3 respuesta escalon

Glc=feedback(Kp*C*Gp,Gs)
step(Glc)
polos=pole(Glc)

%% 3.5) Diagramas de Bode y Nyquist con Kp=1 de Gla=C*Gp*Gs
clear, close all, clc
Kp=1
nums=[100];
dens=[1,100];
Gs=tf(nums,dens)

nump=[200];
denp=[1,20,200];
Gp=tf(nump,denp)

Tr=0.1;
numc=[Tr,1];
denc=[Tr,0];
C=tf(numc,denc)

Gla=Kp*C*Gp*Gs

figure(1)
bode(Gla), grid on, hold on
title('bode GLA')
figure(2)
nyquist(Gla)
title('nyquist GLA')

[Mg,Mf,Wg,Wf]=margin(Gla)

