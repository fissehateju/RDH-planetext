function [Noise_Shadow,S_Shadow,Noise_Blank,S_Blank] = CompressNoise(Noise) 
% Noiseԭʼ����ˮƽ
%��ɫ�飺Noise_Shadowѹ������ˮƽ��S_Shadow��¼ѹ����������
%��ɫ�飺Noise_Blankѹ������ˮƽ��S_Blank��¼ѹ����������
[m,n] = size(Noise);
M = 16; %������ˮƽѹ������Χ:[1,16]
Noise_Shadow = Noise;
Noise_Blank = Noise;
%% ѹ����ɫ�������ˮƽ
Max_Shadow = 0;
N_Shadow = 0; 
for i=2:m-2  %��һ��+������У����ã�
    for j=2:n-2  %��һ��+������У����ã�
       if mod((i+j),2)==0 %��ɫ��
           N_Shadow = N_Shadow+1; %��¼��ɫ������ˮƽ����
           if Max_Shadow < Noise_Shadow(i,j)
               Max_Shadow = Noise_Shadow(i,j); %�����������ˮƽ
           end
       else
           Noise_Shadow(i,j) = -1; %���ò��ֱ��Ϊ-1
       end 
    end
end
S_Shadow = zeros(1,M-1); %������¼ѹ����������
for v=0:M-2
    sum_Shadow = 0; %��¼����ˮƽ��Sn�ĸ���
    for Sn=0:Max_Shadow
        for i=2:m-2     
            for j=2:n-2     
                if mod((i+j),2)==0 && Noise_Shadow(i,j)==Sn   
                    sum_Shadow = sum_Shadow+1;  
                end     
            end     
        end 
        if sum_Shadow/N_Shadow >= (v+1)/M
            S_Shadow(v+1) = Sn;
            break;
        else         
            continue;
        end
    end
end
for v=1:M  %��Χѹ��
    for i=2:m-2           
        for j=2:n-2
            if v == 1
                if Noise_Shadow(i,j)>=0 && Noise_Shadow(i,j)<=S_Shadow(v)
                    Noise_Shadow(i,j) = v;
                end
            elseif v == M
                if Noise_Shadow(i,j)>=S_Shadow(v-1)+1
                    Noise_Shadow(i,j) = v;
                end
            else
                if Noise_Shadow(i,j)>=S_Shadow(v-1)+1 && Noise_Shadow(i,j)<=S_Shadow(v)
                    Noise_Shadow(i,j) = v;
                end
            end
        end
    end
end
%% ѹ����ɫ�������ˮƽ
Max_Blank = 0;
N_Blank = 0; 
for i=2:m-2  %��һ��+������У����ã�
    for j=2:n-2  %��һ��+������У����ã�
       if mod((i+j),2)==1 %��ɫ��
           N_Blank = N_Blank+1; %��¼��ɫ������ˮƽ����
           if Max_Blank < Noise_Blank(i,j)
               Max_Blank = Noise_Blank(i,j); %�����������ˮƽ
           end
       else
           Noise_Blank(i,j) = -1; %���ò��ֱ��Ϊ-1
       end 
    end
end
S_Blank = zeros(1,M-1); %������¼ѹ����������
for v=0:M-2
    sum_Blank = 0; %��¼����ˮƽ��Sn�ĸ���
    for Sn=0:Max_Blank
        for i=2:m-2     
            for j=2:n-2     
                if mod((i+j),2)==1 && Noise_Blank(i,j)==Sn   
                    sum_Blank = sum_Blank+1;  
                end     
            end     
        end 
        if sum_Blank/N_Blank >= (v+1)/M
            S_Blank(v+1) = Sn;
            break;
        else         
            continue;
        end
    end
end
for v=1:M %��Χѹ��
    for i=2:m-2           
        for j=2:n-2
            if v == 1
                if Noise_Blank(i,j)>=0 && Noise_Blank(i,j)<=S_Blank(v)
                    Noise_Blank(i,j) = v;
                end
            elseif v == M
                if Noise_Blank(i,j)>=S_Blank(v-1)+1
                    Noise_Blank(i,j) = v;
                end
            else
                if Noise_Blank(i,j)>=S_Blank(v-1)+1 && Noise_Blank(i,j)<=S_Blank(v)
                    Noise_Blank(i,j) = v;
                end
            end
        end
    end
end