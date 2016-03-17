//
//  PinyinDecoder.m
//  PinyinDemo
//
//  Created by yang yi on 14-8-3.
//  Copyright (c) 2014年 Autonavi. All rights reserved.
//

#import "PinyinDecoder.h"
#include "matrixsearch.h"
#include "utf16char.h"
#include "redefinesizet.h"
#define MAX_PINYINCHARS (256)


#define PINYIN_DIC_PATH [[NSBundle mainBundle] pathForResource:@"pinyin" ofType:@"bin"]
static PinyinDecoder* instance = nil;
@interface PinyinDecoder()
{
    BOOL bDicInited;    //
    BOOL bPrepared;
    
    char sysDicPath[MAX_PINYINCHARS];
    char userDicPath[MAX_PINYINCHARS];
    
    ime_pinyin::MatrixSearch *mMatrixSearch;
    
    ime_pinyin::char16 mUnicodeBuffer[MAX_PINYINCHARS];
    char mRetBuffer[MAX_PINYINCHARS];
    
    NSString *inputStr;
}
- (BOOL)setPinyinDecodeWithSysDic:(NSString*)sysDicPathStr WithUserDic:(NSString*)userDicPathStr;
- (BOOL)prepare;
- (BOOL)releasePinyinObj;

/**
 * 拼音识别
 * return -1 失败，否则将返回识别成功的侯选字个数
 */
- (long)searchWithString:(NSString*)pinyinStr;

- (long)delSearchWithPosition:(long)position WithSpell:(BOOL)bInSpell WithClear:(BOOL)bClear;

- (NSString*)getPinYinWithDecoded:(BOOL)bDecoded;

- (NSString*)getCandidateWithIndex:(long)index;

- (long)chooseCandidateWithIndex:(long)index;

- (long)getFixedCount;

- (NSArray*)getStartPosition;//WithPosition:(int)position;
@end
@implementation PinyinDecoder

- (id)init
{
    self = [super init];
    if (self)
    {
        //init
        bDicInited = [self setPinyinDecodeWithSysDic:PINYIN_DIC_PATH WithUserDic:@""];
        inputStr = nil;
        if (!bDicInited)
        {
            NSLog(@"ERROR init dic failed");
        }else
        {
            [self prepare];
        }
    }
    return self;
    
}

+ (PinyinDecoder *)sharedInstance
{
    @synchronized(self)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[PinyinDecoder alloc] init];
        });
    }
    
    return instance;
}

//+ (id)sharedInstance
//{
//    static dispatch_once_t sonceToken;
//    dispatch_once(&sonceToken, ^{
//        instance = [[PinyinDecoder alloc] init];
//        
//    });
//    
//    return instance;
//}

- (BOOL)checkDicPathWith:(NSString*)dicPath
{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    
    if (![fileManage fileExistsAtPath:dicPath])
    {
        return NO;
    }else
    {
        return YES;
    }
}

- (BOOL)setPinyinDecodeWithSysDic:(NSString*)sysDicPathStr WithUserDic:(NSString*)userDicPathStr;
{
    //check dic path exist first
    if (!((sysDicPathStr&&[self checkDicPathWith:sysDicPathStr])
          ||(userDicPathStr&&[self checkDicPathWith:userDicPathStr])))
    {
        return NO;
    }
    
    //set dic path
    sysDicPath[0] = 0;
    userDicPath[0] = 0;
    strcpy(sysDicPath, [sysDicPathStr UTF8String]);
    strcpy(userDicPath, [userDicPathStr UTF8String]);
    
    mMatrixSearch = NULL;
    mUnicodeBuffer[0] = 0;
    mRetBuffer[0] = 0;
    
    bPrepared = NO;
    return YES;
}

- (BOOL)prepare
{
    if (bPrepared)
    {
        return NO;
    }
    mMatrixSearch = new ime_pinyin::MatrixSearch();
    if (mMatrixSearch == NULL)
    {
        return NO;
    }
    bPrepared = mMatrixSearch->init(sysDicPath, userDicPath);
    if (!bPrepared)
    {
        delete mMatrixSearch;
        mMatrixSearch = NULL;
    }
    return bPrepared;
}

- (BOOL)releasePinyinObj
{
    if (!bPrepared)
    {
        return NO;
    }
    if (mMatrixSearch != NULL)
    {
        mMatrixSearch->close();
        delete mMatrixSearch;
        mMatrixSearch = NULL;
    }
    return YES;
}

#pragma mark - for public method -
- (NSArray*)searchPinYinWithString:(NSString*)pinyinStr
{
    long count = [self searchWithString:pinyinStr];
    if (count<0)
    {
        return nil;
    }
    
    NSString *result = [self getPinYinWithDecoded:YES];
    NSMutableArray *candidateList = nil;
    inputStr = [NSString stringWithString:result];
    
    if ([result isEqualToString:pinyinStr])
    {
        candidateList = [[NSMutableArray alloc] initWithCapacity:count];
        NSString *candidateStr = nil;
        for (long i = 0; i < count; i++)
        {
            candidateStr = [self getCandidateWithIndex:i];
            if (candidateStr)
            {
                [candidateList addObject:candidateStr];
            }
        }
    }else
    {
        [self resetSearch];
        return [self searchPinYinWithString:result];
    }
    
    return candidateList;
}
- (NSArray*)getCandidateListWithIndex:(long)index Result:(selectCandidate) param
{
    long count = [self chooseCandidateWithIndex:index];
    if (count<0)
    {
        return nil;
    }
    
    NSString *result = [self getPinYinWithDecoded:YES];
    NSLog(@"choose candidate,result =%@",result);
    
    long fixeds = [self getFixedCount];
    
    NSArray* tmp = [self getStartPosition];
    
    NSMutableArray *candidateList = nil;
    
    candidateList = [[NSMutableArray alloc] initWithCapacity:count];
    NSString *candidateStr = nil;
    for (long i = 0; i < count; i++)
    {
        candidateStr = [self getCandidateWithIndex:i];
        if (candidateStr)
        {
            [candidateList addObject:candidateStr];
        }
    }
    if ([candidateList count] < 2)
    {
        [self resetSearch];
    }
    
    param(fixeds,tmp,result);
    
    return candidateList;
    
}

- (NSArray*)delSearchAndCandidateWithPosition:(int)position WithSpell:(BOOL)bInSpell WithClear:(BOOL)bClear
{
    long count = [self delSearchWithPosition:position WithSpell:bInSpell WithClear:YES];
    if (count<0)
    {
        return nil;
    }
    
    NSString *result = [self getPinYinWithDecoded:YES];
    NSLog(@"choose candidate,result =%@",result);
//    inputStr = [NSString stringWithString:result];
    
    NSMutableArray *candidateList = nil;
    
    candidateList = [[NSMutableArray alloc] initWithCapacity:count];
    NSString *candidateStr = nil;
    for (int i = 0; i < count; i++)
    {
        candidateStr = [self getCandidateWithIndex:i];
        if (candidateStr)
        {
            [candidateList addObject:candidateStr];
        }
    }
    if ([candidateList count]<2)
    {
        [self resetSearch];
    }
    return candidateList;
}

- (BOOL)resetSearch
{
    if (!bPrepared)
    {
        return false;
    }
//[inputStr release];
    return mMatrixSearch->reset_search();
}

#pragma mark - private methods -
- (long)searchWithString:(NSString*)pinyinStr
{
    if (!bPrepared||!pinyinStr)
    {
        return -1;
    }
    const char* pinyin= [pinyinStr UTF8String];
    mMatrixSearch->search(pinyin, (unsigned)strlen(pinyin));
    
    return mMatrixSearch->get_candidate_num();
}

- (long)delSearchWithPosition:(long)position WithSpell:(BOOL)bInSpell WithClear:(BOOL)bClear
{
    if (!bPrepared)
    {
        return -1;
    }
    mMatrixSearch->delsearch((unsigned)position, bInSpell, bClear);
    return mMatrixSearch->get_candidate_num();
}

- (NSString*)getPinYinWithDecoded:(BOOL)bDecoded
{
    if (!bPrepared)
    {
        return nil;
    }
    size_t len;
    const char* pystr = mMatrixSearch->get_pystr(&len);
    if (!bDecoded)
    {
        len = (unsigned)strlen(pystr);
    }
    memcpy(mRetBuffer, pystr, len);
    mRetBuffer[len] = 0;
//    return mRetBuffer;
    return [NSString stringWithUTF8String:mRetBuffer];
}

- (NSString*)getCandidateWithIndex:(long)index
{
    if (!bPrepared)
    {
        return NULL;
    }
    mUnicodeBuffer[0] = 0;
    ime_pinyin::char16 *StrCandidate = mMatrixSearch->get_candidate((unsigned)index, mUnicodeBuffer, MAX_PINYINCHARS);
    if (StrCandidate)
    {
//        NSLog(@"get Candidate is: %@",[[NSString alloc] initWithCharacters:StrCandidate length:ime_pinyin::utf16_strlen(StrCandidate)]);
        return [[NSString alloc] initWithCharacters:StrCandidate length:ime_pinyin::utf16_strlen(StrCandidate)];
    }
//    int strlen =
//handle utf16 to NSString;
    return nil;
}

- (long)chooseCandidateWithIndex:(long)index
{
    if (!bPrepared)
    {
        return -1;
    }
    return mMatrixSearch->choose((unsigned)index);
}

- (long)getFixedCount
{
    if (!bPrepared)
    {
        return -1;
    }
    return mMatrixSearch->get_fixedlen();
}

- (NSArray*)getStartPosition;//WithPosition:(int)position
{
    if (!bPrepared)
    {
        return nil;
    }
    const ime_pinyin::uint16* getPosition;
    long count = mMatrixSearch->get_spl_start(getPosition);
    
    NSMutableArray *positionArray = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i =0; i<count; i++)
    {
        [positionArray addObject:[NSNumber numberWithInt:getPosition[i]]];
    }
    NSLog(@"result[%ld]=%@",count,positionArray);
    NSArray *result = [NSArray arrayWithArray:positionArray];
//    [positionArray release];
    return result;
}
@end
