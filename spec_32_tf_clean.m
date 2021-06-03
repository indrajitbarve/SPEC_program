
% this program is to plot the spec binary data 
% and followed bye 401 points 
% jith : time information added in graph on 26:07:2008;;

%folder_path = input('Enter the folder name with path.....: ','s');
%23-10-08
%1.F.M band rejected and VBW=RBW=300 KHz to aviod smooth plot.
%2.Header information for each sweep first 8 bytes followed by data 1604 bytes
%totally 1612 bytes ,401 points.35 - 85 MHz, so 125 KHz freq,resolution.
%3.Header information as follow as
 % bytes index         details
 %===============================
 %   0001-------------> year last two digits 
 %    0002-------------> month(1-12);
 %    0003-------------> date(1-31);
  %   0004-------------> hour(0-24)UT;
 %    0005-------------> min (0-59);
  %   0006-------------> secs(0-59);
  %   0007-------------> start frequency (MHz);
 %    0008-------------> stop frequency (MHz);
 %    0009-------------> sweep time(msec)
%     0010-------------> reserved for future use
%     0011-------------> data starts(amplitude data 32 bits= 4 bytes and this is LSB);
%     0012-------------> data which we used to plot this data contains the information 
%                        so collect all the 3 and multiples of 3 index values remaining
%                        3 bytes are not used to plot;
%     1614-------------> last byte
 %    second sweep data 
%	.
%	.
%	.
%	.
%	.
%	.
%	.
%	.
%   2000 sweeps.
%=========================================================================================
% above one was canceled and reading the data as int 32 .......
 %===============================
 %   0001-------------> year last two digits 
 %    0002-------------> month(1-12);
 %    0003-------------> date(1-31);
  %   0004-------------> hour(0-24)UT;
 %    0005-------------> min (0-59);
  %   0006-------------> secs(0-59);
  %   0007-------------> start frequency (MHz);
 %    0008-------------> stop frequency (MHz);
 %    0009-------------> sweep time(msec)
%     0010-------------> number of points each sweep 
%     0011-------------> data starts from here
%     0012-------------> second data  here i am reading the data as int 32 values 
%     0411-------------> last data
 %    second sweep data 
%	.
%	.
%	.
%	.
%	.
%	.
%	.
%	.
%   2000 sweeps.
%=========================================================================================
%clear;


 folder = input('Enter the folder.....: ','s');
 file = input('To start prees "s"  To stop type "x" ........: ','s');
 folder_path = strcat('/home/graphx/Documents/kodai_spec/',folder);
while file ~= 'x';
       
    file = input('Enter the file number to plot (or) to stop "x".......: ','s');  
    if file == 'x',break,end
 
    file_path = strcat(folder_path,'/Data_kkl0',file,'.spec');
  %file_path = strcat(folder_path,'/Data',file,'.spec');

%    file_path = strcat('/home/grh/work/Spec/Data61.spec');
   %z= strcat('Data',file);
   fid = fopen(file_path,'r');
   [data,count]=fread(fid,'int32');
   raw=reshape(data,411,2000);
   raw1=raw;
   header_info=raw(1:10,:);
   out=raw(11:411,:)/1000.0;
   [x y]=size(out);
   raw=[];
   data=[];
   st_freq=header_info(7,1);
   end_freq=header_info(8,1);
   num_freq_channel=(header_info(10,1)-1);
   del_freq=((end_freq-st_freq)/num_freq_channel);

st_time_info = header_info(4:6,1);
st_hh= num2str(st_time_info(1));st_min= num2str(st_time_info(2));st_ss= num2str(st_time_info(3));
start_time_UT= strcat('Start time --->' ,st_hh,':',st_min,':',st_ss,' UT ,');
ttt=[1:1:2000];
end_time_info = header_info(4:6,2000);
end_hh= num2str(end_time_info(1));end_min= num2str(end_time_info(2));end_ss= num2str(end_time_info(3));
end_time_UT= strcat('  End time ---> ',end_hh,':',end_min,':',end_ss,' UT');
st_time=st_time_info(1)+(st_time_info(2)/60)+(st_time_info(3)/3600);
end_time=end_time_info(1)+(end_time_info(2)/60)+(end_time_info(3)/3600);
delta_t=((end_time-st_time)/2000);
fff=[st_freq:del_freq:end_freq];
tt=[st_time:delta_t:end_time];
% ttt=tt(1:2000)-5.553055556;
ttt=tt(1:2000);
%open 'temp_1.fig';
%subplot(2,2,1);axes('Position',[0.05859 0.2192 0.8289 0.7058]);


 figure(1);
% % subplot(4,4,[1,2,3,5,6,7,9,10,11]);
%  pcolor(ttt,fff,out);
%  ylabel ('Frequency (MHz)');xlabel ('Time in UT'); shading interp;axis tight;

%figure(1);
%subplot(4,4,[1,2,3,5,6,7,9,10,11]);
pcolor(ttt,fff,out);ylabel ('Frequency (MHz)');shading interp;axis tight;
title('RAW IMAGE');
%m_out_t=mean(out(1:185,:));
%m_out_t=mean(out(149:153,:)); % 80 mhz with 1 MHz bandwidth
%m_out_t=mean(out(99:103,:)); % 65 mhz with 1 MHz bandwidth
%m_out_t_p=m_out_t;
   
%m_out_f=mean(out');
%subplot(4,4,[13:15]);
%subplot(2,2,2);axes('Position',[0.05859 0.07523 0.8258 0.144]);

%plot(ttt,m_out_t);grid;axis tight
%subplot(2,1,2);axes('Position',[0.9094 0.2274 0.07344 0.6976]);
%xlabel(strcat(start_time_UT,end_time_UT));
%subplot(4,4,[4,8,12]);
%plot(m_out_f,fff);grid;axis tight


% zz=[];
% 
% %   For cleaning the raw data use this commands .
% for i=1:401;
%     zz(i,:)=out(i,:)-median(out(i,:));
%   % t(i,:)=ttt(i,:)-median(ttt(i,:));
% end

d1m=medfilt2(out-median(out(:,1:100),2)*ones(1,length(out)),[5 5]);

figure(2);
subplot(2,1,1);
%set(gca,'position',[0.1300 0.2838 0.7750 0.6412])

pcolor(ttt,fff,d1m);shading interp;ylabel ('Frequency (MHz)');axis tight;
colormap('jet')
% figure(2);pcolor(ttt,fff,zz),shading interp;ylabel ('Frequency (MHz)');xlabel ('Time in UT');axis tight;
%title('CLEANED IMAGE');
%xlabel(strcat(start_time_UT,end_time_UT));
subplot(2,1,2);
%set(gca,'position',[0.1300    0.0738    0.7750    0.1855])

plot(ttt,mean(d1m));
xlabel ('Time in UT');
ylabel('Amplitude');
axis tight;
end


% xxx=zz;
% xxxt=ttt;
 %zzz=[xxx yyy];
 %figure(3);pcolor(ttt,fff,zzz);shading interp;
% title(strcat (folder,strcat( ' -  ', z)));
% m_out_t=mean(out(1:185,:));
% m_out_t=mean(out(149:153,:)); % 80 mhz with 1 MHz bandwidth
% m_out_t=mean(out(99:103,:)); % 65 mhz with 1 MHz bandwidth
% m_out_t_p=m_out_t;
%    
% m_out_f=mean(out');
% subplot(4,4,[13:15]);
% subplot(2,2,2);axes('Position',[0.05859 0.07523 0.8258 0.144]);
% 
% plot(ttt,m_out_t);grid;axis tight
% subplot(2,1,2);axes('Position',[0.9094 0.2274 0.07344 0.6976]);
% xlabel(strcat(start_time_UT,end_time_UT));
% subplot(4,4,[4,8,12]);
% plot(m_out_f,fff);grid;axis tight



