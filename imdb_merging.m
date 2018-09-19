% imdb_merging('CMU_DB(64x64x3)_train', 'CMU_DB(64x64x3)_validation', 'mat','CMU_DB(64x64x3)_train_validation.mat' )
function [] = imdb_merging(train_imdb, validation_imdb, matDir,savename)
model.matDir = matDir ; 

imdb1 = load(train_imdb);
imdb2 = load(validation_imdb);

imdb.images.data = cat(4, imdb1.imdb.images.data(:,:,:,:), imdb2.imdb.images.data(:,:,:,:));
imdb.images.label = [imdb1.imdb.images.label, imdb2.imdb.images.label];
imdb.images.set = [imdb1.imdb.images.set, imdb2.imdb.images.set];

clear imdb1; clear imdb2;


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
 
 imdb.info.numTrainPerClass = [];
 imdb.info.numValPerClass = [];
 imdb.info.average = [avg_1 avg_2 avg_3];
 
save(fullfile(model.matDir, savename), 'imdb','-v7.3') ;