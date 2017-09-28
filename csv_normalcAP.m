function [traceAnalysis] = csv_normalcAP (allData)
%%normalization and plotting of worked up cardiac data

%%load the data
cAPtrace = allData;

%%rename and define variables
A = cAPtrace;
numEvents = length(A);

    normalcAP = A ;%load relevant cAP
    minimum = min(A);
    maximum = max(A);
    difference = maximum-minimum;
    normcAP = (normalcAP-minimum)./difference;



% % plot normalized cAPs
% figure('name',outputName,'numbertitle','off');
% hold on
% title('AP Events');
% xlabel('Time(ms)');
% ylabel('Intensity');
% for i= 1:numEvents;
%         numFrames = length(normcAP{i,1});
%     for j= 1:numFrames;
%         numframes2 = length (normcAP{j,1});
%         timeElap2 = numframes2*(1/Fs);
%         time2 = zeros (numframes2,1); %pre-allocate;
%         cnt = 1; %start the count;
%         for ii = (1:numframes2)
%             time2(cnt) = (ii/Fs);
%             cnt = cnt + 1;
%         end
%         time2 = time2*1000;
%     plot (time2 , normcAP{i,1});
% end

%calculate and plot avg normalized cAP
% n = max(cellfun(@(x) size(x,1),normcAP));
% fillcAP_Data = cellfun(@(x) [x;zeros(n-size(x,1),1)],normcAP,'un',0);
% meancAP = mean(cat(3,fillcAP_Data{:}),3);
% plot(meancAP,'LineWidth',3);

%%save variables and traces before exit
% fullOutputName = [outputPath outputName];
% save(fullOutputName,'normcAP','-append');
% save(fullOutputName,'meancAP','-append');

%Save figure
% saveas(gcf,fullOutputName,'pdf'); %save as a pdf
% saveas(gcf,fullOutputName); %save as matlab fig

%define output
traceAnalysis = normcAP;

end
