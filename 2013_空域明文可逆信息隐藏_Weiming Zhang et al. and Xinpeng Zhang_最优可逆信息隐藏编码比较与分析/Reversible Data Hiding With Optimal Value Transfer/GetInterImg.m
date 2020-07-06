function [iminter,X]=GetInterImg(im,label)

im = double(im);
[size1,size2] = size(im);%��ȡim�ĳ��Ϳ�

iminter = zeros(size1,size2);%Ϊiminter�趨�ռ�
%%
%Ԥ��ֵ����Ե��Ԥ��ֵ��
iminter(1,1) = (im(1,2)+im(2,1))/2;%��һ��Ԥ��ֵ
iminter(1,size2) = (im(1,size2-1)+im(2,size2))/2;%���Ͻ�Ԥ��ֵ
iminter(size1,size2) = (im(size1,size2-1)+im(size1-1,size2))/2;%���һ��Ԥ��ֵ
iminter(size1,1) = (im(size1,2)+im(size1-1,1))/2;%���½ǵ�Ԥ��ֵ
iminter(1,2:size2-1) = (im(1,1:size2-2)+im(1,3:size2)+im(2,2:size2-1))/3;%��һ�г�ȥ��������ֵ���Ԥ��ֵ
iminter(2:size1-1,1) = (im(2:size1-1,2)+im(1:size1-2,1)+im(3:size1,1))/3;%��һ�г�ȥһ������ֵ���Ԥ��ֵ
iminter(size1,2:size2-1) = (im(size1,1:size2-2)+im(size1,3:size2)+im(size1-1,2:size2-1))/3;%���һ�г�ȥһ��һ��ֵ���Ԥ��ֵ
iminter(2:size1-1,size2) = (im(2:size1-1,size2-1)+im(1:size1-2,size2)+im(3:size1,size2))/3;%���һ�г�ȥһ��һ��ֵ���Ԥ��ֵ

% iminter(2:size1-1,2:size2-1) = (im(2:size1-1,1:size2-2)+im(2:size1-1,3:size2)+im(1:size1-2,2:size2-1)+im(3:size1,2:size2-1))/4;
% iminter(2:size1-1,2:size2-1) = ((im(2:size1-1,1:size2-2)+im(2:size1-1,3:size2))*0.65+(im(1:size1-2,2:size2-1)+im(3:size1,2:size2-1))*0.35)/2;
%%
%����Ȩ����Ԥ��ֵ
if label == 1
B = [im(2:2:size1-1,2:2:size2-1); im(3:2:size1-1,3:2:size2-1)];%����ľ������ӣ���ȡ�����У���ȡż���У�������һ��
B = B(:);%����������ݴ�������ȡ���г�һ��
A = zeros(length(B),4);%��A����B��4�еľ���
Temp = [im(1:2:size1-2,2:2:size2-1); im(2:2:size1-2,3:2:size2-1)];
A(:,1) = Temp(:);%������A�ĵ�һ�������滻Ϊtemp��������ȡ���г�һ�е���ֵ
Temp = [im(3:2:size1,2:2:size2-1); im(4:2:size1,3:2:size2-1)];
A(:,2) = Temp(:);%������A�ĵڶ��������滻Ϊtemp��������ȡ���г�һ�е���ֵ
Temp = [im(2:2:size1-1,1:2:size2-2); im(3:2:size1-1,2:2:size2-2)];
A(:,3) = Temp(:);%������A�ĵ����������滻Ϊtemp��������ȡ���г�һ�е���ֵ
Temp = [im(2:2:size1-1,3:2:size2); im(3:2:size1-1,4:2:size2)];
A(:,4) = Temp(:);%������A�ĵ����������滻Ϊtemp��������ȡ���г�һ�е���ֵ
X = pinv(A'*A)*(A'*B);%������A'��ͬ�ߴ�ľ���X                                                                                                                   
iminter(2:size1-1,2:size2-1) = im(1:size1-2,2:size2-1)*X(1,1) + im(3:size1,2:size2-1)*X(2,1) + im(2:size1-1,1:size2-2)*X(3,1) + im(2:size1-1,3:size2)*X(4,1);
%��ȥ��һ�е�һ�к��ÿ������ֵ��Ԥ��ֵ
else
B = [im(2:2:size1-1,3:2:size2-1); im(3:2:size1-1,2:2:size2-1)];
B = B(:);
A = zeros(length(B),4);
Temp = [im(1:2:size1-2,3:2:size2-1); im(2:2:size1-2,2:2:size2-1)];
A(:,1) = Temp(:);
Temp = [im(3:2:size1,3:2:size2-1); im(4:2:size1,2:2:size2-1)];
A(:,2) = Temp(:);
Temp = [im(2:2:size1-1,2:2:size2-2); im(3:2:size1-1,1:2:size2-2)];
A(:,3) = Temp(:);
Temp = [im(2:2:size1-1,4:2:size2); im(3:2:size1-1,3:2:size2)];
A(:,4) = Temp(:);
X = pinv(A'*A)*(A'*B);
iminter(2:size1-1,2:size2-1) = im(1:size1-2,2:size2-1)*X(1,1) + im(3:size1,2:size2-1)*X(2,1) + im(2:size1-1,1:size2-2)*X(3,1) + im(2:size1-1,3:size2)*X(4,1);
end    
%%

iminter = round(iminter);