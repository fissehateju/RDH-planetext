function [hist_ac1,num1,num_1] = jpeg_hist(dct_coef) %����acϵ��ֱ��ͼ
%num1��ʾacϵ��ֵΪ1������,num_1��ʾacϵ��ֵΪ-1������
[m,n] = size(dct_coef); %ͳ��dctϵ����������
ac_1 = zeros(); %�洢����acϵ��
t1 = 0;
for i = 1:m
    for j = 1:n
        if (mod(i,8) ~= 1) || (mod(j,8) ~= 1) %ȥ��dcϵ��
            if dct_coef(i,j) ~= 0 %����acϵ��Ϊ0ʱ
                t1 = t1 + 1;
                ac_1(t1) = dct_coef(i,j);            
            end
        end
    end
end
hist_ac1=tabulate(ac_1(:)); %ͳ�Ʒ���acϵ��ֱ��ͼ
num1 = hist_ac1((hist_ac1(:,1)==1),2);
num_1 = hist_ac1((hist_ac1(:,1)==-1),2);
end
