function [PV_I,PE_I,Noise_I] = Calculate(I) 
%PV_I��ʾԤ��ֵ,PE_I��ʾԤ�����,Noise_I��ʾ����ˮƽ
[row,col]=size(I); %ͳ��I��������
PV_I = I;
PE_I = I;
Noise_I = ones(row,col)*(-1); %ȫ-1����
for i=2:row-2 %��
    for j=2:col-2 %��
        w1 =  I(i-1,j); %��
        w2 =  I(i,j-1); %��
        w3 =  I(i+1,j); %��
        w4 =  I(i,j+1); %��
        w5 =  I(i+1,j-1);
        w6 =  I(i+1,j+1);
        w7 =  I(i+2,j);
        w8 =  I(i,j+2);
        w9 =  I(i+2,j-1);
        w10 =  I(i-1,j+2);
        w11 =  I(i+2,j+1);
        w12 =  I(i+1,j+2);
        w13 =  I(i+2,j+2);
        PV_I(i,j) = floor((w1+w2+w3+w4)/4); %(i,j)����Ԥ��ֵ����������ȡƽ��ֵ
        PE_I(i,j) = I(i,j) - PV_I(i,j); %Ԥ�����
        Noise_I(i,j) = abs(w2-w5)+abs(w5-w9)+abs(w3-w7)+abs(w4-w6)+abs(w6-w11)+abs(w10-w8)+abs(w8-w12)+abs(w12-w13)...
            +abs(w4-w8)+abs(w5-w3)+abs(w3-w6)+abs(w6-w12)+abs(w9-w7)+abs(w7-w11)+abs(w11-w13);  %��������ˮƽ
    end
end