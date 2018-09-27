function flag = check_parameters_tra(msg , num0 )
flag = true;
if isempty(num0) || ~(num0>0)
    if msg
        msgbox('Object maximal displacement needs to be a positive number.','Error','error');
    end
    flag = false;
    return;
end
end

