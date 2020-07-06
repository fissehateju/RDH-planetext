function [Opt] = Optimal(Hist,num_D)  %%�������⣩
% Hist��ʾ��ֱ��ͼ��num_D��ʾ��ҪǶ�������
[~,M] = size(Hist);
Opt = zeros(2,M); %�洢���Ų���
a_max = 6;
%% ���һ��ֱ��ͼ�����Ƕ�����Ŀ
sum_max = 0;
for a=1:a_max
    for i=1:M
        sum_max = sum_max + Hist{i}((Hist{i}(:,1)==a-1),2); %(a-1,-a)Ϊһ��Ƕ���
        sum_max = sum_max + Hist{i}((Hist{i}(:,1)==-a),2);
    end
    if sum_max >= num_D
        Opt(1,1) = a;
        break;
    end
end
%% ���Ƕ���Ϊ1
if Opt(1,1)==1
    for i=1:M
        Opt(1,i) = 1;
    end
    sum_1 = 0;
    for i=1:M
        for j=6:-1:0 %�����Ƕ��㷶Χ[a-1,a+5]
            EC = Hist{i}((Hist{i}(:,1)==j),2) + Hist{i}((Hist{i}(:,1)==-j-1),2);
            if sum_1+EC >= num_D
                break;
            end
        end
        sum_1 = sum_1+EC;
        if sum_1 >= num_D
            for x=1:i-1
                Opt(2,x) = 0; 
            end
            Opt(2,i) = j;  
            for x=i+1:M  
                Opt(2,x) = -1;  %-1��ʾ�����
            end
            break;
        end
    end
%% ���Ƕ��Դ���1
else  
    Opt(2,1) = Opt(1,1)-1;
    [EC_1] = Capacity(Hist{1},Opt(1,1),Opt(2,1));   
    sum = 0;
    sum = sum + EC_1;
    for i=2:M  
        for a=1:Opt(1,i-1) %Ƕ�������ֱ��ͼ��ŵ����Ӷ���С
            for b=a+5:-1:Opt(2,i-1) %�����Ƕ��㷶Χ[a-1,a+5],������һ��ֱ��ͼ
                EC_i = Capacity(Hist{i},a,b);
                if sum + EC_i >= num_D
                    break;
                end
            end
            if sum + EC_i >= num_D           
                break;
            end         
        end 
        Opt(1,i) = a;   
        Opt(2,i) = b;
        sum = sum + EC_i;
        if sum >= num_D
            for x=i+1:M
                Opt(1,x) = 1;
                Opt(2,x) = -1; %-1��ʾ�����
            end
            break;
        end
    end
%     for j=1:Opt(1,1) %Ƕ�������ֱ��ͼ��ŵ����Ӷ���С    
%         c = 0;
%         for i=2:M
%             c = c + Hist{i}((Hist{i}(:,1)==j-1),2) + Hist{i}((Hist{i}(:,1)==-j),2);
%             if sum+c >= num_D       
%                 end_i = i;
%                 break;
%             end
%         end
%         sum = sum + c;        
%         if sum >= num_D        
%             end_j = j;
%             break;
%         end
%     end
%     for i=2:end_i
%         Opt(1,i) = end_j;
%     end
%     for i=end_i+1:M
%         Opt(1,i) = end_j-1;
%     end  
end
%% ʧ���
EC_sum = 0;
ED_sum = 0;
for i=1:M
    [EC_i] = Capacity(Hist{i}, Opt(1,i), Opt(2,i));
    EC_sum = EC_sum + EC_i;
    [ED_i] = Distortion(Hist{i}, Opt(1,i), Opt(2,i));
    ED_sum = ED_sum + ED_i;
end
ED_EC = ED_sum/ED_sum;
end
