setup() ;

%% Part 1.1: convolution

%% Part 1.1.1: convolution by a single filter

% Load an image and convert it to gray scale and single precision
x = im2single(rgb2gray(imread('data/ray.jpg'))) ;

% Define a filter
w = single([
   0 -1  0
  -1  4 -1
   0 -1  0]) ;

% Apply the filter to the image
y = vl_nnconv(x, w, []) ;

% Visualize the results
figure(11) ; clf ; colormap gray ;
set(gcf, 'name', 'Part 1.1: convolution') ;

subplot(2,2,1) ;
imagesc(x) ;
axis off image ;
title('Input image x') ;

subplot(2,2,2) ;
imagesc(w) ;
axis off image ;
title('Filter w') ;

subplot(2,2,3) ;
imagesc(y) ;
axis off image ;
title('Output image y') ;

%% Part 1.1.2: convolution by a bank of filters

% Concatenate three filters in a bank
w1 = single([
   0 -1  0
  -1  4 -1
   0 -1  0]) ;

w2 = single([
  -1 0 +1
  -1 0 +1
  -1 0 +1]) ;

w3 = single([
  -1 -1 -1
   0  0  0
  +1 +1 +1]) ;

wbank = cat(4, w1, w2, w3) ;

% Apply convolution
y = vl_nnconv(x, wbank, []) ;

% Show feature channels
figure(12) ; clf('reset') ;
set(gcf, 'name', 'Part 1.1.2: channels') ;
colormap gray ;
showFeatureChannels(y) ;


%% Part 1.2: non-linear activation functions (ReLU)

%% Part 1.2.1: Laplacian and ReLU
x = im2single(rgb2gray(imread('data/ray.jpg'))) ;

% Convolve with the negated Laplacian
y = vl_nnconv(x, - w, []) ;

% Apply the ReLU operator
z = vl_nnrelu(y) ;

figure(14) ; clf ; set(gcf, 'name', 'Part 1.2.1: Laplacian and ReLU') ;
colormap gray ;
subplot(2,2,1); imagesc(x) ; axis off image ; title('Image x') ;
subplot(2,2,2); imagesc(y) ; axis off image ; title('Laplacian y')
subplot(2,2,3); imagesc(z) ; axis off image ; title('ReLU z') ;

%% Part 1.2.2: effect of adding a bias
figure(15) ; clf ; set(gcf, 'name', 'Part 1.2.2: adding a bias') ;

colormap gray ;
subplot(1,5,1); imagesc(x) ; axis off image ; title('Image x') ;

bias = single(- 0.2) ;
y = vl_nnconv(x, - w, bias) ;
z = vl_nnrelu(y) ;
subplot(1,5,2); imagesc(y) ; axis off image ; title('Laplacian y with bias')
subplot(1,5,3); imagesc(z) ; axis off image ; title('ReLU z with bias') ;


%% 원 그리기%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold on; 
[row,col] = find(z>0.2 & z<10);   % weight
[s_row, none] = size(row);
clear none;

for c_row = 1:s_row
    r = 2;                        % 반지름
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + col(c_row);
    yunit = r * sin(th) + row(c_row);
    plot(xunit, yunit,'r');
    % pause();  
 end
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k = vl_nnconv(x, - w, []) ;

l = vl_nnrelu(k) ;
subplot(1,5,4); imagesc(k) ; axis off image ; title('Laplacian k')
subplot(1,5,5); imagesc(l) ; axis off image ; title('ReLU k') ;

%% 원 그리기%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold on; 
[row,col] = find(l>0.2);   % weight
[s_row, none] = size(row);
clear none;

for c_row = 1:s_row
    r = 2;                        % 반지름
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + col(c_row);
    yunit = r * sin(th) + row(c_row);
    plot(xunit, yunit,'r');  
    % pause();  
 end
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
