function [res] = R(f)
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
d=f(:)';
d=sort(d,'descend');
d1=d.^2;
sum1=sum(d1);
sum2=sum(d1(1:4));
res=sum2/sum1;
end

