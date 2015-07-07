function testPar(T1file)

t1 = '.\data\sHIVE4-0301-00003-000001-01.img';
scalpfile = '.\data\c5sHIVE4-0301-00003-000001-01.nii';
gmfile = '.\data\c1sHIVE4-0301-00003-000001-01.nii';
scalp_points = ScalpGM_getCH(scalpfile);

pool = parpool

tic
 distfile = ScalpGM_Distance_par (scalp_points,gmfile);
 toc1=toc;
 distfile = ScalpGM_Distance_par (scalp_points,gmfile);
 toc2=toc;
 distfile = ScalpGM_Distance_par (scalp_points,gmfile);
 toc3=toc;

 fprintf('Total elapsed time: %4.2f sec\n1st : %4.2f\n2nd : %4.2f\n3rd : %4.2f\n\n',...
     toc3,toc1,toc2-toc1,toc3-toc2);
 
delete(pool)
%cd ('..')


% WITH PAR - NEWNEW
% Total elapsed time: 211.01 sec
% 1st : 70.33
% 2nd : 70.18
% 3rd : 70.49
%
% NO PAR - NEWNEW
% Total elapsed time: 250.79 sec
% 1st : 83.55
% 2nd : 83.53
% 3rd : 83.72



%     % NO PAR
%     Total elapsed time: 301.21
% Segment  : 233.60 sec
% ConvHull : 0.47
% Distance : 67.14
% MNI warp : 281.28

% % NEW NO PAR
% Total elapsed time: 83.96
% Segment  : 0.00 sec
% ConvHull : 0.45
% Distance : 83.51
% MNI warp : 237.64


