//
//  JTHWRConfig.h
//  HciCloud51Demo
//
//  Created by jietong jietong on 13-3-25.
//  Copyright (c) 2013年 jietong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTHWRConfig : NSObject
{
    id subLangArray; //全部语种配置
    id recogRange; //全部识别范围配置
    id openSlant; //全部倾斜矫正配置
    id dispCode; //全部简繁转换配置
    id fullHalf; //全部全角半角配置
    id splitMode; //全部书写模式配置
    id wordMode; //全部英文大小写配置
    id domain; //全部领域
    
    NSMutableDictionary *configNameAndSupportedValuesDict; //当前capkey支持的全部配置项及具体配置的键值对
    NSMutableDictionary *allCapKeyAndSupportedConfigValuesDict; //全部capkey支持的配置项及具体配置的键值对
    NSMutableDictionary *configDict;
    
    NSMutableDictionary *currentConfigDict; //当前的配置
}

@property (copy,nonatomic) NSString *capKey;
@property (copy,nonatomic) NSString *currentConfigSubLang; //当前语种配置
@property (copy,nonatomic) NSString *currentConfigRecogRange; //当前识别范围配置
@property (copy,nonatomic) NSString *currentConfigOpenSlant; //当前倾斜矫正配置
@property (copy,nonatomic) NSString *currentConfigDispCode; //当前简繁转换配置
@property (copy,nonatomic) NSString *currentConfigFullHalf; //当前全角半角配置
@property (copy,nonatomic) NSString *currentConfigSplitMode; //当前书写模式配置
@property (copy,nonatomic) NSString *currentConfigWordMode; //当前英文大小写配置

- (id)initWithString:(NSString*)capKeyParam;

//设置当前活跃的capkey
- (void) setCurrentCapKey:(NSString*)capkeyParam;

//获取全部当前配置
- (NSString*) getAllCurrentConfig;

//通过配置项获取当前配置值
- (NSString*) getCurrentConfigValueByName:(NSString*)configName;

//通过配置项设置当前配置值
- (void) setCurrentConfigValue:(NSString*)configValue ByName:(NSString*)configName;

//删除某个识别范围
- (void) removeCurrentConfigRecogRange:(NSString*)rangeValue;

//通过配置项名称获取配置项所有可取值的列表
- (id) getConfigDetailArrayByConfigName:(NSString*)configName;

//通过配置项名称获取当前被选择的配置项所有可取值的列表
- (id) getCurrentConfigDetailArrayByConfigName:(NSString *)configName;

//获取默认配置
- (void) innerGetDefaultConfig;

//创建所有的capkey及其支持的配置
- (void) innerMakeAllCapkeyConfigDict;

//获取当前capkey配置项的键值对
- (void) innerGetCurrentCapkeyAndSupportedValuesDict;


- (void) innerAddConfigArrayToDict;
- (void) innerCreateDefaultDict;
- (void) innerCreateLocalLetterDict;
- (void) innerCreateLocalLetterGbDict;
- (void) innerCreateLocalLetterBig5Dict;
- (void) innerCreateLocalLetterHkDict;
- (void) innerCreateLocalLetterJapaneseDict;
- (void) innerCreateLocalLetterKoreanDict;
- (void) innerCreateLocalLetterThaiDict;
- (void) innerCreateLocalLetterHindiDict;
- (void) innerCreateLocalLetterGreekDict;
- (void) innerCreateLocalLetterLatinDict;
- (void) innerCreateLocalLetterCyrillicDict;
- (void) innerCreateLocalLetterArabicDict;
- (void) innerCreateCloudLetterDict;
- (void) innerCreateCloudLetterJapaneseDict;
- (void) innerCreateCloudLetterKoreanDict;
- (void) innerCreateCloudLetterThaiDict;
- (void) innerCreateCloudLetterHindiDict;
- (void) innerCreateCloudLetterGreekDict;
- (void) innerCreateCloudLetterLatinDict;
- (void) innerCreateCloudLetterCyrillicDict;
- (void) innerCreateCloudLetterArabicDict;
- (void) innerCreateLocalFreewriteDict;
- (void) innerCreateLocalFreewriteEnglishDict;
- (void) innerCreateLocalFreewriteJapaneseDict;
- (void) innerCreateLocalFreewriteKoreanDict;
- (void) innerCreateLocalFreestylusDict;
- (void) innerCreateLocalFreestylusEnglishDict;
- (void) innerCreateLocalFreestylusJapaneseDict;
- (void) innerCreateLocalFreestylusKoreanDict;
- (void) innerCreateCloudFreewriteDict;
- (void) innerCreateCloudFreewriteEnglishDict;
- (void) innerCreateCloudFreewriteJapaneseDict;
- (void) innerCreateCloudFreewriteKoreanDict;
- (void) innerCreateLocalGestureDict;
- (void) innerCreateCloudGestureDict;
@end
