% Autor: Gonzalez Targon, Joaquin
% Legajo: G-5767/3
% Año: 2023

% Estrategia basica de control por realimentacion del MCC

%% 3.2) Calculo de ganancia entre 0.95 y 1.05
clear, close all, clc
Glc0=[0.95; 1.05]
%Las siguientes formulas se desarrollaron en la hoja
K1=(Glc0(1))/(1-(Glc0(1)))
K2=(Glc0(2))/(1-(Glc0(2)))

%Para K>19 la ganancia es mayor a 0,95 (que es lo que se pide) y mientras
%mas grande es el valor la ganancia tiende a 1
%Para K<0 el sistema es inestable

%% 3.2) Grafica de lazo cerrado
clear, close all, clc
nump=[400];
denp=[1,20,200];
Gp=tf(nump,denp)
%configurar controlador teniendo en cuenta que la ganciancia minima deseada
%es G(0)=0,95 y esto se da para K=19
K=19;
Glc=feedback(K*Gp,1)
step(Glc);
title('respuesta al escalon lazo cerrado')
ganancia=dcgain(Glc)
polos=pole(Glc)

%% 3.3) Lazo de realimentacion con K=19, comparacion con lazo abierto
clear, close all, clc

%Grafica lazo abierto
Kp=2;
nump=(1/Kp)*[400];
denp=[1,20,200];
Gp=tf(nump,denp)
figure(1)
step(Gp), hold on, grid on
title('Comparacion LA y LC');

% Grafica lazo cerrado
Kp=2;
nump=(1/Kp)*[400];
denp=[1,20,200];
Gp=tf(nump,denp)

K=19;
Glc=feedback(K*Gp,1)
ganancia=dcgain(Glc)
figure(1)
step(Glc), hold on, grid on
legend('LA','LC')

%% 3.4) Grafica lazo cerrado para a0 max y min, comparacion con item 3.3
nump=[200];
%Notar que para valores de K negativos el sistema es inestable
K=19;
% a0 -> +10%
denp1=[1,20,220];
Gp1=tf(nump,denp1);
Glc1=feedback(Gp1*K,1)
step(Glc1); hold on, grid on
title('comparacion con variaciones de a0')

% a0 -> -10%
denp2=[1,20,180];
Gp2=tf(nump,denp2)
Glc2=feedback(Gp2*K,1)
step(Glc2) , hold on, grid on

% a0=200
denp=[1,20,200];
Gp=tf(nump,denp)
Glc=feedback(Gp*K,1)
step(Glc), hold on, grid on

legend('LA a0=220','LA a0=180','LC')

%% 3.5) Grafico de lugar de las raices para el lazo cerrado
clear, close all, clc

%Se abre el lugar geometrico de las raices, elegimos un valor y nos muestra
%donde se encuentran los polos
nump=[200];
denp=[1,20,200];
Gp=tf(nump,denp)

%Buscar K y polos en la grafica
rlocus(Gp);
title('Lugar geometrico de las raices')

%% 3.6) Diagrama de Bode y Nyquist de Gp
clear, close all, clc
nump=[200];
denp=[1,20,200];
Gp=tf(nump,denp)

%graficas
figure(1);
bode(Gp), grid on, hold on
title('Bode de Lazo abierto')
figure(2);
nyquist(Gp), hold on
title('Nyquist de Lazo abierto')

%Margenes de estabilidad y sus frecuencias
[Mg,Mf,Wg,Wf]=margin(Gp)

%% 3.7) Bode y Nyquist de GLA=K*Gp, margenes de ganancia y fase.
clear, close all, clc
K=19;

%Lazo abierto
num=[200];
den=[1,20,200];
Gla=tf(num,den)
figure(1)
bode(Gla), hold on, grid on
title('Bode de Lazo abierto')
figure(2)
nyquist(Gla), hold on
title('Nyquist de Lazo abierto')


%Lazo cerrado
% Glc=feedback(Gla*K,1)
% figure(3)
% bode(Glc), hold on, grid on
% title('Bode de Lazo cerrado')
% figure(4)
% nyquist(Glc), hold on
% title('Nyquist de Lazo cerrado')

%Margenes de estabilidad y sus frecuencias
[Mga,Mfa,Wga,Wfa]=margin(Gla)
%[Mgc,Mfc,Wgc,Wfc]=margin(Glc)

%% 3.7) Superposicion de ambos diagramas
clear, close all, clc
%Lazo abierto
nump=[200];
denp=[1,20,200];
Gp=tf(nump,denp)
K=19;

% Gp
figure(1);
bode(Gp), grid on, hold on
title('Superposicion de Bode')
figure(2);
nyquist(Gp), hold on
title('Superposicion de Nyquist') 

% Gla=Gp*K
figure(1);
bode(K*Gp), grid on, hold on
title('Superposicion de Bode')
figure(2);
nyquist(K*Gp), hold on
title('Superposicion de Nyquist')
legend('Gp','K*Gp')

%Lazo cerrado
% K=19;
% Glc=feedback(Gp*K,1)
% figure(1)
% bode(Glc), hold on, grid on
% legend('LA','LC')
% figure(2)
% nyquist(Glc), hold on


