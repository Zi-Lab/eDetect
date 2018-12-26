function flag = check_parameters_seg(msg , num1,num2,num3 )
flag = true;
%%
%%
if isempty(num1) || ~(num1>=0)
    if msg
        msgbox('Object minimal radii estimation needs to be a non-negative number.','Error','error');
    end
    flag = false;
    return;
end
%%
if isempty(num2) || ~(num2>0)
    if msg
        msgbox('Object median radii estimation needs to be a positive number.','Error','error');
    end
    flag = false;
    return;
end
%%
if isempty(num3) || ~(num3>0)
    if msg
        msgbox('Object maximal radii estimation needs to be a positive number.','Error','error');
    end
    flag = false;
    return;
end
%%
if num1 > num2
    if msg
        msgbox('Minimal radius is larger than median.','Error','error');
    end
    flag = false;
    return;
end
if num3 < num2
    if msg
        msgbox('Maximal radius is smaller than median.','Error','error');
    end
    flag = false;
    return;
end
%%
end

