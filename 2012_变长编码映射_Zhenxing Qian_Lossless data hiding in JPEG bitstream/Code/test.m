clc;clear;
%% ��ȡ�ļ�
addpath('functions_stream');
addpath('D:\Matlab\ucid.v2');
fidorg = fopen('Baboon_10.jpg');
jpgData=fread(fidorg);%��ȡ�ļ�ȫ������
[byteNum,n]= size(jpgData);
%% ��ȡ�ļ�ͷ
fprintf('��ȡ�ļ�ͷ...\n');
locff=find(jpgData==255);%��ȡJPEG�ļ���FF��λ��
jhddata=fun_read_header(locff,jpgData);%��ȡ�ļ�ͷ����
[len,height]=size(jpgData);
for i=1:len
    if(jpgData(i,1)==0&&jpgData(i+1,1)==63&&jpgData(i+2,1)==0)
        break;
    end 
end
jpg_head=jpgData(1:i-1,:);
[height_ini, width_ini] = fun_read_sof_wh(locff,jpgData);
height_ini = height_ini(1)*256 + height_ini(2);
width_ini = (width_ini(1))*256 + width_ini(2);
%% ��ȡ�ļ���������
fprintf('��ȡ�ļ���������...\n');
locc4=find(jpgData(locff+1,1)==196);%��ȡhuffman��  FF C4
if length(locc4)>1,
	jhuffdcdata=fun_read_dht(locff,jpgData,fidorg,1);%��ȡ�ļ�ͷ�б�ʾhuffman��Ĳ���
	tdchufftbl=fun_huff_dctable(jhuffdcdata);%����dc��huffman��
	jhuffacdata=fun_read_dht(locff,jpgData,fidorg,2);
	tachufftbl=fun_huff_actable(jhuffacdata);
else
    [jhuffdcdata,jhuffacdata] = fun_read_huff(locff,locc4,jpgData,fidorg);
	tdchufftbl=fun_huff_dctable(jhuffdcdata);   %����dc��huffman��--��һ���볤��������ŵ������ֵı���
	tachufftbl=fun_huff_actable(jhuffacdata);   %run - category - length - base code length -  base code
end
%% ��ȡ�ļ�������
fprintf('��ȡ�ļ�������...\n');
jsosdata=fun_read_sos(locff,jpgData,fidorg);%��ȡSOSɨ�貿����Ч��ͼƬ����ѹ����
jsosdataclr=fun_dlt_zero(jsosdata);%ȥ������ѹ������255��������00
vsosbits=fun_gen_bits(jsosdataclr);%������ѹ��������0��1��һ������
% [ acPosition,vlcUsedNum ] = fun_parse_data( 4096,vsosbits,tdchufftbl,tachufftbl );
init_len = length(vsosbits);%ԭʼ����������
[~,~,pblkrow,pblkcol]=fun_jpg_size(jpgData,locff);
pblknum=pblkrow*pblkcol;%����ͼƬ�ָ��8*8ģ����
% ��ȡÿһ��block��λ���Լ�appended��Ϣ
tmpi=1;  tmppydcp=1; 
%tmppydcp ÿһ��DC���ص���ʼλ��
%tmppyacp ÿһ��AC���ص���ʼλ��
while tmpi<=pblknum
    %vdcapplen��ÿ����DC appended bitsteam ����
    [tmppyacp,vdcapplen(tmpi,1)]=fun_parse_dc(vsosbits,tdchufftbl,tmppydcp); 
    dc_posi(tmpi) = tmppydcp;%��ȡÿһ��DC��ַ����ÿһ��block��λ��
    %vaccodeidx{tmpi,1}����tmpi��������ACϵ�������������������ǵڼ���
    [tmppydcp,vaccodeidx{tmpi,1}]=fun_parse_ac(vsosbits,tachufftbl,tmppyacp);
    tmpi=tmpi+1;
end
%% �����ļ�������
fprintf('�����ļ�������...\n');
%vlc_used_num - ÿ��vlc��ѹ�����г��ֵĴ�����Ƶ�ʣ�
vlc_used_num = zeros(162,1);
%vlc_group - ��vlc_used_num����vlc���ȷ���
vlc_group=cell(1,16);
%vlc_subsets - ÿ��vlc�ֳ�used_VLC��unused_VLC
vlc_subsets = cell(1,16);
for i=1:pblknum
    for j=1:length(vaccodeidx{i,1})
        vlc_used_num(vaccodeidx{i,1}(j,1),1)=vlc_used_num(vaccodeidx{i,1}(j,1),1)+1;
    end
end
for i=1:16
vlc_group{:,i} = (reshape(vlc_used_num(find(tachufftbl(:,4)==i)),1,[]));
unused_num = length(find(vlc_group{:,i}==0));
used_num = length(vlc_group{:,i}) - unused_num;
vlc_subsets{:,i} = [used_num,unused_num];
end
%% ���ݷ���
payload = max(vlc_used_num); % ���Ƕ���غ�
achufftable = sortrows(tachufftbl,4);
ac_vlc(:,1:2) = achufftable(:,1:2);
ac_vlc(:,4) = achufftable(:,4);
flag = 1;
for i=1:16
    if(~isempty(vlc_group{1,i}))
        [rows,columns] = size(vlc_group{1,i});
        for j=1:columns
            ac_vlc(flag,3) = vlc_group{1,i}(1,j);
            flag = flag + 1;
        end
    end
end
acvlc = ac_vlc;
zero_point = find(acvlc(:,3)==0,1);
acvlc(1:zero_point,:) = sortrows(acvlc(1:zero_point,:),-3);
acvlc(:,5) = achufftable(:,4);
increased_proposed = 0; % JPEGͼ��ʹ�ñ��������ӵı�����
increased_liu = 0; % JPEGͼ��ʹ�����ķ������ӵı�����
for i = 2:zero_point
    increased_proposed = increased_proposed + acvlc(i,3) * (acvlc(i+1,5) - acvlc(i,4));
end
liu_vlc = vlc_used_num;
liu_vlc(:,2) = tachufftbl(:,4);
zero_point_liu = find(liu_vlc(:,1)==0,1);
for i = find(max(liu_vlc(:,1)))+1:zero_point_liu
    increased_liu = increased_liu + liu_vlc(i,1) * (liu_vlc(i+1,2) - liu_vlc(i,2));
end