function [EC] = Capacity(h,a,b)
%h��ʾֱ��ͼ��a��ʾѡ������ض�����b��ʾ����ߵ����ض�
% [row,~] = size(h);
EC = 0;
if a == 1    
    EC = EC + h( (h(:,1)==a-1) ,2 ); %(a-1,-a)Ϊһ��Ƕ���
    EC = EC + h( (h(:,1)==-a) ,2 );
%     for i=1:row
%         if h(i,1) == b || h(i,1) == -1-b
%             EC = EC+ h(i,2);      
%         end 
%     end   
else  % a>1(���)
    for bn=0:a-2 %ǰ��a-1�������ض���[(0,-1),...,(a-2,1-a)]        
        EC = EC + h( (h(:,1)==bn) ,2 ); 
        EC = EC + h( (h(:,1)==-1-bn) ,2 );
%         for i=1:row
%             if h(i,1) == bn || h(i,1) == -1-bn
%                 EC = EC+ h(i,2);      
%             end 
%         end 
    end 
    EC = EC + h( (h(:,1)==b) ,2 );
    EC = EC + h( (h(:,1)==-1-b) ,2 );
%     for i=1:row
%         if h(i,1) == b || h(i,1) == -1-b
%             EC = EC+ h(i,2);      
%         end 
%     end
end