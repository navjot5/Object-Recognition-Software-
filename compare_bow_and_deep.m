function compare()

	files = [4503, 394];
	kMeans = load('kMeans.mat');
	kMeans = kMeans.kMeans;

	figs = [figure('Position',[0 0 1920 1080]), figure('Position',[0 0 1920 1080])];
	figsNet = [figure('Position',[0 0 1920 1080]), figure('Position',[0 0 1920 1080])];

	f = 1;
	
	for file = files

		sift = load(sprintf('sift/friends_000000%04d.jpeg.mat', file));		
		im = imread(sprintf('frames/friends_000000%04d.jpeg', file));
		desc = sift.descriptors;

		D = dist2(kMeans', desc);
		[miRow, indRow] = min(D);
		d_j = histc(indRow, 1:1500);

		similar = zeros(10, 2);	
		[mi, mindex] = min(similar(:,1));
		similarNet = zeros(10, 2);		
		[miNet, mindexNet] = min(similarNet(:,1));
		for frame = 60:6671
			if file == frame
				continue;
			end

			name = sprintf('friends_000000%04d.jpeg.mat', frame);
			sift2 = load(strcat('sift/', name));
			desc2 = sift2.descriptors;
			D = dist2(kMeans', desc2);
			[miRow, indRow] = min(D);
			p = histc(indRow, 1:1500);

			nscale = (d_j * p') / (sqrt(d_j * d_j') * sqrt(p * p'));
			ANETscale = (sift.deepFC7 * sift2.deepFC7') / (sqrt(sift.deepFC7 * sift.deepFC7') * sqrt(sift2.deepFC7 * sift2.deepFC7'));

			if mi < nscale
				similar(mindex,:) = [nscale, frame];
				[mi, mindex] = min(similar(:, 1));
			end

			if miNet < ANETscale
				similarNet(mindexNet,:) = [ANETscale, frame];
				[miNet, mindexNet] = min(similarNet(:, 1));
			end

		end

		figure(figs(f)), subplot(4,3,1), imshow(im);
		figure(figsNet(f)), subplot(4,3,1), imshow(im);

		[S, I] = sort(similar(:,1), 'descend');
		similar = similar(I, :)
		[S, I] = sort(similarNet(:,1), 'descend');
		similarNet = similarNet(I, :)
		for count = 1:10
			pause(1);
			im = imread(sprintf('frames/friends_000000%04d.jpeg', similar(count,2)));
			figure(figs(f)), subplot(4,3,count + 1), imshow(im);
			pause(1);
			im = imread(sprintf('frames/friends_000000%04d.jpeg', similarNet(count,2)));
			figure(figsNet(f)), subplot(4,3,count + 1), imshow(im);
		end


		f = f + 1;
	end



end