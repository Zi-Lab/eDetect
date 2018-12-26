function keyPressCallback( h, eventdata)
param = guidata(h);
keyPressed = eventdata.Key;
switch keyPressed
    case 'leftarrow'
        if param.tmp.n_time == 1
            t = param.tmp.min_time;
        else
            t = round((get(param.hMain.SliderFrame2,'Value')));
        end
        if t > 1
            set(param.hMain.Edit2, 'string',num2str(t-1));
            CallbackImageDisplayFrame(param.hMain.Edit2);
        end
    case 'rightarrow'
        if param.tmp.n_time == 1
            t = param.tmp.min_time;
        else
            t = round((get(param.hMain.SliderFrame2,'Value')));
        end
        if t < param.tmp.n_time
            set(param.hMain.Edit2, 'string',num2str(t+1));
            CallbackImageDisplayFrame(param.hMain.Edit2);
        end
    case '1'
        DrawObject(param.hMain.pushtool_draw_object);
    case '2'
        DrawDivision(param.hMain.pushtool_draw_division);
    case 'c'
        EditObjects(param.hMain.pushtool_create_objects);
    case 'r'
        EditObjects(param.hMain.pushtool_remove_objects);
    case 'd'
        EditObjects(param.hMain.pushtool_divide_objects);
    case 'l'
        EditObjects(param.hMain.pushtool_delete_objects);
    case 'v'
        EditObjects(param.hMain.pushtool_recover_objects);
    case 's'
        EditObjects(param.hMain.pushtool_split_objects);
    case 'm'
        EditObjects(param.hMain.pushtool_merge_objects);
end
end

