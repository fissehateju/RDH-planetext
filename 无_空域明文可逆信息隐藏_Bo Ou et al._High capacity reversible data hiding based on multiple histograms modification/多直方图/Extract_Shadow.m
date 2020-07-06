function [recover_I2,exD2] = Extract_Shadow(recover_I1,S_Shadow,Opt_Shadow,map,end_x,end_y)
%recover_I1��ʾ�ں�ɫ����Ƕ����Ϣ�������ͼ��
%S_Shadowѹ����������,Opt_Shadow����Ƕ�����,map�����Ϣ,(end_x,end_y)����λ��
%recover_I2��ʾ�ָ���ɫɫ����Ƕ����Ϣ��Ļָ�ͼ��exD2��ʾ��ȡ������
[~,n] = size(recover_I1);
exD2 = zeros();
num_exD2 = 0; %����
I = recover_I1;
for i = end_x:-1:2
    if i == end_x
        %% Ƕ�������
        for j =end_y:-1:2
            if mod((i+j),2)==0
            w1 =  I(i-1,j); %��
            w2 =  I(i,j-1); %��
            w3 =  I(i+1,j); %��
            w4 =  I(i,j+1); %��
            w5 =  I(i+1,j-1);
            w6 =  I(i+1,j+1);
            w7 =  I(i+2,j);       
            w8 =  I(i,j+2);
            w9 =  I(i+2,j-1);
            w10 =  I(i-1,j+2);
            w11 =  I(i+2,j+1);
            w12 =  I(i+1,j+2);
            w13 =  I(i+2,j+2);
            PV = floor((w1+w2+w3+w4)/4); %(i,j)����Ԥ��ֵ����������ȡƽ��ֵ
            PE = I(i,j) - PV; %Ԥ�����
            Noise = abs(w2-w5)+abs(w5-w9)+abs(w3-w7)+abs(w4-w6)+abs(w6-w11)+abs(w10-w8)+abs(w8-w12)+abs(w12-w13)...
                +abs(w4-w8)+abs(w5-w3)+abs(w3-w6)+abs(w6-w12)+abs(w9-w7)+abs(w7-w11)+abs(w11-w13);  %��������ˮƽ              
            %% ���������ĸ�ֱ��ͼ
            if Noise <= S_Shadow(1)
                h_n = 1;
            elseif Noise > S_Shadow(15)
                h_n = 16;
            else 
                for s=2:15
                    if Noise>S_Shadow(s-1) && Noise<=S_Shadow(s)
                        h_n = s;
                        break;
                    end
                end
            end
            %% �ж��Ƿ�Ϊ�����
            flag = 0;
            [~,over] = size(map);
            lo = (i-1)*512+j; %λ��
            for l=1:over
                if lo == map(l);
                    flag = 1; %�������
                    break;
                end
            end
            %% ��ȡ��Ϣ
            a = Opt_Shadow(1,h_n); %���Ƕ���
            b = Opt_Shadow(2,h_n); %��ΧǶ���
            if flag == 0
                %% ��������ȡ��Ϣ
                 if PE>=0
                    if PE == b+(a-1) %��ȡ0 
                        num_exD2 = num_exD2+1;
                        exD2(num_exD2) = 0;
                        PE = PE - (a-1);
                    elseif PE == b+(a-1)+1 %��ȡ1
                        num_exD2 = num_exD2+1;
                        exD2(num_exD2) = 1;
                        PE = PE - (a-1) - 1;
                    elseif PE > b+a  %ƽ��
                        PE = PE - a;
                    elseif PE>=2*(a-1) && PE<b+(a-1) %ƽ��   
                        PE = PE - (a-1);
                    else
                        for p=0:a-2
                            if PE == 2*p  %��ȡ0
                                num_exD2 = num_exD2+1;
                                exD2(num_exD2) = 0;
                                PE = PE - p;
                                break;      
                            elseif PE == 2*p+1 %��ȡ1
                                num_exD2 = num_exD2+1;
                                exD2(num_exD2) = 1;
                                PE = PE - p -1;
                                break;
                            end
                        end  
                    end
                 else %PE<0         
                     if PE == -1-b-(a-1) %��ȡ0           
                         num_exD2 = num_exD2+1;      
                         exD2(num_exD2) = 0;
                         PE = PE + (a-1);         
                     elseif PE == -2-b-(a-1) %��ȡ1  
                         num_exD2 = num_exD2+1;
                         exD2(num_exD2) = 1;
                         PE = PE + (a-1) + 1;
                     elseif PE <= -2-b-a  %ƽ��      
                         PE = PE + a;    
                     elseif PE<-2*(a-1) && PE>-1-b-(a-1) %ƽ��   
                         PE = PE + (a-1);
                     else     
                         for p=1:a-1 
                             if PE == -2*p+1  %��ȡ0
                                 num_exD2 = num_exD2+1;
                                 exD2(num_exD2) = 0;  
                                 PE = PE + (p-1);
                                 break;
                             elseif PE == -2*p  %��ȡ1
                                 num_exD2 = num_exD2+1; 
                                 exD2(num_exD2) = 1;
                                 PE = PE + (p-1) + 1;
                                 break;
                             end  
                         end  
                     end   
                 end
                 else % flag == 0
                %% �������ȡ��Ϣ
                if PE>=0
                    PE = PE + a;
                    if PE == b+(a-1) %��ȡ0 
                        num_exD2 = num_exD2+1;
                        exD2(num_exD2) = 0;
                        PE = PE - (a-1);
                    elseif PE == b+(a-1)+1 %��ȡ1
                        num_exD2 = num_exD2+1;
                        exD2(num_exD2) = 1;
                        PE = PE - (a-1) - 1;
                    elseif PE > b+a  %ƽ��
                        PE = PE - a;
                    elseif PE>=2*(a-1) && PE<b+(a-1) %ƽ��   
                        PE = PE - (a-1);
                    else
                        for p=0:a-2
                            if PE == 2*p  %��ȡ0
                                num_exD2 = num_exD2+1;
                                exD2(num_exD2) = 0;
                                PE = PE - p;
                                break;      
                            elseif PE == 2*p+1 %��ȡ1
                                num_exD2 = num_exD2+1;
                                exD2(num_exD2) = 1;
                                PE = PE - p -1;
                                break;
                            end
                        end  
                    end
                 else %PE<0
                     PE = PE - a;
                     if PE == -1-b-(a-1) %��ȡ0           
                         num_exD2 = num_exD2+1;      
                         exD2(num_exD2) = 0;
                         PE = PE + (a-1);         
                     elseif PE == -2-b-(a-1) %��ȡ1  
                         num_exD2 = num_exD2+1;
                         exD2(num_exD2) = 1;
                         PE = PE + (a-1) + 1;
                     elseif PE <= -2-b-a  %ƽ��      
                         PE = PE + a;    
                     elseif PE<-2*(a-1) && PE>-1-b-(a-1) %ƽ��   
                         PE = PE + (a-1);
                     else     
                         for p=1:a-1 
                             if PE == -2*p+1  %��ȡ0
                                 num_exD2 = num_exD2+1;
                                 exD2(num_exD2) = 0;  
                                 PE = PE + (p-1);
                                 break;
                             elseif PE == -2*p  %��ȡ1
                                 num_exD2 = num_exD2+1; 
                                 exD2(num_exD2) = 1;
                                 PE = PE + (p-1) + 1;
                                 break;
                             end  
                         end  
                     end 
                end         
            end
            I(i,j) = PV + PE;
            end
        end    
    else
        %% Ƕ�������֮ǰÿ����ȡ��Ϣ
        for j = n-2:-1:2
            if mod((i+j),2) == 0
            w1 =  I(i-1,j); %��
            w2 =  I(i,j-1); %��
            w3 =  I(i+1,j); %��
            w4 =  I(i,j+1); %��
            w5 =  I(i+1,j-1);
            w6 =  I(i+1,j+1);
            w7 =  I(i+2,j);       
            w8 =  I(i,j+2);
            w9 =  I(i+2,j-1);
            w10 =  I(i-1,j+2);
            w11 =  I(i+2,j+1);
            w12 =  I(i+1,j+2);
            w13 =  I(i+2,j+2);
            PV = floor((w1+w2+w3+w4)/4); %(i,j)����Ԥ��ֵ����������ȡƽ��ֵ
            PE = I(i,j) - PV; %Ԥ�����
            Noise = abs(w2-w5)+abs(w5-w9)+abs(w3-w7)+abs(w4-w6)+abs(w6-w11)+abs(w10-w8)+abs(w8-w12)+abs(w12-w13)...
                +abs(w4-w8)+abs(w5-w3)+abs(w3-w6)+abs(w6-w12)+abs(w9-w7)+abs(w7-w11)+abs(w11-w13);  %��������ˮƽ
            %% ���������ĸ�ֱ��ͼ
            if Noise <= S_Shadow(1)
                h_n = 1;
            elseif Noise > S_Shadow(15)
                h_n = 16;
            else 
                for s=2:15
                    if Noise>S_Shadow(s-1) && Noise<=S_Shadow(s)
                        h_n = s;
                        break;
                    end
                end
            end 
             %% �ж��Ƿ�Ϊ�����
            flag = 0;
            [~,over] = size(map);
            lo = (i-1)*512+j; %λ��
            for l=1:over
                if lo == map(l);
                    flag = 1; %�������
                    break;
                end
            end
            %% ��ȡ��Ϣ
            a = Opt_Shadow(1,h_n); %���Ƕ���
            b = Opt_Shadow(2,h_n); %��ΧǶ���
            if flag == 0
                %% ��������ȡ��Ϣ
                 if PE>=0
                    if PE == b+(a-1) %��ȡ0 
                        num_exD2 = num_exD2+1;
                        exD2(num_exD2) = 0;
                        PE = PE - (a-1);
                    elseif PE == b+(a-1)+1 %��ȡ1
                        num_exD2 = num_exD2+1;
                        exD2(num_exD2) = 1;
                        PE = PE - (a-1) - 1;
                    elseif PE > b+a  %ƽ��
                        PE = PE - a;
                    elseif PE>=2*(a-1) && PE<b+(a-1) %ƽ��   
                        PE = PE - (a-1);
                    else
                        for p=0:a-2
                            if PE == 2*p  %��ȡ0
                                num_exD2 = num_exD2+1;
                                exD2(num_exD2) = 0;
                                PE = PE - p;
                                break;      
                            elseif PE == 2*p+1 %��ȡ1
                                num_exD2 = num_exD2+1;
                                exD2(num_exD2) = 1;
                                PE = PE - p -1;
                                break;
                            end
                        end  
                    end
                 else %PE<0         
                     if PE == -1-b-(a-1) %��ȡ0           
                         num_exD2 = num_exD2+1;      
                         exD2(num_exD2) = 0;
                         PE = PE + (a-1);         
                     elseif PE == -2-b-(a-1) %��ȡ1  
                         num_exD2 = num_exD2+1;
                         exD2(num_exD2) = 1;
                         PE = PE + (a-1) + 1;
                     elseif PE <= -2-b-a  %ƽ��      
                         PE = PE + a;    
                     elseif PE<-2*(a-1) && PE>-1-b-(a-1) %ƽ��   
                         PE = PE + (a-1);
                     else     
                         for p=1:a-1 
                             if PE == -2*p+1  %��ȡ0
                                 num_exD2 = num_exD2+1;
                                 exD2(num_exD2) = 0;  
                                 PE = PE + (p-1);
                                 break;
                             elseif PE == -2*p  %��ȡ1
                                 num_exD2 = num_exD2+1; 
                                 exD2(num_exD2) = 1;
                                 PE = PE + (p-1) + 1;
                                 break;
                             end  
                         end  
                     end   
                 end
            else % flag == 0
                %% �������ȡ��Ϣ
                if PE>=0
                    PE = PE + a;
                    if PE == b+(a-1) %��ȡ0 
                        num_exD2 = num_exD2+1;
                        exD2(num_exD2) = 0;
                        PE = PE - (a-1);
                    elseif PE == b+(a-1)+1 %��ȡ1
                        num_exD2 = num_exD2+1;
                        exD2(num_exD2) = 1;
                        PE = PE - (a-1) - 1;
                    elseif PE > b+a  %ƽ��
                        PE = PE - a;
                    elseif PE>=2*(a-1) && PE<b+(a-1) %ƽ��   
                        PE = PE - (a-1);
                    else
                        for p=0:a-2
                            if PE == 2*p  %��ȡ0
                                num_exD2 = num_exD2+1;
                                exD2(num_exD2) = 0;
                                PE = PE - p;
                                break;      
                            elseif PE == 2*p+1 %��ȡ1
                                num_exD2 = num_exD2+1;
                                exD2(num_exD2) = 1;
                                PE = PE - p -1;
                                break;
                            end
                        end  
                    end
                 else %PE<0
                     PE = PE - a;
                     if PE == -1-b-(a-1) %��ȡ0           
                         num_exD2 = num_exD2+1;      
                         exD2(num_exD2) = 0;
                         PE = PE + (a-1);         
                     elseif PE == -2-b-(a-1) %��ȡ1  
                         num_exD2 = num_exD2+1;
                         exD2(num_exD2) = 1;
                         PE = PE + (a-1) + 1;
                     elseif PE <= -2-b-a  %ƽ��      
                         PE = PE + a;    
                     elseif PE<-2*(a-1) && PE>-1-b-(a-1) %ƽ��   
                         PE = PE + (a-1);
                     else     
                         for p=1:a-1 
                             if PE == -2*p+1  %��ȡ0
                                 num_exD2 = num_exD2+1;
                                 exD2(num_exD2) = 0;  
                                 PE = PE + (p-1);
                                 break;
                             elseif PE == -2*p  %��ȡ1
                                 num_exD2 = num_exD2+1; 
                                 exD2(num_exD2) = 1;
                                 PE = PE + (p-1) + 1;
                                 break;
                             end  
                         end  
                     end 
                end         
            end
            I(i,j) = PV + PE;
            end
        end
    end    
end
%% ��¼��ȡ��Ϣ
recover_I2 = I;
exD = exD2;
for i=1:num_exD2
    exD2(i) = exD(num_exD2-i+1); %����
end