%imdb_making('data\CMU_DB(19)', 'train', '*.bmp', 'mat', 19, 'CMU_DB(64x64x3)_train.mat')
%imdb_making('data\CMU_DB(19)', 'validation', '*.bmp', 'mat', 19, 'CMU_DB(64x64x3)_validation.mat')
function [] = imdb_making(calDir, kind, ext,matDir, numClasses, savename)

calDir = fullfile(calDir, kind);
model.calDir = calDir ; %'data\CMU_DB(20)\train' 
model.matDir = matDir ; %mat ������ ����Ǵ� ��� 'mat'
model.numTrain = 1000000 ; % �η� ��(per-class) �Ʒû��õ��� ����
model.numVal = 0; % �η� ��(per-class) validation ���õ��� ���� 160
model.numTest = 0; % �η� ��(per-class) �׽�Ʈ ���õ��� ���� 179
model.numClasses = numClasses ; % Num. of classes
tf = strcmp('validation',kind);

images = {} ;
imageClass = {} ;

classes = dir(model.calDir) ;
classes = classes([classes.isdir]) ;
classes = {classes(3:model.numClasses+2).name} ;

for ci = 1:length(classes)
  ims = dir(fullfile(model.calDir, classes{ci}, ext))' ; % ���� class name�� ���� ������ ����� jpg ���ϵ��� structure ��ȯ
  ims = vl_colsubset(ims, model.numTrain + model.numTest) ; %(�� class ���� 'model.numTrain + model.numTest'�� ����ŭ ����)
                                                         
  ims = cellfun(@(x)fullfile(classes{ci},x),{ims.name},'UniformOutput',false) ; %�����ϰ� ������ jpg������ �̸� ����
  images = {images{:}, ims{:}} ; %��� classes�鿡 ��� ���� �̸��� ����
  imageClass{end+1} = ci * ones(1,length(ims)) ; %class label ���̱�
end


selTrain = find(mod(0:length(images)-1, model.numTrain+model.numTest) < model.numTrain) ; 
selTest = setdiff(1:length(images), selTrain) ; 
imageClass = cat(2, imageClass{:}) ; 


 selTrainFeats = vl_colsubset(selTrain, model.numClasses*model.numTrain) ; %selTrain�� ��� training instances ����

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
 
%------------------------ cmu_db.mat ���� ���� -----------------------
save(fullfile(model.matDir, savename), 'imdb','-v7.3') ;
end