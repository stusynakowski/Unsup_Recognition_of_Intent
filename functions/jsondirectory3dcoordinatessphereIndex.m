function [returnedmatrix,responsevector,vidnames,sphereName]=jsondirectory3dcoordinates(jsondirectoryname)
%returns row of trajectory through prjection = [x,y] and response vectory 
% each row in repsonse vectory is 0 non intent or 1 intent.


%default camera position = 0,0,0
%default camera pointing = [ 0,0,-1] (camera to
count=0;
ndctterms=1000;
videodirectory=jsondirectoryname   %'./dataForStu-2018-03-02/';
filenamesstruct= dir(fullfile(videodirectory,'*.json'));
datamatrix=zeros(100,3*ndctterms);
responsevariable=zeros(100,1);
sphereName=[];


%videoname=filenamesstruct(3:length(filenamesstruct),:).name;

rawvideodata=cell(1,length(filenamesstruct));

%%
for i=1: length(filenamesstruct)
    %get the intent state: 1 intent 0 non intent:
    videopath=[videodirectory,'/',filenamesstruct(i).name];
    intentstate=extractBetween(filenamesstruct(i).name,'alpha','_');
    checkfordelimeter=(size(intentstate)==0);
    if checkfordelimeter(1,1)
    intentstate=extractBetween(filenamesstruct(i).name,'alpha','-');
    end 
    intentstate=str2num(intentstate{1,1});
    
    text=fileread(videopath);
    rawvideodata{i}=jsondecode(text);
    perspectivedata=rawvideodata{i}.persp;
    
    %intialized for maya footage specifically
    camvec=[0;0;-1];
    camUbasis=[-1;0;0];
    camVbasis=[0;-1;0];
    campos=[0;0;0];
    rotX=rotx(perspectivedata.rotateX);
    rotY=roty(perspectivedata.rotateY);
    rotZ=rotz(perspectivedata.rotateZ);
    %camera stuff to compute real image plane
    
    camvec=rotZ*rotY*rotX*camvec;
    camUbasis=rotZ*rotY*rotX*camUbasis;
    camVbasis=rotZ*rotY*rotX*camVbasis;
    
    camtranslate=[perspectivedata.translateX;perspectivedata.translateY;perspectivedata.translateZ];
    distance=perspectivedata.focalLength;
    campos=campos+camtranslate;
    imageplaneorigin=campos-distance.*camvec;
    
    
    %% for each point coordinate:

    %% just to find the sphere trakectories:
    objectsinvideo=fieldnames(rawvideodata{i});
    objectsthatcontainsphere=contains(objectsinvideo,'Sphere');
    indiciesthatcontainsphere=find(objectsthatcontainsphere==1);     
    rawvideocell=struct2cell(rawvideodata{i});   
    %fprintf("%f\n",length(indiciesthatcontainsphere));
    for indicies = indiciesthatcontainsphere'
    
   spherename=objectsinvideo{indicies};
    spheredata=rawvideocell{indicies,1};
    count=count+1;
    sphereName=[sphereName;spherename(end-7:end)];
    %%
    
    
    
    
    coordinates=[spheredata.translateX.value,spheredata.translateY.value,spheredata.translateZ.value];
%     cobUV=inv([camUbasis,camVbasis,camvec]);
%     uv=zeros(length(coordinates),3);
%             for j = 1:length(coordinates) 
%             
%             
%             
%             
%             [planeintersec,check]=plane_line_intersect(camvec',imageplaneorigin',campos',coordinates(j,:));
%             coordinatesb=planeintersec'-imageplaneorigin;
%             uv(j,:)=(cobUV*coordinatesb)';
%             
%             end 
   %  dctx=dct(uv(:,1),ndctterms);
   %  dcty=dct(uv(:,2),ndctterms);
     datamatrix(count,1:3*length(coordinates))=[spheredata.translateX.value',spheredata.translateY.value',spheredata.translateZ.value'];
     responsevariable(count)= intentstate;
     vidnames{count}=filenamesstruct(i).name;      
            
    end 
    %imageplaneparameters=[camvec',camvec'*imageplaneorigin];
    
    
end
% set up the svm;
%datamatrix=array2table(tablesvm(1:count,:));
returnedmatrix=datamatrix(1:count,1:3*(length(coordinates)));
responsevector=responsevariable(1:count);
vidnames=vidnames(1:count);


%%
%linearclassifier= fitclinear(tablesvm(1:count,:),responsevector);
% niave bayes
%Mdl = fitcnb(Tbl,ResponseVarName)

