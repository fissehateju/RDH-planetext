clear
clc
addpath(genpath('D:\�ҵ�����\�ҵĴ���\JPEG_Toolbox'));
Data = round(rand(1,1000000)*1);%�������01���أ���ΪǶ�������
payload =1000000;
I = imread('Splash.tiff');
imwrite(I,'photo_name.jpg','jpeg','quality',70);%������������Ϊ70��JPEGͼ��
imwrite(I,'Ori_photo.jpg','jpeg','quality',70);%������������Ϊ70��JPEGͼ��
%% ����JPEG�ļ�
jpeg_info = jpeg_read('photo_name.jpg');%����JPEGͼ��
ori_jpeg = imread('photo_name.jpg');%��ȡԭʼjpegͼ��
quant_tables = jpeg_info.quant_tables{1,1};%��ȡ������
dct_coef = jpeg_info.coef_arrays{1,1};%��ȡdctϵ��
%% ����Ƕ�� 
[emdData,numData,jpeg_info_stego] = jpeg_emdding(Data,dct_coef,jpeg_info,payload);
jpeg_write(jpeg_info_stego,'stego_photo.jpg');%��������jpegͼ��
stego_jpeg  = imread('stego_photo.jpg');%��ȡ����jpegͼ��
%% ������ȡ
stego_jpeg_info = jpeg_read('stego_photo.jpg');%����JPEGͼ��
[numData2,stego_jpeg_info,extData] = jpeg_extract(stego_jpeg_info,payload);
jpeg_write(stego_jpeg_info,'re_photo.jpg');%����ָ�jpegͼ��
re_jpeg = imread('re_photo.jpg');%��ȡ�ָ�jpegͼ��
%% ��ʾ
figure;
subplot(221);imshow(I);title('tiffԭʼͼ��');%��ʾԭʼͼ��
subplot(222);imshow(ori_jpeg);title('jpegԭʼͼ��');%��ʾJPEGѹ��ͼ��
subplot(223);imshow(stego_jpeg);title('����ͼ��');%��ʾstego_jpeg
subplot(224);imshow(re_jpeg);title('�ָ�ͼ��');%��ʾ�ָ�ͼ��
%% ͼ�������Ƚ�
psnrvalue1 = psnr(ori_jpeg,stego_jpeg);
psnrvalue2 = psnr(ori_jpeg,re_jpeg);
v = isequal(emdData,extData);
if psnrvalue2 == -1
    disp('�ָ�ͼ����ԭʼͼ����ȫһ�¡�');
elseif psnrvalue2 ~= -1
    disp('warning���ָ�ͼ����ԭʼͼ��һ�£�');
end
if v == 1
    disp('��ȡ������Ƕ��������ȫһ�¡�');
elseif v ~= 1
    disp('warning����ȡ������Ƕ�����ݲ�һ��');
end
ori_filesize = imfinfo('stego_photo.jpg');
disp(numData);
disp(psnrvalue1)