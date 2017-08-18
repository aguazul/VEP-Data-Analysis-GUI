function updateGraph(hObject, handles)
    if (strcmp(hObject.Tag, 'overlayButton')) % if user clicked the Overlay button
        try
            ax = handles.overlayAxes; % see if the overlay axis is already made
        catch  % if not, then make it
            overlayFig = figure;
            handles.overlayAxes = axes('Parent', overlayFig);
            ax = handles.overlayAxes;
            guidata(hObject, handles); % saves the overlayAxes to the handles
        end    
    else  % user did not click the Overlay button
        ax = handles.axes1;  % set the current axes as the main axes of the GUI
        cla(ax); % clear the axes to erase any plots
    end
    co1 = get(handles.Channel1ColorPicker, 'BackgroundColor');
    co2 = get(handles.Channel2ColorPicker, 'BackgroundColor');
    co3 = get(handles.Channel3ColorPicker, 'BackgroundColor');
    co4 = get(handles.Channel4ColorPicker, 'BackgroundColor');
    co = [co1; co2; co3; co4]; % the colors selected for the 4 channels

    t = getappdata(0, 't'); % all of the time vectors of the dataset
    selectedSaves = get(handles.edit1, 'Value'); % which saves did the user select to graph
    tt = t(:, selectedSaves); % get time vector for each save (probably will be identical)
    numTimepoints = ones(size(selectedSaves));   % numTimepoints stores number of values (usually 512, but could be up to 2048)
    for i=1:length(selectedSaves)
        ttt = tt(:, i);
        numTimepoints(i) = length(ttt(1:find(ttt,1,'last')));
    end
    if (std(numTimepoints)~=0)  % all the vectors should be the same length unless the user selected two different saves with different recording lengths
        h = warndlg('The saves you have selected have different lengths. Some data will be cut off when averaging together.', 'Warning:');
    end
    minTimepoints = min(numTimepoints);
    tt = tt(1:minTimepoints, 1); % just select the first time vector up to the min length
    
    data = getappdata(0, 'currentdata');  % pull in the post-processed data
    data = data(:, 1:minTimepoints, selectedSaves);  % get all channels of just the selected saves
    data = mean(data, 3);  % average across the selected saves.  If only 1 selected then nothing changes.
    nChannels = getappdata(0, 'nChannels');
    %legendText = cell(nChannels, 1);
    L = 0; % legend counter
    for i = 1:nChannels
        if (sum(co(i,:)) < 3)  % Skip plotting if color is set to white (sum of co will be 3 only when color is white)
            plot(ax, tt, data(i,:), 'Color', co(i,:), 'LineWidth', 2);
            hold on;
            L = L + 1; % count the number of items in the legend
            eval(['legendText{L} = get(handles.Channel', int2str(i), 'Title, ''String'');']);
        end
    end
    
    % Plot the ChA - ChB Difference plot
    if (get(handles.PlotDiffCheckbox, 'value')) % if the Plot A-I Difference checkbox is ticked
        ChA = data(str2num(get(handles.PlotDiffChA, 'String')),:);
        ChB = data(str2num(get(handles.PlotDiffChB, 'String')),:);
        ABDiff = ChA - ChB;
        plot (ax, tt, ABDiff, 'k--', 'LineWidth', 2);        
    end

    % Plot N1 Boundry Lines
    if (get(handles.findN1CheckBox, 'value')) % if the N1 checkbox is ticked then attempt to find N1
        minN1 = str2num(get(handles.findN1FromEditor, 'String'));
        maxN1 = str2num(get(handles.findN1ToEditor, 'String'));
        if (get(handles.autoscaleCheckBox, 'value')) % if autoscale is checked then determine y limits based on max and min values of the data
            yLim = [min(min(data)), max(max(data))];   % this avoids the error of -inf and inf being the ylimits when autoscale is checked  
        else
            yLim = get(ax, 'ylim'); % autoscale isn't checked, so set yLim to the y axes limits
        end
        plot(ax, [minN1 minN1], yLim, 'y--', 'LineWidth', 3);
        plot(ax, [maxN1 maxN1], yLim, 'y--', 'LineWidth', 3);
        
        % find N1
        timeZero = find(tt==0);
        analyzeChannel = str2num(get(handles.findN1ChannelEditor, 'String'));
        d = squeeze(data(analyzeChannel, timeZero + minN1*2:timeZero + maxN1*2));  % multiply by 2 because we assume 2000 Hz recording frequency
        
        noiseAmp = round(max(data(analyzeChannel, 1:timeZero)) - min(data(analyzeChannel, 1:timeZero)), 2);
        noiseMean = round(mean(abs(data(analyzeChannel, 1:timeZero))), 2);
        noiseSD = round(std(data(analyzeChannel, 1:timeZero)), 2);
        set(handles.noiseAmpTag, 'String', noiseAmp);
        set(handles.noiseMeanTag, 'String', noiseMean);
        set(handles.noiseSDTag, 'String', noiseSD);
        
        minDistance = str2num(get(handles.distanceN1Editor, 'String'));
        minHeight = str2num(get(handles.heightN1Editor, 'String'));
        try
            [PKS,LOCS] = findpeaks(d*-1, 'MINPEAKDISTANCE', minDistance, 'MINPEAKHEIGHT', minHeight*-1);
            LOCS = LOCS(PKS==max(PKS)); % get the loc of the maximum peak
            PKS = max(PKS); % use just the maximum peak found
            PKS = PKS*-1; % invert back to N1
            N1Amp = PKS; 
            peakTime = tt(timeZero + LOCS + minN1*2);
            yLim(2) = N1Amp;
            plot(ax, [peakTime peakTime], yLim, 'b--', 'LineWidth', 3);
            set(handles.amplitudeN1TextBox, 'String', num2str(round(N1Amp, 2)));
            set(handles.latencyN1TextBox, 'String', num2str(peakTime));
        catch
            set(handles.amplitudeN1TextBox, 'String', '????');
            set(handles.latencyN1TextBox, 'String', '????');
        end
        
    else % since N1 is not checked, set the text boxes back to empty
        set(handles.amplitudeN1TextBox, 'String', '');
        set(handles.pN1TextBox, 'String', '');
        set(handles.latencyN1TextBox, 'String', '');
    end
    
        % Plot P1 Boundry Lines
    if (get(handles.findP1CheckBox, 'value')) % if the P1 checkbox is ticked then attempt to find P1
        if (get(handles.autoP1MinCheckBox, 'value') && ~strcmp(get(handles.latencyN1TextBox, 'String'), '????'))
            if (str2num(get(handles.latencyN1TextBox, 'String')) > 0)
                % set P1Min = Latency of N1 + 2
                minP1 = str2num(get(handles.latencyN1TextBox, 'String')) + 2;
            else
                minP1 = str2num(get(handles.findP1FromEditor, 'String'));
            end
        else
            minP1 = str2num(get(handles.findP1FromEditor, 'String'));
        end
        maxP1 = str2num(get(handles.findP1ToEditor, 'String'));
        if (get(handles.autoscaleCheckBox, 'value')) % if autoscale is checked then determine y limits based on max and min values of the data
            yLim = [min(min(data)), max(max(data))];   % this avoids the error of -inf and inf being the ylimits when autoscale is checked  
        else
            yLim = get(ax, 'ylim'); % autoscale isn't checked, so set yLim to the y axes limits
        end
        plot(ax, [minP1 minP1], yLim, '--', 'Color', [0.3, 0, 0.3], 'LineWidth', 3);
        plot(ax, [maxP1 maxP1], yLim, '--', 'Color', [0.3, 0, 0.3], 'LineWidth', 3);
        
        % Find P1
        timeZero = find(tt==0);
        analyzeChannel = str2num(get(handles.findP1ChannelEditor, 'String'));
        d = squeeze(data(analyzeChannel, timeZero + minP1*2:timeZero + maxP1*2));  % multiply by 2 because we assume 2000 Hz recording frequency
        minDistance = str2num(get(handles.distanceP1Editor, 'String'));
        minHeight = str2num(get(handles.heightP1Editor, 'String'));
        try
            [PKS,LOCS] = findpeaks(d, 'MINPEAKDISTANCE', minDistance, 'MINPEAKHEIGHT', minHeight);
            LOCS = LOCS(PKS==max(PKS)); % get the loc of the maximum peak
            PKS = max(PKS);
            peakTime = tt(timeZero + LOCS + minP1*2);
            yLim(1) = PKS;
            P1Amp = PKS;
            plot(ax, [peakTime peakTime], yLim, 'b--', 'LineWidth', 3);
            set(handles.amplitudeP1TextBox, 'String', num2str(round(P1Amp, 2)));
            set(handles.latencyP1TextBox, 'String', num2str(peakTime));            
            if (exist('noiseSD', 'var'))
                set(handles.xNoiseTextBox, 'String', num2str(round((P1Amp+abs(N1Amp))/noiseMean, 2)));
            end

        catch
            set(handles.amplitudeP1TextBox, 'String', '????');
            set(handles.latencyP1TextBox, 'String', '????');  
        end
    else
        set(handles.amplitudeP1TextBox, 'String', '');
        set(handles.xNoiseTextBox, 'String', '');
        set(handles.latencyP1TextBox, 'String', '');
    end
    
    if (strcmp(hObject.Tag, 'overlayButton') || length(selectedSaves)>1)
        titlestr = ''; % for multiple overlayed plots dont show a title on the plot
    else
        titlestr = ['Save #' num2str(selectedSaves)];
    end
    title(ax, titlestr);
    legend(ax, legendText);
    set(ax,'FontSize',18);
    xlabel(ax, 'time (ms)', 'FontSize', 18);
    ylabel(ax, 'Voltage (\muV)', 'FontSize', 18);
    if (get(handles.autoscaleCheckBox, 'Value'))
        axis(ax, [tt(1) str2num(get(handles.xMaxEditor, 'String')) -inf inf]); % -inf and inf lets it autoscale along Y axis
    else
        axis(ax, [tt(1) str2num(get(handles.xMaxEditor, 'String')) str2num(get(handles.yMinEditor, 'String')) str2num(get(handles.yMaxEditor, 'String'))]);
    end
end