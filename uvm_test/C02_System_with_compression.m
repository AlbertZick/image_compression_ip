%function C02_System_with_compression();
clear variables; clear global;
close all force;
clc;

%----------------------------------------------------------------------------------------------------
%----- list all images
cd '.\rgb8bit\';
ls;
cd ..;
% ----- choose an image and the part of image to compress
prompt = 'ten anh can nen\n';
str = input(prompt,'s');
str = strcat('.\rgb8bit\',str);
prompt = 'vi tri x:\n';
x = input(prompt);
prompt = 'vi tri y:\n';
y = input(prompt);
prompt = 'rong :\n';
width = input(prompt);
prompt = 'cao :\n';
height = input(prompt);

RGB = cutImage(y, x, height, width, str);
%RGB = imread('image.jpg');


%----- get the size of image
RGB = double(RGB);
[M, N, O] = size(RGB);

up_r = ceil(M/8);
up_c = ceil(N/8);

%----- write the pixels value to files so that RTL system read files for its inputs
R_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\read_R.v','w');
G_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\read_G.v','w');
B_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\read_B.v','w');

for y_block = 1:up_r
    for x_block = 1:up_c
         for r = (y_block-1)*8+1 : y_block*8
            for c = (x_block-1)*8+1 : x_block*8
                if c <= N && r <= M
                    fprintf(R_file,'%s\n', num2hex(single(RGB(r,c,1))));
                    fprintf(G_file,'%s\n', num2hex(single(RGB(r,c,2))));
                    fprintf(B_file,'%s\n', num2hex(single(RGB(r,c,3))));
                else
                    fprintf(R_file,'%s\n', num2hex(single(255.0)));
                    fprintf(G_file,'%s\n', num2hex(single(255.0)));
                    fprintf(B_file,'%s\n', num2hex(single(255.0)));
                end
            end
        end
    end
end


fprintf(R_file,'%s\n', num2hex(single(0.0)));
fprintf(G_file,'%s\n', num2hex(single(0.0)));
fprintf(B_file,'%s\n', num2hex(single(0.0)));

fprintf(R_file,'%s\n', num2hex(single(0.0)));
fprintf(G_file,'%s\n', num2hex(single(0.0)));
fprintf(B_file,'%s\n', num2hex(single(0.0)));

fprintf(R_file,'%s\n', num2hex(single(0.0)));
fprintf(G_file,'%s\n', num2hex(single(0.0)));
fprintf(B_file,'%s\n', num2hex(single(0.0)));


%----- add white pixels if the image does not have suitable size
for y_block = 1:up_r
    for x_block = 1:up_c
         for r = (y_block-1)*8+1 : y_block*8
            for c = (x_block-1)*8+1 : x_block*8
                if r > M || c > N
                    RGB(r,c,1) = 255;
                    RGB(r,c,2) = 255;
                    RGB(r,c,3) = 255;
                end
            end
        end
    end
end

%----------------------------------------------------------------------------------------------------
%----- convert RGB space into YCbCr space
YCbCr(:,:,1) =  round(0.299*RGB(:,:,1) + 0.587*RGB(:,:,2) + 0.114*RGB(:,:,3));
YCbCr(:,:,2) =  round(-0.169*RGB(:,:,1) - 0.331*RGB(:,:,2) + 0.500*RGB(:,:,3) + 128);
YCbCr(:,:,3) =  round(0.500*RGB(:,:,1) - 0.419*RGB(:,:,2) - 0.081*RGB(:,:,3) + 128);

for i=1:M
   for j=1:N
       YCbCr(i,j,1) = min(max(0,YCbCr(i,j,1)),255);
       YCbCr(i,j,2) = min(max(0,YCbCr(i,j,2)),255);
       YCbCr(i,j,3) = min(max(0,YCbCr(i,j,3)),255);
   end
end

%----- write the result of conversion to files to check the one of RTL system
in_Y_file  = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\in_Y.v','w');
in_Cb_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\in_Cb.v','w');
in_Cr_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\in_Cr.v','w');
for y_block = 1:up_r
    for x_block = 1:up_c
        for r = (y_block-1)*8+1 : y_block*8
            for c = (x_block-1)*8+1 : x_block*8
                fprintf(in_Y_file,'%f\n',  YCbCr(r,c,1));
                fprintf(in_Cb_file,'%f\n', YCbCr(r,c,2));
                fprintf(in_Cr_file,'%f\n', YCbCr(r,c,3));
            end
        end
    end
end
%----------------------------------------------------------------------------------------------------
%----- normalize matrix, subtract 128 from YCbCr matrix
normalization = YCbCr - 128;

Y  = round(normalization(:,:,1));
Cb = round(normalization(:,:,2));
Cr = round(normalization(:,:,3));
%----------------------------------------------------------------------------------------------------
%-----DCT 2-D transform
%D = dctmtx(8);         % uncomment to use a built-in 8x8 DCT matrix

a=39; b=36; c=15; d=35; e=2; f=8; g=30; h=16; y=6; j=19; k=14;
W = [
    1  1  1  1  1  1  1  1;
    1 -1 -1  1  1 -1 -1  1;
    1  1 -1 -1 -1 -1  1  1;
    1 -1  1 -1 -1  1 -1  1;
    1  1  1  1 -1 -1 -1 -1;
    1 -1 -1  1 -1  1  1 -1;
    1  1 -1 -1  1  1 -1 -1;
    1 -1  1 -1  1 -1  1 -1  ];

T = [
    a  0    0  0   0   0   0  0;
    0  a    0  0   0   0   0  0;
    0   0   b  c   0   0   0  0;
    0   0  -c  b   0   0   0  0;
    0   0   0  0   d  -e   h  y;
    0   0   0  0   f   g  -j  k;
    0   0   0  0  -k   j   g  f;
    0   0   0  0  -y  -h  -e  d  ];

cv = T(2,:);
T(2,:) = T(5,:);
T(5,:) = cv;
cv = T(7,:);
T(7,:) = T(4,:);
T(4,:) = cv;

D = T*W;
% D = [
%     39    39    39    39    39    39    39    39;
%     55    47    27    11   -11   -27   -47   -55;
%     51    21   -21   -51   -51   -21    21    51;
%     43   -11   -55   -33    33    55    11   -43;
%     39   -39   -39    39    39   -39   -39    39;
%     33   -55    11    43   -43   -11    55   -33;
%     21   -51    51   -21   -21    51   -51    21;
%     11   -27    47   -55    55   -47    27   -11];
D_T = (T*W)';

for i=0:up_r-1
    for j=0:up_c-1
        temp = Y(i*8+1:(i+1)*8, j*8+1:(j+1)*8);
        Y_o(i*8+1:(i+1)*8, j*8+1:(j+1)*8) = ((D*(D*temp)')') /8/39/39;

        temp = Cb(i*8+1:(i+1)*8, j*8+1:(j+1)*8);
        Cb_o(i*8+1:(i+1)*8, j*8+1:(j+1)*8) = ((D*(D*temp)')') /8/39/39;
        
        temp = Cr(i*8+1:(i+1)*8, j*8+1:(j+1)*8);
        Cr_o(i*8+1:(i+1)*8, j*8+1:(j+1)*8) = ((D*(D*temp)')') /8/39/39;
    end
end

dct_transform(:,:,1) = Y_o;
dct_transform(:,:,2) = Cb_o;
dct_transform(:,:,3) = Cr_o;

%----- write the result of transformation to files to check the one of RTL system
dct_Y_file  = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\dct_Y.v','w');
dct_Cb_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\dct_Cb.v','w');
dct_Cr_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\dct_Cr.v','w');
for y_block = 1:up_r
    for x_block = 1:up_c 
        for c = (x_block-1)*8+1 : x_block*8
            for r = (y_block-1)*8+1 : y_block*8
                fprintf(dct_Y_file,'%f\n',  dct_transform(r,c,1));
                fprintf(dct_Cb_file,'%f\n', dct_transform(r,c,2));
                fprintf(dct_Cr_file,'%f\n', dct_transform(r,c,3));
            end
        end
    end
end
%----------------------------------------------------------------------------------------------------
%----- quantize
Y_quantization = [
    16 11 10 16  24  40  51  61;
    12 12 14 19  26  58  60  55;
    14 13 16 24  40  57  69  56;
    14 17 22 29  51  87  80  62;
    18 22 37 56  68 109 103  77;
    24 35 55 64  81 104 113  92;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103  99  ];

Chrominance_quantization = [
    17 18 24 47 99 99 99 99;
    18 21 26 66 99 99 99 99;
    24 26 56 99 99 99 99 99;
    47 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99  ];

for i=0:up_r-1
    for j=0:up_c-1
        quantized_Y(i*8+1:(i+1)*8, j*8+1:(j+1)*8) = round(Y_o(i*8+1:(i+1)*8, j*8+1:(j+1)*8)./Y_quantization);
        quantized_Cb(i*8+1:(i+1)*8, j*8+1:(j+1)*8) = round(Cb_o(i*8+1:(i+1)*8, j*8+1:(j+1)*8)./Chrominance_quantization);
        quantized_Cr(i*8+1:(i+1)*8, j*8+1:(j+1)*8) = round(Cr_o(i*8+1:(i+1)*8, j*8+1:(j+1)*8)./Chrominance_quantization);
    end
end

%----- write the result of quantization to files to check the one of RTL system
qun_Y_file  = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\qun_Y.v','w');
qun_Cb_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\qun_Cb.v','w');
qun_Cr_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\qun_Cr.v','w');
for y_block = 1:up_r
    for x_block = 1:up_c
        for c = (x_block-1)*8+1 : x_block*8
            for r = (y_block-1)*8+1 : y_block*8
                fprintf(qun_Y_file,'%f\n' , (quantized_Y(r,c)));
                fprintf(qun_Cb_file,'%f\n', (quantized_Cb(r,c)));
                fprintf(qun_Cr_file,'%f\n', (quantized_Cr(r,c)));
            end
        end
    end
end

%----------------------------------------------------------------------------------------------------
%----- un-quantize
for i=0:up_r-1
    for j=0:up_c-1
        un_quantized_Y(i*8+1:(i+1)*8, j*8+1:(j+1)*8) = quantized_Y(i*8+1:(i+1)*8, j*8+1:(j+1)*8).* Y_quantization;
        un_quantized_Cb(i*8+1:(i+1)*8, j*8+1:(j+1)*8) = quantized_Cb(i*8+1:(i+1)*8, j*8+1:(j+1)*8) .* Chrominance_quantization;
        un_quantized_Cr(i*8+1:(i+1)*8, j*8+1:(j+1)*8) = quantized_Cr(i*8+1:(i+1)*8, j*8+1:(j+1)*8) .* Chrominance_quantization;
    end
end

%----- write the result of un-quantization to files to check the one of RTL system
unqun_Y_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\unqun_Y.v','w');
unqun_Cb_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\unqun_Cb.v','w');
unqun_Cr_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\unqun_Cr.v','w');
for y_block = 1:up_r
    for x_block = 1:up_c
        for c = (x_block-1)*8+1 : x_block*8
            for r = (y_block-1)*8+1 : y_block*8
                    fprintf(unqun_Y_file,'%f\n' , (un_quantized_Y(r,c)));
                    fprintf(unqun_Cb_file,'%f\n', (un_quantized_Cb(r,c)));
                    fprintf(unqun_Cr_file,'%f\n', (un_quantized_Cr(r,c)));

            end
        end
    end
end

%----------------------------------------------------------------------------------------------------
%-----inverse DCT 2-D transform
for i=0:up_r-1
    for j=0:up_c-1
        temp = un_quantized_Y(i*8+1:(i+1)*8, j*8+1:(j+1)*8);
        Y_i(i*8+1:(i+1)*8, j*8+1:(j+1)*8)  = ((D_T*(D_T*temp)')') /8/39/39;

        temp = un_quantized_Cb(i*8+1:(i+1)*8, j*8+1:(j+1)*8);
        Cb_i(i*8+1:(i+1)*8, j*8+1:(j+1)*8) = ((D_T*(D_T*temp)')') /8/39/39;
        
        temp = un_quantized_Cr(i*8+1:(i+1)*8, j*8+1:(j+1)*8);
        Cr_i(i*8+1:(i+1)*8, j*8+1:(j+1)*8) = ((D_T*(D_T*temp)')') /8/39/39;
        
        
    end
end

inverse_dct_transform(:,:,1) = Y_i;
inverse_dct_transform(:,:,2) = Cb_i;
inverse_dct_transform(:,:,3) = Cr_i;


%----- write the result of r-DCT 2-D to files to check the one of RTL system
r_dct_Y_file  = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\r_dct_Y_file.v','w');
r_dct_Cb_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\r_dct_Cb_file.v','w');
r_dct_Cr_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\r_dct_Cr_file.v','w');
for y_block = 1:up_r
    for x_block = 1:up_c
        for r = (y_block-1)*8+1 : y_block*8
            for c = (x_block-1)*8+1 : x_block*8
                fprintf(r_dct_Y_file,'%f\n' , (Y_i(r,c)));
                fprintf(r_dct_Cb_file,'%f\n', (Cb_i(r,c)));
                fprintf(r_dct_Cr_file,'%f\n', (Cr_i(r,c)));
            end
        end
    end
end

%----------------------------------------------------------------------------------------------------
%-----to un-normalize
un_normalization = inverse_dct_transform + 128;


%----------------------------------------------------------------------------------------------------
%-----convert YCbCr space to RGB space
rgb_matrix(:,:,1) = round(1*un_normalization(:,:,1)-00000*(un_normalization(:,:,2)-128)+1.400*(un_normalization(:,:,3)-128));
rgb_matrix(:,:,2) = round(1*un_normalization(:,:,1)-0.343*(un_normalization(:,:,2)-128)-0.711*(un_normalization(:,:,3)-128));
rgb_matrix(:,:,3) = round(1*un_normalization(:,:,1)+1.765*(un_normalization(:,:,2)-128)+0.000*(un_normalization(:,:,3)-128));

%----- write the result to file
r_R_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\r_R_file.v','w');
r_G_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\r_G_file.v','w');
r_B_file = fopen('F:\MyProjects\TruongTran\project_term_172\02_Simulate\test_data\r_B_file.v','w');
for x_block = 1:up_c
    for y_block = 1:up_r
         for i = (x_block-1)*8+1 : x_block*8
            for j = (y_block-1)*8+1 : y_block*8
                % R
                if (rgb_matrix(i,j,1) > 255)
                    fprintf(r_R_file,'%d\n', 255); 
                else if (rgb_matrix(i,j,1) < 0)
                        fprintf(r_R_file,'%d\n', 0); 
                    else
                        fprintf(r_R_file,'%d\n', rgb_matrix(i,j,1));
                    end
                end
                % G
                if (rgb_matrix(i,j,2) > 255)
                    fprintf(r_G_file,'%d\n', 255); 
                else if (rgb_matrix(i,j,2) < 0)
                        fprintf(r_G_file,'%d\n', 0); 
                    else
                        fprintf(r_G_file,'%d\n', rgb_matrix(i,j,2));
                    end
                end
                % B
                if (rgb_matrix(i,j,3) > 255)
                    fprintf(r_B_file,'%d\n', 255); 
                else if (rgb_matrix(i,j,3) < 0)
                        fprintf(r_B_file,'%d\n', 0); 
                    else
                        fprintf(r_B_file,'%d\n', rgb_matrix(i,j,3));
                    end
                end
                
            end
        end
    end
end


%----------------------------------------------------------------------------------------------------
%-----display images
im_1 = figure;
im_1.Name = 'Recreated image and Original image';
rgb_matrix=uint8(rgb_matrix);
RGB=uint8(RGB);
imshow([rgb_matrix,RGB]);

% im_2 = figure;
% im_2.Name = 'Original Image';
% RGB=uint8(RGB);
% imshow(RGB);

%----------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------
%-----mesure some metrics
%=====1. MD metric
format long;

r_m=0.0; g_m=0.0; b_m=0.0;

R=RGB(:,:,1);
G=RGB(:,:,2);
B=RGB(:,:,3);

r_m = max(max(abs(rgb_matrix(:,:,1) - R)));
g_m = max(max(abs(rgb_matrix(:,:,2) - G)));
b_m = max(max(abs(rgb_matrix(:,:,3) - B)));
fprintf('\n================\nMD metric\n');
fprintf('R space: %f\nG space: %f\nB space: %f\n',r_m,g_m,b_m);

%----------------------------------------------------------------------------------------------------
%=====2. MSE metric
fprintf('\n================\nMSE metric\n');
% MSE_R = 0.0; MSE_G = 0.0; MSE_B = 0.0;
% r=rgb_matrix(:,:,1);
% g=rgb_matrix(:,:,2);
% b=rgb_matrix(:,:,3);
% 
% for i=1:M
%     for j=1:N
%         MSE_R = MSE_R + (double(r(i,j)) - double(R(i,j)))^2;
%         MSE_G = MSE_G + (double(g(i,j)) - double(G(i,j)))^2;
%         MSE_B = MSE_B + (double(b(i,j)) - double(B(i,j)))^2;
%     end
% end
% MSE_R = double(MSE_R/M/N);
% MSE_G = double(MSE_G/M/N);
% MSE_B = double(MSE_B/M/N);
% fprintf('MSE Red space metric: %f\nMSE Green space metric: %f\nMSE Blue space metric: %f\n',MSE_R,MSE_G,MSE_B);
MSE = immse(rgb_matrix,RGB)

%----------------------------------------------------------------------------------------------------
%-----2. PSNR metric
fprintf('\n================\nPSNR metric\n');
% PSNR_R = 0.0; PSNR_G = 0.0; PSNR_B = 0.0;
% 
% PSNR_R = 10*log10((M^2/MSE_R));
% PSNR_G = 10*log10((M^2/MSE_G));
% PSNR_B = 10*log10((M^2/MSE_B));
% 
% fprintf('PSNR Red space metric: %f\nPSNR Green space metric: %f\nPSNR Blue space metric: %f\n',PSNR_R,PSNR_G,PSNR_B);
pSNR = psnr(rgb_matrix,RGB)
%----------------------------------------------------------------------------------------------------
%-----2. SSIM metric
fprintf('\n================\nSSIM metric\n');

SSIM = ssim(rgb_matrix,RGB)


fclose('all');

% end