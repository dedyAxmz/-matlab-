%�����ٶȷֱ淽��
clc;
close all;
clear;
%����Ԥ����
DATA=xlsread('C:\Users\201810\Desktop\�ڶ�����Ŀ\����1.xlsx',1);%������
%data=DATA(:,1:3).*9.8;
data=DATA(:,4:9);
%pre_data=data;
[pre_data] = datapreprocesssing(data);
%��һ��
% [pre_data PS] = mapminmax(predata',0,1);
% pre_data = pre_data';
%---------------------------------------
ax=pre_data(:,1);ay=pre_data(:,2);az=pre_data(:,3);
wx=pre_data(:,4);wy=pre_data(:,5);wz=pre_data(:,6);
acceleration=sqrt(ax.*ax+ay.*ay+az.*az);%���ٶ�
gyrocope=sqrt(wx.*wx+wy.*wy+wz.*wz);%���ٶ�
% % %���ٶȼ�ֵ
% % Ϊʲôȡ80
% gy=gyrocope(80:length(gyrocope),1);
% ayy=ay(80:length(gyrocope),1);
% % ��С��ֵ��ô���ã�-1
% %���ٶȷ�ֵ�ҳ�
% [pk,loc] = findpeaks(gy,'minpeakheight',1441);
% %���ٶ�ƫ��
% alrfa=abs(acceleration-9.8);
% % %swing phase
% se_Start=[];se_End=[];
% for i=1:length(loc)
%     Start=loc(i)-22;se_Start=[se_Start;Start];
%     End=loc(i)+33;se_End=[se_End;End];
% end
% %2ֵ��
% seq=[se_Start,se_End];
% zupt=ones(length(ayy),1);
% for i=1:length(seq)
%     LL=seq(i,2)-seq(i,1);
%     zupt(seq(i,1):seq(i,2))=zeros(LL+1,1);
% end 
% %dertx=0.4;derty=0.14;dertz=0.13;
% dertx=0.2370;derty=0.2170;dertz=0.3240;
% %�����ж�
% beita=dertx+derty+dertz;
% s=length(alrfa);
% zupt=zeros(s,1);
% for i=1:length(alrfa)
%     if alrfa(i,:)<=beita
%         zupt(i,:)=1;
%     elseif beita<alrfa(i,:)<=0.34*9.8
%         zupt(i,:)=0;
%     else
%         zupt(i,:)=2;
%     end      
% end
% 
% % %����ʱ��Լ��
% stop_poit=diff(zupt);
% Start=find(stop_poit==-1);
% End=find(stop_poit==1);
% End=[1;End];
% Start=[Start];
% T1_terval=abs(End-Start);
% ft=find(T1_terval<=3);
% for i=1:length(ft)
% zupt(End(ft(i)):Start(ft(i)),1)=zeros(Start(ft(i))-End(ft(i))+1,1);
% end

%_______________________������һ��
Var1=[];
window=3;
for i=1:length(ay)-window
    V=var(ay(i:i+window,:));
    Var1=[Var1;V];  
end
row=length(Var1)
a_zupt=zeros(row,1);
for i=1:row
    if Var1(i)<=0.22
      a_zupt(i)=1;
    end
end
stop_poit=diff(a_zupt);
Start=find(stop_poit==-1);
End=find(stop_poit==1);
End=[1;End];
Start=[Start;length(a_zupt)];
T1_terval=abs(End-Start);
ft=find(T1_terval<=7);
for i=1:length(ft)
  a_zupt(End(ft(i)):Start(ft(i)),1)=zeros(Start(ft(i))-End(ft(i))+1,1);
end
x=1:1000;
plot(x,ay(1:1000),x,a_zupt(1:1000).*10);