clear
clc
I = imread('Lena.tiff');
I2=I;
I=double(I);
[row,col]=size(I);
%for Te=0:1:100%��ѡ��һ��TeʹԤ��Ч�����
Te=36;%Lena
%Te=20;%baboon
for i=1:1:row-2
    for j=1:1:col-2
        I1=I(i:i+2,j:j+2);%ѡ��Ÿ������γ�һ�����ؿ�
        c=C(I1);%������ؿ��еڶ����������ڶ�С�����صĲ�ֵ
        if(c>Te)
        P(i,j)=Blo(I1);%����������ķ���Ԥ��
        else
        P(i,j)=rhombus(I1);%������Ԥ��
        end
    end
end
%SM(Te+1)=sum(sum(E));
%end



