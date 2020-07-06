clear
clc
% I = imread('lena.tiff');
I = imread('Baboon.tiff');
origin_I = double(I); 
%% �������Ƕ������
e = 0.09; %Ƕ����/BPP
num = floor(512*512*e);
% num = 64281;  %Lena���Ƕ����
% num = 21895;  %Baboon���Ƕ����
rand('seed',0); %��������
D = round(rand(1,num)*1); %�����ȶ������
%% Ƕ������
[stego_I,emD,sign] = embed(origin_I,D);
%% ��ȡ����
[recover_I,exD] = extract(stego_I,num,sign);
%% ͼ��Ա�
figure;
subplot(221);imshow(origin_I,[]);title('ԭʼͼ��');
subplot(222);imshow(stego_I,[]);title('����ͼ��');
subplot(224);imshow(recover_I,[]);title('�ָ�ͼ��');
%% �жϽ���Ƿ���ȷ
psnrvalue = psnr(origin_I,stego_I)
isequal(emD,exD)
isequal(origin_I,recover_I)
%% ����Ƕ�����������µ�PSNRֵ
% [PSNR1] = psnr_num(origin_I);
% x =[1:1:14];
% figure;
% plot(x(1,:),PSNR1(1,:),'r-*');
% %legend('��άֱ��ͼƽ��');
% title('��άֱ��ͼƽ�Ʒ���������Ƕ�����������µ�PSNR����ͼ');
% xlabel('����Ƕ����(��λ��5*10^3 bit)','LineWidth',14);  
% ylabel('PNSRֵ','LineWidth',14); 