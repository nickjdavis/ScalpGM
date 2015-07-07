function [P,I] = checktb ()
v = ver;
[installedToolboxes{1:length(v)}] = deal(v.Name);
P = all(ismember('Parallel Computing Toolbox',installedToolboxes));
I = all(ismember('Image Processing Toolbox',installedToolboxes));