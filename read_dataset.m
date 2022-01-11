% 从 .txt 数据集中读取数据到结构体数组 field 中
function field = read_dataset(dataset)
    % dataset 数据集的名称，不含后缀 .txt
    % field 返回值，包含提取出来的数据值
    
    field_name = {  % 数据集的各字段名
        'DATASET: '
        'NODE_COUNT: '
        'NODE: '
        'EDGE_COUNT: '
        'EDGE: '
        'VEHICLE_COUNT: ' 
        'VEHICLE_CAPACITY: '
        'VEHICLE_SHIPPING_COST: '
        'VEHICLE_FIXED_COST: '
        'VEHICLE_DISINFECTION_COST: '
        'VEHICLE_VELOCITY: '
        'DEMAND: '
        'RISK_MATRIX: '
        'EOF'};
    
    datatext = fileread([dataset '.txt']);  % 读取数据集文件为字符串
    
    field.DATASET = extract_value(datatext, field_name, 1);
    field.NODE_COUNT = str2num(extract_value(datatext, field_name, 2));
    field.NODE = str2num(extract_value(datatext, field_name, 3));
    field.EDGE_COUNT = str2num(extract_value(datatext, field_name, 4));
    field.EDGE = str2num(extract_value(datatext, field_name, 5));
    field.VEHICLE_COUNT = str2num(extract_value(datatext, field_name, 6));
    field.VEHICLE_CAPACITY = str2num(extract_value(datatext, field_name, 7));
    field.VEHICLE_SHIPPING_COST = str2num(extract_value(datatext, field_name, 8));
    field.VEHICLE_FIXED_COST = str2num(extract_value(datatext, field_name, 9));
    field.VEHICLE_DISINFECTION_COST = str2num(extract_value(datatext, field_name, 10));
    field.VEHICLE_VELOCITY = str2num(extract_value(datatext, field_name, 11));
    field.DEMAND = str2num(extract_value(datatext, field_name, 12));
    field.RISK_MATRIX = str2num(extract_value(datatext, field_name, 13));
end