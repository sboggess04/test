function[] = analyzeCardiacData()

prompt2 = 'Provide filename: ';

%%select .mat files generated from apdCalc to combine and analyze
[Filename,Pathname] = uigetfile('C:\Users\Steven Boggess\Documents\Miller Lab\Data\*.mat','File Selector','MultiSelect','on');
allData  = struct();
numFiles = numel(Filename);
for iFile = 1:numFiles              % Loop over found files
    Data = load(fullfile(Pathname, Filename));
    Data = rmfield(Data , 'cAP_Data') ; %remove the table from files, avoid error
    Fields = fieldnames(Data);
    for iField = 1:numel(Fields)              % Loop over fields of current file
        aField = Fields{iField};
        if isfield(allData, aField)             % Attach new data:
            allData.(aField)(end+1:end+numel(Data.(aField))) = Data.(aField); %Add new data to end of previous data
        else
            allData.(aField) = Data.(aField);
        end
    end
end

filename = input (prompt2);
if isempty(filename) == 1
    disp ('Please provide a string');
    filename = input(prompt2);
else
end
if ischar(filename) == 0
    disp ('Please provide a character in single quotations');
    filename = input(prompt2);
else
end

DataAnalysis = cAPstat (allData , filename, Pathname);
allcAPs = normalcAP (allData , filename, Pathname);
% save(fullfile(Folder, 'AllData.mat'), '-struct', 'allData');
end