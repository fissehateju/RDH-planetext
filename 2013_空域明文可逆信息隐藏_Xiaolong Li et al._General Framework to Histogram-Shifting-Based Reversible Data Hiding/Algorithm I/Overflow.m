function [lc,LM,LMc] = Overflow(x,y,stego_I,s,tl,tr,PE_x5,C_x5)
%(x,y)��ʾ�ò��е�һ���ֿ����ʼλ�ã�stego_I��ʾ��һ��Ƕ�����ݺ������ͼ��
%s��tl��tr��ʾǶ�������PE_x5��ʾԤ����C_x5��ʾ���Ӷ�
%lc��ʾLMc���ȣ�LM��ʾ���п����Ϣ��LMc��ʾ�������Ϣ
[m,n]=size(stego_I); %ͳ��stego_I��������
LM = zeros(); %������¼����Ϣ
LMc = zeros(); %������¼�������Ϣ
k = 0; %��¼�ֿ����
l = 0; %��¼��������
%% �����зֿ���ϢLM
x0 = x+1; %��3*3�ֿ���������ش�Ƕ����Ϣ
y0 = y+1;
for i=x0:+3:m
    for j=y0:+3:n
        if i+1<=m && j+1<=n  %��ֹԽ��
            k=k+1; 
            x5_value = stego_I(i,j); %�ֿ���������ֵ
            x5_max1 = x5_value + tr;
            x5_min1 = x5_value - tl;
            e5 = PE_x5(k);
            x5_max2 = x5_value + floor(e5) + 1;
            x5_min2 = x5_value + floor(e5) + 0;
            C = C_x5(k);
            if x5_max1>255 && x5_min1<0 && x5_max2>255 && x5_min2<0 && C<s
                LM(k) = 1; %�����
                l = l+1;
            else     
                LM(k) = 0; %Ƕ����ƽ�ƿ�
            end
        end
    end
end
%% ���������ϢLMc
len_k = ceil(log2(k)); %k�Ķ�����λ��������ȡ��
lc = (l+1)*len_k;  %��ʾLMc�ĳ���
num = l; % l����������
for i=len_k:-1:1 %LMcǰlen_k���ر�ʾ��������
    bin = mod(num,2);  %ȡ����
    num = floor(num/2);%ȡ��,����ȡ��
    LMc(i) = bin;
end
num_l = 0;%������¼�ڼ��������
for i=1:k %��¼ÿ��������λ��
    if LM(i)==1 %�����
        num_l = num_l+1;
        loc = i; %��¼λ��
        for j=(num_l+1)*len_k:-1:num_l*len_k+1
            bin = mod(loc,2);  %ȡ����
            loc = floor(loc/2);%ȡ��
            LMc(i) = bin;
        end
    end
end