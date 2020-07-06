clear
clc
I = imread('lena.tiff');
% I = imread('Baboon.tiff');
origin_I = double(I); 
%% ������������������
e = 0.8; %Ƕ����/BPP
num = floor(512*512*e);
rand('seed',1); %��������
D = round(rand(1,num)*1); %�����ȶ������
%% Ƕ������
[stego_I,emD,S_Shadow,Opt_Shadow,map1,end_x1,end_y1,S_Blank,Opt_Blank,map2,end_x2,end_y2] = Embed(origin_I,D);
%% ��ȡ����
[recover_I,exD] = Extract(stego_I,S_Shadow,Opt_Shadow,map1,end_x1,end_y1,S_Blank,Opt_Blank,map2,end_x2,end_y2);
%% ͼ��Ա�
figure;
subplot(221);imshow(origin_I,[]);title('ԭʼͼ��');
subplot(222);imshow(stego_I,[]);title('����ͼ��');
subplot(224);imshow(recover_I,[]);title('�ָ�ͼ��');
%% �жϽ���Ƿ���ȷ
psnrvalue = PSNR(origin_I,stego_I)
isequal(emD,exD)
isequal(origin_I,recover_I)