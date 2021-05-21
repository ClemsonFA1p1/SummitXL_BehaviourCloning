load('IMG_train_cc.mat')
load('IMG_val_cc.mat')
load('Vel_train_cc.mat')
load('Vel_val_cc.mat')

load('IMG_train_c.mat')
load('IMG_val_c.mat')
load('Vel_train_c.mat')
load('Vel_val_c.mat')

%%

X_train=cat(4,IMG_train_c,IMG_train_cc);
X_val=cat(4,IMG_val_c,IMG_val_cc);

y_train=cat(1,Vel_train_c,Vel_train_cc);
y_val=cat(1,Vel_val_c,Vel_val_cc);

%%
save('X_train.mat','X_train')
save('X_val.mat','X_val')
save('y_train.mat','y_train')
save('y_val.mat','y_val')