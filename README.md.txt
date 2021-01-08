**Unsupervised Recognition of Intent**

This repository is based on the work published in the International Journal of Computer Vision &quot;Adding Knowledge to Unsupervised Algorithms for the Recognition of Intent&quot; (https://arxiv.org/abs/2011.06219) . This code is research code and is thus, a little messy.In short given the trajectory of the center of mass of an agent, this algorithm will infer whether segments of the trajectory to be either intentional or non-intentional. This is achieved by examining whether segments of trajectories exhibit self-propelled motion, external force motion, or a result of one of them. We show how this algorithm works across layers of abstraction, meaning if we remove features like the pose or appearance of an agent&#39;s trajectory, we can still infer between intentional and nonintentional movement.

**DEMOS:**

We have provided a set of problems where our algorithm can be applied.

**Maya Video Agent Trajectories:**

We have provided the set of trajectories of agents (spheres) moving in a virtual scene which exhibit either intentional and non intentional movement throughout their entire trajectory.

**Mocap Data from Mixamo:**

We also provide sets of mocap animations from [https://www.mixamo.com/](https://www.mixamo.com/) depicting intentional and nonintentional movement.

**YOUTUBE 3D Reconstruction:**

We have also provided a set of pose estimation sequences extracted from YOUTUBE videos depicting intentional and non-intentional movement.

**Running Demos:**

The scripts are implemented in MATLAB (2017b) We have not tested in octave. We apply our algorithm Provided are 3 scripts for each data set we experimented on labeled as maya\_demo.m, mixamo\_demo.m, youtube\_data.m. Simply execute each of those scripts for each problem class to see our classification performance shown in work in IJCV. Data sets are all preprocessed and in the &quot;Data&quot; directory.

**Functions:**

We have provided a set of functions if one wants to use this work for their own application.

**Intention from Trajectory:**

FeatureObject= IntentObjectFromTrajectory(X,Y,Z,fps,Gvect,tolaccy,toldh)

FeatureObject contains the intentional annotations of the trajectory. X and Z are vectors of size N denoting the sequence horizontal positions of the agent for N frames, while Y denotes the vertical position of the agent for N frames. Since we estimate the total mechanical energy induced by the agent, we require the frames per second (fps) as well as the gravitational acceleration (Gvect) which is -9.8 m/s^2 in our case since we use metric units for our experiments. Lastly, we define external force motion (EFM) to be any constant negative vertical acceleration below a particular threshold (tollaccy) and any self-propelled motion (SPM) in which the change in total mechanical energy from one frame to the next is above a threshold (toldh). This function returns the intent feature object containing FeatureObject.C1234 which is theannotation regarding the intent state of segments of trajectory containting N-3 annotations, where +1 indicates intentional movement while -1 indicates nonintentional movement. FeatureObject.C1234 incorporates all common knowledge concepts mentioned in the paper.

**Center of Mass Estimation from 3d pose sequence:**

[X,Y,Z] = rawpose2COM(Rawpose)

Raw Pose takes in a tensor containing N pose sequences and computes a weighted estimation of the censor of mass trajectory of the agent. Refer to the paper and function to see how key points are formatted and averaged.