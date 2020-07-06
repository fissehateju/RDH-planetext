function [stego_I2,emD2,S_Blank,Opt_Blank,map,end_x,end_y] = Embed_Blank(stego_I1,D2)
%stego_I1��ʾ�ں�ɫ����Ƕ����Ϣ�������ͼ��D2��ʾ����һ�����������
%stego_I2��ʾ�ڰ�ɫ����Ƕ����Ϣ�������ͼ��emD2��ʾǶ�������
%S_Blankѹ����������,Opt_Blank����Ƕ�����,map�����Ϣ,(end_x,end_y)����λ��
num_D2 = length(D2); %ͳ���������ݸ���
[m,n] = size(stego_I1); %ͳ��stego_I1��������
stego_I2 = stego_I1;
%% ����Ԥ��ֵ��Ԥ����������ˮƽ
[PV,PE,Noise] = Calculate(stego_I1);
%% ѹ������ˮƽNoise
[~,~,Noise_Blank,S_Blank] = CompressNoise(Noise);
%% ͳ��ֱ��ͼ
M = 16;
sta_PE = cell(1,M); %ͳ��û������ˮƽ�µ�Ԥ�����
for i = 2:m-2
    for j = 2:n-2
        if mod((i+j),2) == 1
            sta_PE{Noise_Blank(i,j)} = [sta_PE{Noise_Blank(i,j)},PE(i,j)];
        end
    end
end
Hist = cell(1,M); %���M��ֱ��ͼ
for i = 1:M
    Hist{i} = tabulate(sta_PE{i}); %����ֱ��ͼ
end
%% ������Ų���
[Opt_Blank] = Optimal(Hist,num_D2);
% [Opt_Blank] = Optimal_Blank(Hist,num_D2);
%% ��������Ϣ
[map,~] = LocationMap(stego_I1,Noise_Blank,Opt_Blank);
%% Ƕ����Ϣ
num_emD2 = 0; %����,��¼Ƕ�����ݸ���
end_x = 0; %��¼����λ��
end_y = 0;
[~,over] = size(map);
for i=2:m-2
    for j=2:n-2
        if num_emD2 >= num_D2
            break;
        end
        No = Noise_Blank(i,j);
        if No ~= -1
            v = PV(i,j); %Ԥ��ֵ
            e = PE(i,j); %Ԥ�����
            a = Opt_Blank(1,No); %���Ƕ���
            b = Opt_Blank(2,No); %��ΧǶ���
            %% �ж��Ƿ�Ϊ�����
            boole = 0;
            lo = (i-1)*512+j; %λ��
            for l=1:over
                if lo == map(l);
                    boole = 1; %�������
                end
            end
            
            if boole == 0
                %% ������Ƕ��ƽ��
                if e>=0
                    if e == b %Ƕ�� 
                        num_emD2 = num_emD2+1;        
                        if D2(num_emD2) == 0  
                            e = e + (a-1);
                        else  % D2(num_emD2) == 1                            
                            e = e + (a-1) + 1;                 
                        end   
                    elseif e>b  %ƽ��
                        e = e + a;
                    elseif e>=a-1 && e<b %ƽ��   
                        e = e + (a-1);
                    else  
                        for p=1:a-1  %Ƕ��
                            if e == p-1   
                                num_emD2 = num_emD2+1;
                                if D2(num_emD2) == 0
                                    e = e + (p-1);
                                else  % D2(num_emD2) == 1                           
                                    e = e + (p-1) + 1;
                                end 
                                break;
                            end
                        end  
                    end
                else  %e<0
                    if e == -1-b %Ƕ�� 
                        num_emD2 = num_emD2+1;        
                        if D2(num_emD2) == 0  
                            e = e - (a-1);
                        else  % D2(num_emD2) == 1                            
                            e = e - (a-1) - 1;                 
                        end   
                    elseif e<-1-b  %ƽ��
                        e = e - a;
                    elseif e<=-a && e>-1-b %ƽ��   
                        e = e - (a-1);
                    else  
                        for p=1:a-1  %Ƕ��
                            if e == -p  
                                num_emD2 = num_emD2+1;
                                if D2(num_emD2) == 0
                                    e = e - (p-1);
                                else  % D2(num_emD2) == 1                           
                                    e = e - (p-1) - 1;
                                end 
                                break;
                            end
                        end  
                    end
                end
            else  %boole == 1
                %% �����Ƕ��ƽ��
                if e>=0
                    if e == b %Ƕ�� 
                        num_emD2 = num_emD2+1;        
                        if D2(num_emD2) == 0  
                            e = e + (a-1) - a;
                        else  % D2(num_emD2) == 1                            
                            e = e + (a-1) + 1 - a;                 
                        end   
                    elseif e>b  %ƽ��
                        e = e + a - a;
                    elseif e>=a-1 && e<b %ƽ��   
                        e = e + (a-1) - a;
                    else  
                        for p=1:a-1  %Ƕ��
                            if e == p-1   
                                num_emD2 = num_emD2+1;
                                if D2(num_emD2) == 0
                                    e = e + (p-1) - a;
                                else  % D2(num_emD2) == 1                           
                                    e = e + (p-1) + 1 - a;
                                end 
                                break;
                            end
                        end  
                    end
                else  %e<0
                    if e == -1-b %Ƕ�� 
                        num_emD2 = num_emD2+1;        
                        if D2(num_emD2) == 0  
                            e = e - (a-1) + a;
                        else  % D2(num_emD2) == 1                            
                            e = e - (a-1) - 1 + a;                 
                        end   
                    elseif e<-1-b  %ƽ��
                        e = e - a + a;
                    elseif e<=-a && e>-1-b %ƽ��   
                        e = e - (a-1) + a;
                    else  
                        for p=1:a-1  %Ƕ��
                            if e == -p  
                                num_emD2 = num_emD2+1;
                                if D2(num_emD2) == 0
                                    e = e - (p-1) + a;
                                else  % D2(num_emD2) == 1                           
                                    e = e - (p-1) - 1 + a;
                                end 
                                break;
                            end
                        end  
                    end
                end
            end
            stego_I2(i,j) = v + e;
            end_x = i;
            end_y = j;
        end
    end
end
%% ��¼Ƕ������
emD2 = D2(1:num_emD2);
end