%find_at_no_sp1
%Find the atom number from the fits.
load configdata.mat
load maindata.mat

kB = 1.38e-23;
muB = 9.27d-24;
h = 6.63d-34;
omegabar = 2*pi*(xfreq_sp1*yfreq_sp1*zfreq_sp1)^(1/3);

species1 = element_sp1; %cell2mat(handles.species1);

[mass, lambda, gam, Isat, scattXsection, threebodyloss] = elementproperties(species1);

sigma0 = 3*(lambda).^2/(2.0*(pi)); % in SI
sigmatotal = sigma0/(1 + 2*IoverIs_sp1 + 4*(delta_sp1/gam)^2);

% if (get(handles.popupmenu_1dsum_sp1,'Value') == 2)  % sum or cut
%     verticalsize = crosszfit(4)/(2^0.5)*pixelsize1;
% else
%     verticalsize = cz(4)/(2^0.5)*pixelsize1;
% end

verticalsize = cz(4)/(2^0.5)*pixelsize1;

% Correcting for view angle if necessary
if viewAngle_sp1 == 0
    
%     if (get(handles.popupmenu_1dsum_sp1,'Value') == 2)  % sum or cut
%         h_size_angle_corrected  = crossxfit(4);  % ie no change
%     else
%         h_size_angle_corrected  = cx(4);  % ie no change
%     end
    h_size_angle_corrected  = cx(4);
    horizontalsize  = h_size_angle_corrected/(2^0.5)*pixelsize1; % Conversion to rms width and microns
    
else
    
%     if (get(handles.popupmenu_1dsum_sp1,'Value') == 2)  % sum or cut
%         h_size_angle_corrected  = 1/cos(viewAngle_sp1)*(crossxfit(4)^2 - crosszfit(4)^2*sin(viewAngle_sp1)^2)^0.5; % Corrected for angle, still in px
%     else
%         h_size_angle_corrected  = 1/cos(viewAngle_sp1)*(cx(4)^2 - cz(4)^2*sin(viewAngle_sp1)^2)^0.5; % Corrected for angle, still in px
%     end
    h_size_angle_corrected  = 1/cos(viewAngle_sp1)*(cx(4)^2 - cz(4)^2*sin(viewAngle_sp1)^2)^0.5;
    horizontalsize  = h_size_angle_corrected/(2^0.5)*pixelsize1; % Conversion to rms width  and microns
    
end

Ratio = horizontalsize/verticalsize;

verticalsizetrap = verticalsize/sqrt(1+(2.0*pi*zfreq_sp1*tof_sp1*1.0e-3)^2);
horizontalsizetrap = horizontalsize /sqrt(1+(2.0*pi*xfreq_sp1*tof_sp1*1.0e-3)^2);
Tv = mass*(2.0*pi*zfreq_sp1*verticalsizetrap*(2^0.5)).^2/(2*kB);
Th = mass*(2.0*pi*xfreq_sp1*horizontalsizetrap*(2^0.5)).^2/ (2*kB);

switch analysis_type_sp1
    
    case 'Classic'

        %NOD = 2*opticaldepth*pi*verticalsize*horizontalsize/sigmatotal;
        Nh = (sum(I1)-cx(1)*length(I1))*pixelsize1^2/sigmatotal;
        Nv = (sum(I2)-cz(1)*length(I2))*pixelsize1^2/sigmatotal;
        %N_pxsum = handles.A_sum_sp1*pixelsize1^2/sigmatotal;    
        
    case 'px-by-px'
        
        sigma_px = sigma0./(1 + 2*B./Isat_eff_sp1 + 4*(delta_sp1/gam)^2);
        Nh = sum(sum((A - cx(1)/length(I1))./sigma_px))*pixelsize1^2;
        Nv = sum(sum((A' - cz(1)/length(I2))./sigma_px'))*pixelsize1^2;
        
%         if exist('roi_used') == 1
%             if roi_used == 1
%                 NOD = 2*opticaldepth*pi*verticalsize*horizontalsize/sigma_px(round(crosszfit(3) - (ycamerapixel_sp1-1)),round(crossxfit(3) - (xcamerapixel_sp1-1)));
%             else
%                 NOD = 2*opticaldepth*pi*verticalsize*horizontalsize/sigma_px(round(crosszfit(3)),round(crossxfit(3)));
%             end
%         else
%             if useROI_sp1 == 1
%                 NOD = 2*opticaldepth*pi*verticalsize*horizontalsize/sigma_px(round(crosszfit(3) - (ycamerapixel_sp1-1)),round(crossxfit(3) - (xcamerapixel_sp1-1)));
%             else
%                 NOD = 2*opticaldepth*pi*verticalsize*horizontalsize/sigma_px(round(crosszfit(3)),round(crossxfit(3)));
%             end
%         end
%         
%         N_pxsum = sum(sum(A*pixelsize1^2./sigma_px));
        
    case 'High Intensity'
        
        sigma_px = sigma0./(1 + 2*B./Isat_eff_sp1 + 4*(delta_sp1/gam)^2);
        Nh = sum(sum((A - cx(1)/length(I1))./sigma_px))*pixelsize1^2;
        Nv = sum(sum((A' - cz(1)/length(I2))./sigma_px'))*pixelsize1^2;
        
%         if exist('roi_used') == 1
%             if roi_used == 1
%                 NOD = 2*opticaldepth*pi*verticalsize*horizontalsize/sigma_px(round(crosszfit(3) - (ycamerapixel_sp1-1)),round(crossxfit(3) - (xcamerapixel_sp1-1)));
%             else
%                 NOD = 2*opticaldepth*pi*verticalsize*horizontalsize/sigma_px(round(crosszfit(3)),round(crossxfit(3)));
%             end
%         else
%             if useROI_sp1 == 1
%                 NOD = 2*opticaldepth*pi*verticalsize*horizontalsize/sigma_px(round(crosszfit(3) - (ycamerapixel_sp1-1)),round(crossxfit(3) - (xcamerapixel_sp1-1)));
%             else
%                 NOD = 2*opticaldepth*pi*verticalsize*horizontalsize/sigma_px(round(crosszfit(3)),round(crossxfit(3)));
%             end
%         end
%         
%         N_pxsum = sum(sum(A*pixelsize1^2./sigma_px));
        
end

% npk = NOD*omegabar^3*(mass/(2*pi*kB*mean([Tv Th])))^(3/2);
% psdensity = npk*(h/((2*pi*mass*kB*mean([Tv Th]))^0.5))^3;
