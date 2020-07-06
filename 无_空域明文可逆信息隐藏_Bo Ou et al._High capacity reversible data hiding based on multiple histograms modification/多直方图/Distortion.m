function [ED] = Distortion(h,a,b)
%h��ʾֱ��ͼ��count��ʾѡ������ض�����b��ʾ����ߵ����ض�
[row,~] = size(h);
ED = 0;
sum = 0; %��¼��������
for i=1:row
    sum = sum + h(i,2);
end
if a == 1 
    num = 0;
    for i=1:row
        if h(i,1) == b || h(i,1) == -1-b  %Ƕ���
            ED = ED + (a^2-a+0.5) * h(i,2);
        elseif h(i,1) > b || h(i,1) < -1-b %ƽ�Ƶ�
            num = num + h(i,2);
        end 
    end
    ED = ED + (a^2) * num;
else  % a>1(���)
    num1 = 0;
    num2 = 0;
    for bn=1:a-1 %ǰ��a-1�������ض���[(0,-1),...,(a-2,1-a)]
        for i=1:row
            if h(i,1) == bn-1 || h(i,1) == -bn
                ED = ED + (bn^2-bn+0.5) * h(i,2);
            elseif ( h(i,1)>a-2 && h(i,1)<b ) || ( h(i,1)<1-a && h(i,1)>-1-b )
                num1 = num1 + h(i,2);  
            end   
        end 
    end 
    for i=1:row
         if h(i,1) == b || h(i,1) == -1-b  %Ƕ���
            ED = ED + (a^2-a+0.5) * h(i,2);
        elseif h(i,1) > b || h(i,1) < -1-b %ƽ�Ƶ�
            num2 = num2 + h(i,2);
        end 
    end
    ED = ED + ((a-1)^2)*num1 + (a^2)*num2;
end