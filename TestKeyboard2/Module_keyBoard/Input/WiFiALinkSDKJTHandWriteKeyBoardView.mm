//
//  WiFiALinkSDKJTHandWriteKeyBoardView.m
//  TestKeyboard2
//
//  Created by autonavi\wang.weiyang on 1/28/15.
//  Copyright (c) 2015 autonavi\wang.weiyang. All rights reserved.
//

#import "WiFiALinkSDKJTHandWriteKeyBoardView.h"
#import "JTHandWritePadView.h"
#import "JTHWRConfig.h"
#import "JTAccountInfo.h"
#import "JTSDKEngieError.h"
#import "hci_hwr.h"

#define BTN_CANDIDATE_MAX_NUMBER    8

@interface WiFiALinkSDKJTHandWriteKeyBoardView ()
{
    /** 手写板 */
    JTHandWritePadView* handWritePadView;
    float               ALWiFiKeyBoardbasisWidth;
    float               ALWiFiKeyBoardbasisHeight;
    float               ALWiFiKeyBoardbasisSpace;
    
    /** 识别出来的存放候选字符的按钮 */
    NSMutableArray*     candidateButtons;
    /** 识别出来的候选字符的列表 */
    NSMutableString*    candidateWords;
    long                currentPageIndex;
    long                totalPageCount;
    
    UIButton*           upBtn;
    UIButton*           downBtn;
    
    /** 用于手写字符的自动输入，在完成手写后一定事件触发，如果期间做了其他操作，则使其失效 */
    NSTimer*            autoInputTimer;
    
    
    
    NSString *hwrCapKey; //所有能力列表
    JTHWRConfig *hwrConfig; //hwr配置
    NSLock *hwrEngineLock; //hwr引擎互斥锁
    BOOL isHwrViewDisappered; //手写界面是否消失了。
}
@end

@implementation WiFiALinkSDKJTHandWriteKeyBoardView

/**
 * 初始化界面及各种参数
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        currentPageIndex = -1;
        totalPageCount = 0;
        
        ALWiFiKeyBoardbasisSpace = 5;
        ALWiFiKeyBoardbasisWidth = frame.size.width / 10;
        ALWiFiKeyBoardbasisHeight = (225 - ALWiFiKeyBoardbasisSpace * 2) / 6.0;
        
        [self initKeyboardLayout];
        
        [self HWInit];
    }
    return self;
}

- (BOOL)HWInit{
    string strAccountInfo;
    bool bRet = GetAccountInfo(@"tk2.bundle/AccountInfo", @"txt", strAccountInfo);
    if(!bRet)
    {
        NSLog(@"Account information not found in AccountInfo.txt");
    }
    
    NSArray *homeDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [homeDir objectAtIndex:0];
    NSString *strConfig = [NSString stringWithFormat:@"%s,logLevel=5,logfilecount=5,logFileSize=1048576,atuoCloudAuth=no",strAccountInfo.c_str()];
    
    NSString *strLogPath = [@"logFilePath = " stringByAppendingString:document];
    NSLog(@"\n\n\n%@\n\n\n",strLogPath);
    NSString *strAuthPath = [@"AuthPath = " stringByAppendingString:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"tk2.bundle"]];
    
    NSString *tempConfig = [strConfig stringByAppendingFormat:@",%@, %@", strLogPath, strAuthPath];
    NSLog(@"初始化配置:%@",tempConfig);
    HCI_ERR_CODE eError = hci_init([tempConfig UTF8String]);
    if (eError != HCI_ERR_NONE) {
        UIAlertView *alertWarnig = [[UIAlertView alloc] initWithTitle:@"提示" message:@"初始化灵云系统失败,程序将退出!\n请检测您在AccountInfo.txt里填写的灵云sdk授权账号是否正确。"  delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertWarnig show];
        return NO;
    }
    
    //判断能力是否可用，不可用则联网获取授权
    const char *pszCapkey[1] = {"hwr"};
    for (int index = 0; index < 1; index++) {
        CAPABILITY_LIST sCapabilityList;
        eError = hci_get_capability_list(pszCapkey[index], &sCapabilityList);
        if (eError == HCI_ERR_NONE) {
//            if (sCapabilityList.uiItemCount == 0)
//            {
//                eError = hci_check_auth();
//                if (eError != HCI_ERR_NONE)
//                {
//                    hci_free_capability_list(&sCapabilityList);
//                    UIAlertView *alertWarnig = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取授权失败,程序将退出!请确认网络连接打开后重试"  delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                    [alertWarnig show];
//                    return NO;
//                }
//                else
//                {
//                    hci_free_capability_list(&sCapabilityList);
//                    break;
//                }
//            }
            
            hci_free_capability_list(&sCapabilityList);
        }
    }
    
    
    //初始化互斥量
    hwrEngineLock = [[NSLock alloc] init];
    
    [self getCapkeyFromFile];
    hwrConfig = [[JTHWRConfig alloc] initWithString:hwrCapKey];
    isHwrViewDisappered = NO;
    return YES;
}

- (void) getCapkeyFromFile
{
    string capKey;
    bool bRet = GetCapKey(@"tk2.bundle/AccountInfo", @"txt", capKey);
    if (!bRet) {
        NSLog(@"capKey not found in AccountInfo.txt");
    }
    hwrCapKey = [NSString stringWithFormat:@"%s",capKey.c_str()];
}

/**
 * 键盘面板初始化类，填充各种按钮和控件，定义控件的位置
 */
- (void)initKeyboardLayout
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    CGFloat x, y, w, h;
    x = ALWiFiKeyBoardbasisSpace;
    y = ALWiFiKeyBoardbasisSpace;
    w = ALWiFiKeyBoardbasisWidth;
    h = ALWiFiKeyBoardbasisHeight;
    
    handWritePadView = [[JTHandWritePadView alloc] initWithFrame:CGRectMake(x, y, w * 6 - ALWiFiKeyBoardbasisSpace * 2, h * 6)];
    [handWritePadView setDelegate:self];
    handWritePadView.layer.cornerRadius = 6;//设置圆角的弧度
    handWritePadView.layer.masksToBounds = YES;
    [self addSubview:handWritePadView];
    
    x = w * 9.0;
    upBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"UP" frame:CGRectMake(x, y, w, h * 1.5) enable:YES target:self action:@selector(upButtonPressed:)];
    [self addSubview:upBtn];
    y += h * 1.5;
    downBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"DOWN" frame:CGRectMake(x, y, w, h * 1.5) enable:YES target:self action:@selector(downButtonPressed:)];
    [self addSubview:downBtn];
    y += h * 1.5;
    deleteBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"DELE" frame:CGRectMake(x, y, w, h) enable:YES target:self action:@selector(deleteButtonPressed:)];
    [self addSubview:deleteBtn];
    x = w * 6.0;
    y += h * 1;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@" " frame:CGRectMake(x, y, w * 1.34, h) enable:YES target:self action:@selector(charButtonPressed:)]];
    x += w * 1.34;
    UIButton* moveLeftBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"LEFTMOBILE" frame:CGRectMake(x, y, w * 1.33, h) enable:YES target:self action:@selector(moveCursorToLeftButtonPressed:)];
    [self addSubview:moveLeftBtn];
    x += w * 1.33;
    UIButton* moveRightBtn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"RIGHTMOBILE" frame:CGRectMake(x, y, w * 1.33, h) enable:YES target:self action:@selector(moveCursorToRightButtonPressed:)];
    [self addSubview:moveRightBtn];
    x = w * 6.0;
    y += h;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"?#123" frame:CGRectMake(x, y, w * 1.34, h) enable:YES target:self action:@selector(changeNumberKeyboardButtonPressed:)]];
    x += w * 1.34;
    [self addSubview:[WiFiALinkSDKkeyBoardView buttonWithTitle:@"手写" frame:CGRectMake(x, y, w * 2.66, h) enable:YES target:self action:@selector(selectKeyboardButtonPressed:)]];
    
    //填充待选手写字符的按钮
    x = w * 6.0;
    y = ALWiFiKeyBoardbasisSpace;
    candidateButtons = [[NSMutableArray alloc] init];
    for (int i = 0; i < BTN_CANDIDATE_MAX_NUMBER; i++)
    {
        UIButton* btn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"" frame:CGRectMake(x, y, w * 1.5, h) enable:YES target:self action:@selector(candidateWordBtnPressed:)];
        [candidateButtons addObject:btn];
        [self addSubview:btn];
        x += w * 1.5;
        i++;
        btn = [WiFiALinkSDKkeyBoardView buttonWithTitle:@"" frame:CGRectMake(x, y, w * 1.5, h) enable:YES target:self action:@selector(candidateWordBtnPressed:)];
        [candidateButtons addObject:btn];
        [self addSubview:btn];
        y += h;
        x = w * 6.0;
    }
}

/**
 * 用于在输入结束或者取消的时候对输入的整个状态进行清理
 */
- (void)clearInputStatus
{
    if (autoInputTimer != nil)
    {
        [autoInputTimer invalidate];
        autoInputTimer = nil;
    }
    
    [handWritePadView clearHandWritePad];
    if (candidateWords != nil)
    {
        SAFE_ARC_RELEASE(candidateWords);
        candidateWords = nil;
    }
    
    for (int nIndex = 0; nIndex < BTN_CANDIDATE_MAX_NUMBER; nIndex++)
    {
        [candidateButtons[nIndex] setTitle:@"" forState:UIControlStateNormal];
        [candidateButtons[nIndex] setEnabled:NO];
    }
    [upBtn setEnabled:NO];
    [downBtn setEnabled:NO];
}

/**
 * 向上翻页
 */
- (IBAction)upButtonPressed:(id)sender{
    if (autoInputTimer != nil)
    {
        [autoInputTimer invalidate];
        autoInputTimer = nil;
    }
    if (currentPageIndex == 0)
    {
        return;
    }
    currentPageIndex--;
    [self setCandidateWordPage:currentPageIndex];
}

/**
 * 向下翻页
 */
- (IBAction)downButtonPressed:(id)sender{
    if (autoInputTimer != nil)
    {
        [autoInputTimer invalidate];
        autoInputTimer = nil;
    }
    if (currentPageIndex + 1 == totalPageCount)
    {
        return;
    }
    currentPageIndex++;
    [self setCandidateWordPage:currentPageIndex];
}

/**
 * 更新为要翻到的页码
 */
- (void)setCandidateWordPage:(long)pageNo
{
    //先计算当前的页数
    long nLen = [candidateWords length];
    NSLog(@"str:%@, length = %ld",candidateWords, nLen);
    currentPageIndex = 0;
    if (nLen % BTN_CANDIDATE_MAX_NUMBER == 0)
    {
        totalPageCount = nLen / BTN_CANDIDATE_MAX_NUMBER;
    }
    else
    {
        totalPageCount = nLen / BTN_CANDIDATE_MAX_NUMBER + 1;
    }
    
    //将待选字符填入按钮，如果不够一页，则将剩余按钮置空
    if (pageNo < 0 || pageNo > totalPageCount - 1)
    {
        return;
    }
    currentPageIndex = pageNo;
    for (int nIndex = 0; nIndex < BTN_CANDIDATE_MAX_NUMBER; nIndex++)
    {
        long nTemp = (nIndex + BTN_CANDIDATE_MAX_NUMBER * currentPageIndex);
        if (nTemp < nLen)
        {
            NSRange range = NSMakeRange(nTemp,1);
            [candidateButtons[nIndex] setEnabled:YES];
            [candidateButtons[nIndex] setTitle:[candidateWords substringWithRange:range] forState:UIControlStateNormal];
        }
        else
        {
            [candidateButtons[nIndex] setTitle:@"" forState:UIControlStateNormal];
            [candidateButtons[nIndex] setEnabled:NO];
        }
    }
    [upBtn setEnabled:(currentPageIndex == 0 ? NO : YES)];
    [downBtn setEnabled:(currentPageIndex == totalPageCount - 1 ? NO : YES)];
}

/**
 * 将候选字符的第一个字填入文本框
 */
- (void)autoInput
{
    UIButton* firstCandidateWordBtn = [candidateButtons objectAtIndex:0];
    [self candidateWordBtnPressed:firstCandidateWordBtn];
}

/**
 * 选择指定的字符按钮，在本面板其实就是空格，如果当前有候选字符，则将第一个字符填入文本框，否则填入空格
 */
- (IBAction)charButtonPressed:(id)sender
{
    UIButton* btn = (UIButton *)sender;
    NSString* title = btn.currentTitle;
    if (title != nil && [title isEqualToString:@" "])
    {
        if (candidateWords.length > 0)
        {
            UIButton* firstCandidateWordBtn = [candidateButtons objectAtIndex:0];
            [self candidateWordBtnPressed:firstCandidateWordBtn];
        }
        else
        {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(insertText:)])
            {
                [self.delegate insertText:title];
            }
        }
    }
    [self renewButtonStatus];
}

/**
 * 如果当前有笔迹，则先清理输入面板，否则删除字符
 */
- (IBAction)deleteButtonPressed:(id)sender
{
    if (handWritePadView.hasMarks)
    {
        [self clearInputStatus];
    }
    else
    {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(deleteBackward)])
        {
            [self.delegate deleteBackward];
        }
    }
    [self renewButtonStatus];
}

/**
 * 选中候选字符后，将选中的字填入，并清理输入面板
 */
- (IBAction)candidateWordBtnPressed:(id)sender
{
    UIButton* btn = (UIButton *)sender;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(insertText:)])
    {
        NSString* title = btn.currentTitle;
        [self.delegate insertText:title];
    }
    [self clearInputStatus];
    [self renewButtonStatus];
}

- (void)outKeyboard
{
    //退出前清理面板
    [self clearInputStatus];
    [super outKeyboard];
}

- (void)renewButtonStatus
{
    //如果有笔迹，也可以删除
    if (handWritePadView.hasMarks)
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

- (void)dealloc
{
    if (candidateButtons != nil) {
        SAFE_ARC_RELEASE(candidateButtons);
        candidateButtons = nil;
    }
    if (candidateWords != nil)
    {
        SAFE_ARC_RELEASE(candidateWords);
        candidateWords = nil;
    }
    SAFE_ARC_RELEASE(handWritePadView);
    SAFE_ARC_SUPER_DEALLOC();
}

- (void)drawingView:(JTHandWritePadView *)view willBeginDrawUsingTool:(id<JTDrawingTool>)tool{
    if (autoInputTimer != nil)
    {
        [autoInputTimer invalidate];
        autoInputTimer = nil;
    }
    [self renewButtonStatus];
}


//识别
- (bool) hwrEngineRecog:(NSMutableArray*)pointArray;
{
    [hwrEngineLock lock];
    //初始化
    isHwrViewDisappered = NO;
//    NSString *initParam = [NSString stringWithFormat:@"initCapKeys=%@,dataPath=%@",hwrConfig.capKey, [[NSBundle mainBundle] resourcePath]];
    NSString *initParam = [NSString stringWithFormat:@"initCapKeys=%@,dataPath=%@",hwrConfig.capKey, [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"tk2.bundle"]];
    HCI_ERR_CODE eError = hci_hwr_init([initParam UTF8String]);
    if (eError != HCI_ERR_NONE) {
        NSLog(@"错误:%@", [JTSDKEngieError getErrorInfoByErrorCode:eError]);
        [hwrEngineLock unlock];
        return false;
    }
    
    //开启会话
    int nSessingId = 0;
    NSString *recogParam = [NSString stringWithFormat:@"capkey=%@",hwrConfig.capKey];
    NSString *currentConfig = [hwrConfig getAllCurrentConfig];
    if (currentConfig != nil) {
        NSLog(@"currentConfig:%@",currentConfig);
        recogParam = [NSString stringWithFormat:@"%@,%@",recogParam,currentConfig];
    }
    
    eError = hci_hwr_session_start([recogParam UTF8String], &nSessingId);
    if (eError != HCI_ERR_NONE) {
        hci_hwr_release();
        NSLog(@"错误:%@", [JTSDKEngieError getErrorInfoByErrorCode:eError]);
        [hwrEngineLock unlock];
        return false;
    }
    HWR_RECOG_RESULT sHwrRecogResult;
    sHwrRecogResult.psResultItemList = NULL;
    int nLength = (int)[pointArray count] * 2;
    short *psStrokingData = new short[nLength];
    for (int i = 0; i < [pointArray count]; i++) {
        psStrokingData[i*2] = ((JTHWRWordPoint*)[pointArray objectAtIndex:i]).locationX;
        psStrokingData[i*2+1] = ((JTHWRWordPoint*)[pointArray objectAtIndex:i]).locationY;
    }
    
    const char *pszConfig = NULL;
    if (currentConfig != nil) {
        pszConfig = [currentConfig UTF8String];
    }
    eError = hci_hwr_recog(nSessingId, psStrokingData, nLength*2, pszConfig, &sHwrRecogResult);
    delete[]psStrokingData;
    psStrokingData = NULL;
    if (eError != HCI_ERR_NONE) {
        hci_hwr_session_stop(nSessingId);
        hci_hwr_release();
        if (!isHwrViewDisappered) {
            NSLog(@"错误:%@", [JTSDKEngieError getErrorInfoByErrorCode:eError]);
        }
        [hwrEngineLock unlock];
        return false;
    }
    
    candidateWords = [[NSMutableString alloc] init];
    
    //当前在hwr主界面，就显示结果
    for (int i = 0; i < sHwrRecogResult.uiResultItemCount; i++) {
        NSString *result = nil;
        if ([hwrConfig.capKey rangeOfString:@"gesture"].length > 0) {//笔势识别出来的结果是笔势的序号
            if (sHwrRecogResult.psResultItemList[i].pszResult != NULL) {
                result = [NSString stringWithFormat:@"笔势索引[%d]",sHwrRecogResult.psResultItemList[i].pszResult[0]];
            }
        }else{
            if (sHwrRecogResult.psResultItemList[i].pszResult != NULL) {
                result = [NSString stringWithUTF8String:sHwrRecogResult.psResultItemList[i].pszResult];
            }
        }
        
        if (result) {
            [candidateWords appendString:result];
        }
    }
    
    //更新页面
    [self setCandidateWordPage:0];
    
    hci_hwr_free_recog_result(&sHwrRecogResult);
    hci_hwr_session_stop(nSessingId);
    hci_hwr_release();
    [hwrEngineLock unlock];
    
    [self performSelectorOnMainThread:@selector(activateAutoInputTimer) withObject:nil waitUntilDone:NO];
    
    return true;
}

-(void)activateAutoInputTimer{
    //如果在2.5秒内没有操作，则自动填入文本框，期间任何操作都将取消自动填入
    autoInputTimer = [NSTimer scheduledTimerWithTimeInterval:2.5f target:self selector:@selector(autoInput) userInfo:nil repeats:NO];
}


@end
