% Webcam Initialization
camList = webcamlist;
disp('Available webcams:');
disp(camList);

if isempty(camList)
    error('No webcam found. Please connect a real webcam.');
end

try
    cam = webcam(1);  % Initialize webcam (change index if needed)

    % Load or create student database
    if exist('studentDB.mat', 'file')          %if the file exists,it loads the data to studentDB
        load('studentDB.mat', 'studentDB');
    else
        studentDB = containers.Map();         %else creating dictionary
        studentDB('PES1UG23EC203') = struct('Name', 'Nikhil N', 'Course', 'ECE', 'Year', '2nd', 'Phone_num', 'xx');
        studentDB('PES1UG23EC200') = struct('Name', 'Nikhil Babu', 'Course', 'ECE', 'Year', '2nd', 'Phone_num', 'yy');
        studentDB('PES1UG23EC230') = struct('Name', 'Pruthvi', 'Course', 'ECE', 'Year', '2nd', 'Phone_num', 'zz');
        studentDB('PES1UG24EC808') = struct('Name', 'Rakesh', 'Course', 'ECE', 'Year', '2nd', 'Phone_num', 'aa');
        save('studentDB.mat', 'studentDB');
    end

    success = false;
    attempt = 0;

    while ~success && attempt < 10
        attempt = attempt + 1;
        fprintf('\nAttempt %d: Capturing and Processing Image...\n', attempt);

        % Capture Image
        img = snapshot(cam);

        % Convert to grayscale
        grayImg = rgb2gray(img); 

        % Apply preprocessing filters
        filteredImg = medfilt2(grayImg);               % Median filter:reduces noise
        sharpenedImg = imsharpen(filteredImg);         % Sharpen:makes text edge clearer
        contrastImg = imadjust(sharpenedImg);          % Enhance contrast
        resizedImg = imresize(contrastImg, 2);         % Resize

        % Adaptive binarization       :converts img to black & white for better working of OCR
        bwImg = imbinarize(resizedImg, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.4);
        bwImg = medfilt2(bwImg);  % Additional noise reduction

        % Display OCR image with grid overlay
        figure(2), imshow(bwImg), title('Image used for OCR');
        axis on;
        grid on;
        set(gca, 'XColor', 'g', 'YColor', 'g', 'GridAlpha', 0.6);

        % Custom dashed green grid every 50 pixels
        hold on;
        xSpacing = 50;
        ySpacing = 50;
        xLines = 1:xSpacing:size(bwImg, 2);
        yLines = 1:ySpacing:size(bwImg, 1);
        for x = xLines
            line([x x], [1 size(bwImg,1)], 'Color', 'g', 'LineStyle', '--', 'LineWidth', 0.5);
        end
        for y = yLines
            line([1 size(bwImg,2)], [y y], 'Color', 'g', 'LineStyle', '--', 'LineWidth', 0.5);
        end
        hold off;

        % OCR with limited character set
        ocrResults = ocr(bwImg, 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789');
        detectedNumber = upper(strtrim(ocrResults.Text));  % Clean result
        disp(['Detected Text: "', detectedNumber, '"']);

        % Skip if blank
        if isempty(detectedNumber)
            disp('No valid text detected. Please try again with clearer image.');
            continue; %while loop continues
        end

        % Check if student exists
        if isKey(studentDB, detectedNumber)
            studentInfo = studentDB(detectedNumber);
            disp(['✅ Student Found: ', studentInfo.Name]);
            disp(['Course: ', studentInfo.Course]);
            disp(['Year: ', studentInfo.Year]);
            disp(['Phone Number: ', studentInfo.Phone_num]);
            success = true;
            break;
        else
            disp('❌ Not a valid student ID. Retrying...');
        end
    end

    clear cam;

    if ~success
        disp('🛑 No valid ID detected after 10 attempts.');
    end

catch ME %this ensure hte webcam is released even if something goes wrong
    disp('An error occurred while initializing the webcam or processing image:');
    disp(ME.message);
    if exist('cam', 'var')
        clear cam;
    end
end
