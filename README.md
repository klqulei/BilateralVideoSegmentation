## BilateralVideoSegmentation

>By [Oliver Wang](http://www.oliverwang.info)  
oliver.wang2@gmail.com

This is a *personal* reimplementation based on the publication *Bilateral Space Video Segmentation* [Maerki et al. 2016]. 
In particular, it only partially implements method described in the above paper, featuring only multi-linear interpolation. 
Furthermore, it is written for clarity of understanding, and is totally unoptimized (i.e. IT'S SLOW and uses a LOT of memory).
For realistic timing and results to compare against, please refer to the material included in the original publication. 

All code provide here is to be used for **research purposes only**. For questions regarding commercial use, including licensing rights and IP, you must contact the owner; The Walt Disney Company.

Note: If you use this software, you should cite the following work: 

    Bilateral Space Video Segmentation
    Nicolas Maerki, Federico Perazzi, Oliver Wang, Alexander Sorkine-Hornung
    2016 IEEE Conference on Computer Vision and Pattern Recognition (CVPR)

###GRAPHCUT

This method also uses a third party [GraphCut library](http://vision.csd.uwo.ca/code/).
If you use this you have to cite their works as well! Please refer to the
webpage for the most up to date information.

###DATA

The datasets included originate from the [FBMS-59 dataset](http://lmb.informatik.uni-freiburg.de/resources/datasets/).
The datasets are provided only for research purposes and without any warranty. 
Any commercial use is prohibited. When using the BMS-26 or FBMS-59 in your 
research work, you should cite the appropriate papers in the link above.
