//
//  PinyinDecoder.h
//  PinyinDemo
//
//  Created by yang yi on 14-8-3.
//  Copyright (c) 2014年 Autonavi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef  void (^selectCandidate)(long fixedIdx,NSArray* fixRange, NSString *originStr);

@interface PinyinDecoder : NSObject
/**
 * 单例
 */
+ (id)sharedInstance;

/**
 * 拼音识别,如"xiaomen",候选字可能包含"校门"、"小" 、"笑"...
 * return nil 失败，否则将返回识别成功的侯选字列表
 */
- (NSArray*)searchPinYinWithString:(NSString*)pinyinStr;


/**
 * 选择候选字,并反馈剩余部分的候选内容,如"xiaomen",选择了候选字"小",剩余的候选字可能有"门"、"们"...
 * selectCandidate param(已匹配完成的字母下标,已输入的字母信息)
 * return nil 失败，否则将返回识别成功的侯选字列表
 * eg:
 *  __block int fixedValue = 0;         //已匹配的个数
 *  __block NSArray *range = nil;       //匹配的字母下标列表
 *  __block NSString *getInputStr= nil  //当前输入的所有字母信息
 *
 * [[PinyinDecoder sharedInstance] getCandidateListWithIndex:delLetter Result:^(int fixedIdx,NSArray *fixRange,NSString* originStr){
 *      fixedValue =fixedIdx;
 *      range = fixRange;
 *      getInputStr = originStr;
 *      }];
 *
 */
- (NSArray*)getCandidateListWithIndex:(long)index Result:(selectCandidate) param;


/**
 * 删除指定位置的拼音字母后进行搜索并返回候选字,如原输入文本为"xiaomen",删除position:3的字母"o"后,以"xiamen"进行新的搜索
 * position 要删除的字母位置下标[0,strlen("pinyin")-1],bInSpell(默认YES,删除后重新搜索),bClear
 */
- (NSArray*)delSearchAndCandidateWithPosition:(int)position WithSpell:(BOOL)bInSpell WithClear:(BOOL)bClear;

/**
 * 搜索复位,在选择完侯选字或退出拼音输入法时调用
 */
- (BOOL)resetSearch;

@end
