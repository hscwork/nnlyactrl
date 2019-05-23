clear all;
format long
%find smooth parameter using testing states's averaged log£¨Infidelity£©
load Data_n200_t03pi_g0_2H_5y_fw20_20_4para105000.mat
load SJCT4E5.mat
global  SJTEST  H0 H1 H2 K gs es1 es2 phif ps ts net Pn Tn

format long
dim=3;
id=eye(3);
%---------------------------------------------
phi1=[1;0;0];
phi2=[0;1;0];
phi3=[0;0;1];
bk11=phi1*phi1';   bk22=phi2*phi2';   bk33=phi3*phi3';
omega1=1;
omega2=2;
omega3=5;
g=0;
K=1;
H0=omega1*bk11+omega2*bk22+omega3*bk33+g*(phi1*phi2'+phi2*phi1');

[ss,vv]=eig(H0);
gs=ss(:,1);
es1=ss(:,2);
es2=ss(:,3);
phif=es2;
%--------------------------
H1=(phi1*phi3'+phi3*phi1');
H2=(phi2*phi3'+phi3*phi2');

SJTEST=SJCT4E5(:,200000:400000);

SNum=2000;   % the number  of samples
TNum=0;   % the number  of Test samples
AvDis=2/(SNum)^(1/4);
%HW=(2*sqrt(2*log(2)))^(-1)*sigma;
sprd_expnc=AvDis*0.5
%for training
P=Chutai(1:4,1:SNum); %Parameters for study
T=[Ptj(:,1:SNum)]; %target for study


[Pn,ps]=mapminmax(P,-1,1);  %setting
[Tn,ts]=mapminmax(T,0,1);  %setting

tempLD=1;
tempsprd=sprd_expnc;
ccn=15
sprds=linspace(AvDis*0.001,0.8*AvDis,ccn);
tic
for cc=1:ccn
    cc
    sprd=sprds(cc);
 net=newgrnn(Pn,Tn,sprd);
 % eval([   'save net_temp' num2str(cc) '.mat net ps ts'      ]);
        meanLDs(cc)=testmeanLD2H(net,ps,ts)
         
       if meanLDs(cc)<tempLD
            tempLD=meanLDs(cc);
            tempsprd=sprd;
            nopt=cc;
            tempnet=net;
       end
        
       toc
end
%-------------------------------------------------------------------------
toc
nopt
%save GRNNnet.mat tempnet ps ts 
Rt=tempsprd/AvDis
figure;plot(sprds/AvDis,meanLDs,'o') 
 %figure;plot(sprds/AvDis,meanLDs) 
 % 