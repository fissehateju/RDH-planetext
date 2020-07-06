clear;
clc;
%% Ԥ����
addpath(genpath('JPEG_Toolbox'));
rng(100,'twister');

Data = round(rand(1,8000)*1);%�������01���أ���ΪǶ�������
I = imread('Lena.tiff');%��ȡtiffͼƬ����������jpegͼƬ
imwrite(I,'Lena.jpg','jpeg','quality',70);%������������ΪXX��JPEGͼ��
%% Ƕ�����
jpeg_info_ori = jpeg_read('Lena.jpg');%����JPEGͼ��
jpeg_info_stego = jpeg_info_ori;%�ļ�����һ�ݣ���Ϊ����ͼ��
quant_tables = jpeg_info_ori.quant_tables{1,1};%��ȡ������
oridct = jpeg_info_ori.coef_arrays{1,1};%��ȡdctϵ��

[n,m] = size(oridct);
Block_n = 8 * ones(1,n/8);%���ɳ���Ϊn/8��ȫ8����[8,8,8,8...]
Block_m = 8 * ones(1,m/8);
oriBlockdct = mat2cell(oridct,Block_n,Block_m);%��ԭ����ͼ�����ָ��N��8*8��Block
stegoBlockdct=oriBlockdct;

[zeronum]=Getzeronum(oriBlockdct);
[ACnum]=GetACnum(oriBlockdct);
[R]=GetR(oriBlockdct,quant_tables);

payload=length(Data);
rest=payload;
count=1;

while rest > 0
    positions(count)=R(count,1);
    rest=rest-ACnum(R(count,1),1);
    count=count+1;
end
positions=sort(positions,2);

pos=1;
count=1;
while pos<payload
    [stegoBlockdct,pos]=embed(stegoBlockdct,Data,pos,positions,zeronum(count,1),zeronum(count,2));
    count=count+1;
end

tt=stegoBlockdct;
[side]=Getside(payload,positions);
[stegoBlockdct]=LSB_en(stegoBlockdct,side);

stegodct=cell2mat(stegoBlockdct);%��hxBlockdctϸ��������hxdct����
jpeg_info_stego.coef_arrays{1,1} = stegodct;%�޸ĺ��hxdctϵ����д��JPEG��Ϣ
jpeg_write(jpeg_info_stego,'stego_Lena.jpg');%��������jpegͼ�񣬸��ݽ�����Ϣ���ع�JPEGͼ�񣬻������ͼ��


%% ��ԭ����
jpeg_info_stegoI = jpeg_read('stego_Lena.jpg');%����stegoI-JPEGͼ��
jpeg_info_recov=jpeg_info_stegoI;%��stegoI�л��һ�����ݿ���

exData=zeros();
pos=1;
count=1;
recBlockdct=tt;
while pos<payload
    [recBlockdct,exData,pos]=extract(recBlockdct,exData,pos,payload,positions,zeronum(count,1),zeronum(count,2));
    count=count+1;
end

redct=cell2mat(recBlockdct);
jpeg_info_recov.coef_arrays{1,1} = redct; %�޸ĺ��dctϵ�� д�� JPEG��Ϣ
jpeg_write(jpeg_info_recov,'recov_Lena.jpg');%��������jpegͼ��  jpeg_write�����ǽ��������еĺ���  ���ݽ�����Ϣ �ع�JPEGͼ��

%% ��ʾʵ����
ori_jpeg = imread('Lena.jpg');%��ȡԭʼjpegͼ��
stego_jpeg = imread('stego_Lena.jpg');%��ȡ����jpegͼ��
recov_jpeg = imread('recov_Lena.jpg');%��ȡ�ָ�jpegͼ��
figure;
subplot(2,2,1);imshow(I);title('tiffԭʼͼ��');%��ʾԭʼtiffͼ��
subplot(2,2,2);imshow(ori_jpeg);title('jpegԭʼͼ��');%��ʾԭʼͼ��
subplot(2,2,3);imshow(stego_jpeg);title('����ͼ��');%��ʾ����ͼ��
subplot(2,2,4);imshow(recov_jpeg);title('�ָ�ͼ��');%��ʾ�ָ�ͼ��
%% ����ʵ����
psnrvalue=psnr(ori_jpeg,stego_jpeg)
ans1=isequal(ori_jpeg,recov_jpeg);
ans2=isequal(Data,exData);