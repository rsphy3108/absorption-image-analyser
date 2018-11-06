%find_at_no_sp2
%Find the atom number from the fits.
load configdata.mat
load maindata.mat

kB = 1.38e-23;
muB = 9.27d-24;
h = 6.63d-34;
omegabar = 2*pi*(xfreq_sp2*yfreq_sp2*zfreq_sp2)^(1/3);

species2 = element_sp2; %cell2mat(handles.species2);

[mass, lambda, gam, Isat, scattXsection, threebodyloss] = elementproperties(species2);

sigma0 = 3*(lambda).^2/(2.0*(pi)); % in SI
sigmatotal = sigma0/(1 + 2*IoverIs_sp2 + 4*(delta_sp2/gam)^2);

switch analysis_type_sp2
    
    case 'Classic'
        N_pxsum = at_sum*pixelsize1^2/sigmatotal;    
        
    case 'px-by-px'
        
        sigma_px = sigma0./(1 + 2*B./Isat_eff_sp2 + 4*(delta_sp2/gam)^2);       
        N_pxsum = at_sum*pixelsize1^2./sigma_px;
        
    case 'High Intensity'
        
        sigma_px = sigma0./(1 + 2*B./Isat_eff_sp2 + 4*(delta_sp2/gam)^2);      
        N_pxsum = at_sum*pixelsize1^2./sigma_px;
        
end
