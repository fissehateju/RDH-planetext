clear
clc
I=imread('H:\����Ŀ\ͼ��\Lena.tiff');
I=double(I);
pixelnum=50000;%������Ϣ������
data=randi([0,1],1,pixelnum);           %����������Ϣ
[PExh,PExv,PE]=DirectionalPredictionValue(I);       %Ԥ�����
H=GetHis(PE);
bar(-255:255,H);
[I1,end1,flg]=Embed(I,data,pixelnum);
[rdata,I2]=Extract(I1,end1,flg,pixelnum);
figure;
I=uint8(I);
I1=uint8(I1);
I2=uint8(I2);
subplot(1,3,1);imshow(I);title('tiffԭʼͼ��');%��ʾԭʼͼ��
subplot(1,3,2);imshow(I1);title('����ͼ��');%��ʾ����ͼ��
subplot(1,3,3);imshow(I2);title('�ָ����ͼ��');%��ʾ�ָ�ͼ��
ans1=psnr(I,I1);
ans2=isequal(I,I2);
ans3=isequal(data,rdata);
if ans2 == 1
    disp('�ָ����ͼ����ԭʼͼ��һ��');
elseif ans2 ~= 1
    disp('warning���ָ�ͼ����ԭʼͼ��һ�£�');
end
if ans3 == 1
    disp('��ȡ����������Ƕ������һ��');
elseif ans3 ~= 1
    disp('warning����ȡ������Ƕ�����ݲ�һ�£�');
end

