## BilateralVideoSegmentation

>By [Oliver Wang ](http://www.oliverwang.info)  
oliver.wang2@gmail.com

This is a *personal* reimplementation based on the publication *Bilateral Space Video Segmentation* [Maerki et al. 2016]. 
This is only a naive implementation of the above paper. It is written for 
clarity of understanding, and is totally unoptimized (i.e. IT'S SLOW!).

Furthermore, the method does no caching at all, and therefore
uses LOTS of memory. Try it out first on small videos, and if you make any improvements, please feel to submit your changes =). 

All code provide here is to be used for **research purposes only**. For questions regarding commercial use, including licensing rights and IP, you must contact the owner; The Walt Disney Company.

Note: If you use this software, you *must* cite the following work: 

    N. Maerki, O. Wang, H. Zimmer, M. Grosse and A. Sorkine-Hornung
    Bilateral Space Video Segmentation
    2016 IEEE Conference on Computer Vision and Pattern Recognition (CVPR)


###GRAPHCUT

This method also uses a third party GraphCut library:
http://vision.csd.uwo.ca/code/

If you use this you have to cite their works as well! Please refer to the
webpage for the most up to date information.

###DATA

The datasets included originate from the FBMS-59 dataset: 
http://lmb.informatik.uni-freiburg.de/resources/datasets/

The datasets are provided only for research purposes and without any warranty. 
Any commercial use is prohibited. When using the BMS-26 or FBMS-59 in your 
research work, you should cite the appropriate papers in the link above.