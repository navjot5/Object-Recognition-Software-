load('twoFrameData.mat'); %contains two frames

[polygon, imageIndices] = selectRegion(im1, positions1); %list of indices of features within selected region
regionDescriptors = descriptors1(imageIndices,:); %gets  descriptors inside selcted region 
eucDist = dist2(regionDescriptors, descriptors2); %calculates the difference between descriptors of selected region and descriptors of second image
[mins, result] = min(eucDist,[],2); %gets values and indices of the difference. The closest feature is the min of each row
result = result(mins < 0.17); %finds matches below a 0.19 threshold (found best for the fridge)
polygon = [polygon; polygon(1,:)];

figure('Position',[0 0 1920 1080]);
subplot(1,2,1), imshow(im1), line(polygon(:, 1), polygon(:, 2), 'Color', 'green');
subplot(1,2,2), imshow(im2), displaySIFTPatches(positions2(result,:), scales2(result), orients2(result), im2); %displays sift features for the right matches

