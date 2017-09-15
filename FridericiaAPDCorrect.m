function [] = FridericiaAPDCorrect()

%Write script to plot APD and find cycle length (CL, 1/BPM). Finds a linear
%best fit to then correct APDs to find APDc values.

%Define variables
allAvg_apd50 = zeros(1);
allAvg_apd90 = zeros(1);
allAvg_apd30 = zeros(1);
allCL = zeros(1);
allstd_apd50 = zeros(1);
allstd_apd90 = zeros(1);
allstd_apd30 = zeros(1);

%Load APD and BPM from traces
%%select .mat files generated from apdCalc analyze
[Filelist,Pathname] = uigetfile('C:\Users\Steven Boggess\Documents\Miller Lab\Data\*.mat','File Selector','MultiSelect','on');
allData  = struct();
numFiles = numel(Filelist);
for iFile = 1:numFiles              % Loop over found files
    Data = load(fullfile(Pathname, Filelist{1,iFile}));
    Data = rmfield(Data , 'cAP_Data') ; %remove the table from files, avoid error
    Fields = fieldnames(Data);
    for iField = 1:numel(Fields)              % Loop over fields of current file
        aField = Fields{iField};
        switch (aField)
            case 'apd30'
                apd30 = Data.(aField);
            case 'apd50'
                apd50 = Data.(aField);
            case 'apd90'
                apd90 = Data.(aField);
            case 'BPM'
                BPM = Data.(aField);
        end
    end
    %Taking values from file in current loop, calculate CL and APD values.
    %plot these values
    %Calculate mean APD
    avg_apd30 = mean(apd30);
    avg_apd50 = mean(apd50);
    avg_apd90 = mean(apd90);
    
    %Calculate standard deviations
    std_apd30 = std(apd30);
    std_apd50 = std(apd50);
    std_apd90 = std(apd90);
    
    %Calculate Cycle Length (CL)
    CL = 60/(BPM);
    
    %Insert and combine values
    if   (allAvg_apd50(1,1) == 0)
        allAvg_apd50 = avg_apd50;
        allAvg_apd90 = avg_apd90;
        allAvg_apd30 = avg_apd30;
        allCL = CL;
        allstd_apd50 = std_apd50;
        allstd_apd90 = std_apd90;
        allstd_apd30 = std_apd30;
    else
        allAvg_apd50(end+1) = avg_apd50;
        allAvg_apd90(end+1) = avg_apd90;
        allAvg_apd30(end+1) = avg_apd30;
        allCL(end+1) = CL;
        allstd_apd50(end+1) = std_apd50;
        allstd_apd90(end+1) = std_apd90;
        allstd_apd30(end+1) = std_apd30;
    end
end
%Now find FcAPD50 values
F_APD50c = zeros(length(allAvg_apd50),1);

for j = 1:length(allAvg_apd50)
    F_APD50c(j) = (allAvg_apd50(j)/((allCL(j))^(1/3))) ;
end

%Now find FcAPD90 values
F_APD90c = zeros(length(allAvg_apd90),1);

for k = 1:length(allAvg_apd90)
    F_APD90c(k) = (allAvg_apd90(k)/((allCL(k))^(1/3))) ;
end

%Now find FcAPD30 values
F_APD30c = zeros(length(allAvg_apd30),1);

for k = 1:length(allAvg_apd30)
    F_APD30c(k) = (allAvg_apd30(k)/((allCL(k))^(1/3)));
end

%transpose

allAvg_apd90 = allAvg_apd90.';
allAvg_apd50 = allAvg_apd50.';
allAvg_apd30 = allAvg_apd30.';
allCL = allCL.';

%Save the current data set

correctionFilename = input ('Please provide filename  ');
if isempty(correctionFilename) == 1;
    disp ('Please provide a string');
    filename = input('Please provide filename  ');
else
end
if ischar(correctionFilename) == 0;
    disp ('Please provide a character in single quotations');
    correctionFilename = input('Please provide filename  ');
else
end

ThefullOutputName = [Pathname correctionFilename];

save(ThefullOutputName,'allCL');
save(ThefullOutputName,'F_APD30c','-append');
save(ThefullOutputName,'F_APD50c','-append');
save(ThefullOutputName,'F_APD90c','-append');

%Plot and save figures

figure('name','APD50 correction','numbertitle','off');
hold on;
title('APD50');
xlabel('Cycle Length');
ylabel('APD50(ms)');
scatter(allCL , allAvg_apd50 , 'r' , 's' , 'filled');
scatter(allCL , F_APD50c,'o','o','filled'); %plot corrected values
legend('Data'  , 'Corrected Data' ,'Location' , 'best');

figure('name','APD90 correction','numbertitle','off');
hold on;
title('APD90');
xlabel('Cycle Length');
ylabel('APD90(ms)');
scatter(allCL , allAvg_apd90 , 'b' , 's' , 'filled');
scatter(allCL , F_APD90c,'m','o','filled');
legend('Data' , 'Corrected Data','Location','best');

figure('name','APD30 correction','numbertitle','off');
hold on;
title('APD30');
xlabel('Cycle Length');
ylabel('APD30(ms)');
scatter(allCL , allAvg_apd30 , 'b' , 's' , 'filled');
scatter(allCL , F_APD30c,'m','o','filled');
legend('Data', 'Corrected Data','Location','best');
end