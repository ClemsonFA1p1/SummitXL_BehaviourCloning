clear

% Load our Trained Neural Networks
load('AngVelNet.mat')
load('LinVelNet.mat')

n=250; 
A_bw_invert_crop=zeros(512,512);

%Matlab-CoppeliaSim Remote API framework
sim = remApi('remoteApi');
sim.simxFinish(-1);
clientID = sim.simxStart('127.0.0.1', 19999, true, true, 5000, 10);
if (clientID > -1)
    disp('Connected')
    
    %Handle
    [returnCode, LWB] = sim.simxGetObjectHandle(clientID, 'joint_back_left_wheel', sim.simx_opmode_blocking);
    [returnCode, RWB] = sim.simxGetObjectHandle(clientID, 'joint_back_right_wheel', sim.simx_opmode_blocking);
    [returnCode, LWF] = sim.simxGetObjectHandle(clientID, 'joint_front_left_wheel', sim.simx_opmode_blocking);
    [returnCode, RWF] = sim.simxGetObjectHandle(clientID, 'joint_front_right_wheel', sim.simx_opmode_blocking);
    [returnCode, camera] = sim.simxGetObjectHandle(clientID, 'Vision_sensor', sim.simx_opmode_blocking);
    [returnCode, SummitXL] = sim.simxGetObjectHandle(clientID, 'Summit_XL_visible', sim.simx_opmode_blocking);
    
    
    %First Call
    [returnCode, resolution, image] = sim.simxGetVisionSensorImage2(clientID, camera, 1, sim.simx_opmode_streaming);
    [returnCode,linearVelocity,angularVelocity]=sim.simxGetObjectVelocity(clientID, SummitXL, sim.simx_opmode_streaming);
    
    for i=1:n
        i
        
        %Get Vision Sensor Information
        [returnCode, resolution, image] = sim.simxGetVisionSensorImage2(clientID, camera, 1, sim.simx_opmode_buffer); 
        %Process the image to the format out Nueral Net underdands
        imshow(image);
        if i>1
            
            A=image;
            threshold = 120; % custom threshold value
            A_bw = A > threshold;
            A_bw_invert=1-A_bw;
            A_bw_invert_crop=A_bw_invert(250:512,1:512);
            %imshow(A_bw_invert_crop)
            thisimage=imresize(A_bw_invert_crop,[32 32]);
            images4d(:,:,:,i)=thisimage;
            
            V=predict(net1,thisimage);
            w=predict(net2,thisimage);

            d=0.53; %Inter Wheel Distance
            r=0.115; %Wheel Radius
            wb=0.202; %wheel base

            TurnRadius = abs(V/w);

            R_in=TurnRadius-(d/2);
            R_out=TurnRadius+(d/2);

            theta_inner=atan2(wb,R_in);
            theta_outer=atan2(wb,R_out);

            V_star_in=(V/TurnRadius)*(sqrt(R_in^2 +wb^2));
            V_star_out=(V/TurnRadius)*(sqrt(R_out^2 +wb^2));

            V_in_wheel=V_star_in*cos(theta_inner);
            V_out_wheel=V_star_out*cos(theta_outer);
            

            w_outer=0.5*(V_out_wheel/r);
            w_inner=0.5*(V_in_wheel/r);


            if w>0
                [returnCode] = sim.simxSetJointTargetVelocity(clientID, RWB, -w_outer, sim.simx_opmode_blocking);
                [returnCode] = sim.simxSetJointTargetVelocity(clientID, RWF, -w_outer, sim.simx_opmode_blocking);
                [returnCode] = sim.simxSetJointTargetVelocity(clientID, LWB,  w_inner, sim.simx_opmode_blocking);
                [returnCode] = sim.simxSetJointTargetVelocity(clientID, LWF,  w_inner, sim.simx_opmode_blocking);

            else
                [returnCode] = sim.simxSetJointTargetVelocity(clientID, RWB, -w_inner, sim.simx_opmode_blocking);
                [returnCode] = sim.simxSetJointTargetVelocity(clientID, RWF, -w_inner, sim.simx_opmode_blocking);
                [returnCode] = sim.simxSetJointTargetVelocity(clientID, LWB, w_outer, sim.simx_opmode_blocking);
                [returnCode] = sim.simxSetJointTargetVelocity(clientID, LWF, w_outer, sim.simx_opmode_blocking);
            end
        end
        
    end
    
    sim.simxFinish(-1);
end

sim.delete();