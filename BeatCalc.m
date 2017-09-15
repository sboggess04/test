function [BPM interEinter] = BeatCalc(numEvents, timeElap, eventStart, eventEnd)

%Calculates the beat rate and interevent intervals

beatFreq = numEvents/timeElap;
BPM = beatFreq*60;

interEinter = zeros(numEvents-1,1);
for j = 1:(numEvents-1)
        lastevent = eventEnd(j);
        nextevent = eventStart(j+1);
        interEinter(j) = nextevent-lastevent;
    
end

end