<#
文件：re-encoding.ps1
用途：PowerShell 脚本，用于将 UTF-8 编码的文件转换成系统默认编码的文件，输出结果在与本目录的同级的 encoded 文件夹中
创建：2022-02-06 12:03，Song Shichao，song.shichao@outlook.com
修改：2013-02-09 20:56，Song Shichao，song.shichao@outlook.com
#>

mkdir ..\encoded;  # 新建与当前文件夹同级的重编码后的文件夹
Get-ChildItem | ForEach-Object -Process{  # 遍历当前文件夹中的所有文件
	if($_ -is [System.IO.FileInfo]){
		$new_name = -join ("..\encoded\", $_.name);  # 新文件名
		& {get-content $_.name -encoding utf8 | set-content $new_name -encoding Default};  # 编码转换为系统默认编码
	}
}