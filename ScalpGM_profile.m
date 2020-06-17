
function ScalpGM_profile ()

d = 'C:\OASIS\X';


profile on
tic

ScalpGM ('folder',d)


t = toc;
profile viewer


m = floor(t/60);
s = floor(rem(t,60));

sprintf('Elapsed time : %dm%ds',m,s)