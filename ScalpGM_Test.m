% A wrapper function to benchmark the pipeline

function ScalpGM_Test ()

txtfile = 'OASIS-JuneTest.txt';
nFiles = 2; % TODO - count!

tic;

% run main routine
ScalpGM(txtfile)

t1 = toc;

% Calculate mean image
ScalpGM_MeanImage(txtfile)

t2 = toc;


str1 = strcat('Total elapsed time : ', num2str(t2));
str2 = strcat('ScalpGM time : ', num2str(t1), ' (or ', ...
    num2str(t1/nFiles), ' per file).');
disp(str1)
disp(str2)

% txt = strcat('Elapsed time after ScalpGM: ', num2str(t1));
% txt = strcat(txt, '. Then after MeanImage: ', num2str(t2), '.');

% txt = strcat(str1,str2);

% disp(txt)