function [ SLMsectAll ] = SLM_sect_idx( SLM )
    
    SLMsectAll = SLM.sect{1} ;

    for k=2:numel(SLM.beamState)
        SLMsectAll = union(SLM.sect{k},SLMsectAll) ;
    end
    
end