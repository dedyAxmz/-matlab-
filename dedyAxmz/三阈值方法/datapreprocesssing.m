function [ pre_data ] = datapreprocesssing( data )
%��IMU �ɼ�������ԭʼ���ݽ�������Ԥ����
%ʹ����ֵ�˲��͵�ͨ�˲��˲��㷨����ȥ������ʹ��������׼��ȥ���쳣ֵ
%ȥ������
%
pre_data=[];
[m,n]=size(data);
 for i=1:n
    %������׼��ȥ�쳣
    d=data(:,i);
    ave=mean(d);%��ƽ��ֵ
    u=std(d);%���׼��
    [m,w]=size(d);%��ȡ��С
    for j=2:m-1
        if(abs(d(j)-ave)>3*u)%������������׼�򣬾�ֵ�޸�
            d(j)=0.5*(d(j-1)+d(j+1));
        else
            continue;
         end 
    end

%��ֵ�˲��͵�ͨ�˲�
%     %С����ֵ�˲�
%     [thr,sorh,keepapp] = ddencmp('den','wv',d);
%     %���źŽ�������
%     data_no_noise = wdencmp('gbl',d,'db4',2,thr,sorh,keepapp);
      data_no_noise=smooth(d,3);
%     data_no_noise=smooth(data_no_noise,'moving');
      %data=smooth(d,n);
%     %ȥ������
%     average_1=mean(d_no_noise);
%     detrend_d_no_noise = detrend(d_no_noise);
%     d_no_noise_de=detrend_d_no_noise+average_1;
      pre_data=[pre_data,data_no_noise];
 end

end