function [ pre_data ] = datapreprocesssing( data )
%对IMU 采集回来的原始数据进行数据预处理
%使用中值滤波和低通滤波滤波算法进行去噪声，使用拉依达准则去除异常值
%去趋势相
%
pre_data=[];
[m,n]=size(data);
 for i=1:n
    %拉依达准则去异常
    d=data(:,i);
    ave=mean(d);%求平均值
    u=std(d);%求标准差
    [m,w]=size(d);%读取大小
    for j=2:m-1
        if(abs(d(j)-ave)>3*u)%不符合依拉达准则，均值修改
            d(j)=0.5*(d(j-1)+d(j+1));
        else
            continue;
         end 
    end

%中值滤波和低通滤波
%     %小波阈值滤波
%     [thr,sorh,keepapp] = ddencmp('den','wv',d);
%     %对信号进行消噪
%     data_no_noise = wdencmp('gbl',d,'db4',2,thr,sorh,keepapp);
      data_no_noise=smooth(d,3);
%     data_no_noise=smooth(data_no_noise,'moving');
      %data=smooth(d,n);
%     %去趋势项
%     average_1=mean(d_no_noise);
%     detrend_d_no_noise = detrend(d_no_noise);
%     d_no_noise_de=detrend_d_no_noise+average_1;
      pre_data=[pre_data,data_no_noise];
 end

end