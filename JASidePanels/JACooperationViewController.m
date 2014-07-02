//
//  JACooperationViewController.m
//  JASidePanels
//
//  Created by admin on 14-3-2.
//
//

#import "JACooperationViewController.h"

@interface JACooperationViewController ()
@property (strong, nonatomic)NSNumber *nowloading;
@end

@implementation JACooperationViewController
@synthesize name;
@synthesize phonenumber;
@synthesize textview;
@synthesize submit;
@synthesize email;
@synthesize textback;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"企业合作";
        // Custom initialization
        self.nowloading = [[NSNumber alloc]initWithBool:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [contentView setImage:[UIImage imageNamed:@"background_login.jpg"]];
    [contentView setUserInteractionEnabled:YES];
    self.view = contentView;
    self.phonenumber = [[UITextField alloc]initWithFrame:CGRectMake(35, 180, 250, 35)];
    self.name = [[UITextField alloc]initWithFrame:CGRectMake(35, 90, 250, 35)];
    self.email = [[UITextField alloc]initWithFrame:CGRectMake(35, 135, 250, 35)];
    self.textback = [[UITextField alloc]initWithFrame:CGRectMake(35, 220, 250, 100)];
    self.textview = [[UITextView alloc]initWithFrame:CGRectMake(35, 220, 250, 100)];
    self.name.borderStyle=UITextBorderStyleRoundedRect;
    self.email.borderStyle=UITextBorderStyleRoundedRect;
    self.textback.borderStyle=UITextBorderStyleRoundedRect;
    self.phonenumber.borderStyle=UITextBorderStyleRoundedRect;
    [self.name setPlaceholder:@"姓名"];
    [self.email setPlaceholder:@"Email"];
    [self.textview setBackgroundColor:[UIColor clearColor]];
    [self.textback setPlaceholder:@"内容"];
    [self.textback setEnabled:NO];
    [self.phonenumber setPlaceholder:@"手机号"];
    [self.name addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.email addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.phonenumber addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.textview setDelegate:self];
    [self.textview setFont:[UIFont fontWithName:self.textview.font.fontName size:17]];
    [self.view addSubview:self.name];
    [self.view addSubview:self.email];
    [self.view addSubview:self.textback];
    [self.view addSubview:self.textview];
    [self.view addSubview:self.phonenumber];
    UIImage* buttonImage = [[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:6.0 topCapHeight:0.0];
    self.submit = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-70, 330, 140, 38)];
    [self.submit setTitle:@"提交" forState:UIControlStateNormal];
    [self.submit setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submit addTarget:self action:@selector(submitStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitStart
{
    if (![self.nowloading boolValue]) {
        if (![[self.name text] isEqualToString:@""] && ![[self.phonenumber text] isEqualToString:@""] && ![[self.email text] isEqualToString:@""] && ![[self.textview text] isEqualToString:@""]) {
            self.nowloading = [NSNumber numberWithBool:YES];
            [self showProgressDialog];
            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"]  parameters:@{@"action":@"SendCompany",@"name":[self.name text],@"email":[self.email text],@"mobile":[self.phonenumber text],@"content":[self.textview text]} error:nil];
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            op.responseSerializer = [AFJSONResponseSerializer serializer];
            op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                [HUD removeFromSuperview];
                if ([[responseObject objectForKey:@"result"] isEqualToString:@"ok"]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提交成功" message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                    [alert show];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"服务器出错" message:[responseObject objectForKey:@"result"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                    [alert show];
                }
                self.nowloading = [NSNumber numberWithBool:NO];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                self.nowloading = [NSNumber numberWithBool:NO];
            }];
            [[NSOperationQueue mainQueue] addOperation:op];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请将信息填写完整" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alert show];
        }
    }
    
}

#pragma mark removekeyboard

- (void)removeKeyboard
{
    [self resignFirstResponder];
}

#pragma mark UITextView delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.view setFrame:CGRectMake(0, -70, self.view.frame.size.width, self.view.frame.size.height)];
    [self.textback setPlaceholder:@""];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.view setFrame:self.view.window.bounds];
    if ([textView.text isEqualToString:@""]) {
        [self.textback setPlaceholder:@"内容"];
    }
    else
    {
        [self.textback setPlaceholder:@""];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self.textback setPlaceholder:@""];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)showProgressDialog {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    
    //设置对话框文字
    HUD.labelText = @"发送中";
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(5);
    } completionBlock:^{
        //操作执行完后取消对话框
        [HUD removeFromSuperview];
        HUD = nil;
    }];
}
@end
