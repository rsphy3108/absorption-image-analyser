% newdatamenu_cont.m
% Looks for new data continously
% Works for both species or just one.

load configdata.mat;
load maindata.mat;

autoload = 1;

 if (dextersyncValue == 1)    
            syncID = fopen([dexterSyncPath dexterSyncFile]);
            curr_counterDexter = cell2mat(textscan(syncID,'%f'));
            fclose(syncID);
 end
 
 prev_counterDexter = curr_counterDexter;
 %save('maindata','prev_counterDexter','-append');
 
    while(autoload == 1)
        pause(0.1);
        drawnow
        if get(handles.pushbutton_stop_autoload, 'userdata') % stop condition
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
            pause(5);
            Autoload_newdatamenu;
            prev_counterDexter = curr_counterDexter; 
            %save('maindata','prev_counterDexter','-append');
        else
            continue
        end
%     ii = ii+1;
%     disp(['Hello while' num2str(ii)])    
    end

