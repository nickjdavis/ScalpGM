function ScalpGM_UnitTest ()
%ScalpGM_UnitTest - Runs unit tests for ScalpGM project.
%  
% ScalpGM_UnitTest()
% 
% Inputs:
%   none
% Outputs
%   none

% - 2 Jan 2017

% Test 1: Process whole folder then calculate mean image

folder = '.\Data3';
 ScalpGM(folder,1);

% get images from log file
% TODO - images have to be MNI sized!
%  - Need to warp dist image
%  - Check this version - should be using col 7, MNI of dist
%  - Need to check for sanity
logfile = strcat(folder,'\ScalpGM_log.txt');
f = fopen(logfile);
LOG = textscan(f, '%s %s\t%s\t%s\t%s\t%s\t%s\t%s\n');
fclose(f);
nimages = size(LOG,1);
distfile = strcat(folder,'\',LOG{7})
% only one!

% send images to meanimage script
ScalpGM_MeanImage(distfile)