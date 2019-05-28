function [ SLMsectNumber, SLMsect, SLMpos, SLMind ] = SLM_positions_px( SLM )
%   detectPosition.m : Définition des positions et des sections de capture
%   des détecteurs
%
%   Paramètres d'entrée :
%       * nbDetect : nombre de détecteurs (maille carrée)
%       * pitchDetect : espacement entre les détecteurs [m]
%       * detect.taille : taille d'un détecteur [m]
%       * detect.planz : sous-structure associée à chaque plan de détection
%       * CP.NB : nombre total de faisceaux en champ proche
%       * CP.lambda : longueur d'onde du rayonnement [m]
%       * CP.pitch : pas du réseau [m]
%       * CP.w0 : rayon à 1/e² en intensité d'un faisceau gaussien en champ proche [m]
%       * CP.DLens : diamètre d'une lentille de collimation du champ proche [m]
%       * CP.maille : type d'arrangement de la maille du réseau
%       * CP.faisc : structure de taille NBx1 contenant les faisceaux du champ proche
%       * CP.posFaisc : structure de taille NBx2 contenant les coordonnées
%       des centres des faisceaux du champ proche vis à vis de la grille 
%       x,y [m]
%       * grid : grilles spatiales après meshgrid [m, rad/m]
%
%   Paramètres de sortie :
%       * PDsect : indices des sections des photodiodes (cellule)
%       * PDpos : structure de taille Mx2 contenant les coordonnées
%       des centres des faisceaux du champ proche vis à vis de la grille
%       x,y [m]

    %%% Positions des centres des plots de phase
    if mod(sqrt(SLM.beamNumber),1)~=0
        error('Veuillez entrer un nombre de faisceaux valable (4, 9, 16, 25, 36, 49, 64, 81, 100, ...) !')
    else
        
    SLMpos.x = nan(sqrt(SLM.beamNumber),1) ; % Coordonnée x
    SLMpos.y = nan(sqrt(SLM.beamNumber),1) ; % Coordonnée y
    for i=1:sqrt(SLM.beamNumber)
        SLMpos.x(i,1:sqrt(SLM.beamNumber)) = (-(sqrt(SLM.beamNumber)-1)/2+(0:(sqrt(SLM.beamNumber)-1)))*SLM.beamPitch ;
        SLMpos.y(1:sqrt(SLM.beamNumber),i) = (-(sqrt(SLM.beamNumber)-1)/2+(0:(sqrt(SLM.beamNumber)-1)))*SLM.beamPitch ;
    end

    SLMclusterpos.x = nan(sqrt(SLM.cluster.number),1) ; % Coordonnée x
    SLMclusterpos.y = nan(sqrt(SLM.cluster.number),1) ; % Coordonnée y
    for i=1:sqrt(SLM.cluster.number)
        SLMclusterpos.x(i,1:sqrt(SLM.cluster.number)) = (-(sqrt(SLM.cluster.number)-1)/2+(0:(sqrt(SLM.cluster.number)-1)))*SLM.cluster.pitch ;
        SLMclusterpos.y(1:sqrt(SLM.cluster.number),i) = (-(sqrt(SLM.cluster.number)-1)/2+(0:(sqrt(SLM.cluster.number)-1)))*SLM.cluster.pitch ;
    end

    %%% Reshaping
    SLMpos.x = reshape(SLMpos.x,[numel(SLMpos.x) 1]) ;
    SLMpos.y = reshape(SLMpos.y,[numel(SLMpos.y) 1]) ;
    SLMclusterpos.x = reshape(SLMclusterpos.x,[numel(SLMclusterpos.x) 1]) ;
    SLMclusterpos.y = reshape(SLMclusterpos.y,[numel(SLMclusterpos.y) 1]) ;

    %%% Combining
    tmp.x = nan(length(SLMpos.x),length(SLMclusterpos.x)) ;
    tmp.y = nan(length(SLMpos.x),length(SLMclusterpos.x)) ;
    for i=1:length(SLMpos.x)
        for j=1:length(SLMclusterpos.x)
            tmp.x(i,j) = SLMpos.x(i) + SLMclusterpos.x(j) ;
            tmp.y(i,j) = SLMpos.y(i) + SLMclusterpos.y(j) ;
        end
    end
    SLMpos.x = reshape(tmp.x,[numel(tmp.x) 1]) ;
    SLMpos.y = reshape(tmp.y,[numel(tmp.y) 1]) ;
    
    tmp = sortrows([SLMpos.x SLMpos.y],2,'ascend') ;
    
    SLMpos.x = tmp(:,1) ;
    SLMpos.y = tmp(:,2) ;
    
    SLMsectNumber = length(SLMpos.x) ;
    
    %%% Indices des centres des détecteurs, à l'échantillon le plus proche
    for i=1:length(SLMpos.x)%SLM.beamNumber
        [~,SLMind.col(i)] = min(min(abs(SLM.grid.y'-SLMpos.x(i)))) ;
        [~,SLMind.lin(i)] = min(min(abs(SLM.grid.x'-SLMpos.y(i)))) ;
    end
    
    %%% Sections des détecteurs
    SLMsect = cell(length(SLMsectNumber),1) ;
    for k=1:SLMsectNumber
        if strcmp(SLM.beamType,'Square')
            ind1 = find( abs(SLM.grid.x-SLMpos.x(k)) <= SLM.beamSize/2 ) ;
            ind2 = find( abs(SLM.grid.y-SLMpos.y(k)) <= SLM.beamSize/2 ) ;
            SLMsect{k} = intersect(ind1,ind2) ;
        else % strcmp(SLM.beamType,'Disk')
            ind = find( (SLM.grid.x - SLMpos.x(k)).^2 + (SLM.grid.y - SLMpos.y(k)).^2 <= (SLM.beamSize/2)^2  ) ;
            SLMsect{k} = ind ;
        end
    end

end

