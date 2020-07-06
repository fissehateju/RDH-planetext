function [map,com_map] = LocationMap(I,Noise,Opt)
% I��ʾԭʼͼ��Noise��ʾI��ѹ��������Opt��ʾ���Ų���
[row,col]=size(I);
map = zeros();
num = 0; %����
for i=2:row-2 %��
    for j=2:col-2 %��
        if Noise(i,j) ~= -1 % -1��ʾ��ʱ���õĲ���
            n = Noise(i,j); %�����ĸ�ֱ��ͼ
            a = Opt(1,n);  %��n��ֱ��ͼ��Ƕ�����
            if I(i,j) <= a-1 ||  I(i,j) > 255-a  %ƽ�ƻ�Ƕ��֮������
                num = num + 1;
                map(num) = (i-1)*512+j; %��¼�����λ����Ϣ
            end
%             num = num + 1;
%             if I(i,j) <= a-1 ||  I(i,j) > 255-a  %ƽ�ƻ�Ƕ��֮������
%                 map(num) = 1;  %1��ʾ���
%             else
%                 map(num) = 0;
%             end
        end
    end
end
[com_map] = ArithmeticEncode(map);
end