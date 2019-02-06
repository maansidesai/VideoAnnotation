%{
Script takes all of the output .csv files of extracted pain and IMS scores across all patients generated from
pain_correlations_EMU.m, create an average of all scores, and then plot. 

Maansi Desai, April 2017
%}

clear all
close all
clc

%define paths and read in files
studydir = '/Users/maansi/Desktop/matlab_scripts/Pain_Correlations';
source_dir = '/Users/maansi/Desktop/matlab_scripts/Pain_Correlations/saved_data/all_patients';

addpath  '/Users/maansi/Desktop/matlab_scripts/';
addpath '/Users/maansi/Desktop/matlab_scripts/Pain_Correlations/saved_data';

files=dir('/Users/maansi/Desktop/matlab_scripts/Pain_Correlations/saved_data/all_patients/*.csv');

all_files = length(files);

all_files_matrix = [];

for i=1:all_files
     data=csvread(files(i).name);
     all_files_matrix = [all_files_matrix; [data]];
end

pain = all_files_matrix(:,1);
IMS = all_files_matrix(:,2);

[R,p] = corrcoef(pain, IMS, 'rows', 'pairwise');

correlation = R(1,2)
value_p = p(2,1)

% create plot to show IMS vs. Pain scores (x axis shows number of scores, not date/time)
figure
scatter(pain,IMS, 'b')
hold on
xlabel('Pain Score (0-100)','FontSize',7)
ylabel('IMS Score (0-100)','FontSize',7)
title('Pain vs. IMS average')


