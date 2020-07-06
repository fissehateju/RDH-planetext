function [stego_I1,emD1,S_Shadow,Opt_Shadow,map,end_x,end_y] = Embed_Shadow(origin_I,D1)
%origin_I��ʾԭʼͼ��D1��ʾǰ��һ�����������
%stego_I1��ʾ�ں�ɫ����Ƕ����Ϣ�������ͼ��emD1��ʾǶ�������
%S_Shadowѹ����������,Opt_Shadow����Ƕ�����,map�����Ϣ,(end_x,end_y)����λ��
num_D1 = length(D1); %ͳ���������ݸ���
[m,n] = size(origin_I); %ͳ��origin_I��������
stego_I1 = origin_I;
%% ����Ԥ��ֵ��Ԥ����������ˮƽ
[PV,PE,Noise] = Calculate(origin_I);
%% ѹ������ˮƽNoise
[Noise_Shadow,S_Shadow,~,~] = CompressNoise(Noise);
%% ͳ��ֱ��ͼ
M = 16;
sta_PE = cell(1,M); %ͳ��û������ˮƽ�µ�Ԥ�����
for i = 2:m-2
    for j = 2:n-2
        if mod((i+j),2) == 0
            sta_PE{Noise_Shadow(i,j)} = [sta_PE{Noise_Shadow(i,j)},PE(i,j)];
        end
    end
end
Hist = cell(1,M); %���M��ֱ��ͼ
for i = 1:M
    Hist{i} = tabulate(sta_PE{i}); %����ֱ��ͼ
end
%% ������Ų���
[Opt_Shadow] = Optimal(Hist,num_D1);
% [Opt_Shadow] = Optimal_Shadow(Hist,num_D1) ;
%% ��������Ϣ
[map,~] = LocationMap(origin_I,Noise_Shadow,Opt_Shadow);
%% Ƕ����Ϣ
num_emD1 = 0; %����,��¼Ƕ�����ݸ���
end_x = 0; %��¼����λ��
end_y = 0;
[~,over] = size(map);
for i=2:m-2
    for j=2:n-2
        if num_emD1 >= num_D1
            break;
        end
        No = Noise_Shadow(i,j);
        if No ~= -1
            v = PV(i,j); %Ԥ��ֵ
            e = PE(i,j); %Ԥ�����
            a = Opt_Shadow(1,No); %���Ƕ���
            b = Opt_Shadow(2,No); %��ΧǶ���
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
                        num_emD1 = num_emD1+1;        
                        if D1(num_emD1) == 0  
                            e = e + (a-1);
                        else  % D1(num_emD1) == 1                            
                            e = e + (a-1) + 1;                 
                        end   
                    elseif e>b  %ƽ��
                        e = e + a;
                    elseif e>=a-1 && e<b %ƽ��   
                        e = e + (a-1);
                    else  
                        for p=1:a-1  %Ƕ��
                            if e == p-1   
                                num_emD1 = num_emD1+1;
                                if D1(num_emD1) == 0
                                    e = e + (p-1);
                                else  % D1(num_emD1) == 1                           
                                    e = e + (p-1) + 1;
                                end 
                                break;
                            end
                        end  
                    end
                else  %e<0
                    if e == -1-b %Ƕ�� 
                        num_emD1 = num_emD1+1;        
                        if D1(num_emD1) == 0  
                            e = e - (a-1);
                        else  % D1(num_emD1) == 1                            
                            e = e - (a-1) - 1;                 
                        end   
                    elseif e<-1-b  %ƽ��
                        e = e - a;
                    elseif e<=-a && e>-1-b %ƽ��   
                        e = e - (a-1);
                    else  
                        for p=1:a-1  %Ƕ��
                            if e == -p  
                                num_emD1 = num_emD1+1;
                                if D1(num_emD1) == 0
                                    e = e - (p-1);
                                else  % D1(num_emD1) == 1                           
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
                        num_emD1 = num_emD1+1;        
                        if D1(num_emD1) == 0  
                            e = e + (a-1) - a;
                        else  % D1(num_emD1) == 1                            
                            e = e + (a-1) + 1 - a;                 
                        end   
                    elseif e>b  %ƽ��
                        e = e + a - a;
                    elseif e>=a-1 && e<b %ƽ��   
                        e = e + (a-1) - a;
                    else  
                        for p=1:a-1  %Ƕ��
                            if e == p-1   
                                num_emD1 = num_emD1+1;
                                if D1(num_emD1) == 0
                                    e = e + (p-1) - a;
                                else  % D1(num_emD1) == 1                           
                                    e = e + (p-1) + 1 - a;
                                end 
                                break;
                            end
                        end  
                    end
                else  %e<0
                    if e == -1-b %Ƕ�� 
                        num_emD1 = num_emD1+1;        
                        if D1(num_emD1) == 0  
                            e = e - (a-1) + a;
                        else  % D1(num_emD1) == 1                            
                            e = e - (a-1) - 1 + a;                 
                        end   
                    elseif e<-1-b  %ƽ��
                        e = e - a + a;
                    elseif e<=-a && e>-1-b %ƽ��   
                        e = e - (a-1) + a;
                    else  
                        for p=1:a-1  %Ƕ��
                            if e == -p  
                                num_emD1 = num_emD1+1;
                                if D1(num_emD1) == 0
                                    e = e - (p-1) + a;
                                else  % D1(num_emD1) == 1                           
                                    e = e - (p-1) - 1 + a;
                                end 
                                break;
                            end
                        end  
                    end
                end
            end
            stego_I1(i,j) = v + e;
            end_x = i;
            end_y = j;
        end
    end
end
%% ��¼Ƕ������
emD1 = D1(1:num_emD1);
end