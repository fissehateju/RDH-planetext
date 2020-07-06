clear
clc
I=imread('lena.tiff');
A=4;  %ÿһ��A��B��
B=4;
[P,lsum]=DivideAndGetDifferenceImageStep1(I,A,B);                          %����ÿһ��Ĳ��ͼ��
W=GetImagePeakStep2(P,lsum);                                               %�õ�ÿһ��ķ�ֵ��
Q=ShipStep3(P,W,lsum,A,B);                                                 %��ÿһ�������ƽ�ƣ����ڷ�ֵ����ƶ�һλ
Pixelnum=20000;
S=randi([0,1],1,Pixelnum);                                                 %����������Ϣ
%��ÿһ��������Ƕ��
lstart=1;                                                                  %��s�ĵ�һλ��ʼǶ��
Embed=Q;
for i=1:lsum
    %��ֵ��W��i��
    %���ͼ�� Q��i����������
    peak=W(i);
    D=Embed;
    [D,lend]=EmbedStep4(i,Embed,S,peak,lstart,Pixelnum,A,B);
    Embed=D;
    lstart=lend;
    if lstart > Pixelnum
        lastkuai=i;
        break;
    end
end
Mark=GetMarkImageStep5(I,Embed,lsum,A,B);                                  %Ƕ���ı��ͼ��
[SD,sum]=DivideAndGetDifferenceImageStep1(Mark,A,B);                       %Extrating step1
Reget=zeros(1,Pixelnum);                                                   %��ȡ��Ϣ
leend=1;
for i=1:lsum
    if leend>Pixelnum
        break;
    end
    for haha=1:A
        for hahaha=1:B-1
            if SD(i,haha,hahaha) == W(i)
                Reget(leend)=0;
                leend=leend+1;
            elseif SD(i,haha,hahaha)== (W(i)+1)
                Reget(leend)=1;
                leend=leend+1;
            end
            
            if leend > Pixelnum
                break;
            end
        end
        if leend>Pixelnum
                break;
        end
    end
    if leend>Pixelnum
       break;
    end
end
ans1=isequal(S,Reget);                                                     %�Ƚ�Ƕ�����Ϣ����ȡ��������Ϣ�Ƿ���ͬ
RD=RemoveStep3(SD,W,lsum,A,B);                                             %�ָ�ƽ��              
RH=RegetImage(RD,Mark,I,lsum,A,B);
ans2=isequal(RH,I);
subplot(1,3,1);
imshow(I);
title('ԭͼ');
subplot(1,3,2);
imshow(Mark);
title('Ƕ���ı��ͼ��');
subplot(1,3,3);
RH=uint8(RH);
imshow(RH);
title('�ָ����ͼ��');



