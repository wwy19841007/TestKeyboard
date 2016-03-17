//
//  WiFiALinkSDKPinyinKeyBoardView.m
//  AutoNavi
//
//  2014-9-25 Wang Weiyang
//
//

#import "WiFiALinkSDKPinyinKeyBoardView.h"
#import "PinyinDecoder.h"

/**
 * 最大显示的候选字符数量
 */
#define MAXCANDIDATEWORDPAGECOUNT 16

/**
 * 选中英文字符与汉字的键值对，如 pinyin-拼音
 */
@interface PinyinKeyValue : NSObject

@property (retain, nonatomic) NSString* code;
@property (retain, nonatomic) NSString* name;

@end

@implementation PinyinKeyValue

- (void)dealloc
{
    SAFE_ARC_RELEASE(self.code);
    SAFE_ARC_RELEASE(self.name);
    SAFE_ARC_SUPER_DEALLOC();
}

@end

@interface WiFiALinkSDKPinyinKeyBoardView ()
{
    float               ALWiFiKeyBoardbasisWidth;
    float               ALWiFiKeyBoardbasisHeight;
    
    /** 显示临时输入的字符串 */
    UILabel*            pinyinLbl;
    /** 临时选中的PinyinKeyValue数组 */
    NSMutableArray*     choosedWords;
    /** 还没转成汉字的英文字符 */
    NSMutableString*    pinyinStr;
    /** 存放待选汉字的View */
    UIView*             candidateWordContainerVw;
    /** 根据备选词构成的翻页数据，每页总字数大小不超过MAXCANDIDATEWORDPAGECOUNT */
    NSMutableArray*     candidateWordPages;
    /** 所有备选词 */
    NSArray*            candidateWords;
    long                currentPageIndex;
    long                totalPageCount;
    UIButton*           nextPageBtn;
    UIButton*           prePageBtn;
}
@end

@implementation WiFiALinkSDKPinyinKeyBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        currentPageIndex = -1;
        totalPageCount = 0;
        
        ALWiFiKeyBoardbasisWidth = frame.size.width/10;
        ALWiFiKeyBoardbasisHeight = 65/2.0;
        
        choosedWords = [[NSMutableArray alloc] init];
        pinyinStr = [[NSMutableString alloc] init];
        candidateWordPages = [[NSMutableArray alloc] init];
        
        [self initKeyboardLayout];
    }
    return self;
}

/**
 * 键盘面板初始化类，填充各种按钮和控件，定义控件的位置
 */
- (void)initKeyboardLayout
{
    CGFloat x, y, w, h;
    y = self.frame.size.height - 187;
    w = ALWiFiKeyBoardbasisWidth;
    h = ALWiFiKeyBoardbasisHeight;
    
    pinyinLbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 0, 24.5)];
    [pinyinLbl setTextColor:[UIColor whiteColor]];
    [pinyinLbl setBackgroundColor:[UIColor grayColor]];
    pinyinLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    [pinyinLbl setNumberOfLines:1];
    [pinyinLbl setLineBreakMode:NSLineBreakByTruncatingTail];
    [self addSubview:pinyinLbl];
    x = 0;
    y += 24.5;
    prePageBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"<" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(previousPageBtnPressed:)];
    [self addSubview:prePageBtn];
    nextPageBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@">" frame:CGRectMake(x + 9 * w, y, w, h) enable:YES target:self action:@selector(nextPageBtnPressed:)];
    [self addSubview:nextPageBtn];
    
    UIImage* backgroundImage = [UIImage imageNamed:@"ALbtn_keyBoard.png"];
    UIImage* stretchableBackgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(backgroundImage.size.height / 2.0, backgroundImage.size.width / 2.0, backgroundImage.size.height / 2.0 + 1, backgroundImage.size.width / 2.0 + 1)];
    UIImageView* candidateWordContainerBackgroundIv = [[UIImageView alloc] initWithImage:stretchableBackgroundImage];
    [candidateWordContainerBackgroundIv setFrame:CGRectMake(x + w, y, w * 8, h)];
    [self addSubview:candidateWordContainerBackgroundIv];
    SAFE_ARC_RELEASE(candidateWordContainerBackgroundIv);
    
    candidateWordContainerVw = [[UIView alloc] initWithFrame:CGRectMake(x + w, y, w * 8, h)];
    [self addSubview:candidateWordContainerVw];
    x = 0;
    y += h;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"q" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"w" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"e" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"r" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"t" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"y" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"u" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"i" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"o" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"p" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x = 0;
    y += h;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"a" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"s" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"d" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"f" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"g" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"h" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"j" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"k" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"l" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    deleteBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"DELE" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(deleteButtonPressed:)];
    [self addSubview:deleteBtn];
    x = 0;
    y += h;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"z" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"x" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"c" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"v" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"b" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"n" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"m" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w;
    UIButton* moveLeftBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"LEFTMOBILE" frame:CGRectMake(x, y, w * 1.5, h) enable:YES target:self action:@selector(moveCursorToLeftButtonPressed:)];
    moveLeftBtn.tag = 101;
    [self addSubview:moveLeftBtn];
    x += w * 1.5;
    UIButton* moveRightBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"RIGHTMOBILE" frame:CGRectMake(x, y, w * 1.5, h) enable:YES target:self action:@selector(moveCursorToRightButtonPressed:)];
    moveRightBtn.tag = 102;
    [self addSubview:moveRightBtn];
    x = 0;
    y += h;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@" " frame:CGRectMake(x, y, w * 5.0, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w * 5.0;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"?#123" frame:CGRectMake(x, y, w * 2.0, h) enable:YES target:self action:@selector(changeNumberKeyboardButtonPressed:)]];
    x += w * 2.0;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"全拼..." frame:CGRectMake(x, y, w * 3.0, h) enable:YES target:self action:@selector(selectKeyboardButtonPressed:)]];
}

/**
 * 向上翻页
 */
- (IBAction)previousPageBtnPressed:(id)sender
{
    if (currentPageIndex <= 0)
    {
        return;
    }
    currentPageIndex--;
    [self setPinyinWordPage:currentPageIndex];
}

/**
 * 向下翻页
 */
- (IBAction)nextPageBtnPressed:(id)sender
{
    if (currentPageIndex + 1 >= totalPageCount)
    {
        return;
    }
    currentPageIndex++;
    [self setPinyinWordPage:currentPageIndex];
}

/**
 * 更新为要翻到的页码
 */
- (void)setPinyinWordPage:(long)pageNo
{
    //更新页面内容
    if (pageNo < 0 || pageNo > totalPageCount - 1)
    {
        return;
    }
    for (UIView* v in candidateWordContainerVw.subviews)
    {
        [v removeFromSuperview];
    }
    currentPageIndex = pageNo;
    NSMutableArray* candidateWordPage = [candidateWordPages objectAtIndex:currentPageIndex];
    CGFloat x, y, w, h;
    x = 0;
    y = 0;
    w = candidateWordContainerVw.frame.size.width / MAXCANDIDATEWORDPAGECOUNT;
    h = candidateWordContainerVw.frame.size.height;
    for (int i = 0; i < candidateWordPage.count; i++)
    {
        int wordIndex = [[candidateWordPage objectAtIndex:i] intValue];
        NSString* candidateWord = [candidateWords objectAtIndex:wordIndex];
        UIButton* candidateBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:candidateWord frame:CGRectMake(x, y, w * candidateWord.length, h) enable:YES target:self action:@selector(pinyinWordBtnPressed:)];
        [candidateBtn setTag:wordIndex];
        [candidateWordContainerVw addSubview:candidateBtn];
        x += w * candidateWord.length;
    }
    [prePageBtn setEnabled:(currentPageIndex == 0 ? NO : YES)];
    [nextPageBtn setEnabled:(currentPageIndex == totalPageCount - 1 ? NO : YES)];
}

/**
 * 重新获取用于显示的待选词组，通常用于输入的内容变更的情况下
 */
- (void)refreshPinyinCandidate
{
    [[PinyinDecoder sharedInstance] resetSearch];
    NSArray* candidateArray = [[PinyinDecoder sharedInstance] searchPinYinWithString:pinyinStr];
    [self refreshPinyinCandidateWithArray:candidateArray];
}

/** 
 * 重新获取用于显示的待选词组，通常用于输入的内容变更的情况下
 */
- (void)refreshPinyinCandidateWithArray:(NSArray *)candidateArray
{
    currentPageIndex = -1;
    totalPageCount = 0;
    [candidateWordPages removeAllObjects];
    candidateWords = nil;
    for (UIView* v in candidateWordContainerVw.subviews)
    {
        [v removeFromSuperview];
    }
    
    int tmpCurrentPageWords = 0;
    
    candidateWords = candidateArray;
    //根据得到的候选词组产生一个数组，每个元素为一页，该页的总字数不超过MAXCANDIDATEWORDPAGECOUNT，包含了这页中要显示的词组
    if (candidateWords && candidateWords.count > 0)
    {
        NSMutableArray* tmpWordIndexPage = [[NSMutableArray alloc] init];
        [candidateWordPages addObject:tmpWordIndexPage];
        for (int i = 0; i < candidateWords.count; i++)
        {
            NSString* word = [candidateWords objectAtIndex:i];
            if (tmpCurrentPageWords + word.length > MAXCANDIDATEWORDPAGECOUNT)
            {
                if (tmpCurrentPageWords == 0)
                {
                    [tmpWordIndexPage addObject:[NSNumber numberWithInt:i]];
                    if (i != candidateWords.count - 1)
                    {
                        SAFE_ARC_RELEASE(tmpWordIndexPage);
                        tmpWordIndexPage = [[NSMutableArray alloc] init];
                        [candidateWordPages addObject:tmpWordIndexPage];
                    }
                }
                else
                {
                    tmpCurrentPageWords = 0;
                    SAFE_ARC_RELEASE(tmpWordIndexPage);
                    tmpWordIndexPage = [[NSMutableArray alloc] init];
                    [candidateWordPages addObject:tmpWordIndexPage];
                    [tmpWordIndexPage addObject:[NSNumber numberWithInt:i]];
                    tmpCurrentPageWords += word.length;
                }
            }
            else if (tmpCurrentPageWords + word.length == MAXCANDIDATEWORDPAGECOUNT)
            {
                tmpCurrentPageWords = 0;
                [tmpWordIndexPage addObject:[NSNumber numberWithInt:i]];
                if (i != candidateWords.count - 1)
                {
                    SAFE_ARC_RELEASE(tmpWordIndexPage);
                    tmpWordIndexPage = [[NSMutableArray alloc] init];
                    [candidateWordPages addObject:tmpWordIndexPage];
                }
            }
            else
            {
                [tmpWordIndexPage addObject:[NSNumber numberWithInt:i]];
                tmpCurrentPageWords += word.length;
            }
        }
        totalPageCount = candidateWordPages.count;
        
        //更新页面内容
        [self setPinyinWordPage:0];
        
        SAFE_ARC_RELEASE(tmpWordIndexPage);
    }
}

/**
 * 刷新录入标签框
 */
- (void)refreshPinyinLbl
{
    //pinyinLbl的构成包含了已经选为中文的字符和还未选的英文
    NSMutableString* result = [[NSMutableString alloc] init];
    for (PinyinKeyValue* pair in choosedWords)
    {
        [result appendString:pair.name];
    }
    [result appendString:pinyinStr];
    [pinyinLbl setText:result];
    CGSize size = [pinyinLbl sizeThatFits:pinyinLbl.frame.size];
    if (size.width > self.frame.size.width)
    {
        [pinyinLbl setFrame:CGRectMake(pinyinLbl.frame.origin.x, pinyinLbl.frame.origin.y, self.frame.size.width, pinyinLbl.frame.size.height)];
    }
    else
    {
        [pinyinLbl sizeToFit];
    }
    [nextPageBtn setEnabled:NO];
    [prePageBtn setEnabled:NO];
    SAFE_ARC_RELEASE(result);
}

/**
 * 用于在输入结束或者取消的时候对输入的整个状态进行清理
 */
- (void)clearInputStatus
{
    [pinyinLbl setText:@""];
    [pinyinLbl sizeToFit];
    for (UIView* v in candidateWordContainerVw.subviews)
    {
        [v removeFromSuperview];
    }
    [choosedWords removeAllObjects];
    [pinyinStr setString:@""];
    [candidateWordPages removeAllObjects];
    currentPageIndex = -1;
    totalPageCount = 0;
    candidateWords = nil;
}

/**
 * 待选中文按钮按下
 * 按下后，如果没有备选字了，则将中文全部输入到文本框
 * 如果还有备选字，则将剩下的英文重新获得备选字
 */
- (IBAction)pinyinWordBtnPressed:(id)sender
{
    UIButton* btn = (UIButton *)sender;
    NSString* title = btn.currentTitle;
    [[PinyinDecoder sharedInstance] getCandidateListWithIndex:btn.tag Result:^(long fixedIdx, NSArray *fixRange, NSString* originStr)
    {
        
        NSMutableString *a = [NSMutableString  stringWithFormat:@"%@",originStr];
        if (fixedIdx == [fixRange count])
        {
            [a deleteCharactersInRange:NSMakeRange(0, [a length])];
            NSMutableString* result = [[NSMutableString alloc] init];
            for (PinyinKeyValue* pair in choosedWords)
            {
                [result appendString:pair.name];
            }
            [result appendString:title];
            [self clearInputStatus];
            
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(insertText:)])
            {
                [self.delegate insertText:result];
            }
            SAFE_ARC_RELEASE(result);
        }
        else
        {
            PinyinKeyValue* pair = [[PinyinKeyValue alloc] init];
            [pair setCode:[a substringWithRange:NSMakeRange(0, [[fixRange objectAtIndex:fixedIdx] intValue])]];
            [pair setName:title];
            [choosedWords addObject:pair];
            [a deleteCharactersInRange:NSMakeRange(0, [[fixRange objectAtIndex:fixedIdx] intValue])];
            [pinyinStr setString:a];
            
            SAFE_ARC_RELEASE(pair);
            
            [self refreshPinyinLbl];
        }
    }];
    if (pinyinStr.length > 0)
    {
        [self refreshPinyinCandidate];
    }
    [self renewButtonStatus];
}

/**
 * 字符按钮按下
 * 如果是空格，则看当前是否有备选字，如果有，则将第一个备选字填入文本框，否则填入空格即可
 * 如果是普通字符，则搜索备选字
 */
- (IBAction)charButtonPressed:(id)sender
{
    UIButton* btn = (UIButton *)sender;
    NSString* title = btn.currentTitle;
    if (title != nil && [title isEqualToString:@" "])
    {
        if (pinyinStr.length > 0)
        {
            NSMutableString* result = [[NSMutableString alloc] init];
            for (PinyinKeyValue* pair in choosedWords)
            {
                [result appendString:pair.name];
            }
            [result appendString:[candidateWords objectAtIndex:[[[candidateWordPages objectAtIndex:currentPageIndex] objectAtIndex:0] intValue]]];
            //清理键盘
            [self clearInputStatus];
            
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(insertText:)])
            {
                [self.delegate insertText:result];
            }
            
            SAFE_ARC_RELEASE(result);
        }
        else
        {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(insertText:)])
            {
                [self.delegate insertText:title];
            }
        }
    }
    else
    {
        [pinyinStr appendString:title];
        
        //更新pinyinLbl
        [self refreshPinyinLbl];
        
        //更新candidateWordPages
        [self refreshPinyinCandidate];
    }
    [self renewButtonStatus];
}

/**
 * 删除按钮按下
 * 如果没有备选字，删除文本框中内容
 * 如果有备选字，但没有选择中文，则删除最后一个英文字幕
 * 如果有备选字，并已选择中文，则将最后一个中文词组转为英文
 */
- (IBAction)deleteButtonPressed:(id)sender
{
    if (pinyinStr.length == 0)
    {
        //未输入内容
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(deleteBackward)])
        {
            [self.delegate deleteBackward];
        }
    }
    else
    {
        if (choosedWords.count == 0)
        {
            //未选择内容
            
            if (pinyinStr.length == 1)
            {
                //只剩一个字符
                [self clearInputStatus];
            }
            else
            {
                [pinyinStr deleteCharactersInRange:NSMakeRange(pinyinStr.length - 1, 1)];
                
                //更新pinyinLbl
                [self refreshPinyinLbl];
                
                //更新candidateWordPages
                [self refreshPinyinCandidate];
            }
        }
        else
        {
            //已选择内容，但还没有选完
            PinyinKeyValue* pair = [choosedWords objectAtIndex:(choosedWords.count - 1)];
            [pinyinStr insertString:pair.code atIndex:0];
            [choosedWords removeObject:pair];
            
            //更新pinyinLbl
            [self refreshPinyinLbl];
            
            //更新candidateWordPages
            [self refreshPinyinCandidate];
        }
    }
    [self renewButtonStatus];
}

- (void)renewButtonStatus
{
    //如果有输入备选英文，也可以删除
    if (pinyinStr.length > 0)
    {
        [deleteBtn setEnabled:YES];
    }
    else
    {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(hasText)])
        {
            [deleteBtn setEnabled:[self.delegate hasText]];
        }
    }
}

- (void)outKeyboard{
    //如果切换键盘的时候，还有输入内容，则将输入标签中的字符显示到文本框中
    if (pinyinLbl.text.length > 0) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(insertText:)])
        {
            [self.delegate insertText:pinyinLbl.text];
        }
    }
    [self clearInputStatus];
    [super outKeyboard];
}

- (void)dealloc
{
    SAFE_ARC_RELEASE(candidateWordContainerVw);
    SAFE_ARC_RELEASE(pinyinLbl);
    SAFE_ARC_RELEASE(choosedWords);
    SAFE_ARC_RELEASE(pinyinStr);
    SAFE_ARC_RELEASE(candidateWordPages);
    SAFE_ARC_SUPER_DEALLOC();
}

@end
