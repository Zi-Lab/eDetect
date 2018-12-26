function savefile( data , variable_name , savename  )
eval([variable_name ' = data;' ]);
try
    save(savename , variable_name , '-append');
catch
    save(savename , variable_name );
end
end