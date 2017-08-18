function updateAnalysis(hObject, handles)
% performs the post-processing analysis based on which checkboxes are
% checked on the GUI
    data = getappdata(0, 'rawdata'); % the unprocessed (except for flipped) data
    nChannels = getappdata(0, 'nChannels');
    
    
    if (get(handles.detrendCheckBox, 'value'))
        detrendedData = zeros(size(data));
        for i = 1:nChannels
            detrendedData(i,:,:) = detrend(squeeze(data(i,:,:)));
        end
        data = detrendedData;
    end
    
    if (get(handles.smoothCheckBox, 'value'))
        smoothData = zeros(size(data));
        k = str2num(get(handles.kEditor, 'String'));
        f = str2num(get(handles.fEditor, 'String'));
        for i = 1:nChannels
            smoothData(i,:,:) = sgolayfilt(squeeze(data(i,:,:)), k, f);
        end
        data = smoothData; 
    end

    if (get(handles.normalizeCheckBox, 'value'))
        zOffset = zeros(size(data));
        for i = 1:nChannels
            zOffset(i,:,:) = squeeze(repmat(data(i,1,:), size(data, 2), 1));
        end
        data = data - zOffset;
    end
    
    setappdata(0, 'currentdata', data);
end