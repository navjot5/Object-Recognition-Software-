function frameQueries()

	files = [1280, 2396, 3884];
	kMeans = load('kMeans.mat');
	kMeans = kMeans.kMeans;

	figs = [figure('Position',[0 0 1920 1080]), figure('Position',[0 0 1920 1080]), figure('Position',[0 0 1920 1080])];
	
	f = 1;
	
	for file = files

		sift = load(sprintf('sift/friends_000000%04d.jpeg.mat', file));		
		im = imread(sprintf('frames/friends_000000%04d.jpeg', file));
		desc = sift.descriptors;

		D = dist2(kMeans', desc);
		[miRow, indRow] = min(D);
		d_j = histc(indRow, 1:1500);

		similar = zeros(5, 2);			
		[mi, mindex] = min(similar(:,1));
		for frame = 60:6671
			if file == frame
				continue;
			end

			file = sprintf('friends_000000%04d.jpeg.mat', frame);
			sift2 = load(strcat('sift/', file));
			desc2 = sift2.descriptors;
			D = dist2(kMeans', desc2);
			[miRow, indRow] = min(D);
			p = histc(indRow, 1:1500);

			nscale = (d_j * p') / (sqrt(d_j * d_j') * sqrt(p * p'));
			
			if mi < nscale && nscale < 1.0
				similar(mindex,:) = [nscale, frame];
				[mi, mindex] = min(similar(:, 1));
			end

		end

		figure(figs(f)), subplot(2,3,1), imshow(im);
		[S, I] = sort(similar(:,1), 'descend');
		similar = similar(I, :)
		for count = 1:5
			pause(1);
			im = imread(sprintf('frames/friends_000000%04d.jpeg', similar(count,2)));
			figure(figs(f)), subplot(2,3,count + 1), imshow(im);
		end
		f = f + 1;
	end



end


