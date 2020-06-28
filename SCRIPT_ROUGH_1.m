[FileName,PathName]=uigetfile({'*.jpg;*.jpeg;*.png','Acceptable Types'},...
    'Select the "jpg", "jpeg" or "png" file to be used:');
FullName=fullfile(PathName,FileName);
if isequal(FileName,0)
    msg = '***** Selection Cancelled *****';
    error(msg);
else
    disp(FullName)
end

RGB = imread(FullName);

RGB = imsharpen(RGB);
RGB = imsharpen(RGB);
RGB = imsharpen(RGB);
RGB = imsharpen(RGB);
RGB = imsharpen(RGB);

[IND,map] = rgb2ind(RGB,5);
figure;

[IND,map] = imresize(IND,map,[48,48],'Colormap','original');

imagesc(IND);
colormap(map);