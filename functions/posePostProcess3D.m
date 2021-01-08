function [joint3DmatNew] = posePostProcess3D(joint3Dmat)
% post processing the estimated 2D joints

% regularize the bone length differences
edges =     [[1,0],
             [1,2],
             [2,3],
             [3,4],
             [1,5],
             [5,6],
             [6,7],
             [1,8],
             [8,9],
             [9,10],
             [10,11],
             [8,12],
             [12,13],
             [13,14]];
edges = edges + 1;

joint3DmatNew = zeros(size(joint3Dmat(:,2,:)));
joint3DmatNew(:,2,:) = medfilt1(squeeze(joint3Dmat(:,2,:)),[],[],2);

for jointIdx = 1:1:size(joint3Dmat,2)
    thisJointEdge = edges(find(edges(:,2)==jointIdx),:);
    
    if isempty(thisJointEdge)
        continue;
    end
    thisJointParent = thisJointEdge(1);
    % for each joint, find out the index of frames that the detection is
    % missing
    thisJointLoc = squeeze(joint3Dmat(:,jointIdx,:));
    thisJointParentLoc = squeeze(joint3Dmat(:,thisJointParent,:));
    thisJointEdgeMat = thisJointLoc - thisJointParentLoc;
    % get bone length
    thisJointEdgeLen = sqrt(sum(thisJointEdgeMat.^2,1));
    % using median bone length as reference
    medThisEdgeLen = median(thisJointEdgeLen);
    % rescale the bone length
    thisJointEdgeScale = medThisEdgeLen./thisJointEdgeLen;
    thisJointEdgeMatRescale = thisJointEdgeMat.*thisJointEdgeScale;
    thisJointLocNew = thisJointParentLoc + thisJointEdgeMatRescale;
    joint3DmatNew(:,jointIdx,:) = thisJointLocNew;
end

end

