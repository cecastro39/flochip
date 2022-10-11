clc, clear all, close all
original_path = cd;
[f_name1, path_name, filter_index] = uigetfile('.tif','Select first image of sequence');
cd(path_name);
[f_name2, path_name, filter_index] = uigetfile('.tif','Select last image of sequence');
DigitNum=inputdlg({'Enter The Digit#'},'Digit Number',[1  35],{'3'});
n=str2double(DigitNum);
s_first = f_name1((length(f_name1)-3-n):(length(f_name1)-4));
s_last = f_name2((length(f_name2)-3-n):(length(f_name2)-4));
i_first = str2double(s_first);
i_last = str2double(s_last);
%%
cd(path_name);
Im_First=imread(f_name1);
Im_First=im2double(Im_First);
imshow(Im_First)
hold on
newbead='Yes';
Prox=inputdlg({'Enter The Proximity Filter'},'Digit Number',[1  35],{'1'});
PrxFilter=str2double(Prox);
ref=[100 100 2*PrxFilter 4*PrxFilter];
cnt=1;
while strcmp(newbead,'Yes')
    BeadRect = imrect(gca(figure(1)),ref);
    pause
    BeadCoor=BeadRect.getPosition;
    BeadCnt(cnt,:)=[floor(BeadCoor(2)+0.5*BeadCoor(4)) floor(BeadCoor(1)+0.5*BeadCoor(3))];
    cnt=cnt+1;
    delete(BeadRect);
    ref=BeadCoor;
    rectangle('Position',BeadCoor,'EdgeColor','r');
    newbead = questdlg('New Bead?','','No','Yes','Yes');
end
%%
for i=1:cnt-1
    figure(1)
    NUM=num2str(i);
    text(BeadCnt(i,2)-0.5*PrxFilter,BeadCnt(i,1)-0.5*PrxFilter,NUM,'HorizontalAlignment','Right','Color','b','FontSize',8);
    Im_Cut{i}=Im_First(BeadCnt(i,1)-PrxFilter:BeadCnt(i,1)+PrxFilter,BeadCnt(i,2)-PrxFilter:BeadCnt(i,2)+PrxFilter);
    FFTFirst{i}=fft2(Im_Cut{i});
end
%%
OutputC=[];
OutputUpsC=[];
OutputUps2C=[];
Ups=inputdlg({'Enter The Upsacling Factor'},'Digit Number',[1  35],{'16'});
k=str2double(Ups);
%%
for imgindex=i_first:i_last
    j=imgindex-i_first+1;
    cd(path_name);
    i_str = sprintf('%04d',imgindex)
    f_name = strcat(f_name1(1:(length(f_name1)-n-4)),i_str,'.tif')
    Im = im2double(imread(f_name));
    cd(original_path);
    for i=1:cnt-1
        ImC_Cut{i}=Im(BeadCnt(i,1)-PrxFilter: BeadCnt(i,1)+PrxFilter,BeadCnt(i,2)-PrxFilter:BeadCnt(i,2)+PrxFilter);
        FFTC{i}=fft2(ImC_Cut{i});
        [Output(i,:) CCabs{i}]=FTups(FFTC{i},FFTFirst{i},1);
        [OutputUps(i,:) CCabs{i}]=FTups(FFTC{i},FFTFirst{i},k);
        %OutputUps2(i,:)=FTups(FFTC{i},FFTFirst{i},400);
    end
    OutputC=[OutputC Output];
    OutputUpsC=[OutputUpsC OutputUps];
    %OutputUps2C=[OutputUps2C OutputUps2];
end
%%
cd(path_name);
Scl=inputdlg({'Enter The Scale Size'},'Digit Number',[1  35],{'400'});
Scale=str2double(Scl);
TotalNFlt=cnt-1;
filename=['DisplacementData'];
% xlswrite(filename,{'k=1'},'X','C3')
% xlswrite(filename,{'k=1'},'Y','C3')
% loc2=strcat('C',num2str(TotalNFlt+3));
% xlswrite(filename,{'k=' num2str(k)},'X',loc2)
% xlswrite(filename,{'k=40'},'Y',loc2)
% loc3=strcat('C',num2str(2*TotalNFlt+3));
% xlswrite(filename,{'k=400'},'X',loc3)
% xlswrite(filename,{'k=400'},'Y',loc3)
% ShiftIndex=inputdlg({'Enter The Shift Index'},'Digit Number',[1  35],{'1'});
% ShiftI=str2double(ShiftIndex);
% OutputCX=OutputC(:,2:2:end); OutputCY=OutputC(:,1:2:end);
% AveCX=[mean(OutputCX(:,1:ShiftI-2),2) mean(OutputCX(:,ShiftI+2:end),2)];
% AveCY=[mean(OutputCY(:,1:ShiftI-2),2) mean(OutputCY(:,ShiftI+2:end),2)];
% OutputCX=[OutputCX AveCX]; OutputCY=[OutputCY AveCY];
xlswrite(filename,Scale*OutputC','k=1','D3')
xlswrite(filename,Scale*OutputUpsC','k=40','D3')
% loc2=strcat('D',num2str(TotalNFlt+3));
% OutputUpsCX=OutputUpsC(:,2:2:end); OutputUpsCY=OutputUpsC(:,1:2:end);
% AveUpsCX=[mean(OutputUpsCX(:,1:ShiftI-2),2) mean(OutputUpsCX(:,ShiftI+2:end),2)];
% AveUpsCY=[mean(OutputUpsCY(:,1:ShiftI-2),2) mean(OutputUpsCY(:,ShiftI+2:end),2)];
% OutputUpsCX=[OutputUpsCX AveUpsCX]; OutputUpsCY=[OutputUpsCY AveUpsCY];
% xlswrite(filename,Scale*OutputUpsCX,'X',loc2)
% xlswrite(filename,Scale*OutputUpsCY,'Y',loc2)
% loc3=strcat('D',num2str(2*TotalNFlt+3));
% OutputUps2CX=OutputUps2C(:,2:2:end); OutputUps2CY=OutputUps2C(:,1:2:end);
% AveUps2CX=[mean(OutputUps2CX(:,1:ShiftI-2),2) mean(OutputUps2CX(:,ShiftI+2:end),2)];
% AveUps2CY=[mean(OutputUps2CY(:,1:ShiftI-2),2) mean(OutputUps2CY(:,ShiftI+2:end),2)];
% OutputUps2CX=[OutputUps2CX AveUps2CX]; OutputUps2CY=[OutputUps2CY AveUps2CY];
% xlswrite(filename,Scale*OutputUps2CX,'X',loc3)
% xlswrite(filename,Scale*OutputUps2CY,'Y',loc3)
