%% 
 clear all 
 addpath(genpath('./functions/'));
 trajectory__json_paths    = './Data/MAYA_DATA/maya_trajectories/';
 gravity_values_path     = './Data/MAYA_DATA/gravityvals.mat';
 
[returnedmatrix,responsevector,vidnames,SphereName]=jsondirectory3dcoordinatessphereIndex(trajectory__json_paths);
%   intent =>    response value of 0 
%   nonintent => response value of 1

 numTraj=length(responsevector);
 numVids=60;

 
 %% gravity values used in maya
 
           load(gravity_values_path);
          gravitystring=gravityvals{:,1};
          array2table(vidnames);
          Gvect = zeros(length(vidnames),1);
        for gravVidIdx = 1:1:length(gravitystring)
            gravityTemp = cellfun(@(x) strfind(x,gravitystring{gravVidIdx}),vidnames, 'UniformOutput', false);
            gravityIdx = cellfun(@isempty, gravityTemp);
            gravityIdx = ~gravityIdx;
            Gvect(gravityIdx) = gravityvals{gravVidIdx,4};
        end
            Gvect(Gvect==0) = -9.8;
            Gvect(127)=-19.6;
            Gvect(3)=-19.6;
            Gvect(4)=-19.6;
            Gvect(5)=-19.6;
            Gvect(6)=-19.6;
            Gvect(35)=-19.6;
            Gvect(123)=-19.6;
            Gvect(126)=-19.6;
                       
%             Gvect(17)=-19.6;
%             Gvect(18)=-19.6;
 

%%  compute "velocity" , acceleration" and jerk 

interpd=1;
T=[1:1/interpd:480];

    fps=60*interpd; %<----- needed to properly compute energy
%positions
    X=returnedmatrix(:,1:480);
    Y=returnedmatrix(:,481:960);
    Z=returnedmatrix(:,961:end);
    num_frames=457;
% feature 1:% just clipped entering the scene
    X1=X(:,11:end-10);
    Y1=Y(:,11:end-10);
    Z1=Z(:,11:end-10);
    
%velocities    
    Velx=fps.*diff(X1,1,2);
    Vely=fps.*diff(Y1,1,2);
    Velz=fps.*diff(Z1,1,2);
%accelerations 
    Accx=diff(Velx,1,2);
    Accy=diff(Vely,1,2);
    Accz=diff(Velz,1,2);
    

   
   
  %%  horizontal and vertical accelerations features
    
% Horizontal Acceleration magnitude
%     AccHorz=sqrt(Accx.^2+Accz.^2);
%     AccHorzAvg=1.*AccHorz(:,1:end-1);
    
    Jerky=diff(Accy,1,2);
    Accyabs=(Accy<-.01)./-Gvect; 
    absjerky=abs(Jerky)./-Gvect;
    toljerky=(absjerky<10000);
    %toljerky=1;
 %   contaccjerk=zeros(
  %  sumconstccy=zeros(127,1);
    


    contaccjerk=zeros(size(Accy,1),size(Accy,2)-1);
    for i =1:size(toljerky,1)
        for j =1:size(toljerky,2) 
            %if(toljerky(i,j)&&Accyabs(i,j))
             if(Accyabs(i,j))  
                contaccjerk(i,j)=1;

            end  
        end
    end

    
 
% %     AccHorzInd=(AccHorzAvg>=0.01).*(~contaccjerk);
% 
%   sumAccHorzInd=sum(AccHorzInd,2);
   
%   sumconstccy=sum(contaccjerk,2);
   
  

%%  Change in Energy feature 2: 
  X2=X1;
  Y2=Y1;
  Z2=Z1;
  Velx2=fps.*diff(X2,1,2);
  Vely2=fps.*diff(Y2,1,2);
  Velz2=fps.*diff(Z2,1,2);
  
  YP=Y2;
% computing Kenetic Energy
  K=0.5.*(Velx2.*Velx2+Vely2.*Vely2+Velz2.*Velz2);
  
% computing potential energy
    for pp=1:numTraj

        index=find(strcmp(vidnames{pp}(1:end-8),gravitystring));
        P(pp,:)=Gvect(pp).*(YP(pp,1)-YP(pp,:));

    end
    
    P2=P(:,2:end);
    P1=P(:,1:end-1);
    Pavg=(P1+P2)./2;
    
% Computing the Total Mechanical Energy
    H=(K+Pavg)./(-Gvect);
    
% Applied a Median filter to remove impulses during collisions       
        for kk =1:numTraj  
            Hmf(kk,:)=medfilt1(H(kk,:),6);
        end


%computing change in the total mechanical energy        
    DHmf=diff(Hmf,1,2);
    Dhmf=DHmf(:,2:end);
    
    
    DhmfInd=(Dhmf)>.01;
    %DhmfIndavg=sum(DhmfInd,2);
    
    
    
   
    %%
    
    %% jumping condition first
    %% falling condition second
    
    
    
    %Qint=DhmfInd+AccHorzInd+~contaccjerk;
   % Qint=(DhmfInd|~contaccjerk);
    
    C12=DhmfInd-contaccjerk;
    C123=C12;
    %Qint=DhmfInd+;
    C124=C12;
%     
    
    for i=1:numTraj
        for j=1:num_frames
            if DhmfInd(i,j)==1
                counter1=1;
              while( ((j+counter1)<(num_frames+1)) && contaccjerk(i,j+counter1)==1)
                C123(i,j+counter1)=1;
                counter1=counter1+1;
              end
            end
        end 
        
    end 
    
    
   C1234 =C123;  
  
    

    
 %%   
 
 %Intertia of intentionality
 
    for i=1:numTraj
        currentis=0;
        for j=1:num_frames
            if C1234(i,j)>0
                currentis=1;
                 
            elseif C1234(i,j)<0
                currentis=-1;
            end     


            if C1234(i,j)==0
                C1234(i,j)=currentis;
            end        

        end 
        
    end  
    
     for i=1:numTraj
        currentis=0;
        for j=1:num_frames
            if C124(i,j)>0
                currentis=1;
                 
            elseif C124(i,j)<0
                currentis=-1;
            end     


            if C124(i,j)==0
                C124(i,j)=currentis;
            end        

        end 
        
    end     
    
    
  %% no prior
   SumC1234= sum(C1234,2);
   SumC123= sum(C123,2); 
   SumC12= sum(C12,2); 
   SumC1= sum(DhmfInd,2);     
   SumC124= sum(C124,2); 
  %% with prior 
   SumC1234wp      = sum(C1234>=0,2)-sum(C1234<0,2);
   SumC123wp       = sum(C123>=0,2)-sum(C123<0,2); 
   SumC12wp        = sum(C12>=0,2)-sum(C12<0,2); 
   SumC1wp         = sum(DhmfInd>=0,2)-sum(DhmfInd<0,2);     
   SumC124wp       = sum(C124>=0,2)-sum(C124<0,2);  
    

       
    
     %% getting trajectories to match up for each video when classifying video
    cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));
    logigalcells=zeros(numTraj);
    for ii=1:numTraj
    
        logical_cells(:,ii) = cellfun(cellfind(vidnames{ii}),vidnames');
    
    end
    
    uniqueLogical=unique(logical_cells,'rows');
    uniqueLog=flipud(uniqueLogical);
   

    for iii=1:numVids
        sumresponsevector(iii)=sum(responsevector(find(uniqueLog(iii,:)==1),:),1);
        vidnames60{iii,:}=vidnames(:,find(uniqueLog(iii,:)==1));
        
        %features 
       % sumconstccymean(iii,:)=sum(sumconstccy(find(uniqueLog(iii,:)==1),:));
      %  SumAccHorzInd(iii,:)=sum(sumAccHorzInd(find(uniqueLog(iii,:)==1),:));
   %     sumDhmfIndavg(iii,:)=sum(DhmfIndavg(find(uniqueLog(iii,:)==1),:));
%% no prior
        sumC123460(iii,:)=sum(SumC1234(find(uniqueLog(iii,:)==1),:));
        sumC12360(iii,:)=sum(SumC123(find(uniqueLog(iii,:)==1),:));
        sumC1260(iii,:)=sum(SumC12(find(uniqueLog(iii,:)==1),:));
        sumC160(iii,:)=sum(SumC1(find(uniqueLog(iii,:)==1),:));
        sumC12460(iii,:)=sum(SumC124(find(uniqueLog(iii,:)==1),:));
%%with prior
    
        sumC123460wp(iii,:)=sum(SumC1234wp(find(uniqueLog(iii,:)==1),:));
        sumC12360wp(iii,:)=sum(SumC123wp(find(uniqueLog(iii,:)==1),:));
        sumC1260wp(iii,:)=sum(SumC12wp(find(uniqueLog(iii,:)==1),:));
        sumC160wp(iii,:)=sum(SumC1wp(find(uniqueLog(iii,:)==1),:));
        sumC12460wp(iii,:)=sum(SumC124wp(find(uniqueLog(iii,:)==1),:));
    end 
    
    sumresponsevector=(sumresponsevector>0)';


%% TEST  computing the Intent Feature Q avg

          %We accumulated the features for each video knowing that the
          %video depicts prodominantly intentional or nonintentinoal
          %actions
    %   Qavg=(SumAccHorzInd+sumDhmfIndavg-sumconstccymean)./457; %457 number of objserved frames

    %  VideoClassificationAccuracy=100*sum((sumQext60<0==sumresponsevector))/length(sumresponsevector);
       VideoClassificationAccuracy=100*sum((sumC123460<0==sumresponsevector))/length(sumresponsevector);
        fprintf("Classification Accuracy concepts 1, 2, 3, and 4: %f \n", VideoClassificationAccuracy);
        VideoClassificationAccuracy=100*sum((sumC12360<0==sumresponsevector))/length(sumresponsevector);
        fprintf("Classification Accuracy concepts 1, 2, and 3: %f \n", VideoClassificationAccuracy);
        VideoClassificationAccuracy=100*sum((sumC1260<0==sumresponsevector))/length(sumresponsevector);
        fprintf("Classification Accuracy concepts 1 and 2 : %f \n", VideoClassificationAccuracy);
        VideoClassificationAccuracy=100*sum((sumC160<0==sumresponsevector))/length(sumresponsevector);
        fprintf("Classification Accuracy concepts 1: %f \n", VideoClassificationAccuracy);
         VideoClassificationAccuracy=100*sum((sumC12460<0==sumresponsevector))/length(sumresponsevector);
        fprintf("Classification Accuracy concepts 1, 2, and 4: %f \n", VideoClassificationAccuracy);

    %%    
  VideoClassificationAccuracy=100*sum((sumC123460wp<0==sumresponsevector))/length(sumresponsevector);
        fprintf("Classification Accuracy concepts 1, 2, 3, and 4 with prior: %f \n", VideoClassificationAccuracy);
        VideoClassificationAccuracy=100*sum((sumC12360wp<0==sumresponsevector))/length(sumresponsevector);
        fprintf("Classification Accuracy concepts 1, 2, and 3 with prior: %f \n: %f \n", VideoClassificationAccuracy);
        VideoClassificationAccuracy=100*sum((sumC1260wp<0==sumresponsevector))/length(sumresponsevector);
        fprintf("Classification Accuracy concepts 1 and 2 with prior: %f \n", VideoClassificationAccuracy);
        VideoClassificationAccuracy=100*sum((sumC160wp<0==sumresponsevector))/length(sumresponsevector);
        fprintf("Classification Accuracy concepts 1 with prior: %f \n", VideoClassificationAccuracy);
         VideoClassificationAccuracy=100*sum((sumC12460wp<0==sumresponsevector))/length(sumresponsevector);
        fprintf("Classification Accuracy concepts 1, 2, and 4 prior: %f \n", VideoClassificationAccuracy);
    %% looking at the average intent state for each video
    
  IntentIndices=find(sumresponsevector==0); 
 NonIntentIndices=find(sumresponsevector==1); 
 std0=std(sumC123460(IntentIndices)./num_frames);
 std1=std(sumC123460(NonIntentIndices)./num_frames);
 mean1=mean(sumC123460(IntentIndices)./num_frames);
 mean2=mean(sumC123460(NonIntentIndices)./num_frames);
 
 figure(28)
 XXX=[-5:.01:4.5];
 plot(XXX,normpdf(XXX,mean1,std0),'b','linewidth',4)
 hold on 
plot(XXX,normpdf(XXX,mean2,std1),'r','linewidth',4)
scatter(sumC123460(IntentIndices)./457,zeros(1,30),'b','linewidth',4)
scatter(sumC123460(NonIntentIndices)./457,zeros(1,30),'r','linewidth',4)
legend({'Intentional','Unintentional'},'FontSize',20)
xlabel(' mean intent state for each video','FontSize',28)
ylabel('','FontSize',28)
set(gca,'FontSize',20)
ax = gca
ax.LineWidth = 2
hold off 



