function [lc,LM,LMc] = Overflow(x,y,stego_I,s,C_x1)
%(x,y)��ʾ�ò��е�һ���ֿ����ʼλ�ã�stego_I��ʾ��һ��Ƕ�����ݺ������ͼ��s��ʾǶ�������C_x1��ʾ���Ӷ�
%lc��ʾLMc���ȣ�LM��ʾ���п����Ϣ��LMc��ʾ�������Ϣ
[m,n]=size(stego_I); %ͳ��stego_I��������
LM = zeros(); %������¼����Ϣ
LMc = zeros(); %������¼�������Ϣ
k = 0; %��¼�ֿ����
l = 0; %��¼��������
%% �����зֿ���ϢLM
for i=x:+3:m
    for j=y:+3:n
        if i+2<=m && j+2<=n  %��ֹԽ��
            k=k+1;
            x1_value = stego_I(i,j); %�ֿ���������ֵ
            x1_max = x1_value + 1;
            x1_min = x1_value - 1;
            C = C_x1(k);
            if x1_max>255 && x1_min<0 && C<s 
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