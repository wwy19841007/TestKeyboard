#include "JTAccountInfo.h"
#include <fstream>
using std::ifstream;

#define APP_KEY_STR "appKey="
#define DEVELOPER_KEY_STR "developerKey="
#define CLOUD_URL_STR "cloudUrl="
#define CAP_KEY_STR "capKey="

string NsStrToString(NSString *nsStr)
{
	string strRet("");
	if (nsStr == nil) {
		return strRet;
	}
	strRet = [nsStr UTF8String];
	return strRet;
}

string GetIosFullResDataPath(NSString *fileName, NSString *fileType)
{
	NSString *nsSoucePath =[[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
	string strSourcePath = NsStrToString(nsSoucePath);
	return strSourcePath;
}

string trim(const string& str) {
	string t = str;
	t.erase(0, t.find_first_not_of(" \t\n\r"));
	t.erase(t.find_last_not_of(" \t\n\r") + 1);
	return t;
}

bool GetAccountInfo( NSString *fileName, NSString *fileType, string &strAccountInfo )
{
	strAccountInfo.clear();
	ifstream fin;
	fin.open(GetIosFullResDataPath(fileName,fileType).c_str());
	
	if (!fin)
	{
		NSLog(@"get account info failed \n\t may be the file %s not exist!",GetIosFullResDataPath(fileName,fileType).c_str());
		return false;
	}
	
	string strTmp;
	while(getline(fin,strTmp))
	{
		strTmp = trim(strTmp);
		if (strTmp[0] == '#' || strTmp.empty())
		{
			continue;
		}
		if (
            (strTmp.find(APP_KEY_STR) == 0 && strTmp.length() > strlen(APP_KEY_STR))
			|| (strTmp.find(DEVELOPER_KEY_STR) == 0 && strTmp.length() >strlen(DEVELOPER_KEY_STR) )
			|| (strTmp.find(CLOUD_URL_STR) == 0 && strTmp.length() >strlen(CLOUD_URL_STR))
			)
        {
			strAccountInfo += strTmp;
			strAccountInfo += ",";
		}
	}
	
	fin.close();
	if (strAccountInfo.find(APP_KEY_STR) == string::npos
		|| strAccountInfo.find(DEVELOPER_KEY_STR) == string::npos
		|| strAccountInfo.find(CLOUD_URL_STR) == string::npos
		)
	{
		NSLog(@"get account info failed \n\t account info(%s,%s,%s) \n\t some record info may be missed,please check the file %s!",
			   APP_KEY_STR,DEVELOPER_KEY_STR,CLOUD_URL_STR,GetIosFullResDataPath(fileName,fileType).c_str());
		return false;
	}
	
	return true;
}

bool GetCapKey( NSString *fileName, NSString *fileType, string &capKey )
{
	capKey.clear();
	ifstream fin;
	fin.open(GetIosFullResDataPath(fileName,fileType).c_str());
	
	if (!fin)
	{
		NSLog(@"get account info failed \n\t may be the file %s not exist!",GetIosFullResDataPath(fileName,fileType).c_str());
		return false;
	}
	
	string strTmp;
	while(getline(fin,strTmp))
	{
		strTmp = trim(strTmp);
		if (strTmp[0] == '#' || strTmp.empty())
		{
			continue;
		}
		if ((strTmp.find(CAP_KEY_STR) == 0 && strTmp.length() > strlen(CAP_KEY_STR)))
        {
			capKey = strTmp;
		}
	}
	
	fin.close();
	if (capKey.find(CAP_KEY_STR) == string::npos)
	{
		NSLog(@"get capKey failed \n\t CapKey info may be empty,please check the file %s!"
			   ,GetIosFullResDataPath(fileName,fileType).c_str());
		return false;
	}
    
    capKey = capKey.substr(strlen(CAP_KEY_STR),capKey.length()-strlen(CAP_KEY_STR));
	return true;
}