% Autor: Gonzalez Targon, Joaquin
% Legajo: G-5767/3
% Año: 2023
%% Planos modales y originales
clear,close all, clc
A=[-0.25,0.25;0.25,-0.125];
xinicial=[3;3];
tfinal=15;
varargin=5;

%% plano modal de autovalores reales
[V,D]=eig(A)
V1=V(:,1)
V2=V(:,2)
U = [V1,V2];
retrato3d(U\A*U,inv(U)*xinicial,tfinal,varargin)



%% plano modal de autovalores complejos conjugados
[V,D]=eig(A)
V1=V(:,1)

%Modifico la matriz A
U = [real(V1),imag(V1)];

%retrato
retrato3d(U\A*U,inv(U)*xinicial,tfinal,varargin)
