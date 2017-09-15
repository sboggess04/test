folder_name = uigetdir
% f = dir ([folder_name,'\*.tif']); %cell array containing info of all tif files in directory
f = rdir ([folder_name,'\**\*.ome.tif']);% Will search all subfolders as well.
filenames = {f.name}; %tif filenames collected

filetypes = zeros(length(filenames),1);
for ii = 1:length(filenames)
    dummy1 = cell2mat(strfind(filenames(ii),'gcamp')); % if you always  name GCaMP files a certain way, replace 'gcamp' with  that naming
    dummy2 = cell2mat(strfind(filenames(ii),'volt')); % if you always name voltage/berst files a certain way, replace 'volt with that naming
    
    testbf = isempty(dummy1) & isempty(dummy2);
    if testbf == 1
        filetypes(ii) = 0; % brightfield
    elseif isempty(dummy1) & ~isempty(dummy2)
        filetypes(ii) = 1; % voltage tracing
    else 
        filetypes(ii) = 2; % GCaMP tracing
    end
end

for ii = 1:length(filetypes)
reader = bfGetReader(f(ii).name);
series1_plane1 = bfGetPlane(reader, 1);
omeMeta = reader.getMetadataStore();
PlaneCount = omeMeta.getPlaneCount(0);

t0 = double(omeMeta.getPlaneDeltaT(0,0).value);
t1 = double(omeMeta.getPlaneDeltaT(0,1).value);
deltat = (t1-t0) ./ 1e3; % assumes that the time unit  is msec
framerate = round(1 ./ deltat);
