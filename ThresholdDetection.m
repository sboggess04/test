function [cutdata, start1, end1] = ThresholdDetection( Vector, threshold, Fs )
%ThresholdDetection( Vector, threshold ) Takes Vector parts above threshold
%   [ parts, starts, ends ] = ThresholdDetection( Vector, threshold )

%Turn Fs into a time. We want about 60 ms (for now) before the ap crossed the threshold and 60 ms
%at the end %%note%% put this to 180ms 05/15/2017 for analysis of extended
%aps. Seems of at the front, but might consider splitting into 2 variables
%if the end of previous APs becomes included.
apExtendEnd = (180*(Fs/1000));
apExtendFront = (60*(Fs/1000));

%% find start and end points
a=Vector>=threshold;
a=a(:);
a=[0;a;0];
a=diff(a);
starts=find(a==1);
ends=find(a==-1)-1;

%move the start and end point of each event to capture whole event
start1=(starts - apExtendFront);
end1=(ends + apExtendEnd);

%check for out of range events
firstEvent = 1;
lastEvent = length(starts);
if (start1(1) < 0)
    firstEvent = firstEvent + 1; %if the trace starts in the middle of an event, that event is thrown out
end
if (length(ends)<length(starts))
    lastEvent = length(starts) - 1; %if there is an event that doesn't "end", at the end of a trace, it is thrown out
end
while (end1(lastEvent)>length(Vector))
    lastEvent = lastEvent - 1; %if the end point for cutting is moved past the end of the original trace, the last event is thrown out
end
eventsInRange = lastEvent - firstEvent + 1;

%% cutting
%Need to do some cleanup here
cutdata={};
winlen = floor(50*(Fs/1000)); %length of window equals 50 ms time sampling rate (Fs)
disp(winlen);

for i=1:eventsInRange
    try
        ap = Vector(start1(i+firstEvent-1):end1(i+firstEvent-1));
        apTrue = 0;
        for j = winlen:winlen:floor(length(ap)/winlen)*winlen-winlen
            if (min(ap(j:(j+winlen),1))>threshold)
                apTrue = 1;
            end
        end
        if apTrue>0
            cutdata{length(cutdata)+1,1}=Vector(start1(i+firstEvent-1):end1(i+firstEvent-1));
        end
    catch ME
        disp('Error occured in batch');
    end
end
end

