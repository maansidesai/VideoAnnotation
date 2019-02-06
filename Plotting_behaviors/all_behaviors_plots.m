%DOC and TODO: 
% - For excel: create stacked bar per patient (social, activity, emotion)

close all
clear all
clc

addpath(genpath('/Users/maansi/Desktop/UCSF/'))
directory = '/Users/maansi/Desktop/UCSF/Annotation_Data';

[num,txt,raw] = xlsread('all_behaviorEmotions.xlsx');
filename = 'all_behaviorEmotions.xlsx';     % this sheet created manually from outputted files for each patient
sheet = 1;
xlRange = 'B24:AA24'; 
totals = xlsread(filename,sheet,xlRange); %for total percent values across behaviors/emotion
xlRange_pos_neg = 'AB:AC';
pos_neg = xlsread(filename,sheet,xlRange_pos_neg);
states = ((pos_neg(:,1)) - (pos_neg(:,2)))/((pos_neg(:,1) + (pos_neg(:,2))));
positive_states = pos_neg(:,1);
positive_states = positive_states(1:22);
negative_states = pos_neg(:,2);
negative_states = negative_states(1:22);
states_extraction = states(:,8); 
states_extraction = states_extraction(1:22);


patients = txt(2:23)';

behav = txt(1,:,end);
extract_behav = cellstr(behav(2:end));


social_status = extract_behav(1:4);
activities = extract_behav(5:20);
emotions = extract_behav(21:26);

activities_totals = totals(1:20);
emotion_totals = totals(21:26);

stdev_totals = num(24,:,end);
sterror_totals = num(25,:,end);

sterror_activities = sterror_totals(1:20);
sterror_emotions = sterror_totals(21:26);

%% categorize per patient
filename2 = 'Categorization_patients.xlsx';     % this file created manually.
categorization = xlsread(filename2); 
categorization_totals = categorization(:,1) + categorization(:,2);
social_total_cat = (categorization(:,1)/categorization_totals);
activity_total_cat = (categorization(:,2)/categorization_totals);
social_total_cat_extracted = social_total_cat(:,4);
activity_total_cat_extracted = activity_total_cat(:,4);
resting = categorization(:,7);

%% Data for continuous patient annotations
filename3 = 'Continuous_ActivityBehav.xlsx';     % this file created manually.
sheet_cont = 1;
[num,txt,raw] = xlsread(filename3);
totals_cont = num(5,:);
totals_cont_extracted = totals_cont(1:26);
social_status_cont = totals_cont_extracted(1:4);
activities_cont = totals_cont_extracted(5:20);
emotions_cont = totals_cont_extracted(21:26);

stddev_cont = num(6,:);
extracted_stddev_cont = stddev_cont(1:26);
activities_cont_stddev = extracted_stddev_cont(1:20);
emotions_cont_stddev = extracted_stddev_cont(21:26);

sterror_cont = num(7,:);
extracted_sterror_cont = sterror_cont(1:26);
activities_cont_stE = extracted_sterror_cont(1:20);
emotions_cont_stE = extracted_sterror_cont(21:26);

%categorization for continuous data
cont_categorization_pt = categorization(1:4,:);
cont_categorization_totals = cont_categorization_pt(:,1) + cont_categorization_pt(:,2);
social_total_cat_cont = (cont_categorization_pt(:,1)/categorization_totals);
activity_total_cat_cont = (cont_categorization_pt(:,2)/categorization_totals);

%Figure for continuous patient annotation
figure
bar([cont_categorization_pt(:,1), cont_categorization_pt(:,2), cont_categorization_pt(:,7), positive_states(1:4),negative_states(1:4)],'stacked')
xlim([0 5])
set(gca,'XTick',1:4)
set(gca,'XTickLabel',{'EC137','EC129','EC133','EC125'})
set(gca,'XTickLabelRotation',60)
legend('Social','Activity','Resting','Positive','Negative','location','eastoutside')

%bar graph of this (stacked): contains Social Status, Activity, Resting,
%Positive affect and Negative affect
figure
bar([categorization(:,1),categorization(:,2),categorization(:,7),positive_states,negative_states],'stacked')
xlim([0 19])
set(gca,'XTick',1:18)
set(gca,'XTickLabel',{'EC137','EC129','EC133','EC125','EC126','EC122','EC119','EC117','EC111','EC110','EC108','EC105','EC99','EC96','EC92','EC91','EC87','EC84'})
set(gca,'XTickLabelRotation',60)
legend('Social','Activity','Resting','Positive','Negative','location','eastoutside')
saveas(gcf,[directory '/StackedPlot_Behavs'],'epsc')

%% 
%create table
T=table(positive_states,negative_states, states_extraction,...
'RowNames',patients')
save_file = 'pos_neg_states.mat';
save(save_file, 'T', '-v7.3')

%%
%plot all behaviors with error bars
figure
ax1 = subplot( 1,4,1:3);
bar(ax1,activities_totals);
h = barwitherrOiginal(sterror_activities, activities_totals);
xlim([0 21])
ylim([0 0.125])
set(gca,'XTick',1:20)
set(gca,'XTickLabel',{'Fam', 'Med', 'Res', 'Offscreen', 'ConFam', 'ConMed','ConRes', 'Comp','Drink','Eat','Headp','PersCare','Phone','Read','Search','Seiz','Sleep','TMed','TRes','TV'})
set(gca,'XTickLabelRotation',60)

title('Activities')

ax2 = subplot( 1,4, 4);
bar(ax2,emotion_totals, 'r')
hold on
g = barwitherrOiginal(sterror_emotions, emotion_totals);
xlim([0 6.8])
ylim([0 0.61])
set(gca,'XTick',1:6)
set(gca,'XTickLabel',{'Laugh','Smile','Cry','Pos','Neg','Pain'})
set(gca,'XTickLabelRotation',60)
title('Emotions')
saveas(gcf,[directory '/BoxPlot_behavs'],'epsc')

%save('AllBehavs_Emo.mat','T','patients','categorization','positive_states','negative_states','states_extraction', 'extract_behav','social_status','activities','emotions','activities_totals','emotion_totals','sterror_activities','sterror_emotions','social_total_cat_extracted','activity_total_cat_extracted','resting')


