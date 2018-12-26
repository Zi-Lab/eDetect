function flag = check_parameters_exp(msg , str , num01 , num02 , num03 )
flag = true;
if isempty(str)
    return;
end
%%
if isempty(num01) || ~(num01>=0)
    if msg
        msgbox('Object expansion parameters: 1st needs to be non-negative.','Error','error');
    end
    flag = false;
    return;
end
%%
f02 = isempty(num02) || isnan(num02);
f03 = isempty(num03) || isnan(num03);
%%
if (~f02 && f03) || (f02 && ~f03)
    if msg
        msgbox('Object expansion parameters: 2nd and 3rd need to be both specified or both left blank.','Error','error');
    end
    flag = false;
    return;
end
%%
if ~f02 && ~f03
    if ~(num02>=0)
        if msg
            msgbox('Object expansion parameters: 2nd needs to be non-negative.','Error','error');
        end
        flag = false;
        return;
    end
    if ~(num03>=0)
        if msg
            msgbox('Object expansion parameters: 3rd needs to be non-negative.','Error','error');
        end
        flag = false;
        return;
    end
end
%%
if ~f02 && ~f03
    if num02 > num03
        if msg
            msgbox('Object expansion parameters: 2nd is larger than 3rd.','Error','error');
        end
        flag = false;
        return;
    end
end
%%
end

