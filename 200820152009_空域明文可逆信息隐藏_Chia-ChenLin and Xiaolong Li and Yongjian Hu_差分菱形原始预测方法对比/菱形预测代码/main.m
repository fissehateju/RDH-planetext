clear
clc
I=imread('lena.tiff');
I=double(I);
pixelnum=50000;                         %������Ϣ������
data=randi([0,1],1,pixelnum);           %����������Ϣ
[P,PE]=RhombusPredictionValue(I);       %Ԥ��ֵ
% H=GetHis(P);
% plot(-255:255,H);
[I1,end1,flg]=embed(I,data,pixelnum);
ans1=psnr(I,I1);
[rdata,I2]=Rget(I1,end1,flg,pixelnum);
ans2=isequal(I,I2);
ans3=isequal(data,rdata);

