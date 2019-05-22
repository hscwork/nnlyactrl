%读取训练数据
clear 
format long

%load DifHamilDataGen_fun_time.mat

load reply_4Hami_class5_data100000.mat

SNum=50000;   % the number  of samples
TNum=5000;   % the number  of Test samples 

%for training
P=Chutai(:,1:SNum); %Parameters for study
class=c(:,1:SNum); %target for study  
T=full(ind2vec(class));


[Pn,ps]=mapminmax(P,-1,1);  %setting
[Tn,ts]=mapminmax(T,0,1);  %setting  %已经是归一化的了，不用设置也可以。


%for test 
P_t=Chutai(:,(SNum+1):(SNum+TNum)); % Parameter for test
class_t=c(:,(SNum+1):(SNum+TNum)); %target for test
T_t=full(ind2vec(class_t));  % turn it to vectors 


P_tn=mapminmax('apply',P_t,ps);  %按照学习数据的规则归一化测试数据
T_tn=mapminmax('apply',T_t,ts);  %已经归一化了，不用也可以。





%创建神经网络
net = newff( minmax(Pn) , [40 40 5] , { 'logsig'  'logsig'   'logsig'  } , 'trainscg' ) ; 
%net = newff( minmax(Pn) , [35 35 5] , { 'logsig'  'logsig'   'logsig'  } , 'traingdx','learngdm' ) ; 
%net = newff( minmax(Pn) , [50 50 5] , { 'logsig'  'logsig'  'logsig'  'logsig'  } , 'traingdx','learngdm' ) ; 
epoch=50;
%设置训练参数
net.trainparam.show = 50 ;
net.trainparam.epochs =epoch;
net.trainparam.goal = 0.0001 ;
net.trainParam.lr = 0.01 ;
net.trainParam.min_grad=0.00000001;

%开始训练
%----------------初始值---------------------------
Y = sim( net , Pn) ;
Cpred=vec2ind(Y); % predicted class

%检验正确率
zq = 0 ; %正确的数量
for k = 1 : SNum
    if Cpred(k) == class(k) %对比预测分类的index和分类的index
        zq = zq + 1 ;
    end
end
xxl(1)=100 * zq / SNum  % 直接检验学习成功率
   Sample_err(1)=mse(Y,Tn)
  
%-------------------------------------------------
Y = sim( net , P_tn ) ;
Cpred_t=vec2ind(Y); % predicted class
%检验正确率
zq = 0 ;
for k = 1 : TNum
    if Cpred_t(k) == class_t(k)
        zq = zq + 1 ;
    end
end
Test_err(1)=mse(Y,T_tn)
sbl(1)=100 * zq / TNum   %直接检验测试成功率
%---------------------初始值结束---------------------------------------------












tempR=0;  %初始化的学习率
tempErr=1; %初始化的误差函数
  OptIte1=0;
  OptIte2=0;
for m=1:200
    m
   
%     if m<10000
%         net.trainparam.epochs =10;
%     else 
%         net.trainparam.epochs =200;
%     end
 
   net = train( net, Pn ,Tn);
 
 %--------------------------------------------
Y = sim( net , Pn) ;
Cpred=vec2ind(Y); % predicted class

%检验正确率
zq = 0 ; %正确的数量
for k = 1 : SNum
    if Cpred(k) == class(k) %对比预测分类的index和分类的index
        zq = zq + 1 ;
    end
end
xxl(m+1)=100 * zq / SNum  % 直接检验学习成功率
   Sample_err(m+1)=mse(Y,Tn)
 
 
%-------------------------------------------------
 
 
Y = sim( net , P_tn ) ;
Cpred_t=vec2ind(Y); % predicted class
%检验正确率
zq = 0 ;
for k = 1 : TNum
    if Cpred_t(k) == class_t(k)
        zq = zq + 1 ;
    end
end

  sbl(m+1)=100 * zq / TNum   %直接检验测试成功率
  
  Test_err(m+1)=mse(Y,T_tn);
  
if  sbl(m+1)>tempR
    tempR=sbl(m+1);
    tempnet1=net;
       OptIte1=m
end    



if  Test_err(m+1)<tempErr
    tempErr=Test_err(m+1);
    tempnet2=net;
        OptIte2=m;
end    

tempnet3=net;



IteNums=(0:m)*epoch;
subplot(2,1,1)
plot(IteNums,xxl,IteNums,sbl)
subplot(2,1,2)
plot(IteNums,Sample_err,IteNums, Test_err)
end

OptIte1
OptIte2
OptIte2*50
m
tempErr
 
 % save NetTraingHid30and30S40000T1000EPOC200m500.mat 
% 
% IteNums=(0:(m))*epoch;
% figure
% subplot(2,1,1)
% plot(IteNums,xxl,IteNums,sbl)
% subplot(2,1,2)
% plot(IteNums,Sample_err,IteNums,Test_err)
% %plot(IteNums,Sample_err,IteNums,Test_err)
% % 
% % IteNums=(0:(m))*epoch;
% figure 
% plot(IteNums,xxl,IteNums,sbl)
% figure
% plot(IteNums,Sample_err,IteNums,Test_err)
% 

