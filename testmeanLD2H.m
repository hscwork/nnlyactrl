function meanLD=testmeanLD(net,ps,ts)
global  SJSEST H0 H1 H2 K gs es1 es2 SJTEST phif
format long
tjn=2000;
Dpj=0;
LDpj=0;
for tj=1:tjn
 theta1=SJTEST(1,tj)*0.5*pi;
  theta2=SJTEST(2,tj)*0.5*pi;
   psi=SJTEST(3,tj)*2*pi;
   psi2=SJTEST(4,tj)*2*pi;
phi0= sin(theta2)*(  sin(theta1)*exp(1i*psi)*gs  +cos(theta1)*exp(1i*psi2)*es1  )  +cos(theta2)*es2;  
phi(:,1)=phi0;
% %-------AËã·û-------------------------------
 p=[theta1;theta2;psi;psi2];
 pn=mapminmax('apply',p,ps);
 Y=sim(net,pn);
Yr=mapminmax('reverse',Y,ts); 
p1=Yr(1);
p2=Yr(2);

A=p1*gs*gs'+p2*es1*es1'+0*es2*es2';
nmax=200;
tlist=linspace(0,0.3*pi,nmax);
h=tlist(2)-tlist(1);
for n=1:nmax
     D(n)=1-abs(phi(:,n)'*phif)^2;
        k=phi(:,n);     
        TH=H0+1*K*real(k'*1i*(A*H1-H1*A)*k)*H1+1*K*real(k'*1i*(A*H2-H2*A)*k)*H2;
        K1=-1i*(TH)*k; 
        k=phi(:,n)+h/2*K1; 
        TH=H0+1*K*real(k'*1i*(A*H1-H1*A)*k)*H1+1*K*real(k'*1i*(A*H2-H2*A)*k)*H2;
        K2=-1i*(TH)*k;
        k=phi(:,n)+h/2*K2;  
        TH=H0+1*K*real(k'*1i*(A*H1-H1*A)*k)*H1+1*K*real(k'*1i*(A*H2-H2*A)*k)*H2;
        K3=-1i*(TH)*k; 
        k=phi(:,n)+h*K3; 
        TH=H0+1*K*real(k'*1i*(A*H1-H1*A)*k)*H1+1*K*real(k'*1i*(A*H2-H2*A)*k)*H2;
        K4=-1i*(TH)*k;
        phi(:,(n+1))=phi(:,n)+h/6*(K1+2*K2+2*K3+K4);
        phi(:,(n+1))=phi(:,(n+1))/sqrt(phi(:,(n+1))'*phi(:,(n+1))); %¹éÒ»»¯dis=V(n);
end
LD=log10(D(n));
LDtj(tj)=LD;
end
meanLD=mean(LDtj);
