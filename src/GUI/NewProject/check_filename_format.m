function [ flag ] = check_filename_format( str1 , str2 , str_min_scene , str_max_scene , str_min_frame , str_max_frame)
flag = true;
%% formats
if isempty(str1)
    msgbox('Channel 1 filename format needs to be specified.','Error','error');
    flag = false;
    return;
end
str11 = strsplit(str1,'.');
str3 = str11{end};
if ~strcmpi(str3,'tif') && ~strcmpi(str3,'tiff') && ~strcmpi(str3,'jpg') && ~strcmpi(str3,'jpeg') && ~strcmpi(str3,'bmp') && ~strcmpi(str3,'png')
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


%%
%%
end

