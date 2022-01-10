% 将数据集中第 field_num 个字段值提取成字符串 value
function value = extract_value(datatext, field, field_num)
    % datatext 数据集字符串
    % field 字段名数组
    % field_num 要提取的字段的序号
    % value 字符串返回值

    field1 = field{field_num};
    field2 = field{field_num + 1};
    regex = [field1, '.+', field2];
    matches = regexp(datatext, regex, 'match');
    match = matches{1};
    matchsize = size(match, 2);
    field1size = size(field1, 2);
    field2size = size(field2, 2);
    value = match(field1size+1 : matchsize-field2size-2);
end