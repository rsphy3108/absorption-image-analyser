% zoomoutmenu_sp1.m
% Load in original fitting values and matrix

load maindata
load configdata

fitload_sp1;

% Reset axes and plot original 'full' image in image windows
[m,n] = size(A);
ax_zoomout = [1 n 1 m];

switch fittype_sp1
    
    case 'gaussian'
        
        if (get(handles.popupmenu_1dsum_sp1,'Value') == 1) % plots sums
            
            axes(handles.axes_1dh_sp1)
            x = 1:n;
            handles.xh_sp1 = x;
            plot(x,I1,x,R1,'r');
            set(handles.axes_1dh_sp1,'xlim',[ax_zoomout(1) ax_zoomout(2)]);
            title('Intensity along x-axis after z-integration (vertical)');
            
            axes(handles.axes_1dv_sp1)
            x = 1:m;
            handles.xv_sp1 = x;
            plot(x,I2,x,R2,'r');
            set(handles.axes_1dv_sp1,'xlim',[ax_zoomout(3) ax_zoomout(4)]);
            title('Intensity along z-axis after x-integration (horizontal)');
            
        elseif (get(handles.popupmenu_1dsum_sp1,'Value') == 2)  %plot crosscuts
            
            axes(handles.axes_1dh_sp1)
            x = 1:n;
            handles.xh_sp1 = x;
            plot(x,crossx,x,Rx,'r');
            set(handles.axes_1dh_sp1,'xlim',[ax_zoomout(1) ax_zoomout(2)]);
            title('Cross-section along x-axis through center');
            
            axes(handles.axes_1dv_sp1)
            x = 1:m;
            handles.xv_sp1 = x;
            plot(x,crossz,x,Rz,'r');
            set(handles.axes_1dv_sp1,'xlim',[ax_zoomout(3) ax_zoomout(4)]);
            title('Cross-section along z-axis through center');
            
        end
        
    case 'thomas-fermi'
        
        fitloadTF_sp1;
        [m,n] = size(A);
        ax_zoomout = [1 n 1 m];
        datadispTF_sp1;
        fitnewsaveTF_sp1;
               
        % 1D x crosscut
        axes(handles.axes_1dh_sp1);
        plot(x,xdataccut,'b-',xhires,xthermccut,'r-',xhires,fitFun_x,'g-');
        set(handles.axes_1dh_sp1,'XLim',[ax_zoomout(1) ax_zoomout(2)],'YLim',[min(crosscut_x) 1.1*max(crosscut_x)])
        title('1D cross cut along x-axis through centre of condensate');
        
        % 1D y crosscut
        axes(handles.axes_1dv_sp1);
        plot(z,zdataccut,'b-',zhires,zthermccut,'r-',zhires,fitFun_z,'g-');
        set(handles.axes_1dv_sp1,'XLim',[ax_zoomout(3) ax_zoomout(4)],'YLim',[min(crosscut_z) 1.1*max(crosscut_z)])
        title('1D cross cut along z-axis through centre of condensate');
        
end

A_sum = sum(sum(Anew));
handles.A_sum_sp1 = A_sum;

fitnewsave_sp1;

axes(handles.axes_2d_sp1)
zoomoutsize = max(ax_zoomout);
% set(handles.axes_2d_sp1,'xlim',[ax_zoomout(1) zoomoutsize],'ylim',[ax_zoomout(3) zoomoutsize]);
imagesc(A)
caxis(colour_sp1)
axis equal
title([element_sp1 filename_sp1],'Interpreter','none')

opticaldepth = crosszfit(2) + crosszfit(1);		%Background added to give real OD of cloud

% update image and camera coordinate window and write full image coordinates into them
set(handles.text_coordvalues_sp1,'String',['1,1,' num2str(n) ',' num2str(m)]);
clear m n

datadisp_sp1;   % extract parameters and display in GUI
