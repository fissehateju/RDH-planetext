function [diaPV_I,diaPE_I] = diamond(I) 
%diaPV_I��ʾԤ��ֵ,diaPE_I��ʾԤ�����
[row,col]=size(I);
diaPV_I = I;
diaPE_I = I;
for i=1:row
    for j=1:col
        num=0;
        sum=0;
        if i>1 %��һ��ǰ��û������
            sum=sum+I(i-1,j);
            num=num+1;
        end
        if j>1 %��һ��ǰ��û������
            sum=sum+I(i,j-1);
            num=num+1;
        end
        if i<row %���һ�к���û������
            sum=sum+I(i+1,j);
            num=num+1;
        end
        if j<col %���һ�к���û������
            sum=sum+I(i,j+1);
            num=num+1;
        end
        diaPV_I(i,j) = floor(sum/num);
        diaPE_I(i,j) = I(i,j)-diaPV_I(i,j);
    end
end