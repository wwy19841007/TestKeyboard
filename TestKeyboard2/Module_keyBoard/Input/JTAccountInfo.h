#ifndef __JTACCOUNT_INFO_H__
#define __JTACCOUNT_INFO_H__

#include <string>
#import <UIKit/UIKit.h>
using std::string;

//从文件testdata/AccountInfo.txt获取从接通分配的应用账号信息
//pszAccountInfo形如："appKey=##,developerKey=###,cloudUrl=###,"；
bool GetAccountInfo( NSString *fileName, NSString *fileType, string &strAccountInfo );
bool GetCapKey( NSString *fileName, NSString *fileType, string &capKey );

#endif // __FILE_UTIL_H__
