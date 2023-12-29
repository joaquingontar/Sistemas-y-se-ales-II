% Script: TP3.m
% Author: Federico, Scheytt - Joaquin, Gonzalez Targon
% Date: Noviembre 2023
    
%% ========================================  Problema 2  ======================================== %%
% Se desea digitalizar una se�al de audio anal�gica captada por un micr�fono a partir de una canci�n
% que suena en un recinto a trav�s de un procesador digital de se�ales (DSP). Las especificaciones 
% del DSP indican que no es conveniente utilizar una frecuencia de muestreo superior a fs = 12 kHz.
% Para poder simular la presencia de la se�al de audio anal�gica mediante Simulink, se utilizar� una
% se�al de audio digital de alta calidad. Dicha se�al se encuentra en el archivo musica_tp3.mat.

%% a. Cargue los datos del archivo mediante el comando load('musica_tp3.mat')
      clear, clc, close all
      load('musica_tp3.mat');

%% b. Observe las variables cargadas en el workspace. �Cu�nto m�s grande es la frecuencia de la 
%     se�al que usamos para simular la se�al anal�gica con respecto a la frecuencia m�xima que nos 
%     permite utilizar el DSP?
%
%     fs = 12 kHz
%     fo = 48 kHz
%     fo = 4 * fs
%
%     La frecuencia de la se�al fo (frecuencia que usamos para simular una se�al analogica) es
%     cuatro veces mayor que fs (frecuencia maxima de digitalizacion del DSP).
%
%% c. Escuche la se�al de audio mediante el comando soundsc(Musica.Data,fo,nbits)1. 
%     La reproducci�n puede detenerse ejecutando el comando clear sound.
      clear, clc, close all
      load('musica_tp3.mat');
      
      soundsc(Musica.Data,fo,nbits);

%     Detener la reproduccion
%     clear sound;
    
%% ========================================  Problema 3  ======================================== %%
%% 3.1. Muestreo en crudo
%% a. En Simulink, arme un esquema de filtrado y muestreo b�sicos mediante los bloques From 
%     Workspace, Transfer function y To Workspace. Configure el bloque From Workspace de forma de
%     leer los datos contenidos en la variable Musica.
      clear, clc, close all
      
%     Carga de la se�al de audio
      load('musica_tp3.mat');
      
      input = Musica;
    
%% b. Configure el bloque Transfer Function para que tome los valores de numerador y denominador
%     desde variables en el espacio de trabajo. Defina dichas variables para que la funci�n 
%     transferencia consista simplemente en una ganancia unitaria.
      clear, clc, close all
      
%     Carga de la se�al de audio
      load('musica_tp3.mat');
      
      input = Musica;
      num = 1;
      den = 1;

%     Realizo la simulacion
      sim('TP3');
    
%% c. Configure las opciones del bloque To Workspace de manera que muestree la se�al con una 
%     frecuencia fs = 12 kHz.
      clear, clc, close all
      
%     Carga de la se�al de audio
      load('musica_tp3.mat');
      
      input = Musica;
      fs = 12000;
      num = 1;
      den = 1;  
    
%% d. Simule el sistema y escuche mediante el comando soundsc la se�al filtrada. �Puede utilizarse 
%     este muestreo en crudo para digitalizar la se�al anal�gica? �Escucha algo en la se�al 
%     muestreada que indique que esto no es posible? �A qu� se debe?
      clear, clc, close all
      
%     Carga de la se�al de audio
      load('musica_tp3.mat');
      
      input = Musica;
      fs = 12000;
      num = 1;
      den = 1;
     
%     Realizo la simulacion 
      sim('TP3');
      
      soundsc(output.Data,fs,nbits);
     
%% 3.2. Muestreo inteligente
% Para evitar el fen�meno de aliasing la se�al anal�gica debe filtrarse mediante un filtro 
% antialiasing para ser correctamente muestreada y digitalizada por el DSP.

%% a. Dise�e una plantilla de un filtro antialiasing para minimizar el aliasing generado al 
%     muestrear con una frecuencia fs = 12 kHz. Puede utilizar la funci�n filterTemplate provista 
%     para verificar el dise�o.
      clear, clc, close all   
    
%% 3.2.1. Muestreo inteligente 1. Filtro de Butterworth.
%% a. Dise�ar filtros de Butterworth para minimizar el aliasing para una frecuencia de muestreo de 
%     fs = 12 kHz. Asumir una atenuaci�n m�nima alpha min = 20 dB para una frecuencia de corte de 
%     fa := fs/2. Seleccionar una atenuaci�n m�xima para la banda de paso alpha max y varias 
%     selectividades k = fp/fa
%     Funciones �tiles:  [n,wn] = buttord(wp, wa, alpha max, alpha min,'s')
%                        [num,den] = butter(n,wn,'low','s')
%     Para comprobar que se cumple la plantilla propuesta puede superponer la gr�fica de atenuaci�n 
%     del filtro sobre la plantilla dada por filterTemplate por medio de los comandos: 
%     [H,w]=freqs(num,den), plot(w,-20*log10(abs(H))).
      clear, clc, close all

%     Datos
      fs = 12000;
      fa = fs/2;
      a_min = 20;
      wa = 2*pi*fa;
      
%     Atenuacion maxima y selectividades
      a_max = 1;
      fp = [600 3000 5400];
      k = fp/fa;
      wp = wa*k;
      
%     Filtros de Butterworth
      for i = 1:length(k)
          [N, wn] = buttord(wp(i), wa, a_max, a_min, 's');
          [num, den] = butter(N, wn, 'low', 's');
          [H, w] = freqs(num, den);
          figure(1)
              subplot(1,length(k),i),
              filterTemplate(wp(i), wa, a_max, a_min), hold on, grid on,
              plot(w, -20*log10(abs(H))),
              legend(['k = ',num2str(k(i))],'Location','northwest')
      end    
      
%% b. Graficar amplitud y fase de la respuesta en frecuencia del filtro para las distintas 
%     selectividades seleccionadas en una misma gr�fica.2 Identificar ventajas y desventajas de un 
%     filtro antialiasing con mayor o menor selectividad. �Qu� selectividad resulta la m�s adecuada?
      clear, clc, close all
      
%     Datos
      fs = 12000;
      fa = fs/2;
      a_min = 20;
      wa = 2*pi*fa;
      
%     Atenuacion maxima y selectividades
      a_max = 1;
      fp = [600 3000 5400];
      k = fp/fa;
      wp = wa*k;
      
%     Filtros de Butterworth
      for i = 1:length(k)
          [N, wn] = buttord(wp(i), wa, a_max, a_min, 's');
          [num, den] = butter(N, wn, 'low', 's');
          [H, w] = freqs(num, den);
          figure(1)
              subplot(2,length(k),i),
              plot(w,abs(H)), hold on, grid on,
              title('Amplitud'),
              ylabel('|H(s)|'),
              xlabel('\omega[rad/s]'),
              legend(['k = ',num2str(k(i))])
              
              subplot(2,length(k),i+length(k)),
              plot(w,phase(H)), hold on, grid on,
              title('Fase'),
              ylabel('[rad]'),
              xlabel('\omega[rad/s]'),
              legend(['k = ',num2str(k(i))])
      end        

%% c. Configurar el bloque Transfer Function del modelo Simulink para que implemente alguno de los
%     filtros de Butterworth dise�ados. Simular el sistema de filtrado y muestreo. Escuchar el 
%     resultado y evaluar las diferencias con el muestreo en crudo. En caso de no ser satisfactorio 
%     el resultado, redise�ar el filtro para lograr un mejor resultado.
      clear, clc, close all

      
%     Carga de la se�al de audio
      load('musica_tp3.mat');
          
      input = Musica;

%     Datos
      fs = 12000;
      fa = fs/2;
      a_min = 20;
      wa = 2*pi*fa;
      
%     Atenuacion maxima y selectividades
      a_max = 1;
      fp = 1200;
      k = fp/fa;
      wp = wa*k;
      
%     Filtro de Butterworth
      [N, wn] = buttord(wp, wa, a_max, a_min, 's');
      [num, den] = butter(N, wn, 'low', 's');
      
%     Realizo la simulacion
      sim('TP3');
      
      soundsc(output.Data,fs,nbits);

%% 3.2.2. Muestreo inteligente 2. Filtro de Chebyshev Tipo 1.
%% a. Para los mismos par�metros de atenuaciones y selectividades anteriores, dise�ar filtros de 
%     Chebyshev. Funciones �tiles: 
%     [n,wn] = cheb1ord(wp, wa, alphamax, alpha min,'s')
%     [num,den] = cheby1(n,alpha max, wdp,'low','s')
      clear, clc, close all

%     Datos
      fs = 12000;
      fa = fs/2;
      a_min = 20;
      wa = 2*pi*fa;
      
%     Atenuacion maxima y selectividades
      a_max = 1;
      fp = [600 3000 5400];
      k = fp/fa;
      wp = wa*k;
      
%     Filtros de Chebyshev
      for i = 1:length(k)
          [N, ~] = cheb1ord(wp(i), wa, a_max, a_min, 's');
          [num, den] = cheby1(N, a_max, wp(i), 'low', 's');
          [H, w] = freqs(num, den);
          figure(1)
              subplot(1,length(k),i),
              filterTemplate(wp(i), wa, a_max, a_min), hold on, grid on,
              plot(w, -20*log10(abs(H))),
              legend(['k = ',num2str(k(i))],'Location','northwest')
      end   
    
%% b. Graficar amplitud y fase de la respuesta en frecuencia del filtro para las selectividades 
%     seleccionadas en una misma figura. Comparar el orden y las caracter�sticas de los filtros 
%     obtenidos con lo obtenido para los filtros de Butterworth para cada una de las selectividades. 
%     �Qu� ventajas y desventajas encuentra al comparar ambos filtros?
      clear, clc, close all
   
      %     Datos
      fs = 12000;
      fa = fs/2;
      a_min = 20;
      wa = 2*pi*fa;
      
%     Atenuacion maxima y selectividades
      a_max = 1;
      fp = [600 3000 5400];
      k = fp/fa;
      wp = wa*k;
      
%     Filtros de Chebyshev
      for i = 1:length(k)
          [N, ~] = cheb1ord(wp(i), wa, a_max, a_min, 's');
          [num, den] = cheby1(N, a_max, wp(i), 'low', 's');
          [H, w] = freqs(num, den);
          figure(1)
              subplot(2,length(k),i),
              plot(w,abs(H)), hold on, grid on,
              title('Amplitud'),
              ylabel('|H(s)|'),
              xlabel('\omega[rad/s]'),
              legend(['k = ',num2str(k(i))])
              
              subplot(2,length(k),i+length(k)),
              plot(w,phase(H)), hold on, grid on,
              title('Fase'),
              ylabel('[rad]'),
              xlabel('\omega[rad/s]'),
              legend(['k = ',num2str(k(i))])
      end        

%% c. Simular el sistema de filtrado y muestreo correspondiente. Escuchar el resultado y comparar 
%     con el filtro Butterworth seleccionado anteriormente.
      clear, clc, close all
    
%     Carga de la se�al de audio
      load('musica_tp3.mat');
          
      input = Musica;

%     Datos
      fs = 12000;
      fa = fs/2;
      a_min = 20;
      wa = 2*pi*fa;
      
%     Atenuacion maxima y selectividades
      a_max = 1;
      fp = 2500;
      k = fp/fa;
      wp = wa*k;
      
%     Filtro de Chebyshev
      [N, ~] = cheb1ord(wp, wa, a_max, a_min, 's');
      [num, den] = cheby1(N, a_max, wp, 'low', 's');
      
%     Realizo la simulacion
      sim('TP3');
      
      soundsc(output.Data,fs,nbits);

%% d. �Resulta adecuada la plantilla del filtro antialising dise�ada en el punto 3.2.a. para el 
%     dise�o de filtros de Butterworth y Chebyshev? Justifique.
    

%% ========================================  Problema 4  ======================================== %%
%% 4. Dise�o de un ecualizador b�sico mediante filtros digitales.
% Una vez obtenida la se�al adecuadamente muestreada a la frecuencia fs se desea dividirla en 3 
% bandas: de 0 a 600 Hz, de 600 a 1500 Hz y de 1500 Hz en adelante. Se pide dise�ar entonces el 
% ecualizador b�sico mediante filtros FIR y filtros IIR.

%% 1. Filtros FIR.
%% a. Dise�ar filtros FIR de fase lineal para obtener la separaci�n en bandas deseada empleando
%     ventanas de Hamming. Funciones �tiles: fir1, window.
      clear, clc, close all
      
%     Datos
      fs = 12000;
      fb = 600;
      fa = 1500;

%     Orden del filtro
      n = 500;
      %n = 120;
      %n = 80;

      wpb = 2*pi*fb/fs;
      wpa = 2*pi*fa/fs;

%     Filtro pasa bajos 0-600 Hz
      PB = fir1(n,wpb,'low',hamming(n+1));
      [Hpb,Wpb] = freqz(PB);
      
      figure (1)
          plot(Wpb,abs(Hpb)), grid on
          title('Filtro pasa bajo'),
          ylabel('|H(\omega)|'),
          xlabel('\omega[rad/s]')

%     Filtro pasa banda 600-1500 Hz
      PBn = fir1(n,[wpb,wpa],'bandpass',hamming(n+1));
      [Hpbn,Wpbn] = freqz(PBn);
      
      figure(2)
          plot(Wpbn,abs(Hpbn)), grid on
          title('Filtro pasa banda'),
          ylabel('|H(\omega)|'),
          xlabel('\omega[rad/s]')

%     Filtro pasa altos +1500 Hz
      PA = fir1(n,wpa,'high',hamming(n+1));
      [Hpa,Wpa] = freqz(PA);
      
      figure(3)
          plot(Wpa,abs(Hpa)), grid on
          title('Filtro pasa alto'),
          ylabel('|H(\omega)|'),
          xlabel('\omega[rad/s]')
    
%% b. Graficar las respuestas en frecuencia de los filtros dise�ados. Funciones �tiles: fvtool, 
%     freqz.
      clear, clc, close all
    
%     Datos
      fs = 12000;
      fb = 600;
      fa = 1500;

%     Orden del filtro
      n = 500;

      wpb = 2*pi*fb/fs;
      wpa = 2*pi*fa/fs;

%     Filtro pasa bajos 0-600 Hz
      PB = fir1(n,wpb,'low',hamming(n+1));
      fvtool(PB, 1);

%     Filtro pasa banda 600-1500 Hz
      PBn = fir1(n,[wpb,wpa],'bandpass',hamming(n+1));
      fvtool(PBn, 1);
    
%     Filtro pasa altos +1500 Hz
      PA = fir1(n,wpa,'high',hamming(n+1));
      fvtool(PA, 1);
      
%% c. Filtrar la se�al de audio mediante cada uno de los filtros dise�ados. Escuchar las se�ales
%     resultantes. Funciones �tiles: filter.
      clear, clc, close all
      
%     Carga de la se�al de audio
      load('musica_tp3.mat');
         
%     Datos
      fs = 12000;
      fb = 600;
      fa = 1500;

%     Orden del filtro
      n = 500;

      wpb = 2*pi*fb/fs;
      wpa = 2*pi*fa/fs;

%     Filtros
      PB = fir1(n,wpb,'low',hamming(n+1));
      PBn = fir1(n,[wpb,wpa],'bandpass',hamming(n+1));
      PA = fir1(n,wpa,'high',hamming(n+1));
      
%     Simulacion
      input = Musica;
      num = 1;
      den = 1;
      sim('TP3');
      
      bajos_filtrados = filter(PB,1,output.Data);
      medios_filtrados = filter(PBn,1,output.Data);
      altos_filtrados = filter(PA,1,output.Data);

      soundsc(bajos_filtrados,fs,nbits);

%% d. Evaluar los efectos del empleo de distintas ventanas y distintos �rdenes del filtro.
      clear, clc, close all
    
    
    
    
%% 2. Filtros IIR.
%% a. Dise�ar filtros IIR para obtener la separaci�n en bandas deseada, mediante el dise�o ded
%     filtros anal�gicos y aplicaci�n de la transformaci�n bilineal3.
      clear, clc, close all
      
      ordeniir=15;

      [Npasabajoiir,Dpasabajoiir]=butter(ordeniir,2*pi*600/11025,'low');
      [Npasabandaiir,Dpasabandaiir]=butter(ordeniir,[2*pi*600/11025 2*pi*1500/11025],'bandpass');
      [Npasaaltoiir,Dpasaaltoiir]=butter(ordeniir,2*pi*1500/11025,'high');

      freqz(Npasabajoiir,Dpasabajoiir)
      hold on
      freqz(Npasabandaiir,Dpasabandaiir)
      hold on
      freqz(Npasaaltoiir,Dpasaaltoiir)
    

%% b. Filtrar la se�al de audio mediante cada uno de los filtros dise�ados y escuchar las se�ales
%     resultantes.
      clear, clc, close all
    
    