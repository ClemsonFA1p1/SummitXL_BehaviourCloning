load('y_train.mat')
load('X_train.mat')
%%
V=y_train(:,1);
w=y_train(:,2);
r=V./w;

%r_dash=gradient(r);
[r_sort,I]=sort(r);
k_sort=1./r_sort;
yaw_rate_align=w(I);
yaw_rate_grad=gradient(w);
yaw_rate_grad_align=yaw_rate_grad(I);

for i=1:20
    k_bin_mean(i)=mean(yaw_rate_grad_align(1+(i-1)*400:400+(i-1)*400));
    k_bin_std(i)=std(yaw_rate_grad_align(1+(i-1)*400:400+(i-1)*400));
end

V_sort=V(I);

%Moving Mean of the yaw_rate
figure
bar(k_bin_mean(1:10));
title('Mean Shi ddot as Curvature Increases')
xlabel('Increasing Curvature')
ylabel('Shi ddot Mean')
grid on

%Moving SD of the yaw_rate
figure
bar(k_bin_std(1:10));
title('SD Shi ddot as Curvature Increases')
xlabel('Increasing Curvature')
ylabel('Shi ddot SD')
grid on

figure
plot(yaw_rate_grad_align(1:4000))
title('Shi ddot as Curvature Increases')
xlabel('Increasing Curvature')
ylabel('Shi ddot')
grid on

%%

load('AngVelNet.mat')
load('LinVelNet.mat')

V_pred=predict(net1,X_train);
w_pred=predict(net2,X_train);

r_pred=V_pred./w_pred;
[r_pred_sort,I_pred]=sort(r_pred);
yaw_rate_pred_align=w_pred(I_pred);
yaw_rate_pred_grad=gradient(w_pred);
yaw_rate_pred_grad_align=yaw_rate_pred_grad(I_pred);
k_pred_sort=1./r_pred_sort;
V_pred_sort=V_pred(I_pred);

for i=1:20
    k_bin_mean_pred(i)=mean(yaw_rate_pred_grad_align(1+(i-1)*400:400+(i-1)*400));
    k_bin_std_pred(i)=std(yaw_rate_pred_grad_align(1+(i-1)*400:400+(i-1)*400));
end

V_sort=V(I);

figure
bar(k_bin_mean_pred);

figure
bar(k_bin_std_pred);

figure
bar(k_bin_mean_pred(1:10));
title('Pred Mean Shi ddot 1 as Curvature Increases')
xlabel('Increasing Curvature')
ylabel('Pred Shi ddot Mean')
grid on

figure
bar(k_bin_std_pred(1:10));
title('Pred SD Shi ddot 1 as Curvature Increases')
xlabel('Increasing Curvature')
ylabel('Pred Shi ddot SD')
grid on

figure
plot(yaw_rate_pred_grad_align(1:4000))
title('Pred Shi ddot 1 as Curvature Increases')
xlabel('Increasing Curvature')
ylabel('Pred Shi ddot')
grid on




%%

%Z Statistic

X_bar_1=k_bin_mean;
X_bar_2=k_bin_mean_pred;

sig_1=k_bin_std./sqrt(400);
sig_2=k_bin_std_pred./sqrt(400);

Z1=(X_bar_1-X_bar_2)./sqrt((sig_1.^2)+(sig_2.^2));

bar(Z1(1:10))


%%
%KL Divergenc

A=log(k_bin_std./k_bin_std_pred);
B=k_bin_std_pred.^2 + (k_bin_mean_pred-k_bin_mean).^2;
B=B./(k_bin_std.^2);
B=B./2;

%KLDiv1=log(k_bin_std./k_bin_std_pred) + (((k_bin_std_pred.^2 +(k_bin_mean_pred-k_bin_mean).^2))/(2.*k_bin_std.^2)) -0.5;

KLDiv1=A + B -0.5;

figure
bar(KLDiv1(1:10))
title('KL Divergence between Predicted Probability Dist and Original')
xlabel('Increasing Curvature Bins')
ylabel('Divergence in the Probability Dist')
grid on

%%

load('AngVelNetold.mat')
load('LinVelNetold.mat')

V_pred=predict(net1,X_train);
w_pred=predict(net2,X_train);

r_pred=V_pred./w_pred;
[r_pred_sort,I_pred]=sort(r_pred);
yaw_rate_pred_align=w_pred(I_pred);
yaw_rate_pred_grad=gradient(w_pred);
yaw_rate_pred_grad_align=yaw_rate_pred_grad(I_pred);
k_pred_sort=1./r_pred_sort;
V_pred_sort=V_pred(I_pred);

for i=1:20
    k_bin_mean_pred(i)=mean(yaw_rate_pred_grad_align(1+(i-1)*400:400+(i-1)*400));
    k_bin_std_pred(i)=std(yaw_rate_pred_grad_align(1+(i-1)*400:400+(i-1)*400));
end


figure
bar(k_bin_mean_pred(1:10));
title('Pred Mean Shi ddot 2 as Curvature Increases')
xlabel('Increasing Curvature')
ylabel('Pred Shi ddot Mean')
grid on

figure
bar(k_bin_std_pred(1:10));
title('Pred SD Shi ddot 2 as Curvature Increases')
xlabel('Increasing Curvature')
ylabel('Pred Shi ddot SD')
grid on

figure
plot(yaw_rate_pred_grad_align(1:4000))
title('Pred Shi ddot 2 as Curvature Increases')
xlabel('Increasing Curvature')
ylabel('Pred Shi ddot')
grid on


%%

X_bar_1=k_bin_mean;
X_bar_2=k_bin_mean_pred;

sig_1=k_bin_std./sqrt(400);
sig_2=k_bin_std_pred./sqrt(400);

Z2=(X_bar_1-X_bar_2)./sqrt((sig_1.^2)+(sig_2.^2));

bar(Z2(1:10))

%%
%KL Divergenc

A=log(k_bin_std./k_bin_std_pred);
B=k_bin_std_pred.^2 + (k_bin_mean_pred-k_bin_mean).^2;
B=B./(k_bin_std.^2);
B=B./2;

%KLDiv2=log(k_bin_std./k_bin_std_pred) + (((k_bin_std_pred.^2 +(k_bin_mean_pred-k_bin_mean).^2))/(2.*k_bin_std.^2)) -0.5;

KLDiv2=A + B -0.5;

figure
bar(KLDiv2(1:10))
title('KL Divergence between Predicted Probability Dist and Original')
xlabel('Increasing Curvature Bins')
ylabel('Divergence in the Probability Dist')
grid on

