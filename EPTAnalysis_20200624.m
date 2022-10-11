clc, clear all
[f_name1, path_name, filter_index] = uigetfile('.xls','Select the bead data');
cd(path_name);
%[f_name2, path_name, filter_index] = uigetfile('.xls','Select the rest info data');
cd(path_name);
Data=xlsread(f_name1,'k=40');
%Test=xlsread(f_name2);
LN=size(Data);
L=LN(1)/2;
N=LN(2);
%Flowrate=0.4:0.4:4;
%Flowrate=[0 -10 10 Flowrate];
Q=2;
Test(:,1)=185.16/L:185.16/L:185.16;
%%
for i=1:L
    if Test(i,1)<25
        Test(i,2)=-100;
    elseif Test(i,1)<50
        Test(i,2)=100;
    elseif Test(i,1)<60
        Test(i,2)=0;
    else
        Test(i,2)=9.9*((Test(i,1)-60)/120)+0.1;
    end
end
%%
for i=1:L
    if Test(i,2)==-100
        Ind(1,:)=[Test(i,1) i];
    elseif Test(i,2)==100
        Ind(2,:)=[Test(i,1) i];
    elseif Test(i,2)==0 && Test(i,1)<60
        Ind(3,:)=[Test(i,1) i];
    end
end
%% 
DATAX=Data(2:2:end,:);
DATAY=Data(1:2:end,:);
CenterBackw=[mean(DATAX(150:Ind(1,2)-10,:),1); mean(DATAY(150:Ind(1,2)-10,:),1)];
CenterForw=[mean(DATAX(Ind(1,2)+150:Ind(2,2)-10,:),1); mean(DATAY(Ind(1,2)+150:Ind(2,2)-10,:),1)];
Center=[mean([CenterBackw(1,:);CenterForw(1,:)],1); mean([CenterBackw(2,:);CenterForw(2,:)],1)];
%%
DataX_Offset=DATAX-Center(1,:);
DataY_Offset=DATAY-Center(2,:);
%%
Cnt2Cnt=CenterForw-CenterBackw;
Teta=atan(Cnt2Cnt(2,:)./Cnt2Cnt(1,:));
%%
%RotMatrix=[cos(Teta) -sin(Teta);sin(Teta) cos(Teta)];
for j=1:N
        for i=1:L
            RotMatrix=[cos(Teta(j)) -sin(Teta(j));sin(Teta(j)) cos(Teta(j))];
            RotCnt=RotMatrix*[DataX_Offset(i,j);DataY_Offset(i,j)];
            DataX_Rot(i,j)=RotCnt(1);
            DataY_Rot(i,j)=RotCnt(2);
        end
end
%%
%[f_name1, path_name, filter_index] = uigetfile('.xls','Select the beads size sheet');
%cd(path_name);
%Beads=xlsread(f_name1);
r0=1100;
for j=1:length(Q)
    j
        YAve(j,:)=mean(DataY_Rot(Ind(j+2,2)+50:Ind(j+3,2)-50,:),1);
        XAve(j,:)=mean(DataX_Rot(Ind(j+2,2)+50:Ind(j+3,2)-50,:),1);
        Le(j,:)=sqrt((XAve(j,:)).^2+r0^2);
        MSDY(j,:)=var(DataY_Rot(Ind(j+2,2)+50:Ind(j+3,2)-50,:));
        F(j,:)=4.114*Le(j,:)./MSDY(j,:);
        L0(j,:)=Le(j,:)-r0;
end
xlswrite([f_name1 '_EPT'],F)

%for j=4:L-1
    
    

    

