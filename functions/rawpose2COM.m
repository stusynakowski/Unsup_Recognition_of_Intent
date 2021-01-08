function [X,Y,Z] = rawpose2COM(Rawpose)



torsoi= [1,2,9];
leftarmi= [3,4,5];
rightarmi= [6,7,8];
leftlegi = [10,11,12];
rightlegi= [13,14,15];

TORSO= Rawpose(:,torsoi,:);
LEFTARM= Rawpose(:,leftarmi,:);
RIGHTARM= Rawpose(:,rightarmi,:);
LEFTLEG= Rawpose(:,leftlegi,:);
RIGHTLEG= Rawpose(:,rightlegi,:);

COMW=0.6.*mean(TORSO,2)+0.15.*mean(LEFTLEG,2)+0.15.*mean(RIGHTLEG,2)+0.05*mean(LEFTARM,2)+0.05.*mean(RIGHTARM,2);
COMWf=zeros(3,length(COMW(1,1,:))); 
COMWf(1,:)=COMW(1,1,:);
COMWf(2,:)=COMW(2,1,:);
COMWf(3,:)=COMW(3,1,:);

% for i =1:256
%     
%     plot3DwithCOM(Rawpose(:,:,i),COMWf)
%     axis equal
% end 


%% 
%meanfoot=(Rawpose(:,15,:)+Rawpose(:,12,:))./2;
difference=squeeze((Rawpose(:,2,:)-Rawpose(:,9,:)));
heightset=vecnorm(difference);
s=0.6/median(heightset);
COMs=s*COMWf;
X=COMs(1,:);
Y=COMs(2,:);
Z= COMs(3,:);

end 
