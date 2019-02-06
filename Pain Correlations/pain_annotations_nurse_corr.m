
%define paths: script and pain textfile and dropbox textfiles
studydir = '~/Desktop/matlab_scripts/Pain_Correlations/';   %nurse pain files 
comparedir = '~/Desktop/matlab_scripts/Pain_Correlations/all_subjects_text_files/';    %annotation files
addpath  '~/Desktop/matlab_scripts/';

subject_pain = 'EC71_Pain.txt';     %NEED TO CHANGE EVERYTIME TO ID PATIENT

subjID = subject_pain(1:4);

alldata=[];

%get names from textfiles
ee = dir([subjID '_Pain.txt']);

%open textfile
painfile = ee(1).name;

%extract info from textfile
[date_pain, date_time, ~, norm_score] = textread(painfile, '%s%s%f%f', -1);

%begin reading into annotation files for each patient
cd ([comparedir subjID]);

%read in patient file with annotation info 
ff = dir([subjID '.txt']);
patient_info = ff(1).name;
[patient, scorer, timepoint, video, date, time] = textread(patient_info, '%s%s%s%s%s%s', -1);

start_path = fullfile(matlabroot, '\toolbox');  %define folder to read textfile from

topLevelFolder = uigetdir(start_path);  %ask user to confirm or change 
if topLevelFolder == 0
    return;
end

allSubFolders = genpath(topLevelFolder);
remainder = allSubFolders;

listOfFolderNames = {};     %how can I select more than 1 folder?
while true
    %listOfFolderNames=listOfFolderNames+1;
	[singleSubFolder, remainder] = strtok(remainder, ':');
	if isempty(singleSubFolder)
		break;
	end
	listOfFolderNames = [listOfFolderNames singleSubFolder];
end

numberOfFolders = length(listOfFolderNames);

store_and_read = [];
ind_fileNames_read_full = [];
%process all textfiles in folders
for k = 1 : numberOfFolders
    thisFolder = listOfFolderNames{k};      %get name of folder to process and print
    fprintf('Processing folder %n\n', thisFolder);
    subdirectory = thisFolder(end-5:end);
    
    %output filenames of all .txt
    filePattern = sprintf('%s/*.txt', thisFolder);
    baseFileNames = dir(filePattern);
    numberOfFiles = length(baseFileNames);
    
    if numberOfFiles >= 1
        for f = 1:numberOfFiles
            fullFileName = fullfile(thisFolder, baseFileNames(f).name);
            fprintf('    %s\n', fullFileName);
            subdirectory = thisFolder(end-5:end);
 
            cd ([comparedir subjID '/' subdirectory '/'])
            textfiles = dir('*.txt');
            fileNames = {textfiles.name};
            
            %store_and_read = [];
            
            for i = 1:length(fileNames)
                file_open_text = fopen(fileNames{i}, 'r');
                readfile_text = textscan(file_open_text, '%s %s %f %s %f %s %s %s');
                social_status = readfile_text{1:end};
                time_ON = readfile_text{2:end};
                seconds_ON = readfile_text{3:end};
                time_OFF = readfile_text{4:end};
                seconds_OFF = readfile_text{5:end};
                diff_time = readfile_text{6:end};
                diff_seconds = readfile_text{7:end};
                activity = readfile_text{8:end};
                
                pain_find = strfind(activity, 'pain-general');
                pain_find_index = find(~cellfun('isempty', pain_find), 1);
                store_and_read = [store_and_read; (pain_find)];
                
                
                if ~isempty(pain_find)
                    disp(fileNames{i})
                    ind_fileNames_read = fileNames{i};
                else
                    ind_fileNames_read_full = [ind_fileNames_read_full; (fileNames{i})];
%                     gg = dir(ind_fileNames_read);
%                     individual_ann_file = gg(1).name;
%                     [social_status_individ, time_ON_individ, ~, time_OFF_individ, ~, ~, ~, activity_individ] = textread(individual_ann_file, '%s%s%s%s%s%s%s%s', -1);
%                 
                end
                
            end
            %need to save each iteration from for loop into
            %store_and_read...?
            %store_and_read = [store_and_read; social_status(i), time_ON(i), seconds_ON(i), time_OFF(i), seconds_OFF(i), diff_time(i), diff_seconds(i), activity(i)];
        end
    
    
    else
        fprintf('    Folder %s has no textfiles.\n', thisFolder);
    end

        
end

for m=1:length(timepoint)
    for n=1:length(ind_fileNames_read(6:11))
        if strcmp(timepoint, ind_fileNames_read(6:11));
            if strcmp(video{m}(end-7:end-4),ind_fileNames_read(end-10:end-7))
            end
        end
        
    end
end

%FOR LOOP
%compare date and time from pain textfile to date and time from dropbox
%annotation files

%if date and time from both match within X amount of time, 
% for i=m:length(activity)
%     for j=n:length(scores_norm_IMS)
%     end
% end
