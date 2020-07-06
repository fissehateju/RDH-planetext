function [exD,recover_I] = Extract(stego_I,s,num)
%stego_I��ʾ����ͼ��s,t�ǲ�����num��ʾǶ���������ݵ�����
%exD��ʾ��ȡ�����ݣ�recover_I��ʾ�ָ�ͼ��
recover_I = stego_I; %�����洢�ָ�ͼ�������
[m,n]=size(stego_I);%ͳ��stego_I��������
exD = zeros();
num_exD = 0; %��¼��ȡ���ݵĸ���
%% ����ÿ���ֿ�Ƕ�����ݵ�����
num_ave = floor(num/9);%ÿ���ֿ�ƽ��Ƕ����
num_re = mod(num,9); %���������
num_block = zeros(1,9);%��¼ÿ���ֿ��Ƕ����
for i=1:9
    if i<=num_re
        num_block(i) = num_ave+1;
    else
        num_block(i) = num_ave;
    end
end
%% ����9�㣬��9����ȡ���ݣ��Ӻ���ǰ
for hi=9:-1:1
    if num_exD >= num
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
                x1 = recover_I(i,j);
                x2 = recover_I(i,j+1); 
                x3 = recover_I(i,j+2); 
                x4 = recover_I(i+1,j); 
                x5 = recover_I(i+1,j+1); 
                x6 = recover_I(i+1,j+2); 
                x7 = recover_I(i+2,j);
                x8 = recover_I(i+2,j+1); 
                x9 = recover_I(i+2,j+2); 
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
    %% ���hi��Ŀ���ϢLM
    LM = zeros(1,k); %������¼����Ϣ
    LMc = zeros(); %������¼�������Ϣ
    len_k = ceil(log2(k)); %k�Ķ�����λ��������ȡ��
    %--------�������ĸ���l--------%
    num_l = 0; %��¼I1���滻��LSB����
    for i=x:3:m 
        for j=y:3:n
            if i+2<=m && j+2<=n  %��ֹԽ��  
                for i3=0:2  %ÿ���ֿ�Ĵ�СΪ3*3
                    for j3=0:2
                        if num_l>=len_k %ǰlen_k��ʾ��������
                            break;
                        end
                        value = recover_I(i+i3,j+j3);
                        num_l = num_l+1;
                        LMc(num_l) = mod(value,2);
                    end
                end
            end  
        end  
    end 
    str = num2str(LMc);%����ת�����ַ���
    l =  bin2dec(str); %�������ַ���ת��������
    %--------����������ϢLMc--------%
    lc = (l+1)*len_k; %��ʾLMc�ĳ���
    num_lc = 0;
    for i=x:3:m 
        for j=y:3:n
            if i+2<=m && j+2<=n  %��ֹԽ��  
                for i3=0:2  %ÿ���ֿ�Ĵ�СΪ3*3
                    for j3=0:2
                        if num_lc>=lc %ǰlc�����ص�LSB��ʾ�������Ϣ
                            break;
                        end
                        value = recover_I(i+i3,j+j3);
                        num_lc = num_lc+1;
                        LMc(num_lc) = mod(value,2);
                    end
                end
            end  
        end  
    end
    %--------�����зֿ����ϢLM--------%
    for i=1:l %ÿlen_k��ʾһ����������Ϣ
        str_i = LMc(i*len_k+1:(i+1)*len_k); %��i��������λ����Ϣ
        str = num2str(str_i); 
        ki =  bin2dec(str);
        LM(ki) = 1; %���Ϊ���
    end
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
        elseif LM(ki)==0 && PV_x1(ki)-p_x1(ki)==1 && C_x1(ki)<s
            k2 = k2+1; 
        elseif LM(ki)==0 && PV_x1(ki)-q_x1(ki)==-1 && C_x1(ki)<s
            k2 = k2+1;
        elseif LM(ki)==0 && PV_x1(ki)-q_x1(ki)==-2 && C_x1(ki)<s
            k2 = k2+1;
        end
    end  %ʣ�µĲ��־�����I3 
    %% ��I2������ȡI1��LSB���ָ�
    exk = 0; %��¼��ȡ���λ��
    S_LSB = zeros(); %��¼I1��ԭʼ��LSB
    num_lsb = 0;
    for i=x:+3:m
        for j=y:+3:n
            if i+2<=m && j+2<=n  %��ֹԽ��
                exk = exk+1; 
                if exk>=k1+1 && exk<=k1+k2 %I2����
                     if LM(exk)==0  %ѡ��Ƕ����ƽ�ƿ飬���������
                        x1 = recover_I(i,j);
                        p = p_x1(exk);
                        q = q_x1(exk);
                        C = C_x1(exk);
                        if x1>p+1 && C<s  %ƽ�ƿ�
                            x1 = x1 - 1;
                        elseif x1<q-2 && C<s  %ƽ�ƿ�
                            x1 = x1 + 1;
                        else  %q-2<=x1<=p+1,C<s��Ƕ���  
                            if x1==p && C<s  
                                num_lsb = num_lsb+1; 
                                S_LSB(num_lsb) = 0; 
                                x1 = x1 - 0;
                            elseif x1==p+1 && C<s
                                num_lsb = num_lsb+1; 
                                S_LSB(num_lsb) = 1;
                                x1 = x1 - 1;
                            elseif x1==q-2 && C<s 
                                num_lsb = num_lsb+1; 
                                S_LSB(num_lsb) = 1;
                                x1 = x1 + 1;
                            elseif x1==q-1 && C<s 
                                num_lsb = num_lsb+1; 
                                S_LSB(num_lsb) = 0;
                                x1 = x1 + 0;
                            end  
                        end
                        recover_I(i,j) = x1;  
                    end  
                end
            end
        end
    end
    %% �ָ�I1��lc�����ص�LSBs
    num_lsb = 0; %��¼I1���滻��LSB����
    for i=x:3:m 
        for j=y:3:n
            if i+2<=m && j+2<=n  %��ֹԽ��  
                for i3=0:2  %ÿ���ֿ�Ĵ�СΪ3*3
                    for j3=0:2
                        if num_lsb>=lc %����滻lc��LSB
                            break;
                        end
                        value = recover_I(i+i3,j+j3);
                        num_lsb = num_lsb+1;
                        lsb = S_LSB(num_lsb);
                        value = bitset(value,1,lsb); %LSB�滻
                        recover_I(i+i3,j+j3) = value;
                    end
                end
            end  
        end  
    end
    %% ���¼���I1���ֵ�Ԥ�����͸��Ӷ�
    k_I1 = 0;
    for i=x:+3:m
        for j=y:+3:n
            if k_I1>=k1
                break;
            end
            if i+2<=m && j+2<=n  %��ֹԽ��
                x1 = recover_I(i,j);
                x2 = recover_I(i,j+1); 
                x3 = recover_I(i,j+2); 
                x4 = recover_I(i+1,j); 
                x5 = recover_I(i+1,j+1); 
                x6 = recover_I(i+1,j+2); 
                x7 = recover_I(i+2,j);
                x8 = recover_I(i+2,j+1); 
                x9 = recover_I(i+2,j+2); 
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
    %% ��I1��I3������ȡ����
    exk = 0; %��¼Ƕ����λ��
    exD_hi = zeros(); %������¼��k0����ȡ������
    num_hi = 0; %������¼��k0������ȡ���ݵĸ���
    for i=x:+3:m
        for j=y:+3:n
            if num_hi >= num_block(hi)
                break;
            end
            if i+2<=m && j+2<=n  %��ֹԽ��
                exk = exk+1; 
                if exk<=k1 || exk>=k1+k2+1 %I1��I3����
                    if LM(exk)==0  %ѡ��Ƕ����ƽ�ƿ飬���������
                        x1 = recover_I(i,j);
                        p = p_x1(exk);
                        q = q_x1(exk);
                        C = C_x1(exk);
                        if x1>p+1 && C<s  %ƽ�ƿ�
                            x1 = x1 - 1;
                        elseif x1<q-2 && C<s  %ƽ�ƿ�
                            x1 = x1 + 1;
                        else  %q-2<=x1<=p+1,C<s��Ƕ���  
                            if x1==p && C<s  
                                num_hi = num_hi+1;
                                exD_hi(num_hi) = 0;
                                x1 = x1 - 0;
                            elseif x1==p+1 && C<s
                                num_hi = num_hi+1;
                                exD_hi(num_hi) = 1; 
                                x1 = x1 - 1;
                            elseif x1==q-2 && C<s 
                                num_hi = num_hi+1;
                                exD_hi(num_hi) = 1; 
                                x1 = x1 + 1;
                            elseif x1==q-1 && C<s 
                                num_hi = num_hi+1;
                                exD_hi(num_hi) = 0;
                                x1 = x1 + 0;
                            end  
                        end
                        recover_I(i,j) = x1;  
                    end  
                end     
            end
        end
    end
    %% ��¼��ȡ������ 
    ex2 = num-num_exD; %����λ��
    num_exD = num_exD+num_hi;
    ex1 = num-num_exD+1; %��ʼλ��
    exD(ex1:ex2) = exD_hi;
end