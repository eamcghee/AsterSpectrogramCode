%set up for 1 Hz data long (merged) sac files
clear
fclose('all');

comp='LHZ';
% eval(['!/bin/ls ../SAC_Files2/Longfiles/DR01-2015-year_',comp,'.sac | sort | uniq > list.all'])
%eval(['!/bin/ls ./RIS_14to16/Longfiles/DR01-2014-3-xx_',comp,'.sac > list.all'])
eval(['!/bin/ls ./Longfiles/DR03-2014-3-xx_',comp,'.sac > list.all'])

!cat list.all | wc -l > list.num
fid1 = fopen('list.num');
fid2 = fopen('list.all');
i=1;
while 1
           tline = fgetl(fid2);
            if ~ischar(tline), break, end
            if i==1
            stnames=tline;
            else
                stnames=char(stnames,tline);
            end
            i=i+1;
        end
        fclose(fid2);

nstas=fscanf(fid1,'%d');
fclose(fid1);

for i=1:nstas
    H=figure(i);
[sachdr,data]=load_sac(stnames(i,:));
year=sachdr.nzyear;
datestr_start=['01-01-',num2str(year)];
d_start=datenum(datestr_start)+sachdr.nzjday-1;
ndays_data=sachdr.npts/60/60/24;
d_end=d_start+ndays_data;
xl=[d_start,d_end];

data=detrend(data);
sensitivity = 5.038830e8;
data=data/sensitivity;
% G=max(abs(data));
% data=data/G;
%convert to acceleration (1 s/s)
adata=diff([0;data]);
%Decimation Factor
D=1;
% adata=decimate(adata,D);
% ddata=decimate(data,D);

[month,day]=monthday(sachdr.nzyear,sachdr.nzjday);
tzmin=datenum(sachdr.nzyear,month,day,sachdr.nzhour,sachdr.nzmin,sachdr.sec);
tzmax=tzmin+length(adata)*sachdr.delta/(24*60*60);
Td=linspace(tzmin,tzmax,length(adata));

NW=1024;
%log spacing spectrogram
%freqs=logspace(log10(1/1000),log10(0.5),512);
freqs=[];
%freqs=linspace(0,20,256);

    Ax=[110 130 1000 1200];
    set(H,'Position',Ax);
    [S,F,T,PSD]=spectrogram(detrend(adata),hanning(NW),round(0.95*NW),freqs,1);
    %[S,F,T,PSD]=spectrogram(detrend(adata),1e4,[],[],1);
    F=F/sachdr.delta/D;
    %convert spectrum to power spectral density
  %PSD=real(S.*conj(S))/NW;
    %rerun old data if Sstore, etc. are loaded
    %S=squeeze(Sstore(:,:,i));
    %Tadj is the time in seconds relative to the event origin time
    %index of values to evaluabe pre event spectral normalization
    %ipre=find(Tadj<0&Tadj>-24*60*60);
    %mean of pre-event noise (5 hours)
    %medS(:,i)=median(abs(S(:,ipre(1:end-1)))')';
    medPSD=mean(PSD,2);
    %medS(:,i)=median(abs(S));
    [~,C]=size(PSD);
    %build a matrix for pre-event spectral normalization
    PSDnorm=repmat(medPSD,1,C);
    %Snorm=ones(size(Snorm));
    %Sstore(:,:,i)=S;
    %PSD
    %normalize to get signal/noise PSD
    PSDdiff=PSD./PSDnorm;
    %S2=abs(S);
    %smooth the PSD spectrograms a bit (quasi-Gaussian)
    PSDsm=imgaussfilt(PSD,[3,11]);
%     kern=ones(5,50)/250;
%       PSDsm=filter2(kern,PSD);
%       PSDsm=filter2(kern,PSDsm);
%       PSDsm=filter2(kern,PSDsm);
%     
	   %PSDsm=PSD;
% 
%       PSDdiffsm=filter2(kern,PSDdiff);
%       PSDdiffsm=filter2(kern,PSDdiffsm);
%       PSDdiffsm=filter2(kern,PSDdiffsm);
    
    PSDdiffsm=PSDdiff;
         PSDdiffsm=imgaussfilt(PSDdiff,[3,11]);
%     %instrument amplitude response
    %r=t120tfunc(F);
%     Fcut=.005;:%s/
%     F_ind=find(F<Fcut);
%     r(F<Fcut)=r(F_ind(end));
%     r=r/max(abs(r));
%     %instrument response correction

% r=ones(size(F))*sensitivity;
%     R=repmat(abs(r),1,C);
%     S4=S4./R;
%     %unitary instrument response
%     R=ones(size(R));
    h=subplot(5,1,1);
    plot(Td,adata);
    s=std(data);
    datetick('x',6)
    xlim(xl)
    %bookfonts
    ylabel('A (m/s^2)')
    title([comp,' ',num2str(sachdr.nzyear),' ',sachdr.kstnm])
    set(gca,'xtick',[])
    %axis tight;
    ylim([-9*s,9*s])
%     ax=get(h,'Position');
%     ax(3:4)=ax(3:4)*0.955;
%     set(h,'Position',ax)
%     
PSDlim=[-160 -80];
%PSDrange=[-50 50];
%     h=subplot(6,1,1);
%     semilogx(F,10*log10(medPSD),'linewidth',2)
%     ylim(PSDlim);
%     bookfonts
%     xlabel('F (Hz)')
%     ylabel('Med. PSD')
    
    h=subplot(5,1,2:3);
    imagesc(Td,F,10*log10(PSDsm+eps));
    xlim(xl)
    %datetick('x',3)
    set(gca,'xtick',[])
    axis xy
    %bookfonts
    ylabel('F (Hz)')
    colormap("jet")
    ax=get(h,'Position');
    s=mean(std(10*log10(PSDsm)));
    m=median(median(10*log10(PSDsm)));
    %caxis([m-3*s m+4*s])
    caxis(PSDlim)
    hc=colorbar;
    set(get(hc,'label'),'string','PSD (dB rel. 1 (m/s^2)^2/Hz)');
    set(h,'Position',ax);
    %axis tight
    
    h=subplot(5,1,4:5);
    imagesc(Td,F,10*log10(PSDdiffsm));
    xlim(xl)
    axis xy
    %bookfonts
      ylabel('F (Hz)')
    colormap("jet")
    ax=get(h,'Position');
    s=mean(std(10*log10(PSDdiffsm)));
    m=median(median(10*log10(PSDdiffsm+eps)));
    caxis([m-3*s m+3*s])
    %caxis([-20 50])
    %caxis(PSDrange)
    hc=colorbar;
    set(get(hc,'label'),'string','PSD (dB rel. median)');
    %xlabel('Time since Origin (Hours)')
   %tick_locations=[datenum(year,1,1:365),datenum(year+1,1,1:365)];
   set(gca,'XMinorTick','on','YMinorTick','on')
   %set(gca,'XTick',tick_locations)
   datetick('x',6,'keeplimits', 'keepticks')
   xtickangle(90)
       %axis tight
    set(h,'Position',ax)
    set(gcf,'units','normalized','position',[0.1300 0.1100 0.8 0.7])

end

    

