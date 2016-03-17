//
//  JTSDKEngieError.m
//  HciCloud51Demo
//
//  Created by jietong jietong on 13-3-29.
//  Copyright (c) 2013年 jietong. All rights reserved.
//

#import "JTSDKEngieError.h"
#import "hci_sys.h"
#import "ARCMacros.h"

@implementation JTSDKEngieError
+ (NSString*) getErrorInfoByErrorCode:(int)errorCode
{
    NSString * strError = nil;
    switch (errorCode) {
            
        case HCI_ERR_SERVICE_CONNECT_FAILED:
        {
            strError = @"联网失败";
        }
            break;
        case HCI_ERR_SERVICE_TIMEOUT:
        {
            strError = @"访问服务器超时了";
        }
            break;
        case HCI_ERR_SERVICE_RESPONSE_FAILED:
        {
            strError = @"服务器处理失败";
        }
            break;
        case HCI_ERR_SERVICE_DATA_INVALID:
        {
            strError = @"服务器返回数据不可用";
        }
            break;
        case HCI_ERR_LOCAL_LIB_MISSING:
        {
            strError = @"缺失本地资源";
        }
            break;
        case HCI_ERR_HWR_ENGINE_INIT_FAILED:
        {
            strError = @"初始化引擎失败";
        }
            break;
        case HCI_ERR_HWR_ENGINE_FAILED:
        {
            strError = @"引擎处理失败";
        }
            break;
        case HCI_ERR_HWR_ENGINE_SESSION_START_FAILED:
        {
            strError = @"开启会话失败";
        }
            break;
        case HCI_ERR_PARAM_INVALID:
        {
            strError = @"参数非法";
        }
            break;
        case HCI_ERR_CONFIG_CAPKEY_NOT_MATCH:
        {
            strError = @"没有可用能力";
        }
            break;
        case HCI_ERR_CONFIG_UNSUPPORT:
        {
            strError = @"不支持的配置";
        }
            break;
        case HCI_ERR_CONFIG_CAPKEY_MISSING:
        {
            strError = @"缺少必要的能力项";
        }
            break;
        case HCI_ERR_TTS_ENGINE_SESSION_START_FAILED:
        {
            strError = @"初始化引擎失败";
        }
            break;
        case HCI_ERR_SESSION_INVALID:
        {
            strError = @"无效的会话";
        }
            break;
        case HCI_ERR_CONFIG_DATAPATH_MISSING:
        {
            strError = @"缺少文件路径";
        }
            break;
        case HCI_ERR_CAPKEY_NOT_FOUND:
        {
            strError = @"当前能力不可用";
        }
            break;
        case HCI_ERR_DATA_SIZE_TOO_LARGE:
        {
            strError = @"数据量太大了";
        }
            break;
        default:
        {
            strError = [NSString stringWithFormat:@"出错了，错误代码[%d]",errorCode];
        }
            break;
    }
    return strError;
}
@end
