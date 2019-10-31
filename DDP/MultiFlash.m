%% Getting images
img = imread('test.png');
imgray=rgb2gray(img);
imshow(imgray);
%% Enhancing the contrast
J = histeq(imgray);
[Gx, Gy] = imgradientxy(J,'prewitt');
imshowpair(imgray, J, 'montage');
title('Original vs Contrast Enhanced')
%% Second Derivative to enhance the features
B = locallapfilt(J,0.4,0.5);
imshowpair(J, B, 'montage');
title('Contrast corrected to Second Derivative')
%% Selection of a base line for intensity profile
imshow(J);
title('Selecting Base Line ')
hold on;
p1 = [0 374]; % Start point of base line
p2 = [110 110]; % End point of base line
plot(p1,p2,'Color','r','LineWidth',2);
hold off;
figure
plot(improfile(B,p1,p2)); % intesity profile of at the base line
title('Intensity profile with max and min locations')
xlabel('L')
ylabel('intensity')
hold on;
%% Evaluating peaks and valley of the intesity profile at base line
[fx,fy,f]=improfile(B,p1,p2);% Intensity info at the base line
for x=1:length(fx)-1
    if f(x)>f(x+1) && f(x)>f(x-1) % Local Maximas
        plot(fx(x+1),f(x),'*r');
    end
     if f(x)<f(x+1) && f(x)<f(x-1) % Local Minimas
        plot(fx(x+1),f(x),'*g');
    end
end
hold off;
%% Image Acquisition from two flashes - Multiflash Approach
imgf1=imread('pf1.png'); % Flash placed directly above the specimen
imgf2=imread('pf2.png'); % Flash placed at an angle to specimen to create shadows
imgflash1=rgb2gray(imgf1);
imgflash2=rgb2gray(imgf2);
imshowpair(imgflash1,imgflash2,'montage');
title('Images from Flash1 and Flash2')
%% Differencing the two images to segment the shadow for depth analysis
imgdif = abs(imgf1-imgf2); % differenceing the images from Flash1 and Flash2
L=imcomplement(imgdif);
Lgray=rgb2gray(L);
figure
imshow(Lgray);
title('Differencing of the images')
%% Thresholding for consistent shadows
bw=imbinarize(Lgray,0.6);
figure
imshow(bw);
title('Thresholded Image')
hold on;
%% Selection of base line for intesity profile
imshow(bw);
title('Base line on Thresholded Image')
hold on;
p3=[0 494]; % Start point of base line
p4=[400 400]; % End point of base line
plot(p3,p4,'Color','r','LineWidth',2);
hold off;
[cx,cy,c]=improfile(bw,p3,p4);
%% Intensity Profile at the base line
profile=improfile(bw,p3,p4);
figure
p=plot(profile);
title('Intensity profile with highlited shadow location overt the base line')
xlabel('L')
ylabel('intensity')
hold on;
%% Depth map from the length of shadows obtained from the intensity profile
for i=1:length(cx) % Find for the shadow region
    if c(i)==0
        plot(cx(i+1),c(i),'*r','LineWidth',3);
    end
end
len={};s=1; % Array to store the lengths of the shadows at the base line
for l=1:length(cx)-1
    if c(l)==1
        if c(l+1)==0
            l1=cx(l+1);
        end
    end
    if c(l)==0
        if c(l+1)==1
            len{s}=cx(l)-l1;
            s=s+1;
        end
    end
end
hold off;