#include<bits/stdc++.h>
#include<windows.h>
using namespace std;
int main(){
	WinExec("PanDownload\\pandownload.exe",SW_SHOWMAXIMIZED);
	WinExec("pdproxy\\pdproxy.exe",SW_SHOWMAXIMIZED);
	WinExec("pdproxy\\proxyset.exe",SW_SHOWMAXIMIZED);
	while(1){
		Sleep(3000);
		system("CLS");
		cout<<"启动完毕，pandownload关闭前请勿关闭本窗口！！！"<<endl; 
		cout<<"此版本复活原pandownload登录、高速下载功能"<<endl;
		cout<<"项目更新地址："<<endl;
		cout<<"https://github.com/iamnottsh/PanDownloadSuperModified"<<endl; 
		cout<<"在此向蔡某萌致敬"<<endl; 
	}
} 
