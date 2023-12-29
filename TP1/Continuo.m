% Autor: Gonzalez Targon, Joaquin
% Legajo: G-5767/3
% Año: 2023
%% ======================Trabajo previo==================================
%% 3) Parametros obtenidos
%solve para resolver sistema de ecuaciones
clear, close all, clc;
J=15;b= 1.1;L=0.00279;K=6.69;R=0.051;
%% 4) Diagrama de Bloques del Motor
clear, close all, clc;
J=15;b= 1.1;L=0.00279;K=6.69;R=0.051;
figure(1)
U=440; T=0; ici=0; wci=0;
sim('Motor') %Corre simulink
plot(w.time,w.data,'b')
title('Velocidad angular del motor');grid on
xlabel('Tiempo [seg]')
ylabel('w(t) [rad/seg]')

%% 5) Diagrama de Bloques del Controlador
clear, close all, clc;
%parametros
J=15;b= 1.1;L=0.00279;K=6.69;R=0.051;
r=440; T=0; ici=0; wci=0;
sim('Controlador')
figure(2)
plot(w.time,w.data,'b')
title('Velocidad angular del motor con controlador');grid on
xlabel('Tiempo [seg]')
ylabel('w(t) [rad/seg]')

%% ===============modelo interno y modelo externo=========================

clear, close all, clc;
%parametros
J=15;b= 1.1;L=0.00279;K=6.69;R=0.051;

% a) DB->EE
sim('Motor_a')
[A,B,C,D]=linmod('Motor_a')

% b) EE->FT
[NUM,DEN]=ss2tf(A,B,C,D)
G=tf(NUM,DEN)

% c) Autovalores y autovectores de A
[V,D]=eig(A)
polos=pole(G)

%% =================Respuesta temporal y retrato de fase===================

%% a) Calcular la evolucion con U=440 (no simulink)
clear, close all, clc;
%parametros
J=15;b= 1.1;L=0.00279;K=6.69;R=0.051;

%Obtengo funcion transferencia a partir del diagra de bloques
sim('Motor_a')
[A,B,C,D]=linmod('Motor_a')
[NUM,DEN]=ss2tf(A,B,C,D)
G=tf(NUM,DEN)

%Grafica respuesta al escalon
[Y,T]=step(G*440);
figure (3)
plot(T,Y), grid on, hold on
title('Velocidad angular del motor');grid on
xlabel('Tiempo [seg]')
ylabel('w(t) [rad/seg]')

%% b) simulacion Motor con U=440 y T=0
clear, close all, clc;
%parametros
J=15;b= 1.1;L=0.00279;K=6.69;R=0.051;
U=440; T=0; ici=0; wci=0;

sim('Motor');
figure (4)
plot(w.time,w.data,'b')
title('Velocidad angular del motor');grid on
xlabel('Tiempo [seg]')
ylabel('w(t) [rad/seg]')

%% c) Grafica de w(t) vs i(t) de Motor con U=440 y T=0
clear, close all, clc;
%parametros
J=15;b= 1.1;L=0.00279;K=6.69;R=0.051;
U=440; T=0; ici=0; wci=0;

sim('Motor');
figure (5)
plot(w.data,i.data), grid on, hold on
title('Grafica w(t) vs i(t)');
xlabel ('w(t)');
ylabel ('i(t)');

%% d) Simulacion motor con T(t)=5000 y U(t)=0
clear, close all, clc;
%parametros
J=15;b= 1.1;L=0.00279;K=6.69;R=0.051;
U=0; T=5000; ici=0; wci=0;

sim('Motor');
figure (6)
plot(w.data,i.data), grid on, hold on
title('Grafica w(t) vs i(t)');
xlabel ('w(t)');
ylabel ('i(t)');

%% e) Simulacion Motor con U=0 y T=0, CI: w(0)=65 y i(0)=10
clear, close all, clc;
%parametros
J=15;b= 1.1;L=0.00279;K=6.69;R=0.051;
U=0; T=0; ici=10; wci=65;

sim('Motor');
plot(w.data,i.data,'b'), grid on, hold on

U=440; T=0; ici=0; wci=0;
sim('Motor');
plot(w.data,i.data,'r'), grid on, hold on

U=0; T=5000; ici=0; wci=0;
sim('Motor');
plot(w.data,i.data,'g'), grid on, hold on

%% f) Retrato de fase 3D
clear, close all, clc;
%parametros
J=15;b= 1.1;L=0.00279;K=6.69;R=0.051;
wci=65; ici=10; tf=1; n=12;

sim('Motor_a');
[A,B,C,D]=linmod('Motor_a');
x=[wci;ici];
retrato3d(A,x,tf,n)

%% G) Transformar la matriz A para plano modal
%transformo linealmente los ejes para llevarlo a los ejes coordenados de
%forma de que me queden unicamente componentes reales
clear, close all, clc;
%parametros
%parametros
J=15;b= 1.1;L=0.00279;K=6.69;R=0.051;
wci=65; ici=10; tf=1; n=12;

sim('Motor_a');
[A,B,C,D]=linmod('Motor_a')
[V,D]=eig(A)
V1=V(:,1)

%Modifico la matriz A
U = [real(V1),imag(V1)]

%retrato
x=[wci;ici];
retrato3d(U\A*U,inv(U)*x,tf,n)

%Coinciden los ejes=> plano modal

%% ==============Realimentacion y polos dominantes========================

%% FT->W
close all, clear, clc
%parametros
J=15;b= 1.1;L=0.00279;K=6.69;R=0.051;

sim('Controlador2')
[A,B,C,D]=linmod('Controlador2')
[NUM,DEN]=ss2tf(A,B,C,D)
G=tf(NUM,DEN)

G1=feedback(G,1)
polos=pole(G1)

%% Grafica controlador
close all, clear, clc
J=15;b= 1.1; L=0.00279; K=6.69;R=0.051;
r=60; T=0;
sim('Controlador')
plot(w.time,w.data,'b'), grid on, hold on

