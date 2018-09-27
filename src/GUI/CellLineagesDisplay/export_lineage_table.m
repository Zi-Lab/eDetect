function export_lineage_table( h,~ )
param = guidata(h);
%%
[FileName,PathName] = uiputfile('*.txt','Save form as');
if ischar(FileName) && ischar(PathName)
    dlmwrite(fullfile(PathName,FileName) , param.tmp.filtered_lineage_data,'delimiter','\t','precision',3);
    dlmwrite(fullfile(PathName,[FileName(1:end-4) '_cell_id.txt']) , param.tmp.filtered_lineage_tree,'delimiter','\t','precision',3);
    msgbox('Data table saved.','Information','help');
end
end

