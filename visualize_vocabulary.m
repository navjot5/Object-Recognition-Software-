function visualWords()

	img_ind = zeros(6671 - 59, 1);

	sift_space = zeros(400000, 128);

	count = 1;
	resize = 1;

	for frame = 60:6671

		file = sprintf('sift/friends_000000%04d.jpeg.mat', frame);
		disp(file);
		sift = load(file);
		dim = sift.numfeats;
		if dim == 0
			continue;
		end
		mi = min([dim 100]);
		
		img_ind(frame - 59) = count;

		fprintf('dim = %d, count = %d\n', dim, count);

		if count + mi >= 400000 * resize
			disp('Too large doubling\n')
			sift_space = [sift_space; zeros(400000, 128)];
			resize = resize + 1
		end

		for desc = randperm(dim, mi)
			sift_space(count,:) = sift.descriptors(desc,:);
			count = count + 1;
		end

	end

	% save('sift_space100', 'sift_space', 'count', 'img_ind')

	pause;

	[mem, kMeans, rms] = kmeansML(1500, sift_space)
	save('kMeans', kMeans);

	freq = histc(mem, 1:1500);
	% bar(1:1500, freq, 'histc')
	[ma, ind] = max(freq);
	words = [ind, 1400];

	f1 = figure('Name', 'Light Top, Dark Bottom (Most Common)', 'Position', [0 0 700 700]);	
	f2 = figure('Name', 'Light Top, Dark Bottom (Arbitrary)', 'Position', [0 0 700 700]);

	count = 1;
	for frame = randperm(500, 25)
		frame = frame + 2000;
		file = sprintf('friends_000000%04d.jpeg', frame);
		sift = strcat('sift/', file, '.mat');
		ima = imread(strcat('frames/', file));
		sift = load(sift);
		desc = sift.descriptors;
		D = dist2(desc, kmean.kMeans');
		[miRow, indRow] = min(D(:, words));
		patc1 = getPatchFromSIFTParameters(sift.positions(indRow(1),:), sift.scales(indRow(1)), sift.orients(indRow(1)), rgb2gray(ima));
		figure(f1), subplot(5, 5, count), imshow(patc1);
		patc2 = getPatchFromSIFTParameters(sift.positions(indRow(2),:), sift.scales(indRow(2)), sift.orients(indRow(2)), rgb2gray(ima));
		figure(f2), subplot(5, 5, count), imshow(patc2);
		count = count + 1;
	end

end