clear
clc 
%I = imread('����ͼ��/Lena.tiff'); %����ͼ��s=7/s=10
 I = imread('����ͼ��/Baboon.tiff'); % s=39/s=��
% I = imread('����ͼ��/Airplane (F-16).tiff'); % s=4/s=5
% I = imread('����ͼ��/Peppers.tiff'); % s=10/s=15
% I = imread('����ͼ��/Sailboat on lake.tiff'); % s=11/s=24
% I = imread('����ͼ��/Fishing boat.tiff'); % s=12/s=21
origin_I = double(I);
%% ������������������
% e = 0.1; %Ƕ����/BPP
% num = floor(512*512*e); % 10000/20000
num = 10000;
% for i=1:100 %ȡ100�鲻ͬ����
i=1;
rand('seed',i); %��������
D = round(rand(1,num)*1); %�����ȶ������
%% ���ò���������Ƕ����
s = 39;
%% ����Ƕ��
[emD,num_emD,stego_I] = Embedding(D,origin_I,s);
% p = psnr(origin_I,stego_I);
% PSNR(i) = p;
% if num_emD<num
%     error = 0 %�ж�ѭ��������Ƕ�������޴���
% end
% end
% PSNR_sum=0;
% for x=1:100
%     PSNR_sum = PSNR_sum + PSNR(x);
% end
% origin = PSNR_sum/100 %100�����ݵ�ƽ��PSNR
% PSNR(101) = origin;
%% ������ȡ�ͻָ�
[exD,recover_I] = Extract(stego_I,s,num);
%% ͼ��Ա�
figure;
subplot(221);imshow(origin_I,[]);title('ԭʼͼ��');
subplot(222);imshow(stego_I,[]);title('����ͼ��');
subplot(224);imshow(recover_I,[]);title('�ָ�ͼ��');
%% �жϽ���Ƿ���ȷ
psnrvalue = psnr(origin_I,stego_I)
isequal(emD,exD)
isequal(origin_I,recover_I)
