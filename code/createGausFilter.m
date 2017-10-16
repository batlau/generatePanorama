function filter = createGausFilter(kernelSize)
if kernelSize == 1
    filter = 1;
    return
end
filter = [1 1];
for n = 1:kernelSize - 2;
    filter = conv2(filter, [1 1]);
end
filter = filter / sum(filter);