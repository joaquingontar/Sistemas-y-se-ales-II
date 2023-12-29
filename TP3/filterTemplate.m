function filterTemplate(wp,wa,aMax,aMin,varargin)
% filterTemplate - Grafica la plantilla de atenuacion del filtro especificado
% 
% filterTemplate(wp,wa,aMax,aMin) 
%   Grafica la plantilla de un filtro pasa bajo con frecuencia de paso 
%   wp (rad/s), frecuencia de atenuacion wa (rad/s) y atenuaciones maxima 
%   y minima aMax y aMin (dB), respectivamente.   
%   Si wp y wa son vectores de dos elementos, filterTemplate grafica la 
%   plantilla de un filtro pasa banda.
%
% filterTemplate(wp,wa,aMax,aMin,ftype)
%   Grafica la plantilla de un filtro pasa bajo, pasa alto, pasa banda 
%   o rechaza banda, dependiendo del valor de ftype.
%
%   ftype debe tomar uno de los siguientes valores:
%     - 'low' para un filtro pasa bajo. 'low' es el valor predeterminado 
%       cuando wp y wa son escalares.
%     - 'high' para un filtro pasa alto.
%     - 'bandpass' para un filtro pasa banda. 'bandpass' es el valor por 
%       defecto cuando wp y wa tienen dos elementos.
%     - 'stop' para un filtro rechaza banda. 
%
%   Los diseños pasa banda y rechazabanda banda requieren que wp y wa
%   tengan dos elementos.
%   
%  % Ejemplo 1:
%  %  Graficar la plantilla de atenuacion de un filtro pasa alto con 
%  %  frecuencia de paso de 300Hz, frecuencia de atenuacion de 100Hz, 
%  %  atenuacion maxima de 1dB y atenuacion minima de 20dB.
%
%  filterTemplate(2*pi*300,2*pi*100,1,20,'high');
%
%  % Ejemplo 2:
%  %  Graficar la plantilla de atenuacion de un filtro pasa banda con 
%  %  frecuencias de paso de 500Hz y 1000Hz, frecuencias de atenuacion 
%  %  de 100Hz y 1500Hz, atenuacion maxima de 1dB y atenuacion minima 
%  %  de 20dB.
%
%  filterTemplate(2*pi*[500,1000],2*pi*[100,1500],1,20);
%
% Sistemas y Señales II - Departamento de Control - FCEIA - UNR - 2023

% Check Inputs
Results = validateInputs(wp,wa,aMax,aMin,varargin);

% Dibuja la plantilla segun tipo de filtro
switch Results.ftype
    case 'low'
        stylizedRectangle([0 aMax wp aMin+aMax*2]);
        stylizedRectangle([wa 0 wa+wp aMin]);
           
        title('Plantilla de Atenuación Filtro Pasa bajos');
        ylabel({'\alpha(\omega)[dB]',' ', ' '})
        xlabel({' ','\omega[rad/s]'})
                
        axis([0 wa+wp 0 aMin+2])
        
        text(wp,-2,'\omega_p','HorizontalAlignment','left')
        text(wa,-2,'\omega_a','HorizontalAlignment','left')
        text(0,aMin,'\alpha_{min}      ','HorizontalAlignment','right')
        text(0,aMax,'\alpha_{max}      ','HorizontalAlignment','right')
    
    case 'high'
        stylizedRectangle([0 0 wa aMin]);
        stylizedRectangle([wp aMax wa+wp aMin+aMax*2]);
        
        title('Plantilla de Atenuación Filtro Pasa altos');
        ylabel({'\alpha(\omega)[dB]',' ', ' '})
        xlabel({' ','\omega[rad/s]'})
        
        axis([0 wa+wp 0 aMin+aMax*1.9])
        
        text(wp,-2,'\omega_p','HorizontalAlignment','left')
        text(wa,-2,'\omega_a','HorizontalAlignment','left')
        text(0,aMin,'\alpha_{min}      ','HorizontalAlignment','right')
        text(0,aMax,'\alpha_{max}      ','HorizontalAlignment','right')
    
    case 'bandpass'          
        stylizedRectangle([0 0 wa(1) aMin]);
        stylizedRectangle([wp(1) aMax wp(2)-wp(1) aMin+aMax*2]);
        stylizedRectangle([wa(2) 0 wa(2)+wa(1) aMin]);
    
        title('Plantilla de Atenuación Filtro Pasa banda');
        ylabel({'\alpha(\omega)[dB]',' ', ' '})
        xlabel({' ','\omega[rad/s]'})
        
        axis([0 wa(2)+wa(1) 0 aMin+aMax*1.9])
        
        text(wa(1),-2,'\omega_{a1}')
        text(wa(2),-2,'\omega_{a2}')
        text(wp(1),-2,'\omega_{p1}')
        text(wp(2),-2,'\omega_{p2}')
        text(0,aMin,'\alpha_{min}      ','HorizontalAlignment','right')
        text(0,aMax,'\alpha_{max}      ','HorizontalAlignment','right')

    case 'stop'
        stylizedRectangle([0 aMax wp(1) aMin+aMax*2]);
        stylizedRectangle([wa(1) 0 wa(2)-wa(1) aMin]);
        stylizedRectangle([wp(2) aMax wa(1)+wa(2) aMin+aMax*2]);
    
        title('Plantilla de Atenuación Filtro Rechaza banda');
        ylabel({'\alpha(\omega)[dB]',' ', ' '})
        xlabel({' ','\omega[rad/s]'})
        
        axis([0 wp(2)+wp(1) 0 aMin+aMax*1.9])
        
        text(wa(1),-2,'\omega_{a1}')
        text(wa(2),-2,'\omega_{a2}')
        text(wp(1),-2,'\omega_{p1}')
        text(wp(2),-2,'\omega_{p2}')
        text(0,aMin,'\alpha_{min}      ','HorizontalAlignment','right')
        text(0,aMax,'\alpha_{max}      ','HorizontalAlignment','right')
end

end % end of filterTemplate


%% Funciones auxiliares

%% Valida los valores de entrada
function stylizedRectangle(position)
rectangle('Position',position,...
          'FaceColor',[.75 .75 .75],...
          'EdgeColor','k',...
          'LineWidth',0.5);
end

%% Valida los valores de entrada
function results = validateInputs(wp,wa,aMax,aMin,extraInputs)

% Default and expected Inputs
defaultFtype = 'default';
expectedFtype  = {'low','high','bandpass','stop'};

% Validation functions
validAttenuation = @(x) isnumeric(x) && isscalar(x) && (x>0);
validFrequency = @(x) isnumeric(x) && ...
            (   (isequal(size(x),[1,2]) && (x(1,1)<x(1,2)))...
              || isequal(size(x),[1,1]) );
validFilter = @(x) any(validatestring(x,expectedFtype));

% Input Parser
p = inputParser;

addRequired(p,'wp',validFrequency);
addRequired(p,'wa',validFrequency);
addRequired(p,'aMax',validAttenuation);
addRequired(p,'aMin',validAttenuation);
addOptional(p,'ftype',defaultFtype,validFilter);

parse(p,wp,wa,aMax,aMin,extraInputs{:});
results = p.Results;

% Check frequency sizes
if length(wp) ~= length(wa)
    error('Se epera que wp y wa tengan iguales dimensiones')
end

% Check if ftype is set by default
if isequal(results.ftype, defaultFtype)
    switch length(wp)
        case 1
            results.ftype = 'low';
        case 2
            results.ftype = 'bandpass';
    end
end

% Check frequency relation
switch results.ftype
    case 'low'
        if length(wp) > 1
            error('Se espera un valores únicos de wp y wa para plantillas de filtros pasa bajo')
        end
        if not(wp<wa)
            error('Debe ser wp<wa para plantillas de filtros pasa bajo')
        end
    case 'high'
        if length(wp) > 1
            error('Se espera un valores únicos de wp y wa para plantillas de filtros pasa alto')
        end
        if not(wp>wa)
            error('Debe ser wp>wa para plantillas de filtros pasa alto')
        end
    case 'bandpass'
        if length(wp) < 2
            error('Se espera que wp y wa sean vectores de dos componentes para plantillas de filtros pasa banda')
        end
        if not(wa(1)<wp(1) && wp(1)<wp(2) && wp(2)<wa(2))    
            error('Debe ser wa1<wp1<wp2<wa2 para plantillas de filtros pasabanda')
        end
    case 'stop'
        if length(wp) < 2
            error('Se espera que wp y wa sean vectores de dos componentes para plantillas de filtros rechaza banda')
        end
        if not(wp(1)<wa(1) && wa(1)<wa(2) && wa(2)<wp(2))  
            error('Debe ser wp1<wa1<wa2<wp2 para plantillas de filtros rechazabanda')
        end
end

end
