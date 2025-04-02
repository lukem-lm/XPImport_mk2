%% This is the input deck, and the only file which should need editing
% Here you will input the filepath, filename, and various details of the
% express data

clear all
close all
addpath src

%% Input variables 
% CM Magazzeni 2020

% The file to be imported
filename='Vince_Reformatted_1_Test.xlsx'; %filename
filepath='/Users/lukemulholland/Documents/MATLAB/XPImport/XPressImport/' %file location (with final \)
% results will be saved here under express_results

batchinfo=[1, 1];%eBatch size (see help below)
batchdims=[+1, +1];%Batch dimensions: how many microns are the 
%individuals bundles in the batch separated by? SIGN IS IMPORTANT

%DISCLAIMER: this is a hack, and is not supposed to be used prior to any
%statistical analysis. This is purely for visualisation purposes. 
cleanplotq = 1; %clean up NaN values?
resolution = ['-r' num2str(600)];

%Express maps contain batches of bundles:
%    a bundle
%  x  x  x  x  x     x  x  x  x  x 
%  x  x  x  x  x     x  x  x  x  x 
%  x  x  x  x  x  .. x  x  x  x  x 
%  x  x  x  x  x     x  x  x  x  x 
%  x  x  x  x  x     x  x  x  x  x 
%        :                  :
%  x  x  x  x  x     x  x  x  x  x 
%  x  x  x  x  x     x  x  x  x  x 
%  x  x  x  x  x  .. x  x  x  x  x 
%  x  x  x  x  x     x  x  x  x  x 
%  x  x  x  x  x     x  x  x  x  x 
%  \_____________________________/
%        the batch of bundles
% In this case, a 2 x 2 batch of 5x5 indent bundles
%% Then just click run on this section
xpressimport;