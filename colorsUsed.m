function colors = colorsUsed(K)
%  COLORSUSED returns a K-by-3 array of the colors being used as LEGO
%  bricks. K is the number of colors being used and 3 columns are the rgb
%  values of those colors (Range 0 - 255)

if K~=5
    msg = strcat('K (ie. number of pre-selected colors) should be 5' , ...
        ', ELSE IF K ~= 5 consider editting the colorsUsed() function');
    error(msg);
end

yellow = [255,255,0];
black = [0,0,0];
white = [255,255,255];
lightgrey = [211,211,211];
dimgrey = [105,105,105];

%  This is listed in the decreasing order of probability of occurence of
%  the color in the input image. For example, Yellow is sure to occur since
%  the background of the Face in the Photo Booth is Yellow.
colors = [yellow; black; white; lightgrey; dimgrey];

end