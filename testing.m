clc; clear; close all; warning off all;

[nama_file, nama_folder] = uigetfile('*.jpg');
 
 if ~isequal(nama_file,0)
    citra = imread (fullfile(nama_folder, nama_file));
    Img = imresize(citra,[1000 1000]);
    
    HSV = rgb2hsv(Img);
    %figure, imshow(HSV)
    
    %ekstraksi HSV
    H = HSV(:,:,1); 
    S = HSV(:,:,2); 
    V = HSV(:,:,3);

    bw = im2bw (S,60/255);
    bw = imfill(bw,'holes');
    bw = bwareaopen(bw,1000);
    %figure, imshow(bw);   
    
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,3);

    R(~bw) = 0;
    B(~bw) = 0;
    G(~bw) = 0;
  
    RGB = cat(3,R,G,B);
    %figure, imshow(RGB);
    
    % fitur warna HSV
    Hue = sum(sum(H))/sum(sum(bw));
    Saturation = sum(sum(S))/sum(sum(bw));
    Value = sum(sum(V))/sum(sum(bw));
    
    %luas citra
    Luas = sum(sum(bw));
    
    %fitur bentuk
    [B,L] = bwboundaries(bw,'noholes'); 
    stats = regionprops(L,'All');
    perimeter = stats.Perimeter;
    eccentricity = stats.Eccentricity;
    
    %fitur tekstur
    e = entropy(bw);
    GLCM2 = graycomatrix(bw);
    F = graycoprops(GLCM2, 'all');
    contrast = F.Contrast;
    correlation = F.Correlation;
    energi = F.Energy;
    
    %tabel
    ciri_uji(1,1) = Hue;
    ciri_uji(1,2) = Saturation;
    ciri_uji(1,3) = Value;
    ciri_uji(1,4) = Luas;
    ciri_uji(1,5) = perimeter;
    ciri_uji(1,6) = eccentricity;
    ciri_uji(1,7) = contrast;
    ciri_uji(1,8) = correlation;
    ciri_uji(1,9) = energi;
   
    load Mdl
    
    %predict MDL
    hasil_uji = predict(Mdl,ciri_uji);
    
    %output citra
    figure, imshow(Img)
    title({['Class : ',hasil_uji{1}]})
 else
     return
 end