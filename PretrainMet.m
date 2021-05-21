load('y_train');
load('VelocityDataR5')

load('X_train.mat')

%%
V_good=y_train(:,1);
w_good=y_train(:,2);
V_bad=VelocityData(:,1);
w_bad=VelocityData(:,2);

%%
r=V_good./w_good;
k=1./r;
k_grad=gradient(k);

figure
bar(k(283:514))
title('Curvature across entire track')
xlabel('Discretized Track Length')
ylabel('Kappa (Capped to 50)')
grid on

dt=0.1;
for i=1:7999
    kappa(i)=(k_grad(i+1)-k_grad(i))/(abs(V_good(i+1)-V_good(i)))*dt;
end

kappa(kappa>50)=50;
kappa(isnan(kappa))=0;
kappa_total=sum(kappa);

figure
bar((1:232),kappa(283:514))
title('Kappa across entire track')
xlabel('Discretized Track Length')
ylabel('Kappa (Capped to 50)')
grid on


kappa_selected=kappa(283:514);
norm_kappa = (kappa_selected - min(kappa_selected)) / ( max(kappa_selected) - min(kappa_selected) );

figure
bar(norm_kappa,'r')
hold on
bar(k(283:514),'b')
title('Curvature and Kappa')
xlabel('Discretized Track Length')
ylabel('Curvature/ Kappa Normalized')
legend('Normalized Kappa','Curvature')
grid on

figure
%scatter((1:232),norm_kappa,'*')
scatter((1:232),kappa(283:514),'*')
hold on
bar(abs(k(283:514)),'b')
title('Curvature and Kappa')
xlabel('Discretized Track Length')
ylabel('Curvature/ Kappa Normalized')
legend('Normalized Kappa','Curvature')
grid on

%figure
%scatter((1:232),k(283:514))
%title('Curvature across entire track Scatter')
%xlabel('Discretized Track Length')
%ylabel('Curvature (m^-1)')
%grid on


%%

r2=V_bad./w_bad;
k2=1./r2;
k2_grad=gradient(k2);

figure
bar(k2(172:1163))
title('Curvature across entire track')
xlabel('Discretized Track Length')
ylabel('Kappa (Capped to 50)')
grid on

dt=0.1;
for i=1:3999
    kappa2(i)=abs(k2_grad(i+1)-k2_grad(i))/(abs(V_bad(i+1)-V_bad(i)))*dt;
end

kappa2(kappa2>50)=50;
kappa2(isnan(kappa2))=0;
kappa2_total=sum(kappa2);

kappa2_selected=kappa(172:1163);
for i=1:247
    kappa2_adjust(i)=kappa2_selected(4*i);
end

k2_selected=k2(172:1163);
for i=1:247
    k2_adjust(i)=k2_selected(4*i);
end



figure
bar(kappa2_adjust)
title('Kappa across entire track')
xlabel('Discretized Track Length')
ylabel('Kappa (Capped to 50)')
grid on


norm_kappa2 = (kappa2_adjust - min(kappa2_adjust)) / ( max(kappa2_adjust) - min(kappa2_adjust) );

figure
bar(norm_kappa2,'r')
hold on
bar(k2_adjust,'b')
title('Curvature and Kappa')
xlabel('Discretized Track Length')
ylabel('Curvature/ Kappa Normalized')
legend('Normalized Kappa','Curvature')
grid on

%%
load('AngVelNet.mat')
load('LinVelNet.mat')

V_pred=predict(net1,X_train);
w_pred=predict(net2,X_train);

r=V_pred./w_pred;
k=1./r;
k_grad=gradient(k);

figure
bar(k(283:514))
title('Curvature across entire track')
xlabel('Discretized Track Length')
ylabel('Kappa (Capped to 50)')
grid on

dt=0.1;
for i=1:7999
    kappa(i)=abs(k_grad(i+1)-k_grad(i))/(abs(V_good(i+1)-V_good(i)))*dt;
end

kappa(kappa>50)=50;
kappa(isnan(kappa))=0;
kappa_total=sum(kappa);

figure
scatter((1:232),kappa(283:514),'*')
title('Kappa across entire track')
xlabel('Discretized Track Length')
ylabel('Kappa (Capped to 50)')
grid on


kappa_selected=kappa(283:514);
norm_kappa = (kappa_selected - min(kappa_selected)) / ( max(kappa_selected) - min(kappa_selected) );

figure
bar(norm_kappa,'r')
hold on
bar(k(283:514),'b')
title('Curvature and Kappa')
xlabel('Discretized Track Length')
ylabel('Curvature/ Kappa Normalized')
legend('Normalized Kappa','Curvature')
grid on

figure
scatter((1:232),norm_kappa,'*')
hold on
bar(abs(k(283:514)),'b')
title('Curvature and Kappa')
xlabel('Discretized Track Length')
ylabel('Curvature/ Kappa Normalized')
legend('Normalized Kappa','Curvature')
grid on

%%

load('AngVelNetold.mat')
load('LinVelNetold.mat')

V_pred=predict(net1,X_train);
w_pred=predict(net2,X_train);

r=V_pred./w_pred;
k=1./r;
k_grad=gradient(k);

figure
bar(k(283:514))
title('Curvature across entire track')
xlabel('Discretized Track Length')
ylabel('Kappa (Capped to 50)')
grid on

dt=0.1;
for i=1:7999
    kappa(i)=abs(k_grad(i+1)-k_grad(i))/(abs(V_pred(i+1)-V_pred(i)))*dt;
end

kappa(kappa>50)=50;
kappa(isnan(kappa))=0;
kappa_total=sum(kappa);

figure
scatter((1:232),kappa(283:514),'*')
title('Kappa across entire track')
xlabel('Discretized Track Length')
ylabel('Kappa (Capped to 50)')
grid on


kappa_selected=kappa(283:514);
norm_kappa = (kappa_selected - min(kappa_selected)) / ( max(kappa_selected) - min(kappa_selected) );

figure
bar(norm_kappa,'r')
hold on
bar(k(283:514),'b')
title('Curvature and Kappa')
xlabel('Discretized Track Length')
ylabel('Curvature/ Kappa Normalized')
legend('Normalized Kappa','Curvature')
grid on

figure
scatter((1:232),norm_kappa,'*')
hold on
bar(abs(k(283:514)),'b')
title('Curvature and Kappa')
xlabel('Discretized Track Length')
ylabel('Curvature/ Kappa Normalized')
legend('Normalized Kappa','Curvature')
grid on
