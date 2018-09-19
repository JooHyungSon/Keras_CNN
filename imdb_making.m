%imdb_making('data\CMU_DB(19)', 'train', '*.bmp', 'mat', 19, 'CMU_DB(64x64x3)_train.mat')
%imdb_making('data\CMU_DB(19)', 'validation', '*.bmp', 'mat', 19, 'CMU_DB(64x64x3)_validation.mat')
function [] = imdb_making(calDir, kind, ext,matDir, numClasses, savename)

calDir = fullfile(calDir, kind);
model.calDir = calDir ; %'data\CMU_DB(20)\train' 
model.matDir = matDir ; %mat 파일이 저장되는 장소 'mat'
model.numTrain = 1000000 ; % 부류 당(per-class) 훈련샘플들의 갯수
model.numVal = 0; % 부류 당(per-class) validation 샘플들의 갯수 160
model.numTest = 0; % 부류 당(per-class) 테스트 샘플들의 갯수 179
model.numClasses = numClasses ; % Num. of classes
tf = strcmp('validation',kind);

images = {} ;
imageClass = {} ;

classes = dir(model.calDir) ;
classes = classes([classes.isdir]) ;
classes = {classes(3:model.numClasses+2).name} ;

for ci = 1:length(classes)
  ims = dir(fullfile(model.calDir, classes{ci}, ext))' ; % 현내 class name을 갖는 폴더에 저당된 jpg 파일들의 structure 반환
  ims = vl_colsubset(ims, model.numTrain + model.numTest) ; %(각 class 마다 'model.numTrain + model.numTest'의 수만큼 추출)
                                                         
  ims = cellfun(@(x)fullfile(classes{ci},x),{ims.name},'UniformOutput',false) ; %랜덤하게 선택한 jpg파일의 이름 포함
  images = {images{:}, ims{:}} ; %모든 classes들에 모든 파일 이름들 저장
  imageClass{end+1} = ci * ones(1,length(ims)) ; %class label 붙이기
end


selTrain = find(mod(0:length(images)-1, model.numTrain+model.numTest) < model.numTrain) ; 
selTest = setdiff(1:length(images), selTrain) ; 
imageClass = cat(2, imageClass{:}) ; 


 selTrainFeats = vl_colsubset(selTrain, model.numClasses*model.numTrain) ; %selTrain에 모든 training instances 선택

  for ii = 1:length(selTrainFeats)
      ii
    im = imread(fullfile(model.calDir, images{selTrainFeats(ii)})) ;
    im = imresize(im, [64 64]); 
    [im_rows, im_cols, im_dim] = size(im);
    
    if im_dim ~= 3;
        im = cat(3,im,im,im);
    end
    clear im_rows; clear im_cols; clear im_dim;

    imdb.images.data(:,:,:,ii) = single(im);
    imdb.images.label(ii) = imageClass(ii);
   
    if (tf == 1)
        imdb.images.set(ii) = 2;
    else
        imdb.images.set(ii) = 1;
  end
 
%------------------average------------------------------------------

[row col] = size(imdb.images.data(:,:,1));
sum_image = zeros(row,col);
for ii=1:length(imdb.images.label)
    sum_image = sum_image+imdb.images.data(:,:,ii);
end
avg_img = sum_image/length(imdb.images.label);

avg_1 = mean(mean(avg_img(:,1)));
avg_2 = mean(mean(avg_img(:,2)));
avg_3 = mean(mean(avg_img(:,3)));
clear sum_image;
 
 imdb.info.numTrainPerClass = [];
 imdb.info.numValPerClass = [];
 imdb.info.average = [avg_1 avg_2 avg_3];
 
%------------------------ cmu_db.mat 파일 저장 -----------------------
save(fullfile(model.matDir, savename), 'imdb','-v7.3') ;
end