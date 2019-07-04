clear
%Generate and save samples for checking the successful rate for application.  
%Chutai: parameters in inital states 
%c: categories 1 2 3 4 5 
format long
global H0 H1 H2 H3 H4  phif K nmax  h
dim=3;
id=eye(3);
%---------------------------------------------
phi1=[1;0;0];
phi2=[0;1;0];
phi3=[0;0;1];
bk11=phi1*phi1';   bk22=phi2*phi2';   bk33=phi3*phi3';  %| >< |
omega1=1;
omega2=2;
omega3=5;
g=0.5;
K=1;
H0=omega1*bk11+omega2*bk22+omega3*bk33+g*(phi1*phi2'+phi2*phi1');

[ss,vv]=eig(H0);
gs=ss(:,1);
es1=ss(:,2);
es2=ss(:,3);
phif=es2;
%-----------¿ØÖÆËã·û-----------------
H1=(phi1*phi3'+phi3*phi1');
H2=(phi2*phi3'+phi3*phi2');
H3=(phi1*phi3'+phi3*phi1')+(phi1*phi2'+phi2*phi1');
H4=(phi2*phi3'+phi3*phi2')+(phi1*phi2'+phi2*phi1');

 p1=1;
 p2=1;

A=p1*gs*gs'+p2*es1*es1'+0*es2*es2';
nmax=500;
tlist=linspace(0,6*pi,nmax);
h=tlist(2)-tlist(1);

load SJCT4E5.mat  % random numnbers are saved in  SJCT4E5.mat 

tjn=100000 % sample number
Applystart=200000;
c=[];
wow=0;
tic
for tj=1:tjn
   tj
%     theta1=rand*0.5*pi;
%     theta2=rand*0.5*pi;
%     psi=rand*2*pi;
%     psi2=rand*2*pi;
    
    theta1=SJCT4E5(1,tj+Applystart)*0.5*pi;
    theta2=SJCT4E5(2,tj+Applystart)*0.5*pi;
    psi=SJCT4E5(3,tj+Applystart)*2*pi;
    psi2=SJCT4E5(4,tj+Applystart)*2*pi;
  
    phi0= sin(theta2)*(  sin(theta1)*exp(i*psi)*gs  +cos(theta1)*exp(i*psi2)*es1  )  +cos(theta2)*es2;  %same with paper 
    phi(:,1)=phi0;
    
     LD1=lyactrlfid1(phi0,A);
     LD2=lyactrlfid2(phi0,A);
     LD3=lyactrlfid3(phi0,A);
     LD4=lyactrlfid4(phi0,A);
        
%      if LD1==LD2
%         wow=wow+1
%      end  
if LD1>-2 && LD2>-2 && LD3>-2 && LD4>-2
    c(tj)=5;
else if LD1<=LD2 && LD1<=LD3 && LD1<=LD4
        c(tj)=1;
    else if LD2<=LD3 && LD2<=LD4
            c(tj)=2;
        else if LD3<=LD4
                c(tj)=3;
            else
                c(tj)=4;
            end
        end
    end
end
r=c(tj);
Chutai(:,tj)=[theta1;theta2;psi;psi2];
%LDtj(tj)=LLD;    
end
toc
%mean(LDtj)
figure; plot(c ,'.')
% save apply_5c_data100000.mat Chutai c 
