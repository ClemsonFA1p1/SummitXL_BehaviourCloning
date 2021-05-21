load('y_train');
load('VelocityDataR5')

load('X_train.mat')

%%
V_good=y_train(:,1);
w_good=y_train(:,2);

%%
r=V_good./w_good;
k=1./r;
%k_grad=gradient(k);

figure
bar(k(283:514))
title('Curvature across entire track : PID')
xlabel('Discretized Track Length')
ylabel('Kappa')
grid on

k_zoom=k(283:514);

figure
bar(k_zoom(29:79))
title('Curvature across section of track : PID')
xlabel('Discretized Track Length')
ylabel('Kappa')
grid on

for i=1:7999
    del_kappa(i)=abs(k(i+1)-k(i));
end

del_kappa(del_kappa>50)=50;
del_kappa(isnan(del_kappa))=0;
del_kappa_total=sum(del_kappa);

figure
bar((1:232),abs(del_kappa(283:514)))
title('Kappa Change across entire track : PID')
xlabel('Discretized Track Length')
ylabel('Del Kappa')
grid on


%%
load('AngVelNet.mat')
load('LinVelNet.mat')

V_pred=predict(net1,X_train);
w_pred=predict(net2,X_train);

r=V_pred./w_pred;
k=1./r;
figure
bar(k(283:514))
title('Curvature across entire track : Good')
xlabel('Discretized Track Length')
ylabel('Kappa (Capped to 50)')
grid on

k_zoom=k(283:514);

figure
bar(k_zoom(29:79))
title('Curvature across section of track : PID')
xlabel('Discretized Track Length')
ylabel('Kappa')
grid on

for i=1:7999
    del_kappa(i)=abs(k(i+1)-k(i));
end

del_kappa(del_kappa>50)=50;
del_kappa(isnan(del_kappa))=0;
del_kappa_total=sum(del_kappa);

figure
bar((1:232),abs(del_kappa(283:514)))
title('Kappa Change across entire track : Good')
xlabel('Discretized Track Length')
ylabel('Chnage in Kappa')
grid on

%%

load('AngVelNetPoor.mat')
load('LinVelNetPoor.mat')

V_pred=predict(net1_poor,X_train);
w_pred=predict(net2_poor,X_train);

r=V_pred./w_pred;
k=1./r;
k_grad=gradient(k);

figure
bar(k(283:514))
title('Curvature across entire track : Poor')
xlabel('Discretized Track Length')
ylabel('Kappa (Capped to 50)')
grid on

k_zoom=k(283:514);

figure
bar(k_zoom(29:79))
title('Curvature across section of track : PID')
xlabel('Discretized Track Length')
ylabel('Kappa')
grid on

for i=1:7999
    del_kappa(i)=abs(k(i+1)-k(i));
end

del_kappa(del_kappa>50)=50;
del_kappa(isnan(del_kappa))=0;
del_kappa_total=sum(del_kappa);

figure
bar((1:232),abs(del_kappa(283:514)))
title('Kappa Change across entire track : Poor')
xlabel('Discretized Track Length')
ylabel('Chnage in Kappa')
grid on
