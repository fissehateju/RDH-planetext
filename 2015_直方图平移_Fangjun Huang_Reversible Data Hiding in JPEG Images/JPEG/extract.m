function [exD,jpeg_info_recover] = extract(num,jpeg_info_stego)
%Tz��ʾ�趨����ֵ��num��Ƕ�����ݵ�������jpeg_info_stego��ʾ����jpegͼ�����Ϣ
jpeg_info_recover = jpeg_info_stego; %�����洢�ָ�jpegͼ�������
dct_coef = jpeg_info_stego.coef_arrays{1,1}; %��ȡdctϵ��
[m,n]=size(dct_coef); %ͳ��dctϵ����������
exD = zeros(1,num);
num_exD = 0; %����������ȡ���ݵ�����
for i=1:m
    for j=1:n
        if(num_exD == num) %������ȡ���           
            break;
        elseif (mod(i,8) ~= 1) || (mod(j,8) ~= 1) %ȥ��dcϵ�� 
            if dct_coef(i,j) == 0                                   
                continue;   %����acϵ��Ϊ0ʱ�����ı�               
            elseif dct_coef(i,j) > 2                                 
                dct_coef(i,j)=dct_coef(i,j)-1;    
            elseif dct_coef(i,j) < -2                                  
                dct_coef(i,j)=dct_coef(i,j)+1;             
            elseif dct_coef(i,j) == -2            
                num_exD = num_exD + 1;     
                exD(num_exD) = 1;           
                dct_coef(i,j)=dct_coef(i,j)+1;         
            elseif dct_coef(i,j) == 2          
                num_exD = num_exD + 1;           
                exD(num_exD) = 1;         
                dct_coef(i,j)=dct_coef(i,j)-1;    
            elseif dct_coef(i,j)==-1 || dct_coef(i,j)==1         
                num_exD = num_exD + 1;          
                exD(num_exD) = 0;          
            end                   
        end
    end
end
jpeg_info_recover.coef_arrays{1,1} = dct_coef;
end