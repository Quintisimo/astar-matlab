testPoints = [2,2;7,11;16,2;4,19;24,10;21,19];

path = [];
for i = 1:length(testPoints) - 1
    partial_path = astar(testPoints(i, :), testPoints(i + 1, :));
    path = [path; partial_path];
end
assignin('base', 'path', path);
