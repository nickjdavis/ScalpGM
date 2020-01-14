% figure out stats for CoV

function TestCoVstats ()


% load cov image
covfile = 'AllPOSTFIX_M.nii';
covimg = spm_read_vols(spm_vol(covfile));

S=size(covimg);
n=S(1)*S(2)*S(3);
Y=reshape(covimg,[n 1]);
Y = Y(find(~isnan(Y)));
n = length(Y)

% histogram
lc = round(.025*n)
uc = round(.975*n)
figure
hist(Y,100)
hold on;
axlim = get(gca,'YLim');
axhor = get(gca,'XLim');
set(gca,'XLim',[0 axhor(2)]);
% line ([lc lc],[0 axlim(2)])
% line ([uc uc],[0 axlim(2)])

Yorder = sort(Y);
% LY = Yorder(1:lc); lcx = LY(end);
% UY = Yorder((n-uc):end)
lcx = Yorder(lc)
ucx = Yorder(uc)

line ([lcx lcx],[0 axlim(2)])
line ([ucx ucx],[0 axlim(2)])

% 
% % STATS - see eq. 32 of Abu-Shawiesh et al 2019
% % http://iapress.org/index.php/soic/article/viewFile/soic.190602/488
% 
m = nanmean(Y)
% S2 = nanvar(Y);
% m4= sum((Y-m).^4)/n;
% m2= sum((Y-m).^2)/n;
% g2= (m4/m2)-3;
% G2= ((n-1)/((n-2)*(n-3)))*((n-1)*g2+6);
% Ke5=((n+1)/(n-1))*G2*(1+(5*G2)/n);
% C = (Ke5+((2*n)/(n-1)))/(2*n);
% % B = var(log(nanvar(Y)))
% VarLogS2 = (1/n)*(G2+((2*n)/(n-1)))*(1+(1/(2*n))*(G2+((2*n)/(n-1))));
% B = VarLogS2;
% 
% 
% p = icdf('normal',[0.025 0.975]);
% CI = [m*sqrt(exp( p(1)*sqrt(B)+C)), ...
%       m*sqrt(exp( p(2)*sqrt(B)+C))]
% 
% % alpha = 0.05;
% % CI = [m*sqrt(exp(-normcdf(1-alpha/2)*sqrt(B)+C)), ...
% %       m*sqrt(exp( normcdf(1-alpha/2)*sqrt(B)+C))]


% 
% pdN = fitdist (Y, 'normal')
% pdG = fitdist (Y, 'gamma')