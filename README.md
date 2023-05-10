# Behavior_Cloning

The following repository is in assosiation with the SAE Paper : Virtual Evaluation of Deep Learning Techniques for Vision Based Trajectory Tracking
Salvi, A., Buzhardt, J., Tallapragda, P., Krovi, V. et al., "Virtual Evaluation of Deep Learning Techniques for Vision-Based Trajectory Tracking," SAE Int. J. Adv. & Curr. Prac. in Mobility 5(1):326-334, 2023

The instructions include setting up the data collection process, deep learining process and the evaluation process:

Data collection/ Training and Evaluation Environment (CoppeliaSim Simulator)

![alt text](https://github.com/ClemsonFA1p1/SummitXL_BehaviourCloning/blob/master/sae_2.jpg)

### Important files
API files (The need to be in the directory to setup the CoppeliaSim - Matlab connection)
1. remApi.m
2. remoteApi.dll
3. remoteApiProto.m
4. simpleSynchronousTest.m
5. simpleTest.m

CoppeliaSim Files:
1. BehaviorCloning_Track.ttt

Matlab Files:
1. PID_Control_SumXL.m : PID control API files. Running this file makes the robot track the path using a PID controller and can be used for collecting data.
2. CNNModelBC.m : This sets up the neural network training process.
3. NN_Control.m: This is the inference file that loads the trained network to be used for inference.

## Data Collection :

1. Run BehaviorCloning_Track.ttt (simulation environment)
2. Run PID_Control_SumXL.m 

This will generate the training data (automatically distributed in training and validation sets):
a. X_train.mat 
b. X_val.mat
c. y_train.mat
d. y_val.may

## Deep Learining:

1. Run CNNModelBC.m. This will train and save neural networks to be used as control policy.

## Inference :

1. Run BehaviorCloning_Track.ttt (simulation environment)
2. Run NN_Control.m 

Data generated from these files can be used for computing the KL Divergence and Bending Energy difference
1. Run file KLDMetric.m
![alt text](https://github.com/ClemsonFA1p1/SummitXL_BehaviourCloning/blob/master/sae_3.jpg)

1. Run file CurvatureMetric.m
![alt text](https://github.com/ClemsonFA1p1/SummitXL_BehaviourCloning/blob/master/sae_4.jpg)
