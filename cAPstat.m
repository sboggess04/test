function [cAPanalysis] = cAPstat (allData,outputName,outputPath)
%%Take worked up data from apdCalc and combine for larger data sets

%%Define file path and outputname
% outputPath = strcat(outputPath,'\');
fullOutputName = [outputPath outputName];

%%load the data
apd30 = getfield(allData,'apd30');
apd50 = getfield(allData,'apd50');
apd90 = getfield(allData,'apd90');
cAPD30 = getfield(allData,'cAPD30');
cAPD50 = getfield(allData,'cAPD50');
cAPD90 = getfield(allData,'cAPD90');
BPM = getfield(allData,'BPM');
interEinter = getfield(allData,'interEinter');
%Calculate mean and SD for each parameter
avg_apd30 = mean(apd30);
avg_apd50 = mean(apd50);
avg_apd90 = mean(apd90);
avg_cAPD30 = mean(cAPD30);
avg_cAPD50 = mean(cAPD50);
avg_cAPD90 = mean(cAPD90);
avg_BPM = mean(BPM);
avg_interEinter = mean(interEinter);
% avg_dFoverF = mean(dFoverF);
% avg_SNR = mean(1);
% avg_upstrokeDuration = mean(upstrokeDuration);

%Calculate standard deviations
std_apd30 = std(apd30);
std_apd50 = std(apd50);
std_apd90 = std(apd90);
std_cAPD30 = std(cAPD30);
std_cAPD50 = std(cAPD50);
std_cAPD90 = std(cAPD90);
std_BPM = std(BPM);
std_interEinter = std(interEinter);
% std_dFoverF = std(dFoverF);
% std_SNR = std(1);
% std_upstrokeDuration = std(upstrokeDuration);

%%save variables and traces before exit
% outputPath = 'C:\Users\Steven Boggess\Documents\Miller Lab\Data\MATLAB\apd_stats\';
% fullOutputName = [outputPath outputName];
save(fullOutputName,'avg_apd30');
save(fullOutputName,'avg_apd90','-append');
save(fullOutputName,'avg_apd50','-append');
save(fullOutputName,'std_apd30','-append');
save(fullOutputName,'std_apd50','-append');
save(fullOutputName,'std_apd90','-append');
save(fullOutputName,'apd30','-append');
save(fullOutputName,'apd50','-append');
save(fullOutputName,'apd90','-append');
save(fullOutputName,'avg_cAPD30','-append');
save(fullOutputName,'avg_cAPD50','-append');
save(fullOutputName,'avg_cAPD90','-append');
save(fullOutputName,'std_cAPD30','-append');
save(fullOutputName,'std_cAPD50','-append');
save(fullOutputName,'std_cAPD90','-append');
save(fullOutputName,'cAPD30','-append');
save(fullOutputName,'cAPD50','-append');
save(fullOutputName,'cAPD90','-append');
save(fullOutputName,'avg_BPM','-append');
save(fullOutputName,'avg_interEinter','-append');
save(fullOutputName,'std_BPM','-append');
save(fullOutputName,'std_interEinter','-append');
save(fullOutputName,'BPM','-append');
save(fullOutputName,'interEinter','-append');
% save(fullOutputName,'actTime','-append');
% save(fullOutputName,'dFoverF','-append');
% save(fullOutputName,'SNR','-append');
% save(fullOutputName,'upstrokeDuration','-append');
% save(fullOutputName,'wholeData','-append');
% save(fullOutputName,'smoothData','-append');
% save(fullOutputName,'corrData','-append');
% save(fullOutputName,'chopData','-append');

%Create table of values
stat = {'apd30' ; 'cAPD30' ; 'apd50' ; 'cAPD50' ; 'apd90' ; 'cAPD90' ; 'BPM' ; 'Interevent Interval'};
Mean = {avg_apd30 ; avg_cAPD30 ; avg_apd50 ; avg_cAPD50 ; avg_apd90 ; avg_cAPD90 ; avg_BPM ; avg_interEinter};
Std = {std_apd30 ; std_cAPD30 ; std_apd50 ; std_cAPD50 ; std_apd90 ; std_cAPD90 ; std_BPM ; std_interEinter};

cAPanalysis = table (Mean , Std, ...
    'RowNames', stat);

%Save table
save (fullOutputName,'cAPanalysis','-append');
end