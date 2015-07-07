% Run unit tests for ScalpGM project

function ScalpGM_UnitTest ()

% Test 1: Process whole folder then calculate mean image

folder = [];
ScalpGM(folder,1);
% get images from log file
% send images to meanimage script
