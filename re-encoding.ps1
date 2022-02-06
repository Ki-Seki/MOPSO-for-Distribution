<#
文件：re-encoding.ps1
用途：PowerShell 脚本，用于将 UTF-8 编码的文件转换成系统默认编码的文件，输出结果在与本目录的同级的 encoded 文件夹中
警告：不要修改本目录的名称，其名称必须为 006 本程序才有效
创建：2022-02-06 12:03:44，Song Shichao，song.shichao@outlook.com
修改：2013-02-06 12:43:50，Song Shichao，song.shichao@outlook.com
#>

cd ..;  # 返回上级目录
mkdir encoded;  # 新建重编码后的文件夹
Get-ChildItem .\006 | ForEach-Object -Process{  # 遍历 006 中的所有文件
	if($_ -is [System.IO.FileInfo]){
		$old_name = -join (".\006\", $_.name);
		$new_name = -join (".\encoded\", $_.name);
		& {get-content $old_name -encoding utf8 | set-content $new_name -encoding Default};  # 编码转换为系统默认编码
	}
}