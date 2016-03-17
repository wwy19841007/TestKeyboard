//
//  JTSDKEngieError.h
//  HciCloud51Demo
//
//  Created by jietong jietong on 13-3-29.
//  Copyright (c) 2013年 jietong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTSDKEngieError : NSObject
{
}

+ (NSString*) getErrorInfoByErrorCode:(int)errorCode;

@end
