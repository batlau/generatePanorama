function im = imReadAndConvert(filename, representation)
try
    picInf = imfinfo(filename);
    picCol = picInf.ColorType;
    im = imread(filename);
    if representation ~= 1 && representation ~= 2
        display('wrong input, representation must be 1 or 2 returning null');
        im = [];
    end
    if representation == 1
        if strcmp(picCol, 'truecolor')   
            im = rgb2gray(im);
        end
    end
    im = im2double(im);
catch
    display('error during imReadAndConvert, returning null');
    im = [];
end