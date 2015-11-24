list = readdir(pwd)(3:end);

files = {"checke1", "2dData", "seeds", "abaloneReduced"};
lists = cell(length(files), 3);

for i = 1:length(list)
    for j = 1:length(files)
        if(!isempty(strfind(list{i}, files{j})))
            al = str2num(strsplit(list{i}, "_"){2});
            lists{j, al} = [lists{j, al}; list{i}];
        endif
    endfor
endfor

