//
//  ViewController.m
//  TestKeyboard2
//
//  Created by autonavi\wang.weiyang on 14-9-15.
//  Copyright (c) 2014年 autonavi\wang.weiyang. All rights reserved.
//

#import "ViewController.h"
#import "ARCMacros.h"
#import "WiFiALinkSDKkeyBoard.h"
#import "UITextField+Utility.h"
#import "UITextView+Utility.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (retain, nonatomic) IBOutlet UISearchBar* sb1;
@property (retain, nonatomic) IBOutlet UITextField* tf1;
@property (retain, nonatomic) IBOutlet UITextField* tf2;
@property (retain, nonatomic) IBOutlet UITextView* tv1;

-(IBAction)btnPressed:(id)sender;
-(IBAction)resignbtnPressed:(id)sender;
-(IBAction)tfValueChangedPressed:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tf1 becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnPressed:(id)sender{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    ViewController* viewController = [[ViewController alloc] init];
    viewController.usertag = 1;
    [app.nav pushViewController:viewController animated:YES];
}

-(void)moveLeft{
    [self.tv1 moveCursorToLeft];
}

-(IBAction)resignbtnPressed:(id)sender{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app.nav popViewControllerAnimated:YES];
//    [self.tf1 resignFirstResponder];
//    [self.tf2 resignFirstResponder];
//    [self.tv1 resignFirstResponder];
//    [self.sb1 resignFirstResponder];
}

-(void)dealloc{
    SAFE_ARC_RELEASE(self.tf1);
    SAFE_ARC_RELEASE(self.tf2);
    SAFE_ARC_RELEASE(self.tv1);
    SAFE_ARC_RELEASE(self.sb1);
    SAFE_ARC_SUPER_DEALLOC();
}

-(IBAction)tfValueChangedPressed:(id)sender{
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}



@end
