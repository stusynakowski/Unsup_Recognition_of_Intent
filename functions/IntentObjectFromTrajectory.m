
function [FeatureObject]=IntentObjectFromTrajectory(X,Y,Z,fps,Gvect,tolaccy,toldh)


% 
% interpd=1;
% T=[1:1/interpd:480];
% 
%     fps=60*interpd; %<----- needed to properly compute energy
% %positions
%     X=returnedmatrix(:,1:480);
%     Y=returnedmatrix(:,481:960);
%     Z=returnedmatrix(:,961:end);

% feature 1:% just clipped entering the scene
    X1=X(:,1:end-1);
    Y1=Y(:,1:end-1);
    Z1=Z(:,1:end-1);
    
%velocities    
    Velx=fps.*diff(X1,1,2);
    Vely=fps.*diff(Y1,1,2);
    Velz=fps.*diff(Z1,1,2);
%accelerations 
  %  Accx=diff(Velx,1,2);
    Accy=fps.*diff(Vely,1,2);
  %  Accz=diff(Velz,1,2);
    

   
   
  %%  horizontal and vertical accelerations features
    
% Horizontal Acceleration magnitude
%     AccHorz=sqrt(Accx.^2+Accz.^2);
%     AccHorzAvg=1.*AccHorz(:,1:end-1);
    
    Jerky=diff(Accy,1,2);
    %Accyabs=(Accy<-2.5)./-Gvect;
    Accyabs=(Accy<tolaccy); 
    absjerky=abs(Jerky)./-Gvect;
    toljerky=(absjerky<10000);
    %toljerky=1;
 %   contaccjerk=zeros(
  %  sumconstccy=zeros(127,1);
    


    contaccjerk=zeros(size(Accy,1),size(Accy,2));
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
    for pp=1:1

        
        P(pp,:)=Gvect.*(YP(pp,1)-YP(pp,:));

    end
    
    P2=P(:,2:end);
    P1=P(:,1:end-1);
    Pavg=(P1+P2)./2;
    
% Computing the Total Mechanical Energy
% consider renormalization
    H=(K+Pavg)./(-Gvect);
    
% Applied a Median filter to remove impulses during collisions       
        for kk =1:1  
            Hmf(kk,:)=medfilt1(H(kk,:),6);
        end


%computing change in the total mechanical energy        
    DHmf=diff(Hmf,1,2);
    Dhmf=DHmf(:,1:end);
    
    DhmfInd=(Dhmf)>toldh;
    %DhmfInd=(Dhmf)>.001;
    %DhmfIndavg=sum(DhmfInd,2);
    
    numframes=length(Dhmf);
    
   
    %%
    
    %% jumping condition first
    %% falling condition second
    
    
    
    %Qint=DhmfInd+AccHorzInd+~contaccjerk;
    Cint=(DhmfInd|~contaccjerk);
    
    C12=DhmfInd-contaccjerk;
    C123=C12;
    %Qint=DhmfInd+;
    Cext=DhmfInd+~contaccjerk;
%   
    C124=C12;    
    for i=1:1
        for j=1:numframes
            if DhmfInd(i,j)==1
                counter1=1;
              while( ((j+counter1)<numframes) && contaccjerk(i,j+counter1)==1)  
                Cext(i,j+counter1)=1;
                counter1=counter1+1;
              end
            end
        end 
        
    end 
    
    for i=1:1
        for j=1:numframes
            if DhmfInd(i,j)==1
                counter1=1;
              while( ((j+counter1)<numframes) && contaccjerk(i,j+counter1)==1)
                C123(i,j+counter1)=1;
                counter1=counter1+1;
              end
            end
        end 
        
    end 
    
    
   C1234 =C123;  
   Cxt123=Cext;
    

    
 %%   
 
 
 
    for i=1:1
        currentis=0;
        for j=1:numframes
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
   
     for i=1:1
        currentis=0;
        for j=1:numframes
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
  
  % SumQ1234Qianli= sum(Q1234Qianli,2);

    
    FeatureObject.C1234=C1234;
    FeatureObject.C124=C124;
    FeatureObject.C123=C123;
    FeatureObject.C12=C12;
    FeatureObject.DhmfInd=DhmfInd;
    FeatureObject.Accy=Accy;
    FeatureObject.Accyabs=Accyabs;
    FeatureObject.Hmf=Hmf;
    FeatureObject.K=K;
    FeatureObject.Pavg=Pavg;
    
    
    
    
    

    

    

    
    
    
    

   


