function [recover_I,exD,exD_num]=extract(stego_I,num)
recP_I=stego_I;%Ԥ��ֵ
recPE_I=stego_I;%Ԥ�����
recover_I=stego_I;
[row,col]=size(stego_I);
exD=zeros(1,num);
exD_num=0;
%local_v_I=origin_I;
%local_v_II=origin_I;
%% ����ѵ������֧�����صĴ�С
L=5; 
N=8;
M=(2*L*(L+1))/2;
Y=zeros(M,1);
X=zeros(M,N);
%E=zeros(M,N);
%W=zeros(N,1);
%%  ���ֲ�����
%for i=2;row-1
   % for j=2;col-1
    % local_v_II(i,j)=floor((origin_I(i-1,j)+origin_I(i,j-i)+origin_I(i,j)+origin_I(i+1,j)+origin_I(i,j+1))/5);
     %local_v_I=((origin_I(i-1,j)-local_v_II(i,j))^2+(origin_I(i,j-i)-local_v_II(i,j))^2+(origin_I(i,j)-local_v_II(i,j))^2+(origin_I(i+1,j)-local_v_II(i,j))^2+(origin_I(i,j+1)-local_v_II(i,j))^2)/5;
   % end
%end
%%  ���ڲ�Ͻ�������Ƕ��
numm=0;
for i=L+3:+1:row-1%Ŀ������  
    if(mod(i,2)==0)
    for j=L+3:+2:col-5
        for k=i-L:+1:i%ѵ�����ľ���ֵ,����X�ĸ�ֵ
            if(mod(k,2)==1)
             for h=j-L:+2:j+L-3
                 if (numm<M)
                    numm=numm+1;
                    Y(numm,1)=stego_I(k,h);%ѵ�����е�����
                    X(numm,1)=stego_I(k,h-1);%ѵ�����е�֧������
                    X(numm,2)=stego_I(k-1,h);
                    X(numm,3)=stego_I(k,h+1);
                    X(numm,4)=stego_I(k+1,h);
                    X(numm,5)=stego_I(k-1,h-2);
                    X(numm,6)=stego_I(k-2,h-1);
                    X(numm,7)=stego_I(k-2,h+1);
                    X(numm,8)=stego_I(k-1,h+2);
                 end
             end
            elseif(mod(k,2)==0)
             for h=j-L+1:+2:j+L-3
                if (numm<M)
                    numm=numm+1;
                     Y(numm,1)=stego_I(k,h);%ѵ�����е�����
                    X(numm,1)=stego_I(k,h-1);%ѵ�����е�֧������
                    X(numm,2)=stego_I(k-1,h);
                    X(numm,3)=stego_I(k,h+1);
                    X(numm,4)=stego_I(k+1,h);
                    X(numm,5)=stego_I(k-1,h-2);
                    X(numm,6)=stego_I(k-2,h-1);
                    X(numm,7)=stego_I(k-2,h+1);
                    X(numm,8)=stego_I(k-1,h+2);
                 end
             end
            end
        end 
        W=inv(X'*X)*(X'*Y);
        recP_I(i,j)=floor(W(1,1)*stego_I(i,j-1)+W(2,1)*stego_I(i-1,j)+W(3,1)*stego_I(i,j+1)+W(4,1)*stego_I(i+1,j)+W(5,1)*stego_I(i-1,j-2)+W(6,1)*stego_I(i-2,j-1)+W(7,1)*stego_I(i-2,j+1)+W(8,1)*stego_I(i-1,j+2));
        recPE_I(i,j)=stego_I(i,j)-recP_I(i,j);
          if recPE_I(i,j)<-2
              recPE_I(i,j)=recPE_I(i,j)+1;
              recover_I(i,j)=recP_I(i,j)+recPE_I(i,j);
          elseif recPE_I(i,j)==-2
              exD_num=exD_num+1;
              exD(exD_num)=1;
               recPE_I(i,j)=-1;
               recover_I(i,j)=recP_I(i,j)+recPE_I(i,j);
          elseif recPE_I(i,j)==-1
              exD_num=exD_num+1;
               exD(exD_num)=0;
               recPE_I(i,j)=-1;
               recover_I(i,j)=recP_I(i,j)+recPE_I(i,j);
          elseif recPE_I(i,j)==0
              exD_num=exD_num+1;
               exD(exD_num)=0;
               recPE_I(i,j)=0;
               recover_I(i,j)=recP_I(i,j)+recPE_I(i,j);
          elseif recPE_I(i,j)==1
              exD_num=exD_num+1;
               exD(exD_num)=1;
               recPE_I(i,j)=0;
               recover_I(i,j)=recP_I(i,j)+recPE_I(i,j);
          elseif recPE_I(i,j)>1
               recPE_I(i,j)=recPE_I(i,j)-1;
               recover_I(i,j)=recP_I(i,j)+recPE_I(i,j);
          end
        if exD_num==num      
              break    
        end 
    end
    end
    if(mod(i,2)==1)
    for j=L+4:+2:col-5
        for k=i-L:+1:i
            if(mod(k,2)==1)
             for h=j-L:+2:j+L-3
               if (numm<M)
                    numm=numm+1;
                     Y(numm,1)=stego_I(k,h);%ѵ�����е�����
                    X(numm,1)=stego_I(k,h-1);%ѵ�����е�֧������
                    X(numm,2)=stego_I(k-1,h);
                    X(numm,3)=stego_I(k,h+1);
                    X(numm,4)=stego_I(k+1,h);
                    X(numm,5)=stego_I(k-1,h-2);
                    X(numm,6)=stego_I(k-2,h-1);
                    X(numm,7)=stego_I(k-2,h+1);
                    X(numm,8)=stego_I(k-1,h+2);
                end
             end
            elseif(mod(k,2)==0)
             for h=j-L+1:+2:j+L-3
                if (numm<M)
                    numm=numm+1;
                     Y(numm,1)=stego_I(k,h);%ѵ�����е�����
                    X(numm,1)=stego_I(k,h-1);%ѵ�����е�֧������
                    X(numm,2)=stego_I(k-1,h);
                    X(numm,3)=stego_I(k,h+1);
                    X(numm,4)=stego_I(k+1,h);
                    X(numm,5)=stego_I(k-1,h-2);
                    X(numm,6)=stego_I(k-2,h-1);
                    X(numm,7)=stego_I(k-2,h+1);
                    X(numm,8)=stego_I(k-1,h+2);
                end
             end
            end
        end 
        W=(inv(X'*X))*(X'*Y);
        recP_I(i,j)=floor(W(1,1)*stego_I(i,j-1)+W(2,1)*stego_I(i-1,j)+W(3,1)*stego_I(i,j+1)+W(4,1)*stego_I(i+1,j)+W(5,1)*stego_I(i-1,j-2)+W(6,1)*stego_I(i-2,j-1)+W(7,1)*stego_I(i-2,j+1)+W(8,1)*stego_I(i-1,j+2));
        recPE_I(i,j)=stego_I(i,j)-recP_I(i,j);
          if recPE_I(i,j)<-2
              recPE_I(i,j)=recPE_I(i,j)+1;
              recover_I(i,j)=recP_I(i,j)+recPE_I(i,j);
          elseif recPE_I(i,j)==-2
              exD_num=exD_num+1;
              exD(exD_num)=1;
               recPE_I(i,j)=-1;
               recover_I(i,j)=recP_I(i,j)+recPE_I(i,j);
          elseif recPE_I(i,j)==-1
              exD_num=exD_num+1;
               exD(exD_num)=0;
               recPE_I(i,j)=-1;
               recover_I(i,j)=recP_I(i,j)+recPE_I(i,j);
          elseif recPE_I(i,j)==0
              exD_num=exD_num+1;
               exD(exD_num)=0;
               recPE_I(i,j)=0;
               recover_I(i,j)=recP_I(i,j)+recPE_I(i,j);
          elseif recPE_I(i,j)==1
              exD_num=exD_num+1;
               exD(exD_num)=1;
               recPE_I(i,j)=0;
               recover_I(i,j)=recP_I(i,j)+recPE_I(i,j);
          elseif recPE_I(i,j)>1
               recPE_I(i,j)=recPE_I(i,j)-1;
               recover_I(i,j)=recP_I(i,j)+recPE_I(i,j);
          end
        if exD_num==num      
              break    
        end 
    end
    
    end
    
end