clc; clear; close all; warning off all;

nama_folder = 'data latih';
nama_file = dir(fullfile(nama_folder, '*.jpg'));

jumlah_file = numel(nama_file);
ciri_latih = zeros(jumlah_file, 9);

for n = 1:jumlah_file
    citra = imread (fullfile(nama_folder, nama_file(n).name));
    Img = imresize(citra,[1000 1000]);

    HSV = rgb2hsv(Img);
%     figure, imshow(HSV)

    %ekstraksi HSV
    H = HSV(:,:,1); 
    S = HSV(:,:,2); 
    V = HSV(:,:,3);

    bw = im2bw (S,60/255);
    bw = imfill(bw,'holes');
    bw = bwareaopen(bw,1000);
%     figure, imshow(bw);   
    
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,3);

    R(~bw) = 0;
    B(~bw) = 0;
    G(~bw) = 0;
  
    RGB = cat(3,R,G,B);
%     figure, imshow(RGB);
    
    % fitur warna HSV
    Hue = sum(sum(H))/sum(sum(bw));
    Saturation = sum(sum(S))/sum(sum(bw));
    Value = sum(sum(V))/sum(sum(bw));
    
    % luas citra
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
    ciri_latih(n,1) = Hue;
    ciri_latih(n,2) = Saturation;
    ciri_latih(n,3) = Value;
    ciri_latih(n,4) = Luas;
    ciri_latih(n,5) = perimeter;
    ciri_latih(n,6) = eccentricity;
    ciri_latih(n,7) = contrast;
    ciri_latih(n,8) = correlation;
    ciri_latih(n,9) = energi;
end
%class
kelas_latih = cell(jumlah_file,1);

for k = 1:40
    kelas_latih{k} = 'Alpukat';
end

for k = 41:80
    kelas_latih{k} = 'Apel';
end

for k = 81:120
    kelas_latih{k} = 'Jeruk';
end

for k = 121:160
    kelas_latih{k} = 'Pepaya';
end


Mdl = fitcnb(ciri_latih,kelas_latih);

hasil_latih = predict(Mdl,ciri_latih);

%akurasi
jumlah_benar = 0;
for k = 1:jumlah_file
    if isequal (hasil_latih{k}, kelas_latih{k})
        jumlah_benar = jumlah_benar+1;
    end
end

akurasi_pelatihan = jumlah_benar/jumlah_file*100

%menyimpan modul
save Mdl Mdl
 