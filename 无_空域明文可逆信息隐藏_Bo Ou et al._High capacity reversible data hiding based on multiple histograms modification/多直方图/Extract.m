function [recover_I,exD] = Extract(stego_I,S_Shadow,Opt_Shadow,map1,end_x1,end_y1,S_Blank,Opt_Blank,map2,end_x2,end_y2)
% ���룺stego_I����ͼ��  �����recover_I�ָ�ͼ��exD��ȡ����
% ��ɫ�飺S_Shadowѹ������ˮƽ������Opt_Shadow����Ƕ�������map1�����Ϣ��(end_x1,end_y1)����λ��
% ��ɫ�飺S_Blankѹ������ˮƽ������Opt_Blank����Ƕ�������map2�����Ϣ��(end_x2,end_y2)����λ��

%% ����(1,2)λ�ÿ�ʼ�İ�ɫ����������ȡ��Ϣ
[recover_I1,exD1] = Extract_Blank(stego_I,S_Blank,Opt_Blank,map2,end_x2,end_y2);
%% ����(1,1)λ�ÿ�ʼ�ĺ�ɫ����������ȡ��Ϣ
[recover_I2,exD2] = Extract_Shadow(recover_I1,S_Shadow,Opt_Shadow,map1,end_x1,end_y1);
%% ��¼Ƕ������
recover_I = recover_I2;
exD = [exD2,exD1];
end