displayFeatureMatches = false;


pan = createPan('myPan', 3, displayFeatureMatches);
figure, imshow(pan);
pause(2);
close all

pan = createPan('busStop', 3, displayFeatureMatches);
figure, imshow(pan);
pause(2);
close all

pan = createPan('parallax', 2, displayFeatureMatches);
figure, imshow(pan);
pause(2);
close all
