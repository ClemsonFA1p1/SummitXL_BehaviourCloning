clear all
%% Data Load 
load('X_train.mat')
load('X_val.mat')
load('y_train.mat')
load('y_val.mat')
%%
Xtrain=X_train;
Ytrain1=y_train(:,1);
Ytrain2=y_train(:,2);

Xval=X_val;
Yval1=y_val(:,1);
Yval2=y_val(:,2);

%% Train For Linear Velocities
layers = [
    imageInputLayer([32 32 1])
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    averagePooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(1)
    regressionLayer];

miniBatchSize  = 128;
validationFrequency = floor(numel(Ytrain1)/miniBatchSize);
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',30, ...
    'InitialLearnRate',1e-3, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.0001, ...
    'LearnRateDropPeriod',20, ...
    'Shuffle','every-epoch', ...
    'ValidationData',{Xval,Yval1}, ...
    'ValidationFrequency',validationFrequency, ...
    'Plots','training-progress', ...
    'Verbose',false);

net1_poor = trainNetwork(Xtrain,Ytrain1,layers,options);


%% Train For Angular Velocities
layers = [
    imageInputLayer([32 32 1])
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    averagePooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(1)
    regressionLayer];

miniBatchSize  = 128;
validationFrequency = floor(numel(Ytrain1)/miniBatchSize);
options2 = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',30, ...
    'InitialLearnRate',1e-3, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.0001, ...
    'LearnRateDropPeriod',20, ...
    'Shuffle','every-epoch', ...
    'ValidationData',{Xval,Yval1}, ...
    'ValidationFrequency',validationFrequency, ...
    'Plots','training-progress', ...
    'Verbose',false);

net2_poor = trainNetwork(Xtrain,Ytrain2,layers,options2);

%% Saving the Traned models

save('LinVelNetPoor.mat','net1_poor');
save('AngVelNetPoor.mat','net2_poor');
