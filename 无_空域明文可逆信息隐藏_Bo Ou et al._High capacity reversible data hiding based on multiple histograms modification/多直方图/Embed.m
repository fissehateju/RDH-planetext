function [stego_I,emD,S_Shadow,Opt_Shadow,map1,end_x1,end_y1,S_Blank,Opt_Blank,map2,end_x2,end_y2] = Embed(origin_I,D)
%origin_I��ʾԭʼͼ��D��ʾ�������ݣ�stego_I��ʾ����ͼ��emD��ʾ��Ƕ�������
% num_emD = 0; %����,��¼Ƕ�����ݸ���
% [m,n] = size(origin_I); %ͳ��stego_I��������

%����Ԥ�⣬������Ƕ����Ϣ
num_D = length(D); %ͳ���������ݸ���
half = floor(num_D/2);
D1 = D(1:half);
D2 = D(half+1:num_D);
%% ����(1,1)λ�ÿ�ʼ�ĺ�ɫ��������Ƕ����Ϣ
[stego_I1,emD1,S_Shadow,Opt_Shadow,map1,end_x1,end_y1] = Embed_Shadow(origin_I,D1);
%% ����(1,2)λ�ÿ�ʼ�İ�ɫ��������Ƕ����Ϣ
[stego_I2,emD2,S_Blank,Opt_Blank,map2,end_x2,end_y2] = Embed_Blank(stego_I1,D2);
%% ��¼Ƕ������
stego_I = stego_I2;
emD = [emD1,emD2];
end