% Autor: Gonzalez Targon, Joaquin
% Legajo: G-5767/3
% Año: 2023

% Control por realimentacion con sensor de velocidad y filtro
%% 4.1) FT de controlador con filto Gs
clear, close all, clc

nums=[100];
dens=[1,100];
Gs=tf(nums,dens)

nump=[200];
denp=[1,20,200];
Gp=tf(nump,denp)

K=12.0;
% Para valores de -1<K<13 el sistema es estable
% En el item 4.4 obtengo que el margen exacto es Mg=21.7dB que se da para
% K=12.16
Glc=feedback(K*Gp,Gs)
step(Glc);
title('Respuesta al escalon lazo cerrado')
polos=pole(Glc)

%% 4.2) Lugar de las raices
clear, close all, clc
nums=[100];
dens=[1,100];
Gs=tf(nums,dens)

Kp=2;
nump=(1/Kp)*[400];
denp=[1,20,200];
Gp=tf(nump,denp)

K=11;
% Se ingresa en rlocus el lazo abierto sin poner el controlador K
rlocus(Gp*Gs)
[K,polos]=rlocfind(Gp*Gs)

%Fijarse que el punto de cruce es aproximadamente en K=13 en la grafica,
%pero analiticamente me da que que los puntos de cruce estan en -1 y 1.2

%% 4.3) 

%% 4.4) Diagrama de Bode y Nyqust de G=Gp*Gs
clear, close all, clc

nums=[100];
dens=[1,100];
Gs=tf(nums,dens)

Kp=2;
nump=(1/Kp)*[400];
denp=[1,20,200];
Gp=tf(nump,denp)

G=Gp*Gs

%graficas
figure(1);
bode(Gp), grid on, hold on
title('Bode')
figure(2);
nyquist(Gp), hold on
title('Nyquist')

figure(1);
bode(G)
legend('Gp','G=Gp*Gs')
figure(2);
nyquist(G)
legend('Gp','G=Gp*Gs')

% Se puede ver que a diferencia de Gp, el nyquist de G puede encerrar dos veces
% al punto critico -1, el margen de ganancia es Mg=21.7 y se da para K=12.16
% En el Nyquist de Gp por mas que aumente la ganancia K, el punto en W=0 se
% mantiene fijo y nunca llegara a englobar al punto critico -1

