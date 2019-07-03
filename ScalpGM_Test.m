% A wrapper function to benchmark the pipeline

function ScalpGM_Test ()

% txtfile = 'OASIS-JuneTest.txt';
txtfile = 'OASIS-Disc11-Test.txt';
% txtfile = 'OASIS-Test11.txt';
t = readtable(txtfile);
nFiles = size(t,1);
% nFiles = 2; % TODO - count!

% tic;

% run main routine
ScalpGM(txtfile)

% t1 = toc;

% Calculate mean image
ScalpGM_MeanImage(txtfile)

% t2 = toc;


% str1 = strcat('Total elapsed time : ', num2str(t2));
% str2 = strcat('ScalpGM time : ', num2str(t1), ' (or ', ...
%     num2str(t1/nFiles), ' per file).');
% disp(str1)
% disp(str2)

% bit ugly...
mIm = 'OASIS-JuneTest_mean.nii';
figure;
ScalpGM_ViewM1Slice(mIm);