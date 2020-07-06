function [emD,num_emD,stego_I] = Embedding(D,origin_I,s)
%origin_I��ʾԭʼͼ��D��ʾ�������ݣ�s�ǲ���
%stego_I��ʾ����ͼ��emD��ʾ��Ƕ������ݣ�num_emD��ʾǶ�����ݵĸ���
stego_I = origin_I; %�����洢����ͼ�������
[m,n]=size(origin_I);%ͳ��origin_I��������
num_emD = 0; %��¼Ƕ�����ݵĸ���
num_D = length(D);
%% ����ÿ���ֿ�Ƕ�����ݵ�����
num_ave = floor(num_D/9);%ÿ���ֿ�ƽ��Ƕ����
num_re = mod(num_D,9); %���������
num_block = zeros(1,9);%��¼ÿ���ֿ��Ƕ����
for i=1:9
    if i<=num_re
        num_block(i) = num_ave+1;
    else
        num_block(i) = num_ave;
    end
end
%% ����9�㣬���Է�9��Ƕ������
for hi=1:9 
    if num_emD >= num_D
        break;
    end
    %------��һ���ֿ鿪ʼλ��------%
    x = ceil(hi/3); %��,����ȡ��     
    y = hi-(x-1)*3; %��
    %% ��Ԥ�����͸��Ӷ�
    PV_x1 = zeros();%��¼x1��ֵ
    p_x1 = zeros();%��¼����p
    q_x1 = zeros();%��¼����q
    C_x1 = zeros(); %��¼���Ӷ�
    k = 0; %�ֿ����
    for i=x:+3:m
        for j=y:+3:n
            if i+2<=m && j+2<=n  %��ֹԽ��
                x1 = stego_I(i,j);
                x2 = stego_I(i,j+1); 
                x3 = stego_I(i,j+2); 
                x4 = stego_I(i+1,j); 
                x5 = stego_I(i+1,j+1); 
                x6 = stego_I(i+1,j+2); 
                x7 = stego_I(i+2,j);
                x8 = stego_I(i+2,j+1); 
                x9 = stego_I(i+2,j+2); 
                p = max(x2,x4);
                q = min(x2,x4);
                C_max = max(max(max(max(max(max(max(x2,x3),x4),x5),x6),x7),x8),x9); 
                C_min = min(min(min(min(min(min(min(x2,x3),x4),x5),x6),x7),x8),x9);
                C = C_max - C_min;
                k = k+1;
                PV_x1(k) = x1;
                p_x1(k) = p;
                q_x1(k) = q;
                C_x1(k) = C;
            end
        end
    end
    %% ���hi��Ŀ���Ϣ
    [lc,LM,LMc] = Overflow(x,y,stego_I,s,C_x1);      
    %% �����п�ֳ�������I1��I2��I3
    k1 = ceil(lc/9); %I1������k1�飬ͨ��LSB�滻Ƕ��LMc
    k2 =0; %I2������k2�飬����Ƕ��I1��LSB
    for ki=k1+1:k
        if k2 == lc %���ٰ���lc����Ƕ���
            k2 = ki-k1-1;
            break;
        end
        if LM(ki)==0 && PV_x1(ki)-p_x1(ki)==0 && C_x1(ki)<s
            k2 = k2+1;
        elseif LM(ki)==0 && PV_x1(ki)-q_x1(ki)==-1 && C_x1(ki)<s
            k2 = k2+1;
        end
    end  %ʣ�µĲ��־�����I3
    %% ��I1��I3����Ƕ������
    emk = 0; %��¼Ƕ����λ��
    num_hi = 0; %������¼��k0�����������ݵĸ���
    for i=x:+3:m
        for j=y:+3:n
            if num_hi >= num_block(hi)
                break;
            end
            if i+2<=m && j+2<=n  %��ֹԽ��
                emk = emk+1; 
                if emk<=k1 || emk>=k1+k2+1 %I1��I3����
                    if LM(emk)==0  %ѡ��Ƕ����ƽ�ƿ飬���������
                        x1 = stego_I(i,j);
                        p = p_x1(emk);
                        q = q_x1(emk);
                        C = C_x1(emk);
                        if x1>p && C<s  %ƽ�ƿ�
                            x1 = x1 + 1;
                        elseif x1<q-1 && C<s  %ƽ�ƿ�
                            x1 = x1 - 1;
                        else  %x1-p=0||x1-q=-1,C<s��Ƕ���
                            if x1-p==0 && C<s
                                num_hi = num_hi+1;
                                num_emD = num_emD+1;
                                x1 = x1 + D(num_emD);
                            elseif x1-q==-1 && C<s
                                num_hi = num_hi+1;
                                num_emD = num_emD+1;
                                x1 = x1 - D(num_emD);
                            end
                        end
                        stego_I(i,j) = x1;  
                    end  
                end     
            end
        end
    end
    %% ��I1��Ƕ��LMc����ȡI1��lc�����ص�LSBs
    num_lsb = 0; %��¼I1���滻��LSB����
    S_LSB = zeros(); %��¼I1��ԭʼ��LSB
    for i=x:3:m 
        for j=y:3:n
            if i+2<=m && j+2<=n  %��ֹԽ��  
                for i3=0:2  %ÿ���ֿ�Ĵ�СΪ3*3
                    for j3=0:2
                        if num_lsb>=lc %����滻lc��LSB
                            break;
                        end
                        value = stego_I(i+i3,j+j3);
                        num_lsb = num_lsb+1;
                        S_LSB(num_lsb) = mod(value,2);
                        value = bitset(value,1,LMc(num_lsb)); %LSB�滻
                        stego_I(i+i3,j+j3) = value;
                    end
                end
            end  
        end  
    end 
    %% ��I2��Ƕ��I1ǰlc�����ص�LSBs����S_LSB
    emk = 0; %��¼Ƕ����λ��
    num_lsb = 0;
    for i=x:+3:m
        for j=y:+3:n
            if i+2<=m && j+2<=n  %��ֹԽ��
                emk = emk+1; 
                if emk>=k1+1 && emk<=k1+k2 %I2����
                     if LM(emk)==0  %ѡ��Ƕ����ƽ�ƿ飬��������� 
                         x1 = stego_I(i,j); 
                         p = p_x1(emk);
                         q = q_x1(emk);
                         C = C_x1(emk);
                         if x1>p && C<s  %ƽ�ƿ�
                            x1 = x1 + 1;
                         elseif x1<q-1 && C<s  %ƽ�ƿ�
                             x1 = x1 - 1;
                         else %x1-p=0||x1-q=-1,C<s��Ƕ��� 
                             if x1-p==0 && C<s
                                 num_lsb = num_lsb+1;
                                 x1 = x1 + S_LSB(num_lsb);
                             elseif x1-q==-1 && C<s
                                 num_lsb = num_lsb+1;
                                 x1 = x1 - S_LSB(num_lsb);
                             end 
                         end
                         stego_I(i,j) = x1;
                    end  
                end
            end
        end
    end
end
%% ��¼Ƕ�������
emD = D(1:num_emD);
end