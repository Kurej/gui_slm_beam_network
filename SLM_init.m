function [ SLM ] = SLM_init( )
    SLM.width = 1280 ; % Largeur du SLM [px]
    SLM.heigth = 1024 ; % Hauteur du SLM [px]
    [SLM.grid.x,SLM.grid.y] = meshgrid(-SLM.width/2:1:SLM.width/2-1,-SLM.heigth/2:1:SLM.heigth/2-1) ;
    SLM.dynamicRange = 2^8 ; % Nombre de niveaux de gris du SLM
    SLM.maxGrayLevel = SLM.dynamicRange-1 ;
    SLM.twoPiLvl = 211 ; % Niveau de gris pour un déphasage de 2pi (sur 8 bits)
    
    SLM.beamTypes = {'Disk','Square'} ; % Maille carrée ou hexagonale
    SLM.beamType = SLM.beamTypes{1} ;
    SLM.maxBeamNumber = 256 ;
    SLM.beamNumber = 1 ; % Nombre de faisceaux
    SLM.beamSize = 25;%62 ; % Taille d'un plot déphasant du SLM à section carrée [m]
    SLM.beamPitch = 65 ; % Espacement entre deux plots déphasants du SLM [m]
    SLM.beamGratingPeriod = 10 ; % Pas des réseaux de diffraction [px]
 
    SLM.cluster.number = 16 ; % Nombre de clusters de zones diffractantes
    SLM.cluster.pitch = 40;%78 ; % Pas des clusters de zones diffractantes [px]
    
    SLM.img = zeros(SLM.heigth,SLM.width) ; 
    SLM.figPos.x = 2019 ; % Position en x de la figure SLM [px]
    SLM.figPos.y = 503 ; % Position en y de la figure SLM [px]
    
    SLM.aberrGlobalDiameter = 800 ;
    SLM.aberrSect = find(sqrt(SLM.grid.x.^2+SLM.grid.y.^2)<=SLM.aberrGlobalDiameter/2) ;
    SLM.aberrRandom = 0 ;
    SLM.pistonRange = 0 ;
    SLM.tipRange = 0 ;
    SLM.tiltRange = 0 ;
    SLM.defocusRange = 0 ;
    SLM.pistonGlobal = 0 ;
    SLM.tipGlobal = 0 ;
    SLM.tiltGlobal = 0 ;
    SLM.defocusGlobal = 0 ;
    
    [ SLM.sectNumber, SLM.sect, SLM.pos, SLM.ind ] = SLM_positions_px( SLM ) ;
    SLM.beamState = true(sqrt(SLM.sectNumber)) ;
    
    SLM.pistons.rad = zeros(SLM.sectNumber,1) ; % Phases affichées sur le SLM
    SLM.pistons.gray = SLM.twoPiLvl*SLM.pistons.rad/(2*pi) ;
    SLM.tilt = zeros(SLM.sectNumber,1) ;
    SLM.tip = zeros(SLM.sectNumber,1) ;
    SLM.defocus = zeros(SLM.sectNumber,1) ;
    
    [ SLM.img, SLM.phi ] = SLM_genimg( SLM ) ;

end

