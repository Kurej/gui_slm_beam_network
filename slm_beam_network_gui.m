%{
    Génération d'une image 8 bits sur un écran secondaire (SLM)
    
    * v1 : Réseau de faisceaux
    * v2 : Ajout de clusters de faisceaux
    * v3 : Ajout d'aberrations sur les zones actives
    * v4 : Ajout d'aberrations globales sur une zone de diamètre donné
%}

function slm_beam_network_gui
    % SLM_GUI : Creates a gray level image to be displayed on a SLM.
    close all
    f = figure('Name','SLM beam forming','Visible','off','Position',[360,600,900,350]) ;
    colormap gray
    
    %% SLM initialization
    [ SLM ] = SLM_init( ) ;
    
    
    %% Creation figure SLM
    fSLM = figure('Name','SLM display','units','pixels',...
                  'Position',[1918 43 SLM.width SLM.heigth], ...
                  'resize','off','MenuBar','none','ToolBar','none', ...
                  'colormap',colormap('gray')) ;
    axSLM = gca ;
    set(axSLM,'Units','pixels','Position',[0 0 SLM.width SLM.heigth],'CLim',[0 255]);
    hSLM = imagesc(SLM.img); caxis([0 255]) ;
    
    %% Construct the components.
    figure(f)

    pSLM = uipanel('Parent',f,'Title','SLM','TitlePosition','CenterTop', ...
                    'Units','pixels','Position',[10 f.Position(4)-120 180 120]);
        hedit_SLMwidth = uicontrol('Parent',pSLM,'Style','edit','String',num2str(SLM.width),...
                    'Position',[120,pSLM.Position(4)-40,50,20],'Callback',@edit_SLMwidth_Callback);
        hedit_SLMheigth = uicontrol('Parent',pSLM,'Style','edit','String',num2str(SLM.heigth),...
                    'Position',[120,pSLM.Position(4)-60,50,20],'Callback',@edit_SLMheigth_Callback);
        hedit_SLMtwoPiLvl = uicontrol('Parent',pSLM,'Style','edit','String',num2str(SLM.twoPiLvl),...
                    'Position',[120,pSLM.Position(4)-80,50,20],'Callback',@edit_SLMtwoPiLvl_Callback);
        hedit_SLMgratingPeriod = uicontrol('Parent',pSLM,'Style','edit','String',num2str(SLM.beamGratingPeriod),...
                    'Position',[120,pSLM.Position(4)-100,50,20],'Callback',@edit_SLMgratingPeriod_Callback);
        htext_SLMwidth = uicontrol('Parent',pSLM,'Style','text','String','Width [px]',...
                    'Position',[10,pSLM.Position(4)-40,100,20]); 
        htext_SLMheigth = uicontrol('Parent',pSLM,'Style','text','String','Heigth [px]',...
                    'Position',[10,pSLM.Position(4)-60,100,20]);
        htext_SLMtwoPiLvl = uicontrol('Parent',pSLM,'Style','text','String','2pi gray level',...
                    'Position',[10,pSLM.Position(4)-80,100,20]);
        htext_SLMgratingPeriod = uicontrol('Parent',pSLM,'Style','text','String','Grating period [px]',...
                    'Position',[10,pSLM.Position(4)-100,100,20]);

            
    pClusters = uipanel('Parent',f,'Title','Clusters','TitlePosition','CenterTop', ...
                    'Units','pixels','Position',[200 f.Position(4)-120 180 120]);
        hedit_SLMclusterNumber = uicontrol('Parent',pClusters,'Style','edit','String',num2str(SLM.cluster.number),...
                    'Position',[120,pClusters.Position(4)-40,50,20],'Callback',@edit_SLMclusterNumber_Callback);
        hedit_SLMclusterPitch = uicontrol('Parent',pClusters,'Style','edit','String',num2str(SLM.cluster.pitch),...
                    'Position',[120,pClusters.Position(4)-60,50,20],'Callback',@edit_SLMclusterPitch_Callback);
        htext_SLMclusterNumber = uicontrol('Parent',pClusters,'Style','text','String','Number',...
                    'Position',[10,pClusters.Position(4)-40,95,20]);
        htext_SLMclusterPitch = uicontrol('Parent',pClusters,'Style','text','String','Pitch [px]',...
                    'Position',[10,pClusters.Position(4)-60,95,20]);
    

    pZones = uipanel('Parent',f,'Title','Zones','TitlePosition','CenterTop', ...
                    'Units','pixels','Position',[390 f.Position(4)-120 180 120]);
        hedit_beamNumber = uicontrol('Parent',pZones,'Style','edit','String',num2str(SLM.beamNumber),...
                    'Position',[120,pZones.Position(4)-40,50,20],'Callback',@edit_zoneNumber_Callback);
        hedit_SLMbeamPitch = uicontrol('Parent',pZones,'Style','edit','String',num2str(SLM.beamPitch),...
                    'Position',[120,pZones.Position(4)-60,50,20],'Callback',@edit_SLMzonePitch_Callback);
        hedit_SLMbeamSize = uicontrol('Parent',pZones,'Style','edit','String',num2str(SLM.beamSize),...
                    'Position',[120,pZones.Position(4)-80,50,20],'Callback',@edit_SLMzoneSize_Callback);
        hpopup_SLMbeamType = uicontrol('Parent',pZones,'Style','popupmenu','String',SLM.beamTypes,...
                    'Position',[110,pZones.Position(4)-100,60,20],'Callback',@popup_SLMzoneType_Callback);
        htext_beamNumber = uicontrol('Parent',pZones,'Style','text','String','Number',...
                    'Position',[10,pZones.Position(4)-40,80,20]);
        htext_SLMbeamPitch = uicontrol('Parent',pZones,'Style','text','String','Pitch [px]',...
                    'Position',[10,pZones.Position(4)-60,80,20]);
        htext_SLMbeamSize = uicontrol('Parent',pZones,'Style','text','String','Size [px]',...
                    'Position',[10,pZones.Position(4)-80,80,20]);
        htext_SLMbeamType = uicontrol('Parent',pZones,'Style','text','String','Type',...
                    'Position',[10,pZones.Position(4)-100,80,20]);

                
    pAberr = uipanel('Parent',f,'Title','Aberration ranges','TitlePosition','CenterTop', ...
                    'Units','pixels','Position',[580 f.Position(4)-120 180 120]);
        
        htext_pistonRange = uicontrol('Parent',pAberr,'Style','text','String','Piston [rad]',...
                    'Position',[5,pAberr.Position(4)-40,75,20]);
        htext_tipRange = uicontrol('Parent',pAberr,'Style','text','String','Tip [rad]',...
                    'Position',[5,pAberr.Position(4)-60,75,20]);  
        htext_tiltRange = uicontrol('Parent',pAberr,'Style','text','String','Tilt [rad]',...
                    'Position',[5,pAberr.Position(4)-80,75,20]);
        htext_defocusRange = uicontrol('Parent',pAberr,'Style','text','String','Defocus [rad]',...
                    'Position',[5,pAberr.Position(4)-100,75,20]);
        htext_aberrIndiv = uicontrol('Parent',pAberr,'Style','text','String','Indiv',...
                    'Position',[93,pAberr.Position(4)-119,30,20]);
        htext_aberrGlobal = uicontrol('Parent',pAberr,'Style','text','String','Global',...
                    'Position',[130,pAberr.Position(4)-119,35,20]);
                
        hcheck_aberrRandom = uicontrol('Parent',pAberr,'Style','checkbox','String','Rand. indiv',...
                    'Position',[10,pAberr.Position(4)-115,75,20],'Callback',@check_aberrRandom_Callback);
        hedit_pistonRange = uicontrol('Parent',pAberr,'Style','edit','String',num2str(SLM.pistonRange),...
                    'Position',[90,pAberr.Position(4)-40,35,20],'Callback',@edit_pistonRange_Callback);
        hedit_tipRange = uicontrol('Parent',pAberr,'Style','edit','String',num2str(SLM.tipRange),...
                    'Position',[90,pAberr.Position(4)-60,35,20],'Callback',@edit_tipRange_Callback);
        hedit_tiltRange = uicontrol('Parent',pAberr,'Style','edit','String',num2str(SLM.tiltRange),...
                    'Position',[90,pAberr.Position(4)-80,35,20],'Callback',@edit_tiltRange_Callback);
        hedit_defocusRange = uicontrol('Parent',pAberr,'Style','edit','String',num2str(SLM.defocusRange),...
                    'Position',[90,pAberr.Position(4)-100,35,20],'Callback',@edit_defocusRange_Callback);
                
        hedit_pistonGlobal = uicontrol('Parent',pAberr,'Style','edit','String',num2str(SLM.pistonGlobal),...
                    'Position',[130,pAberr.Position(4)-40,35,20],'Callback',@edit_pistonGlobal_Callback);
        hedit_tipGlobal = uicontrol('Parent',pAberr,'Style','edit','String',num2str(SLM.tipGlobal),...
                    'Position',[130,pAberr.Position(4)-60,35,20],'Callback',@edit_tipGlobal_Callback);
        hedit_tiltGlobal = uicontrol('Parent',pAberr,'Style','edit','String',num2str(SLM.tiltGlobal),...
                    'Position',[130,pAberr.Position(4)-80,35,20],'Callback',@edit_tiltGlobal_Callback);
        hedit_defocusGlobal = uicontrol('Parent',pAberr,'Style','edit','String',num2str(SLM.defocusGlobal),...
                    'Position',[130,pAberr.Position(4)-100,35,20],'Callback',@edit_defocusGlobal_Callback);
        

                
   pOther = uipanel('Parent',f,'Title','Other','TitlePosition','CenterTop', ...
                    'Units','pixels','Position',[770 f.Position(4)-120 120 120]); 
        htext_aberrGlobalDiameter = uicontrol('Parent',pOther,'Style','text','String','Global diam. [px]',...
                    'Position',[0,pOther.Position(4)-45,80,30]);  
        hedit_aberrGlobalDiameter = uicontrol('Parent',pOther,'Style','edit','String',num2str(SLM.aberrGlobalDiameter),...
                    'Position',[80,pOther.Position(4)-40,30,20],'Callback',@edit_aberrGlobalDiameter_Callback);      
        hbutton_calc = uicontrol('Parent',pOther,'Style','pushbutton','String','Calculate',...
                    'Position',[20,pOther.Position(4)-70,70,20],'Callback',@button_calc_Callback);
        hbutton_savePhases = uicontrol('Parent',pOther,'Style','pushbutton','String','Save phases',...
                    'Position',[20,pOther.Position(4)-90,70,20],'Callback',@button_savePhases_Callback);
        hbutton_close = uicontrol('Parent',pOther,'Style','pushbutton','String','Close','BackgroundColor','red',...
                    'Position',[20,pOther.Position(4)-110,70,20],'Callback',@button_close_Callback);
        
                
    htext_enabledBeams = uicontrol('Style','text','String','Enabled zones',...
                'Position',[5,pSLM.Position(2)-25,95,20]);
    htable_beamState = uitable('ColumnWidth','auto','Data',SLM.beamState,'ColumnEditable',true(1,4),...
                'Position',[10,30,250,180],'CellEditCallback',@table_beamState_CellEditCallback);
    
            
    htext_SLMphase = uicontrol('Style','text','String','SLM phase aberrations [rad]',...
                'Position',[310,pSLM.Position(2)-25,140,20]);        
    haxPhase = axes('Units','pixels','Position',[310,30,270,180],'CLim',[-pi pi],'colormap',colormap('gray'));
    
    htext_SLMpreview = uicontrol('Style','text','String','SLM preview [gray levels]',...
                'Position',[620,pSLM.Position(2)-25,130,20]);     
    haxPreview = axes('Units','pixels','Position',[620,30,270,180],'CLim',[0 255],'colormap',colormap('gray'));
    
    

    %% Initialize the UI.
    % Create a plot in the axes.
    axes(haxPhase)
        hplPhase = imagesc(zeros(SLM.heigth,SLM.width)); caxis([-pi pi]), colorbar
    axes(haxPreview)
        hplPreview = imagesc(haxPreview,SLM.img); caxis([0 255]), colorbar

    movegui(f,'center') ; % Move the window to the center of the screen.
    f.Visible = 'on' ; % Make the window visible.
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function button_calc_Callback(source,eventdata)

        [ SLM.sectNumber, SLM.sect, SLM.pos, SLM.ind ] = SLM_positions_px( SLM ) ;
        if SLM.aberrRandom % Valeurs aléatoires dans les intervalles choisis
            SLM.pistons.rad = SLM.pistonRange*(-0.5 + rand(SLM.sectNumber,1)) ; % Phases affichées sur le SLM
            SLM.pistons.gray = SLM.twoPiLvl*(SLM.pistons.rad+pi)/(2*pi) ;
            SLM.tip = SLM.tipRange*(-0.5 + rand(SLM.sectNumber,1)) ; % Angles des tip des faisceaux sur la surface d'une zone [rad]
            SLM.tilt = SLM.tiltRange*(-0.5 + rand(SLM.sectNumber,1)) ; % Angles des tilt des faisceaux sur la surface d'une zone [rad]
            SLM.defocus = SLM.defocusRange*(-0.5 + rand(SLM.sectNumber,1)) ; % Angles des défocus des faisceaux sur la surface d'une zone [rad]
        else % Valeurs fixes dans les intervalles choisis
            SLM.pistons.rad = SLM.pistonRange*ones(SLM.sectNumber,1) ; % Phases affichées sur le SLM
            SLM.pistons.gray = SLM.twoPiLvl*(SLM.pistons.rad+pi)/(2*pi) ;
            SLM.tip = SLM.tipRange*ones(SLM.sectNumber,1) ; % Angles des tip des faisceaux sur la surface d'une zone [rad]
            SLM.tilt = SLM.tiltRange*ones(SLM.sectNumber,1) ; % Angles des tilt des faisceaux sur la surface d'une zone [rad]
            SLM.defocus = SLM.defocusRange*ones(SLM.sectNumber,1) ; % Angles des défocus des faisceaux sur la surface d'une zone [rad]
        end
        [ SLM.img, SLM.phi ] = SLM_genimg( SLM ) ;

        set(hplPreview,'CData',SLM.img)
        set(hplPhase,'CData',angle(exp(1i*SLM.phi)))
        set(hSLM,'CData',SLM.img)
    end


    function button_close_Callback(source,eventdata)
        clear all ; close all ;
    end

    function check_aberrRandom_Callback(source,eventdata)
        SLM.aberrRandom = get(hcheck_aberrRandom,'Value') ;
    end

    function edit_aberrGlobalDiameter_Callback(source,eventdata)
        SLM.aberrGlobalDiameter = abs(str2num(get(hedit_aberrGlobalDiameter,'String'))) ;
        SLM.aberrSect = find(sqrt(SLM.grid.x.^2+SLM.grid.y.^2)<=SLM.aberrGlobalDiameter/2) ;
    end

    function edit_pistonRange_Callback(source,eventdata)
        SLM.pistonRange = abs(str2num(get(hedit_pistonRange,'String'))) ;
    end

    function edit_tipRange_Callback(source,eventdata)
        SLM.tipRange = abs(str2num(get(hedit_tipRange,'String'))) ;
    end
    
    function edit_tiltRange_Callback(source,eventdata)
        SLM.tiltRange = abs(str2num(get(hedit_tiltRange,'String'))) ;
    end

    function edit_defocusRange_Callback(source,eventdata)
        SLM.defocusRange = abs(str2num(get(hedit_defocusRange,'String'))) ;
    end

    function edit_pistonGlobal_Callback(source,eventdata)
        SLM.pistonGlobal = abs(str2num(get(hedit_pistonGlobal,'String'))) ;
    end

    function edit_tipGlobal_Callback(source,eventdata)
        SLM.tipGlobal = abs(str2num(get(hedit_tipGlobal,'String'))) ;
    end
    
    function edit_tiltGlobal_Callback(source,eventdata)
        SLM.tiltGlobal = abs(str2num(get(hedit_tiltGlobal,'String'))) ;
    end

    function edit_defocusGlobal_Callback(source,eventdata)
        SLM.defocusGlobal = abs(str2num(get(hedit_defocusGlobal,'String'))) ;
    end
    
    function button_savePhases_Callback(source,eventdata)
        date = datetime ;
        [y,m,d] = ymd(date) ;
        [h,min,s] = hms(date) ;
        matName = ['SLMstate_' num2str(y) '-' num2str(m) '-' num2str(d) ...
                    '_' num2str(h) 'h' num2str(min) 'm' num2str(round(s)) 's'] ;
        save(matName,'SLM') ;
    end


    function edit_zoneNumber_Callback(source,eventdata)
        % Changes max number of beams to be displayed
        n_tmp = str2num(get(hedit_beamNumber,'String')) ;
        if isempty(n_tmp)
            error('Please enter a valid number of beams !') ;
        elseif mod(sqrt(n_tmp),1)
            error('Please enter a square number of beams : 1, 4, 16, 25...') ;
        elseif n_tmp > SLM.maxBeamNumber
            error('Please enter a square number of beams inferior or equal to 256.') ;
        else
            SLM.beamNumber = n_tmp ;
            htable_beamState.Data = true(sqrt(SLM.beamNumber*SLM.cluster.number)) ;
            htable_beamState.ColumnEditable = true(1,sqrt(SLM.beamNumber*SLM.cluster.number)) ;
            SLM.beamState = htable_beamState.Data ;
            
        end
    end


    function table_beamState_CellEditCallback(source,eventdata)
        SLM.beamState = transpose(htable_beamState.Data) ;
    end


    function edit_SLMtwoPiLvl_Callback(source,eventdata)
        SLM.twoPiLvl = str2num(get(hedit_SLMtwoPiLvl,'String')) ;
    end


    function edit_SLMwidth_Callback(source,eventdata)
        SLM.width = str2num(get(hedit_SLMwidth,'String')) ;
    end


    function edit_SLMheigth_Callback(source,eventdata)
        SLM.heigth = str2num(get(hedit_SLMheigth,'String')) ;
    end


    function edit_SLMzonePitch_Callback(source,eventdata)
        SLM.beamPitch = str2num(get(hedit_SLMbeamPitch,'String')) ;
    end


    function edit_SLMzoneSize_Callback(source,eventdata)
        SLM.beamSize = str2num(get(hedit_SLMbeamSize,'String')) ;
    end


    function popup_SLMzoneType_Callback(source,eventdata)
        val = get(hpopup_SLMbeamType,'Value') ;
        SLM.beamType = SLM.beamTypes{val} ;
    end


    function edit_SLMgratingPeriod_Callback(source,eventdata)
        SLM.beamGratingPeriod = str2num(get(hedit_SLMgratingPeriod,'String')) ;
    end

    function edit_SLMclusterNumber_Callback(source,eventdata)
        SLM.cluster.number = str2num(get(hedit_SLMclusterNumber,'String')) ;

        % Changes max number of beams to be displayed
        n_tmp = str2num(get(hedit_SLMclusterNumber,'String')) ;
        if isempty(n_tmp)
            error('Please enter a valid number of beams !') ;
        elseif mod(sqrt(n_tmp),1)
            error('Please enter a square number of beams : 1, 4, 16, 25...') ;
        elseif n_tmp > SLM.maxBeamNumber
            error('Please enter a square number of beams inferior or equal to 256.') ;
        else
            SLM.cluster.number = n_tmp ;
            htable_beamState.Data = true(sqrt(SLM.beamNumber*SLM.cluster.number)) ;
            htable_beamState.ColumnEditable = true(1,sqrt(SLM.beamNumber*SLM.cluster.number)) ;
            SLM.beamState = htable_beamState.Data ;
        end
    end

    function edit_SLMclusterPitch_Callback(source,eventdata)
        SLM.cluster.pitch = str2num(get(hedit_SLMclusterPitch,'String')) ;
    end

%     function main_figure_close_callback(source,evendata)
%         if ~isempty(findobj('Name','SLM display'))
%             close('SLM display')
%         end
%         
%         if ~isempty(findobj('Name','SLM beam forming'))
%             close('SLM display')
%         end
%     end

end
