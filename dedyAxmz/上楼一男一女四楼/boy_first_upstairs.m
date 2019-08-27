%步行速度分辨方法
clc;
close all;
clear;
%数据预处理
DATA=xlsread('C:\Users\201810\Desktop\dedyAxmz\数据\100Hz数据\上楼\上楼男一组.xlsx',1);%体育场
%data=DATA(:,1:3).*9.8;
data=DATA(:,2:7);
[predata] = datapreprocesssing(data);
% wg_ay=predata(:,2);
%归一化
[pre_data PS] = mapminmax(predata',0,1);
pre_data = pre_data';
ax=pre_data(:,1);ay=pre_data(:,2);az=pre_data(:,3);
wx=pre_data(:,4);wy=pre_data(:,5);wz=pre_data(:,6);
acceleration=sqrt(ax.*ax+ay.*ay+az.*az);%加速度
gyrocope=sqrt(wx.*wx+wy.*wy+wz.*wz);%角速度
%% 步伐数及步伐频率统计
%% 步伐数及步伐频率统计
%局部峰值位置统计
%单步左波峰点
    window=125;
    left_peaks_locs=[];
    for n=1:15
            [pks,locs] = findpeaks(ay(100+window*(n-1):140+window*(n-1)),'MinPeakHeight',0.37,'MinPeakDistance',5);
            locs=locs+99+window*(n-1);
            left_peaks_locs=[left_peaks_locs;locs];
    end
    window=130;
    for n=1:11
            [pks,locs] = findpeaks(ay(2001+window*(n-1):2041+window*(n-1)),'MinPeakHeight',0.37,'MinPeakDistance',3);
            locs=locs+2000+window*(n-1)
            left_peaks_locs=[left_peaks_locs;locs];
    end
    window=125;
    for n=1:7
            [pks,locs] = findpeaks(ay(3471+window*(n-1):3505+window*(n-1)),'MinPeakHeight',0.37,'MinPeakDistance',4);
            locs=locs+3470+window*(n-1);
            left_peaks_locs=[left_peaks_locs;locs];
    end
    window=125;
    for n=1:10
            [pks,locs] = findpeaks(ay(4353+window*(n-1):4402+window*(n-1)),'MinPeakHeight',0.37,'MinPeakDistance',4);
            locs=locs+4352+window*(n-1);
            left_peaks_locs=[left_peaks_locs;locs];
    end
    window=136;
    for n=1:15
            [pks,locs] = findpeaks(ay(5480+window*(n-1):5526+window*(n-1)),'MinPeakHeight',0.375,'MinPeakDistance',4);
            locs=locs+5479+window*(n-1);
            left_peaks_locs=[left_peaks_locs;locs];
    end
peaks=[];
peaks=[left_peaks_locs];
for i=2:length(left_peaks_locs)
    if left_peaks_locs(i)-left_peaks_locs(i-1)<35
        peaks(i)=0;
    end
end
peaks(find(peaks==0|peaks==5388))=[];
left_peaks_locs=[peaks;5296];
plot(1:length(ay),ay,left_peaks_locs,ay(1:length(left_peaks_locs)),'o');
% [pks,locs] = findpeaks(ay(120:170),'MinPeakHeight',0.35,'MinPeakDistance',30);
%findpeaks(ay(6930:6969),'MinPeakHeight',0.33,'MinPeakDistance',7);
% findpeaks(-ay,'MinPeakHeight',-0.22,'MinPeakDistance',20);
%% %谷底点,峰值点
[pks,locs] = findpeaks(-ay,'MinPeakHeight',-0.32,'MinPeakDistance',20);
valley_locs=[locs];
%valley_locs(find(pks>=0.57))=[];
for i=2:length(locs)
    if locs(i)-locs(i-1)<45
        valley_locs(i)=0;
    end
end
valley_locs(find(valley_locs==0|valley_locs==3122|valley_locs==5361|valley_locs==1430))=[];
plot(1:length(ay),ay,valley_locs,ay(1:length(valley_locs)),'o');
%% 右波峰点
[pks,locs] = findpeaks(ay,'MinPeakHeight',0.3,'MinPeakDistance',3);
% findpeaks(ay,'MinPeakHeight',0.3,'MinPeakDistance',3);
right_peaks_locs=locs;
lr_locs=[right_peaks_locs;valley_locs];
lr_locs=sort(lr_locs);
true_right__peaks_locs=[];
for x=1:length(valley_locs)
    for(y=1:length(lr_locs))
        if valley_locs(x)==lr_locs(y)
           true_right__peaks_locs=[true_right__peaks_locs;lr_locs(y+1)];
        end
    end
end
right_peaks_locs=true_right__peaks_locs;
plot(1:length(ay),ay,right_peaks_locs,ay(1:length(right_peaks_locs)),'o');
%% 两波峰一波谷
plus_locs=[right_peaks_locs;valley_locs;left_peaks_locs];
plus_locs=sort(plus_locs);
locate=[];
for x=1:length(valley_locs)
    for(y=1:length(plus_locs))
        if valley_locs(x)==plus_locs(y)
           locate=[locate;plus_locs(y-1);plus_locs(y+1)];
        end
    end
end
step_number=length(locate)/2;
%左移，右移15，分割0,1线
cutline0_1_locs=[];
for t=1:length(locate)
    if mod(t,2)==1 %奇数
         cutline0_1_locs(t)=locate(t)-0;
    else cutline0_1_locs(t)=locate(t)+0;
    end
end
%zupt矩阵
zupt=zeros(size(ay));
for f=1:length(cutline0_1_locs)-1
    if mod(f,2)==1 %摆动阶段
       for h=cutline0_1_locs(f):cutline0_1_locs(f+1)
            zupt(h)=1;
       end
    end
end
zupt=~zupt;
zupt=double(zupt);
x=1:length(ay);
plot(x,ay,x,zupt);
x=3001:6000;
plot(x,ay(3001:6000),x,zupt(3001:6000));
plot(x(1:1000),ay(1:1000),x(1:1000),zupt(1:1000))
%局部峰值画图
%圆圈
% plot(1:length(ay),ay,cutline0_1_locs,pks,'o');
% %倒三角
findpeaks(ay,'MinPeakHeight',0.35,'MinPeakDistance',20);
findpeaks(-ay,'MinPeakHeight',-0.32,'MinPeakDistance',20);
%text(locs + .02,mcc,num2str((1:numel(pks))'));数据标记
% %% 上楼平走下楼不同行走状态（气压计）
% %alt=DATA(:,3);
% %% 方差阈值
% Var1=[];
% window=3;
% for i=1:length(ay)-window
%     V=var(ay(i:i+window,:));                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
%     Var1=[Var1;V];  
% end
% %方差阈值识别结果
% var_test0_1=zeros(length(Var1),1);
% for i=1:length(Var1)
%     if Var1(i)<=0.000005
%       var_test0_1(i)=1;
%     end
% end
% x=1:length(ay)-window;
% plot(x,Var1(1:length(ay)-window).*10,x,ay(1:length(ay)-window),x,var_test0_1(1:length(ay)-window));
% %% 时间间隔(<11)阈值，误判检测
% stop_poit=diff(var_test0_1);
% Start1=find(stop_poit==-1);
% End1=find(stop_poit==1);
% End1=[1;End1];
% Start1=[Start1;length(var_test0_1)];
% T1_terval=abs(End1-Start1);
% error_positon=find(T1_terval<=3);
% for p=1:length(error_positon)
%   var_test0_1(End1(error_positon(p)):Start1(error_positon(p)),1)=zeros(Start1(error_positon(p))-End1(error_positon(p))+1,1);
% end
% x=1:length(ay)-window;
% plot(x,Var1(1:length(ay)-window).*10,x,ay(1:length(ay)-window),x,var_test0_1(1:length(ay)-window));
% %% 陀螺仪的观测值阈值
% %%计算范数矩阵gyro_xyzfan
% wi=[wx,wy,wz]';
% gyro_xyzfan=[];
% for j=1:length(wi)
%     gyro=norm(wi(1:3,j)).*norm(wi(1:3,j));
%     gyro_xyzfan=[gyro_xyzfan;gyro];  
% end
% %范数矩阵方差
% gyro_xyzfan_Var=[];
% window=3;
% for m=1:length(gyro_xyzfan)-window
%     gyro_var=var(gyro_xyzfan(m:m+window,:));                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
%     gyro_xyzfan_Var=[gyro_xyzfan_Var;gyro_var];  
% end
% %%陀螺仪阈值识别结果,（对方差）
% gyro_xyzfan_Var0_1=zeros(size(gyro_xyzfan_Var));
% for n=1:length(gyro_xyzfan_Var)
%     if gyro_xyzfan_Var(n)<0.0015
%       gyro_xyzfan_Var0_1(n)=1;
%     end
% end 
% x=1:length(ay)-window;
% plot(x,gyro_xyzfan_Var(1:length(ay)-window).*10,x,gyro_xyzfan(1:length(ay)-window),x,gyro_xyzfan_Var0_1(1:length(ay)-window));
% %% 时间间隔阈值，误判检测
% stop_poit=diff(gyro_xyzfan_Var0_1);
% Start2=find(stop_poit==-1);
% End2=find(stop_poit==1);
% End2=[1;End2];
% Start2=[Start2;length(gyro_xyzfan_Var0_1)];
% T2_terval=abs(End2-Start2);
% error_positon=find(T2_terval<=10);
% for p=1:length(error_positon)
%   gyro_xyzfan_Var0_1(End2(error_positon(p)):Start2(error_positon(p)),1)=zeros(Start2(error_positon(p))-End2(error_positon(p))+1,1);
% end
% x=1:length(ay)-window;
% plot(x,gyro_xyzfan_Var(1:length(ay)-window).*10,x,gyro_xyzfan(1:length(ay)-window),x,gyro_xyzfan_Var0_1(1:length(ay)-window));
% %% %% 双阈值相与为1，才置1
% var_gyro_0_1=zeros(length(var_test0_1),1);
% for k=1:length(var_test0_1)
%     if gyro_xyzfan_Var0_1(k) && var_test0_1(k)==1
%        var_gyro_0_1(k)=1; 
%     end 
% end
% x=1:length(ay)-window;
% plot(x,gyro_xyzfan_Var(1:length(ay)-window).*10,x,gyro_xyzfan(1:length(ay)-window),x,var_gyro_0_1(1:length(ay)-window));
% %步态结果区分画图（检测结果0:1000）对不对
% x=1:length(ay)-window;
% plot(x,acceleration(1:length(ay)-window),x,gyro_xyzfan(1:length(ay)-window),x,var_gyro_0_1(1:length(ay)-window));
% plot(x,ay(1:length(ay)-window),x,var_gyro_0_1(1:length(ay)-window));