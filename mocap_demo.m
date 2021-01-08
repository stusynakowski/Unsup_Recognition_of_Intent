
 clear all 
 load('Data/MIXAMO_DATA/POSE_info.mat')
 addpath(genpath('./functions/'));
    c1set = [];
    c12set =  [];
    c123set =  [];
    c124set =  [];
    c1234set=[];

for s =1:219

    POSE=POSE_Features{s,1};
    scale = POSE_Features{s,2};
    fps   = POSE_Features{s,3};
    response= POSE_Features{s,4};
    
    LeftLegInd=1:5;
    RightLegInd=6:10;
    LeftArmInd=11:14;
    RightArmInd=15:18;
    TorsoInd   =19:23;
    
    % which indices to remove: HERE
    
    
    
    
    
    %RIGHTLEG=zeros(3,5,size(POSE,3));
    LEFTLEG=POSE(:,LeftLegInd,:);
    RIGHTLEG=POSE(:,RightLegInd,:);
    LEFTARM=POSE(:,LeftArmInd,:);
    RIGHTARM=POSE(:,RightArmInd,:);
    TORSO=POSE(:,TorsoInd,:);

    % weighted center of mass
    
    
    COMW=0.6.*mean(TORSO,2)+0.15.*mean(LEFTLEG,2)+0.15.*mean(RIGHTLEG,2)+0.05*mean(LEFTARM,2)+0.05.*mean(RIGHTARM,2);
    
    COMWs=scale.*COMW;  
    
    
    
    

    X1=COMWs(1,1,:);
    Y1=COMWs(2,1,:);
    Z1=COMWs(3,1,:);
    
    [FeatureObject]=IntentObjectFromTrajectory(X1,Y1,Z1,fps,-9.8,-2.5,.001);

    c1=FeatureObject.DhmfInd;
    c12=FeatureObject.C12;
    c123=FeatureObject.C123;
    c124=FeatureObject.C124;
    c1234=FeatureObject.C1234;
    
    c1set =     [c1set,sum(c1<0)];
    c12set =    [c12set,sum(c12<0)];
    c123set =   [c123set,sum(c123<0)];
    c124set =   [c124set,sum(c124<0)];
    c1234set =  [c1234set,sum(c1234<0)];

end      
     


accuracyset1=[];
accuracyset12=[];
accuracyset123=[];
accuracyset124=[];
accuracyset1234=[];
for j = 1:100
rpi=randperm(115);
rpni=randperm(104)+115;

rpi = rpi(1:100);
rpni =rpni(1:100);

    %% classify q1
a1   = sum(c1set(rpi)<40)+sum(c1set(rpni)>=40);
a12  = sum(c12set(rpi)<40)+sum(c123set(rpni)>=40);  
a123 = sum(c123set(rpi)<40)+sum(c123set(rpni)>=40); 
a124 = sum(c124set(rpi)<40)+sum(c124set(rpni)>=40);   
a1234 =sum(c1234set(rpi)<40)+sum(c1234set(rpni)>=40);     

%  a1=sum(q1iset(rpi)<40)+sum(q1niset(rpni)>=40);
  accuracyset1=[accuracyset1,a1/200];
% %% classify q2
%  a2=sum(q2iset(rpi)<40)+sum(q2niset(rpni)>=40);
  accuracyset12=[accuracyset12,a12/200];
% 
% 
% %% classify  q3
%  a3=sum(q3iset(rpi)<40)+sum(q3niset(rpni)>=40);
  accuracyset123=[accuracyset123,a123/200];
% 
% %% classify  q4
%  a4=sum(q4iset(rpi)<40)+sum(q4niset(rpni)>=40);
  accuracyset124=[accuracyset124,a124/200];
  
  accuracyset1234=[accuracyset1234,a1234/200];
% 
% 
% 
% sum(q2niset>=40)
% sum(q3niset>=40)
% 
% sum(q2iset>=40)
% sum(q3iset>=40)
end 


 ma1=mean(accuracyset1);
 ma12=mean(accuracyset12);
 ma123=mean(accuracyset123);
 ma124=mean(accuracyset124);
 ma1234 = mean(accuracyset1234);

 

fprintf("Classification Accuracy concepts 1, 2, 3, and 4: %f \n", ma1234 * 100);
fprintf("Classification Accuracy concepts 1, 2, and 3: %f  \n: %f \n", ma123 * 100);
fprintf("Classification Accuracy concepts 1 and 2: %f  \n", ma12 * 100);
fprintf("Classification Accuracy concepts 1: %f \n ", ma1 * 100 );
fprintf("Classification Accuracy concepts 1, 2, and4: %f \n", ma124 * 100);



 
 
 
 
 % 
% q3niset-q2niset;
% q3iset-q2iset;

