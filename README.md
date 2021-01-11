This repository is the official code release on the work:

**Adding Knowledge to Unsupervised Algorithms for the Recognition of Intent**<br>
Stuart Synakowski, Qianli Feng & Aleix Martinez, International Journal of Computer Vision (IJCV), 2020.<br>
IJCV: https://link.springer.com/article/10.1007/s11263-020-01404-0, arXiv: https://arxiv.org/abs/2011.06219

**Unsupervised Recognition of Intent**

This repository is based on the work published in the International Journal of Computer Vision paper &quot;Adding Knowledge to Unsupervised Algorithms for the Recognition of Intent&quot; (https://arxiv.org/abs/2011.06219). This code is research code and is thus, a little messy. In short given the trajectory of the center of mass of an agent, this algorithm will infer whether segments of the trajectory to be either intentional or non-intentional. This is achieved by examining whether segments of trajectories exhibit self-propelled motion, external force motion, or a result of one of them. We show how this algorithm works across layers of abstraction, meaning if we remove features like the pose or appearance of an agent&#39;s trajectory, we can still infer between intentional and nonintentional movement.

## DEMOS

We have provided three datasets where our algorithm can be applied.

**Running Demos:**

The scripts are implemented in MATLAB 2017b. We have not tested in octave. We provide three scripts: `maya_demo.m`, `mixamo_demo.m`, `youtube_data.m`. Simply execute each of those scripts for each dataset to see our classification performance shown in our paper. 


## Datasets

Datasets are all preprocessed and in the `Data` directory.

**MAYA_DATA (intent-maya dataset):**

We have provided the set of trajectories of agents (spheres) moving in a virtual scene which exhibit either intentional and non intentional movement throughout their entire trajectory.

**MIXAMO_DATA (intent-mocap dataset):**

We also provide sets of mocap animations from [https://www.mixamo.com](https://www.mixamo.com) depicting intentional and nonintentional movement.

**YOUTUBE_DATA (intent-youtube dataset):**

We have also provided a set of pose estimation sequences extracted from YOUTUBE videos depicting intentional and non-intentional movement.


## Functions

We have provided a set of functions if one wants to use this work for their own application.

**Intention from Trajectory:**

`FeatureObject = IntentObjectFromTrajectory(X,Y,Z,fps,Gvect,tolaccy,toldh)`

`FeatureObject` contains the intentional annotations of the trajectory. X and Z are vectors of size N denoting the sequence horizontal positions of the agent for N frames, while Y denotes the vertical position of the agent for N frames. Since we estimate the total mechanical energy induced by the agent, we require the frames per second (fps) as well as the gravitational acceleration (`Gvect`) which is -9.8 m/s^2 in our case since we use metric units for our experiments. Lastly, we define external force motion (EFM) to be any constant negative vertical acceleration below a particular threshold (`tollaccy`) and any self-propelled motion (SPM) in which the change in total mechanical energy from one frame to the next is above a threshold (`toldh`). This function returns the intent feature object containing `FeatureObject.C1234` which is theannotation regarding the intent state of segments of trajectory containting N-3 annotations, where +1 indicates intentional movement while -1 indicates nonintentional movement. `FeatureObject.C1234` incorporates all common knowledge concepts mentioned in the paper.

**Center of Mass Estimation from 3d pose sequence:**

`[X,Y,Z] = rawpose2COM(Rawpose)`

Raw Pose takes in a tensor containing N pose sequences and computes a weighted estimation of the censor of mass trajectory of the agent. Refer to the paper and function to see how key points are formatted and averaged.
