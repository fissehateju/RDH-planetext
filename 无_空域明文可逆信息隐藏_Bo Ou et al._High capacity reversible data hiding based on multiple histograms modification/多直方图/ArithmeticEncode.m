function [com_map,map_2] = ArithmeticEncode(map)  %%С��̫�࣬���������
% mapԭʼ���������У�com_map��������ѹ����Ķ���������
[~,num]=size(map);
if num == 1 && map(num) == 0
    com_map = 0;
else
    %% λ����Ϣת���ɶ���������
    map_2 = zeros(1,num*18);
    s = 0; %����
    for i=1:num  %ת���ɶ�����
        data = map(i);
        for j=18:-1:1 % 512*512ͼ��ÿ�����ص�λ����18λ�����ƾͿ��Ա�ʾ
            map_2(s+j) = mod(data,2);
            data = floor(data/2);
        end
        s = s + 18;
    end
    %% ��������
    a = 0;
    b = 1;
    for i=1:num*18   
        if map_2(i) == 0
            c = (b-a)*0.5;   
            b = b-c;
            % c = roundn((b-a)*0.5,-100); %������λС��
            % b = roundn(b-c,-100);
        else  % map_2(i)==1
            c = (b-a)*0.5;
            a = a+c;
            % c = roundn((b-a)*0.5,-100);
            % a = roundn(a+c,-100);
        end  
    end 
    com_map = a;
end