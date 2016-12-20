% Run unit tests for ScalpGM project

function ScalpGM_UnitTest ()

% Test 1: Process whole folder then calculate mean image

folder = '.\Data3';
% ScalpGM(folder,1);

% get images from log file
logfile = strcat(folder,'\ScalpGM_log.txt');
f = fopen(logfile);
LOG = textscan(f, '%s %s\t%s\t%s\t%s\t%s\t%s\t%s\n');
fclose(f);
nimages = size(LOG,1);
distfile = strcat(folder,'\',LOG{6})
% only one!

% send images to meanimage script
ScalpGM_MeanImage(distfile)