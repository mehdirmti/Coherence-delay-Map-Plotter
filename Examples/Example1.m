clc;
clear;
close all;

%% Add main the directory of the main algorithms into your path
addpath('../Codes/WaveletCoherencyAnalysis/');
addpath('../Codes/');

%% load data
data = readtable('../Data/SampleData.xlsx');

Date = data.date;
dSM = data.d_theta;
dET = data.d_ET;

%% Wavelet coherency analysis
fig = figure;
[img, rsq, delay, lag, Period, sig] = Plotter(dSM, dET, '../Output/SampleOutput.jpg', 'Weeks', [18 44 71 97 123 149 175 201 227 253 279 305], ...
    {'Jan 2012','July 2012', 'Jan 2013', 'July 2013', 'Jan 2014', 'July 2014', 'Jan 2015', 'July 2015', 'Jan 2016','July 2016', 'Jan 2017', 'July 2017'},  'off');