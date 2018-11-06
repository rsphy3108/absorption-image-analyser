% offline_analysis
% Analyse images offline. 

load configdata
load maindata
load offlineconfigdata

dir_path = ifpath;

filename_cut = ifname(2:end); % removes "a" from file name

underscoreIndex = find(filename_cut == '_');
numI1 = underscoreIndex(1);
numI2 = underscoreIndex(end);
filename_chopped_sp1 = [element_sp1 filename_cut(numI1:numI2)];
filename_chopped_sp2 = [element_sp2 filename_cut(numI1:numI2)];

%filename_chopped_sp1 = '23Oct';
%filename_chopped_sp2 = '23Oct';

%filename_chopped_sp1 = '27Sep';
%filename_chopped_sp2 = '27Sep';

%Points defining the region of interest.
p1_sp1 = [ROI_xmin_sp1 ROI_zmin_sp1];
p2_sp1 = [ROI_xmax_sp1 ROI_zmax_sp1];

p1_sp2 = [ROI_xmin_sp2 ROI_zmin_sp2];
p2_sp2 = [ROI_xmax_sp2 ROI_zmax_sp2];

%points defining image area for fringe removal.
fmp1_sp1 = [p1_sp1(1)-fr_xwidth p1_sp1(2)-fr_zwidth];
fmp2_sp1 = [p2_sp1(1)+fr_xwidth p2_sp1(2)+fr_zwidth];

fmp1_sp2 = [p1_sp2(1)-fr_xwidth p1_sp2(2)-fr_zwidth];
fmp2_sp2 = [p2_sp2(1)+fr_xwidth p2_sp2(2)+fr_zwidth];

%Standard deviation (in pixels) of the gaussian filter used to find the
%center of the cloud.
smoth_sigma = [1,3];

varandfile = table2array(readtable([offlinevarPath offlinevarFilename]));
file_num_array = varandfile(:,1)';

if(fr_ds == 1)
    ref_img_array = file_num_array;
else
    ref_img_array = refindex;
end    
%file_num_array = 7:7;

numI2 = find(offlinevarFilename == '.');
offlinevarFilename1 = offlinevarFilename(1:numI2-1);

%atno_no_fr = cat(1,["file no.", "Variable", string([element_sp1 ' number']),string([element_sp2 ' number']), "mean at. no."],zeros(1,5)); 
%atno_fr = cat(1,["file no.", "Variable", string([element_sp1 ' number']),string([element_sp2 ' number']), "mean at. no."],zeros(1,5)); 

%Start by creating the output files.
atno_no_fr = zeros(2,5); 
atno_fr  =zeros(2,5); 

output_file_path = [ifpath offlinevarFilename1 of_filename '.xls'];
output_file_path_fr = [ifpath offlinevarFilename1 of_filename 'FR' '.xls'];

if(~exist(output_file_path))
    xlswrite([dir_path offlinevarFilename1 of_filename],atno_no_fr)
end

if(~exist(output_file_path_fr))
    xlswrite([dir_path offlinevarFilename1 of_filename 'FR'],atno_no_fr)
end  


Nv = 0;
Nh = 0;
N_pxsum = 0;


%No Fringe removal
for mm = file_num_array
    if(exist(output_file_path))
        out_data = xlsread(output_file_path);
        if(ismember(mm,out_data(:,1)) && no_overwrite==1)
            continue
        end
    end
    disp(['No FR ' num2str(mm)])
    %species1
    filename_chopped = filename_chopped_sp1;
    filenamea = ['a' filename_chopped num2str(mm) '.asc'];
    filenameb = ['b' filename_chopped num2str(mm) '.asc'];
    filenamec = ['c' filename_chopped num2str(mm) '.asc'];
    A = loadascii([dir_path filenamea]);
    A = rot90(A,numrotations_sp1);
    B = loadascii([dir_path filenameb]);
    B = rot90(B,numrotations_sp1);
    C = loadascii([dir_path filenamec]);
    C = rot90(C,numrotations_sp1);  
    
    % Calculate the atom number depending on the slected method. 
    if(fit_method == 0)
        analyse_no_fit_sp1;
    elseif(fit_method == 1)
        analyse_and_fit_sp1;
    end
    
    %Check for unphysical values
    if(Nv > atno_threshold || Nv < 0)
         Nv = 0;
    end
    if(Nh > atno_threshold || Nh < 0)
         Nh = 0;
    end
    
    if(N_pxsum  < 0)
        N_pxsum = 0;
    end
    
    if(fit_method == 0)
        atno_sp1 = N_pxsum;
    elseif(fit_method == 1)
        atno_sp1 = (Nv + Nh)/(2);
    end  
    
        
  
    %%%%%%%
%     %Species 2
    if(single_species == 0)
        filename_chopped = filename_chopped_sp2;
        filenamea = ['a' filename_chopped num2str(mm) '.asc'];
        filenameb = ['b' filename_chopped num2str(mm) '.asc'];
        filenamec = ['c' filename_chopped num2str(mm) '.asc'];
        A = loadascii([dir_path filenamea]);
        A = rot90(A,numrotations_sp2);
        B = loadascii([dir_path filenameb]);
        B = rot90(B,numrotations_sp2);
        C = loadascii([dir_path filenamec]);
        C = rot90(C,numrotations_sp2);  
        
        if(fit_method == 0)
            analyse_no_fit_sp2;
        elseif(fit_method == 1)
            analyse_and_fit_sp2;
        end

        if(Nv > atno_threshold || Nv < 0)
             Nv = 0;
        end
        if(Nh > atno_threshold ||Nh < 0)
             Nh = 0;
        end

        if(N_pxsum  < 0)
            N_pxsum = 0;
        end

        if(fit_method == 0)
            atno_sp2 = N_pxsum;
        elseif(fit_method == 1)
            atno_sp2 = (Nv + Nh)/(2);
        end 

        %Write average atom number data to file
        atno_no_fr = [atno_no_fr;[mm,varandfile(varandfile(:,1)== mm,2), atno_sp1, atno_sp2,(atno_sp1 + atno_sp2)/(2)]];
        xlswrite(output_file_path,[mm,varandfile(varandfile(:,1)== mm,2), atno_sp1, atno_sp2,(atno_sp1 + atno_sp2)/(2)],['A' num2str(size(out_data,1)+2) ':E' num2str(size(out_data,1)+2)]);  
    else
        %Write average atom number data to file if only single species selected
        atno_no_fr = [atno_no_fr;[mm,varandfile(varandfile(:,1)== mm,2), atno_sp1, 0, 0]];
        xlswrite(output_file_path,[mm,varandfile(varandfile(:,1)== mm,2), atno_sp1, 0, 0],['A' num2str(size(out_data,1)+2) ':E' num2str(size(out_data,1)+2)]);
    end
    
%     
 end
 disp(atno_no_fr);
 if(no_overwrite==0)
     delete(output_file_path);
     xlswrite([dir_path offlinevarFilename1 of_filename],atno_no_fr);
 end

 %Fringe removal
if(fr_status > 0)
    for mm = file_num_array
        if(exist(output_file_path))
            out_data = xlsread(output_file_path_fr);
            if(ismember(mm,out_data(:,1)) && no_overwrite==1)
                continue
            end
        end
        disp(['FR' num2str(mm)])
        %species1
        filename_chopped = filename_chopped_sp1;
        filenamea = ['a' filename_chopped num2str(mm) '.asc'];
        filenameb = ['b' filename_chopped num2str(mm) '.asc'];
        filenamec = ['c' filename_chopped num2str(mm) '.asc'];
        A = loadascii([dir_path filenamea]);
        A = rot90(A,numrotations_sp1);
        B = loadascii([dir_path filenameb]);
        B = rot90(B,numrotations_sp1);
        C = loadascii([dir_path filenamec]);
        C = rot90(C,numrotations_sp1);
        
        %Remove the current file no. from the reference images as it is already inlcuded in the fringe removal analysis. 
        for kk = ref_img_array
            filename_refa = ['a' filename_chopped num2str(mm) '.asc'];
            if(filenamea == filename_refa)
                ref_common = intersect(ref_img_array,[mm]);
                ref_img_array1 = setxor(ref_img_array,ref_common);
            end
        end      
        
        %Varibles defining various regions
        p1 = p1_sp1;
        p2 = p2_sp1;
        xdim = size(A,2);
        ydim = size(A,1);
        fmp1 = fmp1_sp1;
        fmp2 = fmp2_sp1;
        
        %Remove fringes according to the slected method. 
        if(fr_status == 1)
            remove_fringes_offline_sp1;
        elseif(fr_status == 2)
            removefringes_PCA_offline_sp1;            
        end
        
        % Calculate the atom number depending on the slected method. 
        if(fit_method == 0)
            analyse_no_fit_sp1;
        elseif(fit_method == 1)
            analyse_and_fit_sp1;
        end

        if(Nv > atno_threshold || Nv < 0)
            Nv = 0;
        end
        if(Nh > atno_threshold || Nh < 0)
             Nh = 0;
        end

        if(N_pxsum  < 0)
            N_pxsum = 0;
        end

        if(fit_method == 0)
            atno_sp1 = N_pxsum;
        elseif(fit_method == 1)
            atno_sp1 = (Nv + Nh)/(2);
        end  
        
        %%%%%%%
        %Species 2
        if(single_species == 0)
            filename_chopped = filename_chopped_sp2;
            filenamea = ['a' filename_chopped num2str(mm) '.asc'];
            filenameb = ['b' filename_chopped num2str(mm) '.asc'];
            filenamec = ['c' filename_chopped num2str(mm) '.asc'];
            A = loadascii([dir_path filenamea]);
            A = rot90(A,numrotations_sp2);
            B = loadascii([dir_path filenameb]);
            B = rot90(B,numrotations_sp2);
            C = loadascii([dir_path filenamec]);
            C = rot90(C,numrotations_sp2);
            for kk = ref_img_array
                filename_refa = ['d' filename_chopped num2str(mm) '.asc'];
                if(filenamea == filename_refa)
                    ref_common = intersect(ref_img_array,[mm]);
                    ref_img_array1 = setxor(ref_img_array,ref_common);
                end
            end        
            p1 = p1_sp2;
            p2 = p2_sp2;
            xdim = size(A,2);
            ydim = size(A,1);
            fmp1 = fmp1_sp2;
            fmp2 = fmp2_sp2;
            if(fr_status == 1)
                remove_fringes_offline_sp2;
            elseif(fr_status == 2)
                removefringes_PCA_offline_sp2;
            end
            if(fit_method == 0)
                analyse_no_fit_sp2;
            elseif(fit_method == 1)
                analyse_and_fit_sp2;
            end

            if(Nv > atno_threshold || Nv < 0)
                 Nv = 0;
            end
            if(Nh > atno_threshold ||Nh < 0)
                 Nh = 0;
            end

            if(N_pxsum  < 0)
                N_pxsum = 0;
            end

            if(fit_method == 0)
                atno_sp2 = N_pxsum;
            elseif(fit_method == 1)
                atno_sp2 = (Nv + Nh)/(2);
            end 

            %Average atom number
            atno_fr = [atno_fr;[mm,varandfile(varandfile(:,1)==mm,2), atno_sp1, atno_sp2,(atno_sp1 + atno_sp2)/(2)]];
            xlswrite(output_file_path_fr,[mm,varandfile(varandfile(:,1)== mm,2), atno_sp1, atno_sp2,(atno_sp1 + atno_sp2)/(2)],['A' num2str(size(out_data,1)+2) ':E' num2str(size(out_data,1)+2)]);
        else
            %Average atom number
            atno_fr = [atno_no_fr;[mm,varandfile(varandfile(:,1)== mm,2), atno_sp1, 0, 0]];
            xlswrite(output_file_path_fr,[mm,varandfile(varandfile(:,1)== mm,2), atno_sp1, atno_sp2,(atno_sp1 + atno_sp2)/(2)],['A' num2str(size(out_data,1)+2) ':E' num2str(size(out_data,1)+2)]);
        end

    end
    disp(atno_fr);
    if(no_overwrite==0)
       delete(output_file_path_fr);
       xlswrite([dir_path offlinevarFilename1 of_filename 'FR'],atno_fr);
    end
end



    