clear
clc
addpath(genpath('C:\Users\Administrator\Desktop\������-E17201016-JEPGͼ���еĿ�����Ϣ����2\JPEG\jpegtbx'));%���ù�����
I = imread('Lena.tiff');
for i = 80 %10:10:90 
QF = i;%��������
imwrite(I,'Lena.jpg','jpeg','quality',QF); %������������Ϊ80��jpegͼ��
%% ����JPEG�ļ�
origin_jpeg = imread('Lena.jpg');  %��ȡԭʼjpegͼ��
jpeg_info = jpeg_read('Lena.jpg'); %����jpegͼ��
dct_coef = jpeg_info.coef_arrays{1,1}; %��ȡdctϵ��
%% ����acϵ��ֱ��ͼ
[hist_ac1,num1,num_1] = jpeg_hist(dct_coef);
figure;
bar(hist_ac1(:,1),hist_ac1(:,2),0.1);
title('��������Ϊ80��jpegͼ��ķ���acϵ��ֱ��ͼ');
num = num1 + num_1;  %���Ƕ���� 
rand('seed',0);  %��������
D = round(rand(1,num)*1); %�����ȶ������
%% ����Ƕ��
[emD,jpeg_info_stego] = emdding(D,jpeg_info);
jpeg_write(jpeg_info_stego,'stego_Lena.jpg'); %��������jpegͼ��
stego_jpeg = imread('stego_Lena.jpg'); %��ȡ����jpegͼ��
%% ������ȡ
jpeg_info_stego1 = jpeg_read('stego_Lena.jpg');%��������jpegͼ��
[exD,jpeg_info_recover] = extract(num,jpeg_info_stego1);
jpeg_write(jpeg_info_recover,'recover_Lena.jpg');%����ָ�jpegͼ��
recover_jpeg = imread('recover_Lena.jpg');%��ȡ�ָ�jpegͼ��
%% ͼ��Ա�
figure;
subplot(221);imshow(I);title('tiffԭʼͼ��');
subplot(222);imshow(origin_jpeg);title('jpegԭʼͼ��');
subplot(223);imshow(stego_jpeg);title('jpeg����ͼ��');
subplot(224);imshow(recover_jpeg);title('jpeg�ָ�ͼ��');
%% �жϽ���Ƿ���ȷ
psnrvalue = psnr(origin_jpeg,stego_jpeg);
isequal(emD,exD)
isequal(origin_jpeg,recover_jpeg)
%% �ļ���С���ӷ���
ori_filesize = imfinfo('Lena.jpg');
steo_filesize = imfinfo('stego_Lena.jpg');
Lena_ori_filesize_set(1,i/10) = ori_filesize.FileSize;
Lena_steo_filesize_set(1,i/10) = steo_filesize.FileSize;
Lena_increased_fs = (Lena_steo_filesize_set - Lena_ori_filesize_set);  %��λ���ֽڣ�
end