% Autor: Gonzalez Targon, Joaquin
% Legajo: G-5767/3
% Año: 2023
%% 1) Funcion tranferencia discreta (FTD)

%parametros
a=0.93;
w0=2*pi/20;
b0=((65/440))*(1-2*a*cos(w0)+a^2)-(3/440);
b1=3/440;
b2=0;
a2=1;
a1=-2*a*cos(w0);
a0=a^2;

%funcion transferencia
num=[b2,b1,b0];
den=[a2,a1,a0];
G=tf(num,den,0.01)
[y,x]=step(440*G);
stem(x,y), hold on, grid on
title('Evolucion wk para Ts=0,01s')
xlabel('Tiempo [seg]')
ylabel('Wk [rad/seg]')

% FTD -> EED

% x'= Ax + Bu
% y = Cx + Du
[A,B,C,D]=tf2ss(num,den)
autvalores=eig(A)

%Polos y ceros
polos=pole(G)
ceros=zero(G)

%% 3) 
% parametros
J=15; b= 1.1; L=0.00279; K=6.69; R=0.051;
sim('MotorMuestreado')
figure (1)
stem(md.time,md.data)
title('Esquema de motor muestreado')
xlabel('Tiempo [seg]')
ylabel('Wk [rad/seg]')
