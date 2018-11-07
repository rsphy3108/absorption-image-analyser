% newdatamenu_cont.m
% Looks for new data continously
% Works for both species or just one.

load configdata.mat;
load maindata.mat;

 if (dextersyncValue == 1)    
            syncID = fopen([dexterSyncPath dexterSyncFile]);
            curr_counterDexter = cell2mat(textscan(syncID,'%f'));
            fclose(syncID);
 end
 
 prev_counterDexter = curr_counterDexter;
 
%ii = 0;
if(autoloadval == 1)        
    while(autoloadval == 1)
        pause(0.1);
        drawnow
        if get(handles.pushbutton_stp_autoload, 'userdata') % stop condition
            break;
        end
        %Check if the new run is done. If yes, process the data
        if (dextersyncValue == 1)    
            syncID = fopen([dexterSyncPath dexterSyncFile]);
            curr_counterDexter = cell2mat(textscan(syncID,'%f'));
            fclose(syncID);
        end
        if(curr_counterDexter > prev_counterDexter)
            disp('found new data');
            pause(4);
            newdatamenu;
            prev_counterDexter = curr_counterDexter; 
            %save('maindata','prev_counterDexter','-append');
        else                
            continue
        end
            
    end
else
    if (dextersyncValue == 1)    
            syncID = fopen([dexterSyncPath dexterSyncFile]);
            curr_counterDexter = cell2mat(textscan(syncID,'%f'));
            fclose(syncID);
    end
    newdatamenu;
    prev_counterDexter = curr_counterDexter;
    save('maindata','prev_counterDexter','-append');
%     disp('Hello else')    
end

    %newdatamenu;
