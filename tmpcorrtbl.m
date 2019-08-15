function tmpcorrtbl (R,P,L)

T = [];
for l=1:length(L)
    T = [T, sprintf('\t\t%s',L{l})];
end
T = [T sprintf('\n')];
    
for i=1:size(R,1)
    T = [T, L{i}];
    for j=1:size(R,2)
       T = [T sprintf('\t%1.3f',R(i,j))];
       if P(i,j)<0.05
           if P(i,j)<0.01
               T = [T '**'];
           else
               T = [T '*'];
           end
       end
    end
    T = [T sprintf('\n')];
end

disp(T)