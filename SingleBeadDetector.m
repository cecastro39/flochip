function [CENTERS_Flt2,RADII_Flt2] = SingleBeadDetector(CENTERS,RADII,PrxFlt)
TotalN=length(RADII);
BeadProxIndex=zeros(1,TotalN);
n=1;
for i=1:TotalN-1
     for j=i+1:TotalN
         if sqrt((CENTERS(i,1)-CENTERS(j,1))^2+(CENTERS(i,2)-CENTERS(j,2))^2)<PrxFlt
             BeadProxIndex(i)=1;
             BeadProxIndex(j)=1;
         end
     end
     if any(BeadProxIndex(i))
     else
         CENTERS_Flt(n,:)=CENTERS(i,:);
         RADII_Flt(n,:)=RADII(i,:);
         n=n+1;
     end
end
m=1;
for i=1:n-1
    if PrxFlt<CENTERS_Flt(i,1) && CENTERS_Flt(i,1)<512-PrxFlt
        if PrxFlt<CENTERS_Flt(i,2) && CENTERS_Flt(i,2)<512-PrxFlt
            CENTERS_Flt2(m,:)=CENTERS_Flt(i,:);
            RADII_Flt2(m,:)=RADII_Flt(i,:);
            m=m+1;
        end
    end
end     

end

