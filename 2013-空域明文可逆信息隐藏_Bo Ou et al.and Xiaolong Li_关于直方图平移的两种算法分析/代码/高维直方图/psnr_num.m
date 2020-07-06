function [PSNR] = psnr_num(origin_I)
S = 70000;
num_P = floor(S/5000); 
PSNR = zeros(1,num_P);
for num = 5000:+5000:S
    rand('seed',0);
    D = round(rand(1,num)*1); %�����ȶ������
    %Ƕ������
    [stego_I,~,~] = embed(origin_I,D);
    %��PSNRֵ
    psnrvalue0 = psnr(origin_I,stego_I);
    PSNR(num/5000) = psnrvalue0; 
end