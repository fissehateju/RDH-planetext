function [HMat, Payl, Dist, drate, L, R, CHist, La,temph,sumhist,OriHist,indmx] = GetHMat1(Err,NumberIteration)
%Pay1�൱�����е�t��i��j��,L�൱�������е�M1��R�൱�������е�M2,drate�൱�������еĦˣ�NumberIteration=itenum = 10000:10000:110000
%CHist�൱�����е�hk��
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        

OriHist = hist(Err(:),[min(min(Err)):1:max(max(Err))]);%�������е�ֵ��С�������в�����ֱ��ͼ����ÿһ��Ԥ�������ֵĴ�����¼�ھ���OriHist��
%figure; hist(Err(:),[min(min(Err)):1:max(max(Err))]); axis([-40 50 0 18000]); % hist(OriHist);% axis([XMIN XMAX YMIN YMAX]) sets scaling for the x- and y-axes

sumhist = sum(OriHist);%sumhist��Ԥ�����ĸ���
temph = sign(OriHist - sumhist/4096);%������������ͷ���1�����������ͷ���0�����С����ͷ���-1
[vmax, indmx] = max(temph);%vmax�Ǿ���temph��ÿһ�е����ֵ��indmx��ÿһ�����ֵ��λ��.���ǽ�ÿһ��temphΪ1��λ�ñ�ǳ���
for k = indmx:length(OriHist)
    if temph(k) == 1 
        indmx1 = k;
    end
end
%indmx��temph��1�������λ�ã�indmx1��temph��1�����Ҳ�λ��
L = min(min(Err))+indmx-1;% min(min(Err))ȡ��Err�������Сֵ���ҳ�indmx��Ӧ�����ֵ�Ƕ���
R = min(min(Err))+indmx1-1;
%L�൱�������е�M1����߽��ޣ���R�൱�������е�M2
CHist =round(OriHist/(sumhist/2048));%CHist�൱�����е�hk��Ԥ�����k��Ӧ��������
for k = indmx:length(CHist)
    if CHist(k) == 0
        CHist(k) = 1;
    end
end
%Ϊ�����ֽ�����ǰ���20��0
%figure; bar([1:1:92]-42, CHist, 1); axis([-22 22 0 300]);
% return

OriHist = [zeros(1,20) CHist(1,indmx:indmx1) zeros(1,20)];
%ȡ��CHist��indmx��indmx1����ֵ��ǰ���ȡ20��0������ֵ����������

%%%%%%%%%%%%%%%%%%
%��CHist��ȡ�������ݷ���OriHist ͬ����С�ľ���ĶԽ�����
LH = length(OriHist); 
HMat = zeros(LH,LH);
for k = 1:LH
    HMat(k,k) = OriHist(k);
end

delta = 1/8;
DRATE = zeros(1,NumberIteration);%������¼ÿ�ε��������Ħ�
for k = 1:NumberIteration
    HMatFold = sum(HMat);%��HMat��ÿһ�н������
    drate = 0;
    %ȷ��������k�ķ�Χ
    for i = 21:LH-20%LHΪOriHist�ĳ��ȣ�������
        for j = 21:LH-20%֮����-20����Ϊͷβ��20��0���м�����Ĳ�������������
            if HMat(i,j) >= delta 
                if i == j
                    jjmin = max(j-5,21);%ȡ����ֵ���ֵ����j=21;jjmin=21,jjmaxȡ����ֵ�бȽ�С��ֵ����jjmax=j+5��
                    jjmax = min(j+5,LH-20);%ȡ����ֵС����ֵ
                else
                    if j > i
                        jjmin = min(j+1,LH-20);
                        jjmax = min(j+5,LH-20);
                    else                                                                                                                                                                                                                                                                                                                                                                                                           
                        jjmin = max(j-5,21);
                        jjmax = max(j-1,21);
                    end
                end                                   
                for jj = jjmin:jjmax  
                    dp = log(HMatFold(j)/HMatFold(jj));
                    dd = (jj-i)^2 - (j-i)^2;
                    if dp > 0
                        dratetemp = dp/dd;%�������еĦ�
                        if dratetemp > drate %�����>0                           
                            drate = dratetemp;%���˸���drate
                            di = i; dj = j; djj = jj;                            
                        end
                    end
                end
            end
        end
    end
    %disp([di dj djj drate]);
    DRATE(1,k) = drate;%��ÿ�ε��������Ħ˼�¼����
    HMat(di,dj) = HMat(di,dj) - delta;
    HMat(di,djj) = HMat(di,djj) + delta;%���¾��󣬴Ӷ��������еĦ�
end  
La = mean(DRATE(1,NumberIteration-500:NumberIteration));%���NumberIteration-500λ�ÿ�ʼֱ����������Ϊֹ�����Ц˵ľ�ֵ
%plot(DRATE);
%disp([di dj djj drate]);

    Dist = 0;
    for i = 1:LH
        for j = 1:LH
            Dist = Dist + HMat(i,j)*(j-i)^2;%��ʧ��
        end
    end
    Payl = 0;
    for i = 1:LH
        Payl = Payl + GetEntropy (HMat(i,:))
    end
    Payl;
    for j = 1:LH
        Payl = Payl - GetEntropy (HMat(:,j));%����
    end
   
    [Payl Dist];

    
   


