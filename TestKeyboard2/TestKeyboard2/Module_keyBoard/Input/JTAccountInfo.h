#ifndef __JTACCOUNT_INFO_H__
#define __JTACCOUNT_INFO_H__

#include <string>
#import <UIKit/UIKit.h>
using std::string;

//���ļ�testdata/AccountInfo.txt��ȡ�ӽ�ͨ�����Ӧ���˺���Ϣ
//pszAccountInfo���磺"appKey=##,developerKey=###,cloudUrl=###,"��
bool GetAccountInfo( NSString *fileName, NSString *fileType, string &strAccountInfo );
bool GetCapKey( NSString *fileName, NSString *fileType, string &capKey );

#endif // __FILE_UTIL_H__
