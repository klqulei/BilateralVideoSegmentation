#include "mex.h"
#ifndef __clang__
#include <omp.h>
#endif

#include <unordered_map>
#include <vector>
#include <math.h>

/*
 * This function slices pixels using NLinear interpolation from a bilateral grid
 *
 * Build:
 * WINDOWS: mex -O mexSlicePointsFromBilateralStreamingSparse.cpp COMPFLAGS="/openmp $COMPFLAGS"
 *
 * bilateralData: [nPoints,nDims] is the data defining the coordinates of each point
 * pointValues: [nPoints,splatDims] is the data to splat
 * gridSize: [nDims,1] the dimensions of the grid
 * neighbors: [2^nDims,nDims], an array of '0' and '1' from dec2bin that describes which neighbor to process
 */

typedef unsigned __int64 uint64;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

	//init
    #ifndef __clang__
	int numCores = omp_get_num_procs();
	//mexPrintf("Using: %d cores\n",numCores);
	//mexEvalString("drawnow;");
    #endif

    //get data
    int c = 0;
    float* bilateralData  = (float*)(mxGetData(prhs[c++]));
    double* sp_i = (double*)(mxGetData(prhs[c++]));
    double* sp_j = (double*)(mxGetData(prhs[c++]));
    double* sp_s = (double*)(mxGetData(prhs[c++]));
    int sparseLength = (int)(mxGetScalar(prhs[c++]));
    double* gridSize = (double*)(mxGetData(prhs[c++]));
    double* neighbors = (double*)(mxGetData(prhs[c++]));
    int nDims = (int)(mxGetScalar(prhs[c++]));
    int nPoints = (int)(mxGetScalar(prhs[c++]));    
    int splatDims = (int)(mxGetScalar(prhs[c++]));
    int nNeighbors = (int)(powf(2.f,(float)nDims));
    bool hardAssignment = mxGetScalar(prhs[c++])==1?true:false;
   
    //create map to hold <index,value> pairs
    std::unordered_map<uint64,double> map;
    for(int i=0;i<sparseLength;++i) {
        double value = sp_s[i];
        uint64 key = (uint64)sp_i[i]*(uint64)splatDims + (uint64)sp_j[i];        
        
        map[key] = value;
    }
    
    //compute the index offsets per dimension
    std::vector<uint64> indexOffsets(nDims);
    indexOffsets[0] = (uint64)gridSize[0];
    for(int i=1;i<nDims;i++) {
        indexOffsets[i] = indexOffsets[i-1]*(uint64)gridSize[i];
    }
    
    //create output
    int sz[2] = {splatDims,nPoints};
    plhs[0] = mxCreateNumericArray(2,sz,mxDOUBLE_CLASS,mxREAL);
    double* sliced = mxGetPr(plhs[0]);    
    for(int i=0;i<nPoints*splatDims;i++) {
        sliced[i] = 0;
    }

    //for all points
#pragma omp parallel for 
    for(int p=0;p<nPoints;p++) {
        
        if(hardAssignment) {
            
            double weight = 1;                                                    
            uint64 index;
            
            for(int j=0;j<nDims;j++) {
                double point = bilateralData[p*nDims+j];
                int pointIndex = floor(point + 0.5);
                
                if(j==0) {
                    index = pointIndex-1;
                }
                else {
                    index += indexOffsets[j-1]*(pointIndex-1);
                }
            }

            for(int j=0;j<splatDims;j++) {
                uint64 splatKey = index*splatDims+j;
                int sliceKey = p*splatDims+j;
                
                double value = map[splatKey];
                sliced[sliceKey] += value*weight;
            }
        }   
        else {
            //for all neighbors
            for(int i=0;i<nNeighbors;i++) {

                double weight = 1;                        
                uint64 index;

                for(int j=0;j<nDims;j++) {
                    /*
                    if((p*nDims+j) >= nPoints*nDims) {
                        mexPrintf("Error: bilateral\n");
                        mexEvalString("drawnow;");
                        return;
                    }
                    */
                    double point = bilateralData[p*nDims+j];
                    int pointFloor = (int)floor(point);                
                    int pointCeil = (int)ceil(point);
                    double remainder = point - pointFloor;                
                    double neighbor = neighbors[i*nDims + j];

                    if(neighbor=='0') {                    
                        weight *= (1-remainder);
                        if(j==0) {
                            index = pointFloor-1;
                        }
                        else {
                            index += indexOffsets[j-1]*(pointFloor-1);
                        }
                    }
                    else if(neighbor=='1') {
                        weight *= remainder;
                        if(j==0) {
                            index = pointCeil-1;
                        }
                        else {
                            index += indexOffsets[j-1]*(pointCeil-1);
                        }
                    }
                }

                for(int j=0;j<splatDims;j++) {
                    uint64 splatKey = index*splatDims+j;
                    int sliceKey = p*splatDims+j;

                    double value = map[splatKey];
                    sliced[sliceKey] += value*weight;		                                       
                }                        
            }
        }
    }
}