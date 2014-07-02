//
//  JARegisterViewController.m
//  JASidePanels
//
//  Created by admin on 14-3-2.
//
//

#import "JARegisterViewController.h"

@interface JARegisterViewController ()
@property (strong, nonatomic)NSNumber *nowloading;
@property (strong, nonatomic)NSString *phoneCode;
@property (strong, nonatomic)NSTimer *connectionTimer;
@property (strong, nonatomic)NSNumber *canSendMessage;
@end

@implementation JARegisterViewController
@synthesize username;
@synthesize password;
@synthesize repeatpassword;
@synthesize phonenumber;
@synthesize registerButton;
@synthesize yanzhengButton;
@synthesize idCode;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"注册";
        self.nowloading = [[NSNumber alloc]initWithBool:NO];
        self.canSendMessage = [[NSNumber alloc]initWithInt:0];
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.username.frame = CGRectMake(35, 20, 250, 35);
    self.password.frame = CGRectMake(35, 60, 250, 35);
    self.repeatpassword.frame = CGRectMake(35, 100, 250, 35);
    self.phonenumber.frame = CGRectMake(35, 140, 250, 35);
    self.idCode.frame = CGRectMake(35, 180, 250, 35);
    self.recommender.frame = CGRectMake(35, 180, 250, 35);
    self.yanzhengButton.frame = CGRectMake(35, 270, 120, 35);
    self.registerButton.frame = CGRectMake(35, 240, 250, 35);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [contentView setImage:[UIImage imageNamed:@"background_login.jpg"]];
    [contentView setUserInteractionEnabled:YES];
    self.view = contentView;
    // Do any additional setup after loading the view from its nib.
    UIImage* buttonImage = [[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:6.0 topCapHeight:0.0];
    self.username = [[UITextField alloc]initWithFrame:CGRectMake(35, 20, 250, 35)];
    self.username.autocorrectionType = UITextAutocorrectionTypeNo;
    self.password = [[UITextField alloc]initWithFrame:CGRectMake(35, 60, 250, 35)];
    self.repeatpassword = [[UITextField alloc]initWithFrame:CGRectMake(35, 100, 250, 35)];
    self.phonenumber = [[UITextField alloc]initWithFrame:CGRectMake(35, 140, 250, 35)];
    self.idCode = [[UITextField alloc]initWithFrame:CGRectMake(35, 180, 250, 35)];
    self.recommender = [[UITextField alloc]initWithFrame:CGRectMake(35, 180, 250, 35)];
    self.recommender.borderStyle=UITextBorderStyleRoundedRect;
    self.username.borderStyle=UITextBorderStyleRoundedRect;
    self.password.borderStyle=UITextBorderStyleRoundedRect;
    self.repeatpassword.borderStyle=UITextBorderStyleRoundedRect;
    self.phonenumber.borderStyle=UITextBorderStyleRoundedRect;
    self.idCode.borderStyle=UITextBorderStyleRoundedRect;
    [self.username setPlaceholder:@"用户名"];
    [self.password setPlaceholder:@"密码"];
    [self.repeatpassword setPlaceholder:@"重复密码"];
    [self.phonenumber setPlaceholder:@"手机号"];
    [self.idCode setPlaceholder:@"请输入验证码"];
    [self.recommender setPlaceholder:@"推荐人"];
    [self.phonenumber setDelegate:self];
    [self.password setSecureTextEntry:YES];
    [self.repeatpassword setSecureTextEntry:YES];
    [self.username addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.password addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.repeatpassword addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.phonenumber addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.idCode addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.recommender addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.recommender setDelegate:self];
    [self.view addSubview:self.username];
    [self.view addSubview:self.password];
    [self.view addSubview:self.repeatpassword];
    [self.view addSubview:self.phonenumber];
//    [self.view addSubview:self.idCode];
    [self.view addSubview:self.recommender];
    [self.idCode setDelegate:self];
    self.registerButton = [[UIButton alloc]initWithFrame:CGRectMake(35, 240, 250, 35)];
    self.registerButton.layer.borderColor =[[UIColor colorWithRed:70/255.0 green:174/255.0 blue:76/255.0 alpha:1] CGColor];
    [self.registerButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [self.registerButton.layer setMasksToBounds:YES];
    self.registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.registerButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(registerStart) forControlEvents:UIControlEventTouchUpInside];
    [self.registerButton setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:self.registerButton];
    
    self.yanzhengButton = [[UIButton alloc]initWithFrame:CGRectMake(35, 270, 120, 35)];
    self.yanzhengButton.layer.borderColor =[[UIColor colorWithRed:70/255.0 green:204/255.0 blue:51/255.0 alpha:1] CGColor];
    [self.yanzhengButton setBackgroundColor:[UIColor colorWithRed:70.0/255.0 green:204.0/255.0 blue:51.0/255 alpha:1.0]];
    [self.yanzhengButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.yanzhengButton.layer setMasksToBounds:YES];
    self.yanzhengButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.yanzhengButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.yanzhengButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.yanzhengButton addTarget:self action:@selector(achieveCode) forControlEvents:UIControlEventTouchUpInside];
    [self.yanzhengButton setShowsTouchWhenHighlighted:YES];
//    [self.view addSubview:self.yanzhengButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 注册

- (void)registerStart
{
    if (![self.nowloading boolValue]) {
        if (![[self.username text] isEqualToString:@""] && ![[self.password text] isEqualToString:@""] && ![[self.repeatpassword text] isEqualToString:@""] && ![[self.phonenumber text] isEqualToString:@""]) {
            if ([[self.password text] isEqualToString:[self.repeatpassword text]]) {
                self.nowloading = [NSNumber numberWithBool:YES];
                NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action" : @"Reg", @"username" : [self.username text], @"password" : [self.password text], @"captcha" : @"8888", @"moble" : [self.phonenumber text], @"recommender" : [self.recommender text]} error:nil];
                NSLog(@"REQUEST:%@",request);
                [self showProgressDialog];
                AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                op.responseSerializer = [AFJSONResponseSerializer serializer];
                op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    [HUD removeFromSuperview];
                    if ([[responseObject objectForKey:@"result"] isEqualToString:@"ok"]) {
                        if (![[responseObject objectForKey:@"用户ID"] isEqualToString:@"0"]) {
                            NSLog(@"%@",[responseObject objectForKey:@"用户ID"]);
                            NSString *string = [NSString stringWithString:[responseObject objectForKey:@"用户ID"]];
                            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                            [ud setObject:string forKey:@"user_id"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册成功！" message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                            [alert show];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                        else
                        {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册信息错误" message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                            [alert show];
                        }
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
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"密码不一致" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请将信息填写完整" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alert show];
        }
    }
}
#pragma mark 获取验证码

- (void)achieveCode
{
    if (![self.nowloading boolValue]) {
        if (![[self.phonenumber text] isEqualToString:@""]) {
            //实例化timer
            [self.phonenumber resignFirstResponder];
//            [self resignFirstResponder];
            [self.yanzhengButton setEnabled:NO];
            [self.yanzhengButton setBackgroundColor:[UIColor grayColor]];
            [self.yanzhengButton setTitle:@"请稍后" forState:UIControlStateNormal];
            self.connectionTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
            self.canSendMessage = [NSNumber numberWithInt:60];
            [[NSRunLoop currentRunLoop]addTimer:self.connectionTimer forMode:NSDefaultRunLoopMode];
            //用timer作为延时的一种方法
            self.nowloading = [NSNumber numberWithBool:YES];
            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"SendMessage",@"mobile":[self.phonenumber text],@"token":@"askldnu324aSASjk212456356sadsxahwjvghjqwdvjh1241k"} error:nil];
            NSLog(@"REQUEST:%@",request);
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            op.responseSerializer = [AFJSONResponseSerializer serializer];
            op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                if ([[responseObject objectForKey:@"result"] isEqualToString:@"ok"]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"验证码已发送" message:[responseObject objectForKey:@"result"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                    [alert show];
                    
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
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请填写手机号" message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alert show];
        }
    }


    //[self resignFirstResponder];
}

#pragma mark 收键盘

- (void)removeKeyboard
{
//    [self resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
}

#pragma mark timer

//timer调用函数
-(void)timerFired:(NSTimer *)timer{
    self.canSendMessage = [NSNumber numberWithInt:[self.canSendMessage intValue]-1];
    if ([self.canSendMessage intValue] == 0) {
        [self.yanzhengButton setEnabled:YES];
        [self.yanzhengButton setBackgroundColor:[UIColor colorWithRed:70.0/255.0 green:204.0/255.0 blue:51.0/255 alpha:1.0]];
        [self.connectionTimer invalidate];
        [self.yanzhengButton setTitle:@"重新发送" forState:UIControlStateNormal];
    }
    else
    {
        [self.yanzhengButton setTitle:[NSString stringWithFormat:@"重新发送(%d)",[self.canSendMessage intValue]] forState:UIControlStateNormal];
    }
    NSLog(@"time out!!");
}

- (void)showProgressDialog {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    
    //设置对话框文字
    HUD.labelText = @"请稍候";
    HUD.yOffset = -90.0f;
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
