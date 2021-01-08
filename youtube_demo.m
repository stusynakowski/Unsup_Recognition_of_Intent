
%5030
clear all

load('./Data/YOUTUBE_DATA/samples_1000_pose.mat')
addpath(genpath('./functions/'));
%load('./goodintent');
%load('goodnonintent');
%load('badnonintent');

reponsevector=3*ones(1000,1);
sumnonintent1=zeros(1000,1);
sumnonintent12=zeros(1000,1);
sumnonintent123=zeros(1000,1);
sumnonintent1234=zeros(1000,1);
sumnonintent124=zeros(1000,1);
sumintent=zeros(1000,1);
maxconsec=zeros(1000,1);

%poseindices=[intentsubsample;nonintentsubsample];


for t = 1:1000


% % samplepost=Samples1000(t).joint3DPost;
% [Rawpose] = posePostProcess3D(samplepost);
Rawpose = Samples1000_pose{t,1};
state=Samples1000_pose{t,2};

if strcmp(state,'intent')
    reponsevector(t)=0;
else 
    reponsevector(t)=1;
end 




% for i =1:105
%     
%     plot3D(joint3DmatNew(:,:,i))
%     axis equal
% end 


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


%% scaling
meanfoot=(Rawpose(:,15,:)+Rawpose(:,12,:))./2;
difference=squeeze((Rawpose(:,2,:)-Rawpose(:,9,:)));
heightset=vecnorm(difference);
s=0.6/median(heightset);
COMs=s*COMWf;
X=COMs(1,:);
Y=COMs(2,:);
Z= COMs(3,:);


[X,Y,Z] = rawpose2COM(Rawpose);




%[FeatureObject]=IntentObjectFromTrajectory(X,Y,Z,30,-9.8,-8.0,.001);
% this is what i used for the benchmarks in the IJCV paper there may be
% some slight descrepancies with the intent feature calculator in the
% function IntentObjectFromTrajectory

[c1234,c123,c12,c1,c124]=UpdateIntentFeatureComputationFunctionwithQ124(X,Y,Z,30,-9.8);




sumnonintent1(t)=sum(c1<0);
sumnonintent12(t)=sum(c12<0);
sumnonintent123(t)=sum(c123<0);
sumnonintent1234(t)=sum(c1234<0);
sumnonintent124(t)=sum(c124<0);


% 
% sumnonintent(t)=sum(Q1234Qianli<0);

sumintent(t)=sum(c1234>=0);


end



% % rpi=randperm(2795);
% % rpni=randperm(552);
% intentsubsample=[goodintent(1:500))]; 
% nonintentsubsample=[goodnonintent;badnonintent(rpni(1:215))];

%%

%% accuracy1

accuracy1=(sum(sumnonintent1(1:500)<=40)+sum(sumnonintent1(501:1000)>40))/1000;
%accuracy12=
accuracy12=(sum(sumnonintent12(1:500)<=40)+sum(sumnonintent12(501:1000)>40))/1000;

accuracy123=(sum(sumnonintent123(1:500)<=40)+sum(sumnonintent123(501:1000)>40))/1000;

accuracy124=(sum(sumnonintent124(1:500)<=40)+sum(sumnonintent124(501:1000)>40))/1000;

accuracy1234=(sum(sumnonintent1234(1:500)<=40)+sum(sumnonintent1234(501:1000)>40))/1000;



%
fprintf("Classification Accuracy concepts 1, 2, 3, and 4: %f \n", accuracy1234 * 100);
fprintf("Classification Accuracy concepts 1, 2, and 3: %f  \n: %f \n", accuracy123 * 100);
fprintf("Classification Accuracy concepts 1 and 2: %f  \n", accuracy12 * 100);
fprintf("Classification Accuracy concepts 1: %f \n ", accuracy1 * 100 );
fprintf("Classification Accuracy concepts 1, 2, and4: %f \n", accuracy124 * 100);




% %%
% %plot3D(samplepost)
% % COMW=0.6.*mean(TORSO,3)+0.15.*mean(LEFTLEG,3)+0.15.*mean(RIGHTLEG,3)+0.05*mean(LEFTARM,3)+0.05.*mean(RIGHTARM,3);
% % 
% % 
% % 
% % 
% % COMWs=scale.*COMW;  
% 
% intentindex=find(reponsevector==0); 
% nonintentindex=find(reponsevector==1);
% 
% figure(100)
% histogram(sumnonintent1(intentindex),[-1:.02: 1],'Normalization','probability','facecolor','b')
% 
% hold on 
% figure(100)
% histogram(sumnonintent1(nonintentindex),[-1:.02:1],'Normalization','probability','facecolor','r')
% legend('intent','non-intent')
% hold off 
% 
% figure(101)
% histogram(sumnonintent12(intentindex),[-1:0.02:1],'Normalization','probability','facecolor','b')
% 
% hold on 
% figure(101)
% histogram(sumnonintent12(nonintentindex),[-1:.02:1],'Normalization','probability','facecolor','r')
% legend('intent','non-intent')
% hold off
% 
% figure(102)
% histogram(sumnonintent123(intentindex),[-1:0.02:1],'Normalization','probability','facecolor','b')
% 
% hold on 
% figure(102)
% histogram(sumnonintent123(nonintentindex),[-1:.02:1],'Normalization','probability','facecolor','r')
% legend('intent','non-intent')
% hold off
% 
% figure(103)
% histogram(sumnonintent1234(intentindex),'Normalization','probability','facecolor','b')
% 
% hold on 
% figure(103)
% histogram(sumnonintent1234(nonintentindex),'Normalization','probability','facecolor','r')
% legend('intent','non-intent')
% hold off
% 
% figure(104)
% histogram(sumnonintent1234(intentindex),[0:.02:1.2],'Normalization','probability','facecolor','b')
% 
% hold on 
% figure(104)
% histogram(sumnonintent1234(nonintentindex),[0:.02:1.2],'Normalization','probability','facecolor','r')
% legend('intent','non-intent')
% hold off
% 
% dsample=min([length(intentindex),length(nonintentindex)]);
% 
% %%classification accuracy
% thresh=10;
% a1set=[];
% a12set=[];
% a123set=[];
% a124set=[];
% a1234set=[];
% for i =1:100
% 
% rpi = randperm(length(intentindex));
% rpni = randperm(length(nonintentindex));
% intentss=intentindex(rpi(1:dsample));
% nonintentss=nonintentindex(rpni(1:dsample));
% 
% 
% 
% a1=(sum(sumnonintent1(intentss)<thresh)+sum(sumnonintent1(nonintentss)>=thresh))./(2*dsample);
% a1set=[a1set,a1];
% 
% a12=(sum(sumnonintent12(intentss)<thresh)+sum(sumnonintent12(nonintentss)>=thresh))./(2*dsample);
% a12set=[a12set,a12];
% 
% a123=(sum(sumnonintent123(intentss)<thresh)+sum(sumnonintent123(nonintentss)>=thresh))./(2*dsample);
% a123set=[a123set,a123];
% 
% a124=(sum(sumnonintent124(intentss)<thresh)+sum(sumnonintent124(nonintentss)>=thresh))./(2*dsample);
% a124set=[a124set,a124];
% 
% a1234=(sum(sumnonintent1234(intentss)<thresh)+sum(sumnonintent1234(nonintentss)>=thresh))./(2*dsample);
% a1234set=[a1234set,a1234];
% end 


















% meana1=mean(a1set);
% stda1=std(a1set);
% 
% meana12=mean(a12set);
% stda12=std(a12set);
% 
% meana123=mean(a123set);
% stda123=std(a123set);
% 
% meana124=mean(a124set);
% stda124=std(a124set);
% 
% meana1234=mean(a1234set);
% stda1234=std(a1234set)





% nonintentforresults=intersect(nonintentindex,find(sumnonintent1234>40));
% 
% intentforresults=intersect(intentindex,find(sumnonintent1234=<40));





