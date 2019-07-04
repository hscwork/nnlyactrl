%固定时间给出fidelity的对数
function  LD=lyactrlfid1(phi0,A)
global H0 H3 phif K nmax h
phi(:,1)=phi0;
for n=1:nmax
     D(n)=1-abs(phi(:,n)'*phif)^2;
        k=phi(:,n);     
        TH=H0+1*K*real(k'*1i*(A*H3-H3*A)*k)*H3;
        K1=-1i*(TH)*k; 
        k=phi(:,n)+h/2*K1; 
         TH=H0+1*K*real(k'*1i*(A*H3-H3*A)*k)*H3;
        K2=-1i*(TH)*k;
        k=phi(:,n)+h/2*K2;  
        TH=H0+1*K*real(k'*1i*(A*H3-H3*A)*k)*H3;
        K3=-1i*(TH)*k; 
        k=phi(:,n)+h*K3; 
        TH=H0+1*K*real(k'*1i*(A*H3-H3*A)*k)*H3;
        K4=-1i*(TH)*k;
        phi(:,(n+1))=phi(:,n)+h/6*(K1+2*K2+2*K3+K4);
        phi(:,(n+1))=phi(:,(n+1))/sqrt(phi(:,(n+1))'*phi(:,(n+1))); %归一化dis=V(n); 
end
LD=log10(D(n));
end