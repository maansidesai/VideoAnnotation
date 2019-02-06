%{
Correlates nurse pain reports from the EMU with mood (IMS scores)
note: both scores (pain and IMS) are normalized on a scale from 0-100
Maansi Desai, Feb. 2017

NOTES on Patient info: 
- EC72 does not have any correlations so it throws an error - no plot
is generated; 
- EC105 is not a part of this group of patients because no IMS
was taken

NOTES on plots generated:
1. Plots ALL pain and IMS points across time (datenum)
2. Plots extracted pain and IMS points across time (datenum)
3. Plots extracted pain and IMS points only. To insert trendline, once
figure is generated: Tools < Basic Fitting

Textfiles need to be manually generated:
Pain textfiles are taken from nurse scores on APeX and will be always
generated manually. 
Script for automating IMS coming soon...

Formats:
IMS:
mm/dd/yy   HH:mm   Time norm   IMS   IMS norm (0-100)   BDI   BAI

Pain:
mm/dd/yy   HH:mm   Pain Score   Pain Norm Score (0-100)


To run this script:
- Press Run
- Enter the Patient number (i.e. EC99) 

OUTPUTS go to path/saved_data_subjID:
- correlation.csv in the format of (R value, p-value)
- pain_IMS_extraction.csv in the format of (IMS score, Pain score)
- ECXX (or ECXXX)_Pain_IMS.fig (plot 3)
- ECXX (or ECXXX).fig  (plot 2)
%}

clear all
close all
clc

%define paths and read in txt file
studydir = '/Users/maansi/Desktop/matlab_scripts/Pain_Correlations';
saveFilePath = ([studydir '/' 'matFiles']);
addpath  '/Users/maansi/Desktop/matlab_scripts/'
addpath(genpath('/Users/maansi/Desktop/matlab_scripts/Pain_correlations'))


subject_input = input('Please enter the patient number : ','s') %i.e EC71 or EC108... etc.

subject_pain = [subject_input, '_', 'Pain' '.txt'];
subject_IMS = [subject_input, '_', 'IMS' '.txt'];

%subjID = subject_pain(1:4)      % will need to change to 1:5 for ECXXX
subjID = subject_input(1:end);

%get names for pain generated textfiles
pain_text = dir([subject_pain]);
IMS_text = dir([subject_IMS]);
file_open_pain = fopen(subject_pain, 'r');
file_open_IMS = fopen(subject_IMS, 'r');
    
% Extract relevant information:
%readfile_pain = textscan(file_open_pain,'%s %s %s %s %s %s %s %d');
readfile_pain = textscan(file_open_pain,'%s %s %f %f');
readfile_IMS = textscan(file_open_IMS, '%s %s %f %d %f %d %d');

%reading into cell array:
date_pain = readfile_pain{1}(1:end); % getting date of pain measures
time_pain= readfile_pain{2}(1:end); %getting time (normalized 60 min for hour + min/60min for min) when pain measure taken
scores_norm_pain = readfile_pain{4}(1:end); %converted to normalized pain scores (now scale of 0 to 100, before 0-10)
date_IMS = readfile_IMS{1}(1:end); % getting date of IMS measures
time_IMS = readfile_IMS{2}(1:end); %getting time (normalized 60 min for hour + min/60min for min) when IMS measure taken
scores_norm_IMS = readfile_IMS{5}(1:end); %getting IMS norm scores (scale of 0 to 100)
BDI = readfile_IMS{6}(1);
BAI = readfile_IMS{7}(1);


pain_extraction = [];

for i=1:length(scores_norm_pain)
    for j=1:length(scores_norm_IMS)
        
        if strcmp(date_pain{i},date_IMS{j});
            if length(time_pain{i}) == length(time_IMS{j});     %times XX:XX will be ran through these conditions
                if str2num(time_pain{i}(1:2)) == str2num(time_IMS{j}(1:2));
                    pain_extraction = [pain_extraction;[date_pain(i), time_pain(i), scores_norm_pain(i), date_IMS(j) time_IMS(j), scores_norm_IMS(j)]];
                end
                if str2num(time_pain{i}(1:2)) == str2num(time_IMS{j}(1:2)) - 1;
                    pain_extraction = [pain_extraction;[date_pain(i), time_pain(i), scores_norm_pain(i), date_IMS(j), time_IMS(j), scores_norm_IMS(j)]];
                end
                if str2num(time_pain{i}(1:2)) == str2num(time_IMS{j}(1:2)) + 1;
                    pain_extraction = [pain_extraction;[date_pain(i), time_pain(i), scores_norm_pain(i), date_IMS(j), time_IMS(j), scores_norm_IMS(j)]];
                end
            end
        elseif str2num(time_IMS{j}(1)) == 9 && str2num(time_pain{i}(1:2)) == 10;    %time_IMS = 00:01-09:59 and time_pain = 10:00-24:59
            pain_extraction = [pain_extraction;[date_pain(i), time_pain(i), scores_norm_pain(i), date_IMS(j), time_IMS(j), scores_norm_IMS(j)]];
        elseif str2num(time_IMS{j}(1:2)) == 10 && str2num(time_pain{i}(1)) == 9;    %time_IMS = 10:00-24:59 and time_pain = 00:01-09:59
            pain_extraction = [pain_extraction;[date_pain(i), time_pain(i), scores_norm_pain(i), date_IMS(j), time_IMS(j), scores_norm_IMS(j)]];
        end
        %
        
        if length(time_pain{i}(1:4)) == length(time_IMS{j});    %times X:XX will be ran through these conditions as defined by (1:4)
            if str2num(time_pain{i}(1:1)) == str2num(time_IMS{j}(1:1));
                pain_extraction = [pain_extraction; [date_pain(i), time_pain(i), scores_norm_pain(i), date_IMS(j), time_IMS(j), scores_norm_IMS(j)]];
            end
            
            if str2num(time_pain{i}(1:1)) == str2num(time_IMS{j}(1:1)) - 1;
                pain_extraction = [pain_extraction; [date_pain(i), time_pain(i), scores_norm_pain(i), date_IMS(j), time_IMS(j), scores_norm_IMS(j)]];
            end
            
            if str2num(time_pain{i}(1:1)) == str2num(time_IMS{j}(1:1)) + 1;
                pain_extraction = [pain_extraction; [date_pain(i), time_pain(i), scores_norm_pain(i), date_IMS(j), time_IMS(j), scores_norm_IMS(j)]];
            end
            
        end
        
    end
end
    

%locate cells from array with pain_extraction data - measure as a quality check
array_contents = find(~cellfun(@isempty,pain_extraction));

%initialize variables to gather data from pain_extraction
pain_scores_to_corr = [];
IMS_scores_to_corr = [];

%extract relevant information (date, time, scores (IMS/pain) from
%pain_extraction
pain_scores_to_corr = [pain_scores_to_corr pain_extraction(:,3)];
IMS_scores_to_corr = [IMS_scores_to_corr pain_extraction(:,6)];

%variables for date and time from pain_extraction
date_pain_to_corr = pain_extraction(:,1);
time_pain_to_corr = pain_extraction(:,2);
date_IMS_to_corr = pain_extraction(:,4);
time_IMS_to_corr = pain_extraction(:,5);

%converting pain scores to ordinary array to then plot
pain_scores_to_corr_plot = cell2mat(pain_scores_to_corr);
IMS_scores_to_corr_plot = cell2mat(IMS_scores_to_corr);

%correlating pain_score with IMS score (norm)
pain_IMS_corr=corrcoef(cell2mat(pain_scores_to_corr(:)),cell2mat(IMS_scores_to_corr(:))); %correlating pain_score with IMS score (norm)
pain_IMS_coeff=pain_IMS_corr(2,1);  %outputs R-value

[R,p] = corrcoef(pain_scores_to_corr_plot,IMS_scores_to_corr_plot,'rows','pairwise');
pain_IMS_corr = R(1,2)
p_IMS_Pain = p(2,1)

average_pain_corr = mean(pain_scores_to_corr_plot);
average_IMS_corr = mean(IMS_scores_to_corr_plot);

% mkdir saved_data
% cd saved_data
% mkdir (subjID)
% cd (subjID)

%save data to csv files
output_csvs = [];
output_IMS_Pain = [output_csvs; [IMS_scores_to_corr_plot, pain_scores_to_corr_plot]];

output_csv_R_p = [];
R_p_csv_file = [output_csv_R_p; [pain_IMS_coeff, p_IMS_Pain]];

averages_pain_IMS = [];
output_averages = [averages_pain_IMS; [average_pain_corr, average_IMS_corr]];
std_dev_pain = std(pain_scores_to_corr_plot);
std_dev_IMS = std(IMS_scores_to_corr_plot); 

std_dev_both = [];
std_dev_output = [std_dev_both; [std_dev_pain, std_dev_IMS]];

%standard error of IMS and Pain 
stderror_IMS = std(IMS_scores_to_corr_plot) / sqrt( length(IMS_scores_to_corr_plot))
stderror_pain = std(pain_scores_to_corr_plot) / sqrt( length(pain_scores_to_corr_plot))

pain_score_var = var(pain_scores_to_corr_plot);
IMS_score_var = var(IMS_scores_to_corr_plot);

patient = subjID;  
cd (studydir)
cd(saveFilePath)
%save([subjID '_PatientStructureNormalized.mat'], 'average_pain_corr', 'stderror_pain', 'average_IMS_corr', 'stderror_IMS', 'BDI', 'BAI', 'patient')
%save([subjID '_PatientStructure.mat'], 'stderror', 'std_dev_output', '-append')
%csvwrite('pain_IMS_extraction.csv', output_IMS_Pain)
%csvwrite('correlation.csv', R_p_csv_file)
%csvwrite([subjID '_pain-IMS_mean.csv'], output_averages)
%csvwrite([subjID '_stderror.csv'], stderror)
%csvwrite([subjID '_std_dev_pain_IMS.csv'], std_dev_output)


%converting num2str to create title for pain_extraction plot
BDI_str = num2str(BDI);
BAI_str = num2str(BAI);
pain_IMS_coeff_str = num2str(pain_IMS_coeff);

p_IMS_Pain_str = num2str(p_IMS_Pain);

%for plot titles
str = [];
pain_extraction_title = [str; [subjID, '  ', 'BDI=' BDI_str,'  ','BAI=' BAI_str,'  ','R= ' pain_IMS_coeff_str]]; %extracted pain and IMS with date
pain_vs_IMS_title = [str; [subjID, '  ', 'R= ' pain_IMS_coeff_str,'  ', 'p= '  p_IMS_Pain_str]]; %extracted pain vs. IMS
all_pain_BDI_BAI_Mod_Severe = [str; [subjID, '  ', 'BDI=' BDI_str,'  ','BAI=' BAI_str]]; %all pain scores over time

saving_fig_IMS_vs_Pain = [];
IMS_vs_Pain_save = [saving_fig_IMS_vs_Pain; [subjID, '_', 'Pain_IMS.fig']];

saving_all_points_fig = [];
saving_all_points = [saving_all_points_fig; [subjID, '_', 'allpoints']];


% ------------- CREATE PLOTS --------------------------------------
%%
%1. Create plot of pain and IMS (all points)
DateFormat = 'mm/dd HH:MM';
plotDateTime_Pain = datenum(date_pain,'mm/dd/yy') + datenum(time_pain,'HH:MM') - datenum('00:00','HH:MM'); %for Pain: creates numeric array and represents each point in time from Jan 0 0000
%plot(2,1,1)
figure
[LineType] = scatter(plotDateTime_Pain,scores_norm_pain, 'k', '*');
%LineType.LineStyle = '--';
hold on 
plotDateTime_IMS = datenum(date_IMS,'mm/dd/yy') + datenum(time_IMS,'HH:MM') - datenum('00:00','HH:MM'); %for IMS: creates numeric array and represents each point in time from Jan 0 0000
plot(plotDateTime_IMS, scores_norm_IMS, 'ro');
datetick('x', DateFormat, 'keepticks')
xlabel('Date and Time','FontSize',7)
ylabel('Normalized Scores','FontSize',7)
title(subjID)
l = legend('Pain', 'IMS', 'Location', 'southeastoutside');
%savefig(saving_all_points)

%%
% 2. plot pain_extraction pain and IMS scores across date/time 
DateFormatCorr = 'mm/dd HH:MM';
plotDateTimePainCorr = datenum(date_pain_to_corr,'mm/dd/yy') + datenum(time_pain_to_corr,'HH:MM') - datenum('00:00','HH:MM');
%plot(2,1,2)
figure
[Pain] = scatter(plotDateTimePainCorr,pain_scores_to_corr_plot, 'k', '*');
hold on
plotDateTimeIMSCorr = datenum(date_IMS_to_corr,'mm/dd/yy') + datenum(time_IMS_to_corr,'HH:MM') - datenum('00:00','HH:MM');
[IMS] = scatter(plotDateTimeIMSCorr, IMS_scores_to_corr_plot, 'ro');
datetick('x', DateFormatCorr, 'keepticks')
hold on
xlabel('Date and Time','FontSize',7)
ylabel('Normalized Scores','FontSize',7)
%legend('Pain', 'IMS','Location', 'eastoutside')
title(pain_extraction_title)
h = legend('Pain', 'IMS', 'Location', 'southeastoutside');
%savefig(subjID)

%%
% 3. create plot to show IMS vs. Pain scores (x axis shows number of scores, not date/time)
figure
%plot(2,1,3)
scatter(pain_scores_to_corr_plot,IMS_scores_to_corr_plot, 'b')
hold on
err = ones(size(pain_scores_to_corr_plot));
%err2 = ones(size(IMS_scores_to_corr_plot));
errorbar(pain_scores_to_corr_plot, IMS_scores_to_corr_plot, err, 'Linestyle', 'none');
hold on
scatter(average_pain_corr, average_IMS_corr, '*', 'r');
xlabel('Pain Score (0-100)','FontSize',7)
ylabel('IMS Score (0-100)','FontSize',7)
title(pain_vs_IMS_title)
%savefig(IMS_vs_Pain_save)x

%%
%4. create plot of average pain/IMS and identify variance 
figure
scatter(average_pain_corr, average_IMS_corr);
hold on


%%
% % variable to create combined pain/IMS score to output
for_csv = [];
pain_IMS_score_comb = [for_csv; [pain_scores_to_corr_plot, IMS_scores_to_corr_plot]];

BDI_BAI_severe_fig = [];
BDI_BAI_severe_fig_save = [BDI_BAI_severe_fig; [subjID, '_', 'BDI_BAI_Mod_Sev.fig']];

cd(studydir)

