function [maxy] = Blo(I1)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��;
maxx=0;
xx=I1(2,2);
for x=0:1:100%�ҳ�һ��xʹ��R�����ﵽ���xΪԤ��ֵ
    A=zeros(3);
    I1(2,2)=x;
    for i=0:2
        for j=0:2
            A(i+1,j+1)=cos(pi*(j+0.5)*i/3);
        end
    end
    f=A*I1*A';
    res=R(f);
    if maxx<res
        maxx=res;
        maxy=x;
    end
end
end

