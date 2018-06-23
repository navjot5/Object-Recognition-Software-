# Object-Recognition-Software
This software is a video search method which retrieves  relevant frames from a video based on the features in a query region of that frame. 


# rawDescriptorMatches.m
Allows a user to select a requested region in one frame, and then matches descriptors in that region to other descriptors in a second image based on Euclidean distance in SIFT space (SIFT features were given).
Displays the selected region of interest in the first image and the matched features in a second image.

# kMeans.mat
Builds a visual vocabulary. Displays example image patches based on the two visual words selected. These are selected to describe different features in the frame. Displays patches to show word content is evident.

# fullFrameQueries.m
Chose 3 frames from the video data set to serve as queries. Each query frame (based on rank) gave the most similiar frames in rank order based on the normalized scalar product between the bag of words histograms.

# regionQueries.m
Allows user to select favorite query regions within 4 frames and outputs retrieved frames when only a portion of the SIFT descriptors are used to form a bag of words. Displays each query region and its 5 most similiar frames. 
