//
//  JTHWRConfig.m
//  HciCloud51Demo
//
//  Created by jietong jietong on 13-3-25.
//  Copyright (c) 2013年 jietong. All rights reserved.
//

#include <UIKit/UIKit.h>
#import "JTHWRConfig.h"
#import "hci_sys.h"
#import "strutil.h"
#import <string>
#import <vector>
#import "ARCMacros.h"
using std::string;
using std::vector;

static string sRange_Common = "lower+upper+alphabet+number+alnum+symbol+punct+sympun+punctuation+";

@implementation JTHWRConfig

@synthesize capKey;
@synthesize currentConfigSubLang; //当前语种配置
@synthesize currentConfigRecogRange; //当前识别范围配置
@synthesize currentConfigOpenSlant; //当前倾斜矫正配置
@synthesize currentConfigDispCode; //当前简繁转换配置
@synthesize currentConfigFullHalf; //当前全角半角配置
@synthesize currentConfigSplitMode; //当前书写模式配置
@synthesize currentConfigWordMode; //当前英文大小写配

#pragma mark 外部可用的方法
- (NSMutableArray*)getRecogRangeForCapkey
{
    string range;
    CAPABILITY_ITEM	capability_item;
    const char  *  capKeyStr = [capKey UTF8String];
    HCI_ERR_CODE errCode = hci_get_capability(capKeyStr, &capability_item);
//    free(&capKeyStr);
    if(errCode != HCI_ERR_NONE)
    {
        return nil;
    }
    // 获取能力属性字段中的识别范围
    for (int nIndex = 0; nIndex < capability_item.uiPropertyCount; ++nIndex)
    {
        if(strcmp(capability_item.pPropertyList[nIndex].pszName,"range") == 0)
        {
            range = capability_item.pPropertyList[nIndex].pszValue;
        }
    }
    // 将所有范围转换为NSMutableArray
    range = sRange_Common + range;
    vector<string> recog_range_vec;
    strutil::split(recog_range_vec,range,"+");
    NSMutableArray *recog_range_array = [[NSMutableArray alloc] init];
    vector<string>::const_iterator iter = recog_range_vec.begin();
    while(iter != recog_range_vec.end())
    {
        [recog_range_array addObject:[NSString stringWithFormat:@"%s", (*iter).c_str()]];
        ++iter;
    }
    [recog_range_array addObject:@"all"];
    return SAFE_ARC_AUTORELEASE(recog_range_array);
}

- (id)initWithString:(NSString*)capKeyParam
{
    if (capKeyParam == nil) {
        return nil;
    }
    self = [super init];
    if (self) {
        //接受参数
        capKey = SAFE_ARC_COPY(capKeyParam);
        
        //生成所有capkey及其支持的配置项具体值的键值对
        [self innerMakeAllCapkeyConfigDict];
        
        //生成键值对
        [self innerGetCurrentCapkeyAndSupportedValuesDict];
        
        //获取默认配置
        [self innerGetDefaultConfig];
    }
    return self;
}

//设置当前活跃的capkey
- (void) setCurrentCapKey:(NSString*)capkeyParam
{
    if(capKey){
        SAFE_ARC_RELEASE(capKey);
    }
    capKey = SAFE_ARC_COPY(capkeyParam);
    //生成键值对
    [self innerGetCurrentCapkeyAndSupportedValuesDict];
    
    //获取默认配置
    [self innerGetDefaultConfig];
}

//获取当前配置
- (NSString*) getAllCurrentConfig
{
    NSString *item = nil;
    NSString *congfigRet = nil;
    
    //获取当前语种配置
    item = [self getCurrentConfigValueByName:@"subLang"];
    if (item != nil) {
        if (congfigRet != nil) {
            congfigRet = [NSString stringWithFormat:@"%@,subLang=%@",congfigRet,item];
        }else{
            congfigRet = [NSString stringWithFormat:@"subLang=%@",item];
        }
    }
    
    //获取当前识别范围配置
    item = [self getCurrentConfigValueByName:@"recogRange"];
    if (item != nil) {
        if (congfigRet != nil) {
            congfigRet = [NSString stringWithFormat:@"%@,recogRange=%@",congfigRet,item];
        }else{
            congfigRet = [NSString stringWithFormat:@"recogRange=%@",item];
        }
    }
    
    //获取当前倾斜矫正配置
    item = [self getCurrentConfigValueByName:@"openSlant"];
    if (item != nil) {
        if (congfigRet != nil) {
            congfigRet = [NSString stringWithFormat:@"%@,openSlant=%@",congfigRet,item];
        }else{
            congfigRet = [NSString stringWithFormat:@"openSlant=%@",item];
        }
    }
    
    //获取当前简繁转换配置
    item = [self getCurrentConfigValueByName:@"dispCode"];
    if (item != nil) {
        if (congfigRet != nil) {
            congfigRet = [NSString stringWithFormat:@"%@,dispCode=%@",congfigRet,item];
        }else{
            congfigRet = [NSString stringWithFormat:@"dispCode=%@",item];
        }
    }
    
    //获取当前全角半角配置
    item = [self getCurrentConfigValueByName:@"fullHalf"];
    if (item != nil) {
        if (congfigRet != nil) {
            congfigRet = [NSString stringWithFormat:@"%@,fullHalf=%@",congfigRet,item];
        }else{
            congfigRet = [NSString stringWithFormat:@"fullHalf=%@",item];
        }
    }
    
    //获取当前书写模式配置
    item = [self getCurrentConfigValueByName:@"splitMode"];
    if (item != nil) {
        if (congfigRet != nil) {
            congfigRet = [NSString stringWithFormat:@"%@,splitMode=%@",congfigRet,item];
        }else{
            congfigRet = [NSString stringWithFormat:@"splitMode=%@",item];
        }
    }
    
    //获取当前英文大小写配置
    item = [self getCurrentConfigValueByName:@"wordMode"];
    if (item != nil) {
        if (congfigRet != nil) {
            congfigRet = [NSString stringWithFormat:@"%@,wordMode=%@",congfigRet,item];
        }else{
            congfigRet = [NSString stringWithFormat:@"wordMode=%@",item];
        }
    }
    return congfigRet;
}

//通过配置项获取当前配置值
- (NSString*) getCurrentConfigValueByName:(NSString*)configName
{
    NSString *configRet = nil;
    id item = [currentConfigDict objectForKey:configName];
    
    if (item != [NSNull null]) {
        if ([configName rangeOfString:@"recogRange"].length > 0) {
            for (int i = 0; i < [item count]; i++) {
                if (configRet == nil) {
                    configRet = [NSString stringWithFormat:@"%@",[item objectAtIndex:i]];
                }else{
                    configRet = [NSString stringWithFormat:@"%@+%@",configRet,[item objectAtIndex:i]];
                }
            }
        }else{
            configRet = item;
        }
    }
    return configRet;
}

//通过配置项设置当前配置值
- (void) setCurrentConfigValue:(NSString*)configValue ByName:(NSString*)configName
{
    id item = [currentConfigDict objectForKey:configName];
    if (item != [NSNull null]) {
        if ([configName rangeOfString:@"recogRange"].length > 0) {
            bool isconfigValueIn = false;
            for (int i = 0; i < [item count]; i++)
            {
                if ([configValue isEqualToString:[item objectAtIndex:i]]) {
                    isconfigValueIn = true;
                }
            }
            
            //如果不存在就加入
            if (!isconfigValueIn) {
                NSMutableArray * tempArray = [NSMutableArray arrayWithArray:item];
                [tempArray addObject:configValue];
                [currentConfigDict setObject:tempArray forKey:configName];
            }
        }else{
            [currentConfigDict setObject:configValue forKey:configName];
        }
    }else{
        if ([configName rangeOfString:@"recogRange"].length > 0) {
            NSMutableArray * tempArray = [NSMutableArray array];
            [tempArray addObject:configValue];
            [currentConfigDict setObject:tempArray forKey:configName];
        }
    }
}

//删除某个识别范围
- (void) removeCurrentConfigRecogRange:(NSString*)rangeValue
{
    id item = [currentConfigDict objectForKey:@"recogRange"];
    if (item != [NSNull null]) {
        NSMutableArray * tempArray = [NSMutableArray arrayWithArray:item];
        for (int i = 0; i < [tempArray count]; i++) {
            if ([rangeValue isEqualToString:[tempArray objectAtIndex:i]]) {
                [tempArray removeObjectAtIndex:i];
                break;
            }
        }
        if ([tempArray count] == 0) {
            [currentConfigDict setObject:[NSNull null] forKey:@"recogRange"];
        }else{
            [currentConfigDict setObject:tempArray forKey:@"recogRange"];
        }
        
    }
}

//通过配置项名称获取配置项所有可取值的列表
- (id) getConfigDetailArrayByConfigName:(NSString*)configName
{
    return [configNameAndSupportedValuesDict objectForKey:configName];
}

//通过配置项名称获取当前被选择的配置项所有可取值的列表
- (id) getCurrentConfigDetailArrayByConfigName:(NSString *)configName
{
    return [currentConfigDict objectForKey:configName];
}
//获取默认配置
- (void) innerGetDefaultConfig
{
    currentConfigSubLang = nil;
    currentConfigRecogRange = nil;
    currentConfigOpenSlant = nil;
    currentConfigDispCode = nil;
    currentConfigFullHalf = nil;
    currentConfigSplitMode = nil;
    currentConfigWordMode = nil;
    currentConfigDict = [[NSMutableDictionary alloc] init];
    
    id item = nil;
    
    //获取默认语种配置
    item = [configNameAndSupportedValuesDict objectForKey:@"subLang"];
    if (item != [NSNull null]) {
        [currentConfigDict setObject:[item objectAtIndex:0] forKey:@"subLang"];
    }else{
        [currentConfigDict setObject:[NSNull null] forKey:@"subLang"];
    }
    
    //获取默认识别范围配置
    item = [configNameAndSupportedValuesDict objectForKey:@"recogRange"];
    if (item != [NSNull null]) {
        NSMutableArray * recogRangeArray = [NSMutableArray array];
        for (int i = 0; i < [item count]; i++) {
            [recogRangeArray addObject:[item objectAtIndex:i]];
        }
        [currentConfigDict setObject:recogRangeArray forKey:@"recogRange"];
        
    }else{
        [currentConfigDict setObject:[NSNull null] forKey:@"recogRange"];
    }
   
    //获取默认倾斜矫正配置
    item = [configNameAndSupportedValuesDict objectForKey:@"openSlant"];
    if (item != [NSNull null]) {
        [currentConfigDict setObject:[item objectAtIndex:0] forKey:@"openSlant"];
    }else{
        [currentConfigDict setObject:[NSNull null] forKey:@"openSlant"];
    }
    
    //获取默认简繁转换配置
    item = [configNameAndSupportedValuesDict objectForKey:@"dispCode"];
    if (item != [NSNull null]) {
        [currentConfigDict setObject:[item objectAtIndex:0] forKey:@"dispCode"];
    }else{
        [currentConfigDict setObject:[NSNull null] forKey:@"dispCode"];
    }
    
    //获取默认全角半角配置
    item = [configNameAndSupportedValuesDict objectForKey:@"fullHalf"];
    if (item != [NSNull null]) {
        [currentConfigDict setObject:[item objectAtIndex:0] forKey:@"fullHalf"];
    }else{
        [currentConfigDict setObject:[NSNull null] forKey:@"fullHalf"];
    }
    
    //获取默认书写模式配置
    item = [configNameAndSupportedValuesDict objectForKey:@"splitMode"];
    if (item != [NSNull null]) {
        [currentConfigDict setObject:[item objectAtIndex:0] forKey:@"splitMode"];
    }else{
        [currentConfigDict setObject:[NSNull null] forKey:@"splitMode"];
    }
    
    //获取默认英文大小写配置
    item = [configNameAndSupportedValuesDict objectForKey:@"wordMode"];
    if (item != [NSNull null]) {
        [currentConfigDict setObject:[item objectAtIndex:0] forKey:@"wordMode"];
    }else{
        [currentConfigDict setObject:[NSNull null] forKey:@"wordMode"];
    }
}

#pragma mark 内部使用的方法

//获取当前capkey配置项的键值对
- (void) innerGetCurrentCapkeyAndSupportedValuesDict
{
    configNameAndSupportedValuesDict = [allCapKeyAndSupportedConfigValuesDict objectForKey:capKey];
    if (configNameAndSupportedValuesDict == nil)
    {
        configNameAndSupportedValuesDict = [allCapKeyAndSupportedConfigValuesDict objectForKey:@"default"];
        UIAlertView *alertWarnig = [[UIAlertView alloc] initWithTitle:@"提示" message:@"capKey错误，请确认填写正确并已授权使用。暂不支持联想、笔形与拼音的演示。"  delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertWarnig show];
        SAFE_ARC_RELEASE(alertWarnig);
    }
}


- (void) innerMakeAllCapkeyConfigDict
{
    allCapKeyAndSupportedConfigValuesDict = [NSMutableDictionary dictionary];
    
    [self innerCreateDefaultDict];
    [self innerCreateLocalLetterDict];
    [self innerCreateLocalLetterGbDict];
    [self innerCreateLocalLetterBig5Dict];
    [self innerCreateLocalLetterHkDict];
    [self innerCreateLocalLetterJapaneseDict];
    [self innerCreateLocalLetterKoreanDict];
    [self innerCreateLocalLetterThaiDict];
    [self innerCreateLocalLetterHindiDict];
    [self innerCreateLocalLetterGreekDict];
    [self innerCreateLocalLetterLatinDict];
    [self innerCreateLocalLetterCyrillicDict];
    [self innerCreateLocalLetterArabicDict];
    [self innerCreateCloudLetterDict];
    [self innerCreateCloudLetterJapaneseDict];
    [self innerCreateCloudLetterKoreanDict];
    [self innerCreateCloudLetterThaiDict];
    [self innerCreateCloudLetterHindiDict];
    [self innerCreateCloudLetterGreekDict];
    [self innerCreateCloudLetterLatinDict];
    [self innerCreateCloudLetterCyrillicDict];
    [self innerCreateCloudLetterArabicDict];
    [self innerCreateLocalFreewriteDict];
    [self innerCreateLocalFreewriteEnglishDict];
    [self innerCreateLocalFreewriteJapaneseDict];
    [self innerCreateLocalFreewriteKoreanDict];
    [self innerCreateLocalFreestylusDict];
    [self innerCreateLocalFreestylusEnglishDict];
    [self innerCreateLocalFreestylusJapaneseDict];
    [self innerCreateLocalFreestylusKoreanDict];
    [self innerCreateCloudFreewriteDict];
    [self innerCreateCloudFreewriteEnglishDict];
    [self innerCreateCloudFreewriteJapaneseDict];
    [self innerCreateCloudFreewriteKoreanDict];
    [self innerCreateLocalGestureDict];
    [self innerCreateCloudGestureDict];
}
- (void) innerAddConfigArrayToDict
{
    if(recogRange == nil)
        return;
    
    configDict = [NSMutableDictionary dictionary];
    
    [configDict setObject:subLangArray forKey:@"subLang"];
    [configDict setObject:recogRange forKey:@"recogRange"];
    [configDict setObject:openSlant forKey:@"openSlant"];
    [configDict setObject:dispCode forKey:@"dispCode"];
    [configDict setObject:fullHalf forKey:@"fullHalf"];
    [configDict setObject:splitMode forKey:@"splitMode"];
    [configDict setObject:wordMode forKey:@"wordMode"];
    [configDict setObject:domain forKey:@"domain"];
}

- (void) innerCreateDefaultDict
{
    subLangArray = [NSNull null];
    recogRange = [NSMutableArray arrayWithObjects:@"无", nil];
    openSlant = [NSMutableArray arrayWithObjects:@"无", nil];
    dispCode = [NSMutableArray arrayWithObjects:@"无", nil];
    fullHalf = [NSMutableArray arrayWithObjects:@"无", nil];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"default"];
}

- (void) innerCreateLocalLetterDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSMutableArray arrayWithObjects:@"nochange", @"tosimplified", @"totraditional", nil];
    fullHalf = [NSMutableArray arrayWithObjects:@"half", @"full" , nil];
    splitMode = [NSNull null];
    wordMode = [NSNull null];;
    domain = [NSNull null];

    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.letter"];
}

- (void) innerCreateLocalLetterGbDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSMutableArray arrayWithObjects:@"nochange", @"tosimplified", @"totraditional", nil];
    fullHalf = [NSMutableArray arrayWithObjects:@"half", @"full" , nil];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.letter.gb"];
}

- (void) innerCreateLocalLetterBig5Dict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSMutableArray arrayWithObjects:@"nochange", @"tosimplified", @"totraditional", nil];
    fullHalf = [NSMutableArray arrayWithObjects:@"half", @"full" , nil];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.letter.big5"];
}
- (void) innerCreateLocalLetterHkDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSMutableArray arrayWithObjects:@"nochange", @"tosimplified", @"totraditional", nil];
    fullHalf = [NSMutableArray arrayWithObjects:@"half", @"full" , nil];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.letter.hk"];
}

- (void) innerCreateLocalLetterJapaneseDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.letter.japanese"];
}

- (void) innerCreateLocalLetterKoreanDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.letter.korean"];
}

- (void) innerCreateLocalLetterThaiDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.letter.thai"];
}

- (void) innerCreateLocalLetterHindiDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.letter.hindi"];
}

- (void) innerCreateLocalLetterGreekDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.letter.greek"];
}

- (void) innerCreateLocalLetterLatinDict
{
    //create array & dict
    subLangArray = [NSMutableArray arrayWithObjects:@"afrikaans", @"albanian", @"basque", @"belarussian_latin", @"bosnian_latin", @"catalan", @"cebuano", @"croatian", @"czech", @"danish", @"dutch" , @"english", @"esperanto", @"estonian", @"faroese", @"fijian", @"finnish", @"flemish", @"french", @"gagauz_latin", @"galician", @"german", @"hungarian", @"icelandic", @"indonesian", @"irish", @"italian", @"kurdish_latin", @"latvian", @"lithuanian", @"luxembourgish", @"malay", @"maltese", @"maori", @"moldavian_latin", @"norwegian", @"oromo", @"polish", @"portuguese_brazil", @"portuguese_portugal", @"romansch", @"romanian", @"samoan", @"slovak", @"slovenian" , @"sotho", @"spanish", @"swahili", @"swazi", @"swedish", @"tagalog", @"tahitian", @"tatar", @"tongan", @"turkish", @"turkmen", @"vietnamese", @"wallon", @"welsh", @"xhosa", @"zulu", nil];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.letter.latin"];
}

- (void) innerCreateLocalLetterCyrillicDict
{
    //create array & dict  
    subLangArray = [NSMutableArray arrayWithObjects:@"belarussian_cyrillic", @"bosnian_cyrillic", @"bulgarian", @"gagauz_cyrillic", @"ingush", @"kabardian, kazakh", @"kirghiz", @"kurdish_cyrillic", @"lezgi", @"macedonian", @"moldavian_cyrillic", @"mongolian", @"russian", @"serbian", @"ukrainian", nil];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.letter.cyrillic"];
}

- (void) innerCreateLocalLetterArabicDict
{
    //create array & dict
    subLangArray = [NSMutableArray arrayWithObjects: @"arabic", @"uyghur",nil];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.letter.arabic"];
}

- (void) innerCreateCloudLetterDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSMutableArray arrayWithObjects:@"nochange", @"tosimplified", @"totraditional", nil];
    fullHalf = [NSMutableArray arrayWithObjects:@"half", @"full", nil];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.cloud.letter"];
}

- (void) innerCreateCloudLetterJapaneseDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.cloud.letter.japanese"];
}

- (void) innerCreateCloudLetterKoreanDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.cloud.letter.korean"];
}

- (void) innerCreateCloudLetterThaiDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.cloud.letter.thai"];
}

- (void) innerCreateCloudLetterHindiDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.cloud.letter.hindi"];
}

- (void) innerCreateCloudLetterGreekDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.cloud.letter.greek"];
}

- (void) innerCreateCloudLetterLatinDict
{
    //create array & dict
    subLangArray = [NSMutableArray arrayWithObjects:@"afrikaans", @"albanian", @"basque", @"belarussian_latin", @"bosnian_latin", @"catalan", @"cebuano", @"croatian", @"czech", @"danish", @"dutch" , @"english", @"esperanto", @"estonian", @"faroese", @"fijian", @"finnish", @"flemish", @"french", @"gagauz_latin", @"galician", @"german", @"hungarian", @"icelandic", @"indonesian", @"irish", @"italian", @"kurdish_latin", @"latvian", @"lithuanian", @"luxembourgish", @"malay", @"maltese", @"maori", @"moldavian_latin", @"norwegian", @"oromo", @"polish", @"portuguese_brazil", @"portuguese_portugal", @"romansch", @"romanian", @"samoan", @"slovak", @"slovenian" , @"sotho", @"spanish", @"swahili", @"swazi", @"swedish", @"tagalog", @"tahitian", @"tatar", @"tongan", @"turkish", @"turkmen", @"vietnamese", @"wallon", @"welsh", @"xhosa", @"zulu", nil];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.cloud.letter.latin"];
}

- (void) innerCreateCloudLetterCyrillicDict
{
    //create array & dict
    subLangArray = [NSMutableArray arrayWithObjects:@"belarussian_cyrillic", @"bosnian_cyrillic", @"bulgarian", @"gagauz_cyrillic", @"ingush", @"kabardian", @"kazakh", @"kirghiz", @"kurdish_cyrillic", @"lezgi", @"macedonian", @"moldavian_cyrillic", @"mongolian", @"russian", @"serbian", @"ukrainian", nil];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.cloud.letter.cyrillic"];
}

- (void) innerCreateCloudLetterArabicDict
{
    //create array & dict
    subLangArray = [NSMutableArray arrayWithObjects: @"arabic", @"uyghur", nil];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.cloud.letter.arabic"];
}

- (void) innerCreateLocalFreewriteDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSMutableArray arrayWithObjects:@"nochange", @"tosimplified", @"totraditional", nil];
    fullHalf = [NSMutableArray arrayWithObjects: @"half",@"full", nil];
    splitMode = [NSMutableArray arrayWithObjects: @"line", @"overlap", nil];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.freewrite"];
}

- (void) innerCreateLocalFreewriteEnglishDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSMutableArray arrayWithObjects: @"line", @"overlap", nil];
    wordMode = [NSMutableArray arrayWithObjects:@"mixed", @"capital", @"lowercase", @"initial", nil];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.freewrite.english"];
}

- (void) innerCreateLocalFreewriteJapaneseDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSMutableArray arrayWithObjects: @"line", @"overlap", nil];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.freewrite.japanese"];
}

- (void) innerCreateLocalFreewriteKoreanDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSMutableArray arrayWithObjects: @"line", @"overlap", nil];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.freewrite.korean"];
}

- (void) innerCreateLocalFreestylusDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSMutableArray arrayWithObjects:@"nochange", @"tosimplified", @"totraditional", nil];
    fullHalf = [NSMutableArray arrayWithObjects: @"half",@"full", nil];
    splitMode = [NSMutableArray arrayWithObjects: @"line", @"overlap", nil];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.freestylus"];
}

- (void) innerCreateLocalFreestylusEnglishDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSMutableArray arrayWithObjects: @"line", @"overlap", nil];
    wordMode = [NSMutableArray arrayWithObjects:@"mixed", @"capital", @"lowercase", @"initial", nil];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.freestylus.english"];
}

- (void) innerCreateLocalFreestylusJapaneseDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSMutableArray arrayWithObjects: @"line", @"overlap", nil];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.freestylus.japanese"];
}

- (void) innerCreateLocalFreestylusKoreanDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSMutableArray arrayWithObjects: @"line", @"overlap", nil];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.freestylus.korean"];
}

- (void) innerCreateCloudFreewriteDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSMutableArray arrayWithObjects:@"nochange", @"tosimplified", @"totraditional", nil];
    fullHalf = [NSMutableArray arrayWithObjects:@"half", @"full", nil];
    splitMode = [NSMutableArray arrayWithObjects: @"line", @"overlap", nil];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.cloud.freewrite"];
}

- (void) innerCreateCloudFreewriteEnglishDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSMutableArray arrayWithObjects: @"line", @"overlap", nil];
    wordMode = [NSMutableArray arrayWithObjects: @"mixed", @"capital", @"lowercase", @"initial", nil];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.cloud.freewrite.english"];
}

- (void) innerCreateCloudFreewriteJapaneseDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSMutableArray arrayWithObjects: @"line", @"overlap", nil];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.cloud.freewrite.japanese"];
}

- (void) innerCreateCloudFreewriteKoreanDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [self getRecogRangeForCapkey];
    openSlant = [NSMutableArray arrayWithObjects:@"no", @"yes", nil];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSMutableArray arrayWithObjects: @"line", @"overlap", nil];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.cloud.freewrite.korean"];
}

- (void) innerCreateLocalGestureDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [NSNull null];
    openSlant = [NSNull null];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.local.gesture"];
}

- (void) innerCreateCloudGestureDict
{
    //create array & dict
    subLangArray = [NSNull null];
    recogRange = [NSNull null];
    openSlant = [NSNull null];
    dispCode = [NSNull null];
    fullHalf = [NSNull null];
    splitMode = [NSNull null];
    wordMode = [NSNull null];
    domain = [NSNull null];
    
    [self innerAddConfigArrayToDict];
    [allCapKeyAndSupportedConfigValuesDict setObject:configDict forKey:@"hwr.cloud.gesture"];
}

-(void)dealloc{
    if (currentConfigDict) {
        SAFE_ARC_RELEASE(currentConfigDict);
        currentConfigDict = nil;
    }
    if (capKey) {
        SAFE_ARC_RELEASE(capKey);
        capKey = nil;
    }
    SAFE_ARC_SUPER_DEALLOC();
}

@end
