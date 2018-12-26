function [ flag ] = check_filename_format( str1 , str2 , str3 , str4 , str5 , str_min_scene , str_max_scene , str_min_frame , str_max_frame)
flag = true;
%% formats
if isempty(str1)
    msgbox('Channel 1 filename format needs to be specified.','Error','error');
    flag = false;
    return;
end
[~,~,ext] = fileparts(str1);
ext = ext(2:end);
if ~strcmpi(ext,'tif') && ~strcmpi(ext,'tiff') && ~strcmpi(ext,'jpg') && ~strcmpi(ext,'jpeg') && ~strcmpi(ext,'bmp') && ~strcmpi(ext,'png')
    msgbox('Please use TIFF/JPEG/BMP/PNG format.','Error','error');
    flag = false;
    return;
end
%%
if isempty(str1)
    flags1 = -1;
    flagt1 = -1;
else
    flags1 = length(strfind(str1,'<'));
    flagt1 = length(strfind(str1,'>'));
end
if isempty(str2)
    flags2 = -1;
    flagt2 = -1;
else
    flags2 = length(strfind(str2,'<'));
    flagt2 = length(strfind(str2,'>'));
end
if isempty(str3)
    flags3 = -1;
    flagt3 = -1;
else
    flags3 = length(strfind(str3,'<'));
    flagt3 = length(strfind(str3,'>'));
end
if isempty(str4)
    flags4 = -1;
    flagt4 = -1;
else
    flags4 = length(strfind(str4,'<'));
    flagt4 = length(strfind(str4,'>'));
end
if isempty(str5)
    flags5 = -1;
    flagt5 = -1;
else
    flags5 = length(strfind(str5,'<'));
    flagt5 = length(strfind(str5,'>'));
end
%%
if flags1 == -1
    msgbox('Channel 1 filename format needs to be specified.','Error','error');
    flag = false;
    return;
end
if (flags2 ~= -1 && flags2 ~= flags1) || (flagt2 ~= -1 && flagt2 ~= flagt1)
    msgbox('Channel 1 and channel 2 filename formats needs to be compatible.','Error','error');
    flag = false;
    return;
end
if (flags3 ~= -1 && flags3 ~= flags1) || (flagt3 ~= -1 && flagt3 ~= flagt1)
    msgbox('Channel 1 and channel 3 filename formats needs to be compatible.','Error','error');
    flag = false;
    return;
end
if (flags4 ~= -1 && flags4 ~= flags1) || (flagt4 ~= -1 && flagt4 ~= flagt1)
    msgbox('Channel 1 and channel 4 filename formats needs to be compatible.','Error','error');
    flag = false;
    return;
end
if (flags5 ~= -1 && flags5 ~= flags1) || (flagt5 ~= -1 && flagt5 ~= flagt1)
    msgbox('Channel 1 and channel 5 filename formats needs to be compatible.','Error','error');
    flag = false;
    return;
end
%% scene indices
if flags1 == 0 && (~isempty(str_min_scene) || ~isempty(str_max_scene))
    msgbox('Scene indices need to be left blank.','Error','error');
    flag = false;
    return;
elseif flags1 ~= 0 && (isempty(str_min_scene) || isempty(str_max_scene))
    msgbox('Scene indices need to be specified.','Error','error');
    flag = false;
    return;
end
%% frame indices
if flagt1 == 0 && (~isempty(str_min_frame) || ~isempty(str_max_frame))
    msgbox('Frame indices need to be left blank.','Error','error');
    flag = false;
    return;
elseif flagt1 ~= 0 && (isempty(str_min_frame) || isempty(str_max_frame))
    msgbox('Frame indices need to be specified.','Error','error');
    flag = false;
    return;
end
end

