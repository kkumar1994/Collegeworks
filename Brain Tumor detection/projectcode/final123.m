close all;
clear all;
global I
%global SVMCorrectRates
[FileName,PathName] = uigetfile('*.*','Select the MR Image');
I=imread([PathName,FileName]);
%figure(1),imshow(I);title('Original image');
[r c ]=size(I);

J = imnoise(I,'Gaussian',0,0.005);
% figure
% imshow(J)
% title('Noisy Image');
k=medfilt2(J); 
% figure,imshow(k)
% title('Denoised Image Using Median Filter');
k1= filter2(fspecial('average',3),J)/255;
% figure,imshow(k1) 
% title('Denoised Image Using Mean Filter');
x = wiener2(J);
% figure,imshow(x)
% title('Denoised Image Using Wiener Filter');

squaredErrorImage1 = (double(J) - double(k)) .^ 2;
squaredErrorImage2 = (double(J) - double(k1)) .^ 2;
squaredErrorImage3 = (double(J) - double(x)) .^ 2;
% % figure,
% % imshow(squaredErrorImage1);
% % title('Squared Error Image1');
% % figure,
% % imshow(squaredErrorImage2);
% % title('Squared Error Image2');
% % figure,
% % imshow(squaredErrorImage3);
% % title('Squared Error Image3');
[M N]=size(J);
% Sum the Squared Image and divide by the number of elements
% to get the Mean Squared Error.  
mse1 = sum(sum(squaredErrorImage1)) / (M * N);
mse2 = sum(sum(squaredErrorImage2)) / (M * N);
mse3 = sum(sum(squaredErrorImage3)) / (M * N);
% % Calculate PSNR (Peak Signal to Noise Ratio) from the MSE according to the formula.
PSNR1 = 10 * log10( 255^2 / mse1);
message1 = sprintf('The mean square error is %.2f.\nThe PSNR of Mean = %.2f', mse1, PSNR1);
%msgbox(message1);
PSNR2= 10 * log10( 255^2 / mse2);
message2 = sprintf('The mean square error is %.2f.\nThe PSNR of Median = %.2f', mse2, PSNR2);
%msgbox(message2);
PSNR3 = 10 * log10( 255^2 / mse3);
message3 = sprintf('The mean square error is %.2f.\nThe PSNR of Wiener = %.2f', mse3, PSNR3);
%msgbox(message3);

filimg=double(x);
[cA1,cH1,cV1,cD1] = dwt2(filimg,'db2','mode','per');
% figure;
% imshow(cA1,[]);
% title('DWT Approximation Coefficient');
% figure;
% imshow(cH1);
% title('DWT Horizontal Coefficient');
% figure;
% imshow(cV1);
% title('DWT Vertical Coefficient');
% figure;
% imshow(cD1);
% title('DWT Detailed Coefficient');
enhance=idwt2(cA1,cH1,cV1,cD1,'db2','mode','per');
figure;
imshow(enhance,[]);
title('Enhanced DWT');
squaredError1 = (filimg) - (enhance) .^ 2;
[M N]=size(filimg);
% % Sum the Squared Image and divide by the number of elements
% % to get the Mean Squared Error.  
 mse4 = sum(sum(squaredError1)) / (M * N);
% % % Calculate PSNR (Peak Signal to Noise Ratio) from the MSE according to the formula.
PSNR4 = 10 * log10( 255^2 / mse4);
 message4 = sprintf('The mean square error is %.2f.\nThe PSNR of DWT = %.2f', mse4, PSNR4);
 %msgbox(message4);
% 
% %filimg=double(x);
[ca,chd,cvd,cdd] = swt2(filimg,1,'sym4');
% figure;
% imshow(ca,[]);
% title('SWT Approximation Coefficient');
% figure;
% imshow(chd,[]);
% title('SWT Horizontal Coefficient');
% figure;
% imshow(cvd,[]);
% title('SWT Vertical Coefficient');
% figure;
% imshow(cdd,[]);
% title('SWT Detailed Coefficient');
enhance1=iswt2(ca,chd,cvd,cdd,'db2');
% figure;
% imshow(enhance1,[]);
% title('Enhanced SWT');
squaredError2 =(filimg) -(enhance1) .^ 2;
[M N]=size(filimg);
% Sum the Squared Image and divide by the number of elements
% to get the Mean Squared Error.  
mse5 = sum(sum(squaredError2)) / (M * N);
% % Calculate PSNR (Peak Signal to Noise Ratio) from the MSE according to the formula.
PSNR5 = 10 * log10( 255^2 / mse5);
message5 = sprintf('The mean square error is %.2f.\nThe PSNR of SWT = %.2f', mse5, PSNR5);
%msgbox(message5);
% 
x0=imresize(x,[256,256]);
cH1=imresize(cH1,[256,256]);
x1=bitxor(uint8(cH1),uint8(chd));
x1=imresize(x1,[256,256]);
% figure,
% imshow(x1,[]);
% title('Horizontal Coefficient of DWT&SWT');
cV1=imresize(cV1,[256,256]);
x2=bitxor(uint8(cV1),uint8(cvd));
x2=imresize(x2,[256,256]);
% figure,
% imshow(x2,[]);
% title('Vertical Coefficient of DWT&SWT');
cD1=imresize(cD1,[256,256]);
x3=bitxor(uint8(cD1),uint8(cdd));
x3=imresize(x3,[256,256]);
% figure,
% imshow(x3,[]);
% title('Detailed Coefficient of DWT&SWT');
output=idwt2(x0,x1,x2,x3,'db2');
output=imresize(output,[256,256]);
% figure,
% imshow(output,[]);
% title('Enhanced Image Using DWT & SWT');
squaredError3 =(filimg) - (output).^ 2;
[M N]=size(filimg);
% Sum the Squared Image and divide by the number of elements
% to get the Mean Squared Error.  
mse6 = sum(sum(squaredError3)) / (M * N);
% % Calculate PSNR (Peak Signal to Noise Ratio) from the MSE according to the formula.
PSNR6 = 10 * log10( 255^2 / mse6);
message6 = sprintf('The mean square error is %.2f.\nThe PSNR of DWT&SWT = %.2f', mse6, PSNR6);
%msgbox(message6);
% 
T = graythresh(x);
bw = im2bw(x,T+.4);
figure;
imshow(bw);
title('SEGMENTED IMAGE');

fs = get(0,'ScreenSize');
figure('Position',[0 0 fs(3)/2 fs(4)])
title('Morphological Operation');
SE = strel('disk',6);
bw1 = imerode(bw,SE);   
subplot(3,2,1);
imshow(bw1);
SE = strel('disk',6);
bw1 = imdilate(bw1,SE);
subplot(3,2,2);
imshow(bw1);
SE2 = strel('disk',6);
bw2 = imerode(bw1,SE2);
subplot(3,2,3);
imshow(bw2)
SE2 = strel('disk',6);
bw2 = imerode(bw2,SE2);
bw2 = imdilate(bw2,SE2);
subplot(3,2,4);
imshow(bw2)
SE3 = strel('disk',6);
bw3 = imerode(bw2,SE3);
subplot(3,2,5);
imshow(bw3)
SE3 = strel('disk',6);
bw3 = imdilate(bw3,SE3);
subplot(3,2,6);
imshow(bw3)

fs = get(0,'ScreenSize');
figure('Position',[round(fs(3)/2) 0 fs(3)/2 fs(4)])
[r2 c2]=size(bw2);
for i=1:1:r2
    for j=1:1:c2
        if bw2(i,j)==1
            I(i,j)=255;
        else
            I(i,j)=I(i,j)*0.3;
        end;
    end;
end;
subplot(1,1,1);
imshow(I);
title('TUMOR EXTRACED IMAGE');

GLCM2 = graycomatrix(I,'Offset',[0,1]);
stats1 = graycoprops(GLCM2,{'contrast','homogeneity','correlation','energy'})
testfea(1,1)=getfield(stats1,'Contrast');
testfea(1,2)=getfield(stats1,'Homogeneity');
testfea(1,3)=getfield(stats1,'Correlation');
testfea(1,4)=getfield(stats1,'Energy');
testfea(1,5)=entropy(GLCM2);

load trainfeanew
load target1
T = trainfea;
C=target1';
tst=testfea;
bow=tst';
aish1=[1,0,0,0,1,1,1,1,0,0,0,1,0,1,1,1,0,0,1,1];
aish2=target1';
deeps=trainfea';
[out] = svmrbff(T,C,tst);
if(out == 1)
        msgbox('SVM Classify as:AbNormal');
        svmaccu1;
elseif(out == 2)
        msgbox('SVM Classify as:Normal');
        svmaccu;
end

% svmaccu;
sensitivity = TP/(TP+FN)*100;
% message7 = sprintf('The Sensitivity of SVM is = %.2f',sensitivity );
% msgbox (message7);
Specificity = TN/(TN+FP)*100;
% message8 = sprintf('The Specificity of SVM is = %.2f',Specificity );
% msgbox (message8);
Accuracy = (TP+TN)/(TP+TN+FP+FN)*100;
% message9 = sprintf('The Accuracy of SVM is = %.2f',Accuracy );
% msgbox (message9);

%bar(sensitivity)
data=[sensitivity,Specificity,Accuracy];
 figure;
 for i=1:length(data)
     if i==1
         colorcode='r';
     elseif i==2
         colorcode='b';
     else
         colorcode='g';
     end
      bar(i,data(i),0.3,colorcode);
      hold on;
 end
   set(gca,'Xtick',1:3,'XTickLabel',{'Sensitivity';'Specificity';'Accuracy'})
   load net
[out1] = sim(net,bow);
if(out1 == 1)
        msgbox('ANN Classify as:AbNormal');
        
elseif(out1 == 2)
        msgbox('ANN Classify as:Normal');
        
end
    
