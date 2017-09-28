function [] = getCardiacData ()

%% REMEMBER TO SET CORRECT FS!!!
%User input variables
Fs = 4000   ; %sampling rate (in Hz or fps)


%%Hopefully this wrapper script will allow for user to select folders
%%containing tiff stacks of CM data to analyze, then run through specific
%%cAP data scripts to analyzed APD, risetime, etc.

%Author: Steven Boggess (sboggess@berkeley.edu)
%%Thanks to Julia and Ben for their guidance and support~

%%Input variables to change:
%% Find FS to set the aqc frequency. All tiff stacks must be of the same frequency to work with this current configuration

%Get all tif filenames from a selected folder
folder_name = uigetdir('C:\Users\Steven Boggess\Documents\Miller Lab\Data\', 'Select Folder Containing Tiff Stacks to Analyze');

tic

f = rdir ([folder_name,'\**\*.tif']);% Will search all subfolders as well.
fe = rdir ([folder_name,'\**\*.csv*']);% Will search all subfolders as well.
filenames = {f.name}; %tif filenames collected
csvFiles = {fe.name}; %csv filenames collected
disp(folder_name);

csvStacks = cell(numel(csvFiles),1);
tifStacks = cell(numel(filenames),1);

% s = isempty(csvStacks);
% switch s
%     case s == 1
for i=1:numel(filenames)
    if strfind(filenames{i} , 'vm')
        tiffname = fullfile(filenames{i});
        [pathstr,name,ext] = fileparts(filenames{i});
        filename = name;
        %         disp (tiffname); %Show the file you are working with
        tifStacks = apdCalc(tiffname,Fs,filename,folder_name);
    else if strfind(filenames{i} , 'Vm')
            tiffname = fullfile(filenames{i});
            [pathstr,name,ext] = fileparts(filenames{i});
            filename = name;
            %             disp (tiffname); %Show the file you are working with
            tifStacks = apdCalc(tiffname,Fs,filename,folder_name);
        else
            disp ('not a vm trace');
        end
    end
    
end

%%For .csv files
%     case iszero(s)
for i = 1:numel(csvFiles)
    csvName = fullfile(csvFiles{i});
    [pathstr,cName,ext] = fileparts(csvFiles{i});
    csvFilename = cName;
    disp (csvName); %Show the file you are working with
    csvValues = csvread(csvName , 0 , 0) ;
    yValues = csvValues(: , 2);
    finalValue = length (csvValues) ;
    tracesStart = find(csvValues == 1);
    numtraces = length(tracesStart);
    for j = 1:((numtraces-1))  %%does all until the last set of traces
        startBound = tracesStart(j) ;
        endBound = tracesStart(j+1) ;
        currentTrace = yValues(startBound:(endBound-1));
        csvRoiTraces{j , 1} = currentTrace ;
    end
    
    if numtraces > 1
        lastTrace = yValues((tracesStart(numtraces-1)):(tracesStart(numtraces)));
        csvRoiTraces{end+1 , 1} = lastTrace ;
        %%Before going into apdCalc, need to parse out the trace.
            csvStacks = csv_apdCalc(csvName,Fs,csvFilename,folder_name,csvRoiTraces);
    else if numtraces == 1
            csvRoiTraces{1 ,1} = yValues ;
            
            %%Before going into apdCalc, need to parse out the trace.
            csvStacks = csv_apdCalc(csvName,Fs,csvFilename,folder_name,csvRoiTraces);
        else
            
        end
        
        fprintf(['While it is always best to believe in one’s self, \n' ...
            ' a little help from others can be a great blessing. --Iroh  \n' ...
            '   ']);
        
        toc
    end
end
end
