function [stegoim1,P1,P2,number0255,number0255r]=ReverEmbed(Err1,im1,HMat, Payl, Dist, drate, L, R, CHist)
%Err1����im1ԭʼ������ֵ��HMat�Ǿ���Payl�Ǹ��أ�Dist��ʧ�棬drate�Ǧˣ�L�൱�����ĵ�M1,R�൱�����ĵ�M2,CHist�൱�������е�h
stegoim1 = im1;
[size1,size2] = size(Err1);
HMatFold = sum(HMat);%��HMatÿһ�����

P1 = 0;
P2 = 0;
P21 = 0; P22 = 0; P23 = 0; P24 = 0; P25 = 0; 
number0255 = 0;
number0255r = 0;
for i = 1:size1
    for j = 1:size2
        tempe = Err1(i,j);%ÿһ�����ֵ
        tempp = im1(i,j);%���ֵ��Ӧ��ԭʼ����ֵ
        if tempe < L%������ֵ���ھ���Χ�ڣ���ߣ�
            tempv = tempe-L+21;%�������ֵ
            if tempv > 0
                if HMatFold(tempv) > 0
                    P21 = P21 - log(0.5/(0.5+HMatFold(tempv)))/log(2);%��L��ߵ����ֵת��Ϊ��������ռ��λ��
                end
            end
        else
            if tempe > R
                tempv = tempe-L+21;
                if tempv < length(HMatFold)+1
                    P22 = P22 - log(0.5/(0.5+HMatFold(tempv)))/log(2);%��L�ұߵ����ֵת��Ϊ��������ռ��λ��
                end
            else%���ֵ��L��R֮��
                fnz = find(HMat(tempe-L+21,:));%�ҵ���tempe-L+21�з���Ԫ���ڵ�tempe-L+21�е�λ��
                vnz = nonzeros(HMat(tempe-L+21,:));%�ҵ���tempe-L+21�з���Ԫ��ֵ
                vnz = vnz';
                fnz = fnz - (tempe-L+21) + tempp; %AES�����������tempp��ԭʼ����ֵ+fnz��Ӧ���µ����ֵ-(tempe-L+21)ԭʼ�����ֵ
                if min(fnz) > 255
                    stegoim1(i,j) = 255;%��Ǳ�Ե��Ϣ
                    number0255 = number0255 + 1;
                    number0255r = number0255r + 1;
                else
                    if max(fnz) < 0
                        stegoim1(i,j) = 0;%��Ǳ�Ե��Ϣ
                        number0255 = number0255 + 1;
                        number0255r = number0255r + 1;
                    else%fnz��0��255֮��ʱ������������Ӧ����Ĺ���
                        msk1 = (sign(fnz + 0.5) + 1)/2;%ת��Ϊ0��1����
                        msk2 = (sign(255.5 - fnz) + 1)/2;
                        msk = msk1 .* msk2;%.*��������ˣ���ʾ���Ԫ�صĳ˷�,��Ӧλ�õ�Ԫ�ص����
                        fnz = msk .* fnz;%
                        vnz = msk .* vnz;
                        vnz = vnz/sum(vnz);%���������صõ����µ����ĸ����ĸ���
                        rand('seed',i*2001+j);%�������ӣ�ÿ�������ȶ��������,��֤ÿ�β�����������в���ͬ
                        tempa = rand(1,1);%����0��1֮��������
                        tempb = 0; tempc = 0;
                        while tempb < tempa
                            tempc = tempc + 1;
                            tempb = tempb + vnz(tempc);%�������µõ������ĸ��ʽ����ۼ�
                        end
                        tempc;
                        P1 = P1 - log(vnz(tempc))/log(2); %�����µõ��������ռ����ת��Ϊ��������ռ��λ��
                        stegoim1(i,j) = fnz(tempc);%��¼�¶�Ӧ������ֵ
                        if fnz(tempc) == 0%��¼����Ƕ���������ֵΪ0��255�ĸ���
                            number0255 = number0255 + 1;
                        end
                        if fnz(tempc) == 255
                            number0255 = number0255 + 1;
                        end
                        tempd = fnz(tempc) - tempp + (tempe-L+21);%Ƕ����Ϣ��õ����µ�����ֵ
                        if tempd < 21
                            P23 = P23 - log(HMat(tempe-L+21,tempd)/(0.5+HMatFold(tempd)))/log(2);%С��L����ֵ��ռ��λ��
                        else
                            if tempd > length(HMatFold) - 20
                                P24 = P24 - log(HMat(tempe-L+21,tempd)/(0.5+HMatFold(tempd)))/log(2);%����R����ֵ��ռ��λ��
                            else
                                P25 = P25 - log(HMat(tempe-L+21,tempd)/HMatFold(tempd))/log(2);%��L��R֮�����ֵ��ռ��λ��
                            end
                        end
                    end
                end
            end
        end
    end
end                   
% disp([P21 P22 P23 P24 P25]);
P2 = P21+P22+P23+P24+P25;
                    