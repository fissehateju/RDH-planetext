function [emD,jpeg_info_stego] = emdding(D,jpeg_info)
%D��ҪǶ������ݣ�Tz��ʾ�趨����ֵ��jpeg_info��ʾjpegͼ�����Ϣ
jpeg_info_stego = jpeg_info; %�����洢����jpegͼ�������
dct_coef = jpeg_info.coef_arrays{1,1}; %��ȡdctϵ��
[m,n]=size(dct_coef); %ͳ��dctϵ����������
num = length(D);  %Ƕ�����ݵĳ���
emD = zeros(1,num);
num_emD = 0; %��������Ƕ�����ݵ�����
for i=1:m
    for j=1:n
        if(num_emD == num) %����Ƕ�����             
            break;
        elseif (mod(i,8) ~= 1) || (mod(j,8) ~= 1) %ȥ��dcϵ��                  
            if dct_coef(i,j) == 0                                   
                continue;   %����acϵ��Ϊ0ʱ�����ı�          
            elseif dct_coef(i,j) > 1 %����1����һλ                               
                dct_coef(i,j)=dct_coef(i,j)+1;       
            elseif dct_coef(i,j) < -1 %С��-1����һλ                               
                dct_coef(i,j)=dct_coef(i,j)-1;     
            elseif dct_coef(i,j) == -1          
                num_emD = num_emD + 1;          
                dct_coef(i,j)=dct_coef(i,j) - D(num_emD);        
                emD(num_emD) = D(num_emD);  
            elseif dct_coef(i,j) == 1      
                num_emD = num_emD + 1;       
                dct_coef(i,j)=dct_coef(i,j) + D(num_emD);      
                emD(num_emD) = D(num_emD);         
            end                   
        end
    end
end
jpeg_info_stego.coef_arrays{1,1} = dct_coef;
end