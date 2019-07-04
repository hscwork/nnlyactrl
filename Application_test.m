%clear
load  apply_5c_data100000.mat
% check the successful rate in applicaitons for Table 2
% the program should be runned after running the training programs. 
 net=tempnet2;

Numapp=100000;
 

 
 P_app=Chutai(:,1:Numapp); % Parameter for applicaiotn 
 class_app=c(:,1:Numapp); 
 T_app=full(ind2vec(class_app)); 
 
 tic
 P_app_n=mapminmax('apply',P_app,ps);
Y = sim( net , P_app_n ) ;
Cpred_app=vec2ind(Y); % predicted class
toc

%check the successful rate in applicaitons
zq = 0 ;
for k = 1 : Numapp
    if Cpred_app(k) == class_app(k)
        zq = zq + 1 ;
    end
end
Appsbl=100 * zq / Numapp ;
FinalTestErr=mse(Y,T_app)
sprintf('Successful rate in application is %3.3f%%',Appsbl)

