function [ SLMimg, phi ] = SLM_genimg( SLM )
% genSLMimg : Generates SLM images from input phases

    SLMimg = zeros(SLM.heigth,SLM.width) ;
    piston = zeros(SLM.heigth,SLM.width) ;
    tilt = zeros(SLM.heigth,SLM.width) ;
    tip = zeros(SLM.heigth,SLM.width) ;
    defocus = zeros(SLM.heigth,SLM.width) ;
    
    pistonGlobal = zeros(SLM.heigth,SLM.width) ;
    tiltGlobal = zeros(SLM.heigth,SLM.width) ;
    tipGlobal = zeros(SLM.heigth,SLM.width) ;
    defocusGlobal = zeros(SLM.heigth,SLM.width) ;
        
    pistonGlobal(SLM.aberrSect) = SLM.pistonGlobal ;
    tipGlobal(SLM.aberrSect) = SLM.grid.y(SLM.aberrSect)/max(max(abs(SLM.grid.y(SLM.aberrSect))))*SLM.tipGlobal ;
    tiltGlobal(SLM.aberrSect) = SLM.grid.x(SLM.aberrSect)/max(max(abs(SLM.grid.x(SLM.aberrSect))))*SLM.tiltGlobal ;
    defocusGlobal(SLM.aberrSect) = (SLM.grid.x(SLM.aberrSect)).^2 + (SLM.grid.y(SLM.aberrSect)).^2 ;
    defocusGlobal(SLM.aberrSect) = defocusGlobal(SLM.aberrSect)/max(max(abs(defocusGlobal(SLM.aberrSect))))*SLM.defocusGlobal - SLM.defocusGlobal/2 ;

    phiGlobal = pistonGlobal + tipGlobal + tiltGlobal + defocusGlobal ;
    
    
    for k=1:numel(SLM.beamState)
        
        if SLM.beamState(k)
            Phix = SLM.beamState(k)*mod(SLM.grid.x(SLM.sect{k})+SLM.pistons.gray(k),SLM.beamGratingPeriod)*SLM.twoPiLvl/SLM.beamGratingPeriod ;
            SLMimg(SLM.sect{k}) = Phix ;
            
            piston(SLM.sect{k}) = SLM.pistons.rad(k) ;

            tilt(SLM.sect{k}) = SLM.grid.x(SLM.sect{k})-SLM.pos.x(k) ;
            tilt(SLM.sect{k}) = tilt(SLM.sect{k})/max(max(abs(tilt(SLM.sect{k}))))*SLM.tilt(k) ;

            tip(SLM.sect{k}) = SLM.grid.y(SLM.sect{k})-SLM.pos.y(k) ;
            tip(SLM.sect{k}) = tip(SLM.sect{k})/max(max(abs(tip(SLM.sect{k}))))*SLM.tip(k) ;

            defocus(SLM.sect{k}) = (SLM.grid.x(SLM.sect{k})-SLM.pos.x(k)).^2 + (SLM.grid.y(SLM.sect{k})-SLM.pos.y(k)).^2 ;
            defocus(SLM.sect{k}) = defocus(SLM.sect{k})/max(max(abs(defocus(SLM.sect{k}))))*SLM.defocus(k) - SLM.defocus(k)/2 ;
        end
    end
    
    phiIndiv = piston + tip + tilt + defocus ;
    phi = angle(exp(1i*(phiIndiv + phiGlobal))) ;
    SLMimg = mod(SLMimg + round(SLM.twoPiLvl*(phiIndiv+phiGlobal+pi)/(2*pi)), SLM.twoPiLvl) ;

end

