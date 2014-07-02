//
//  JALoginViewController.m
//  JASidePanels
//
//  Created by admin on 14-3-1.
//
//

#import "JALoginViewController.h"

@interface JALoginViewController ()
@property (strong, nonatomic)NSNumber *nowloading;
@end

@implementation JALoginViewController
@synthesize username;
@synthesize password;
@synthesize loginButton;
@synthesize registerButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"登录";
        self.nowloading = [[NSNumber alloc]initWithBool:NO];
        self.frameSet = [[NSNumber alloc]initWithBool:NO];
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (![self.frameSet boolValue]) {
        [self.username setFrame:CGRectMake(35, 70-20, 250, 35)];
        [self.password setFrame:CGRectMake(35, 115-20, 250, 35)];
        [self.loginButton setFrame:CGRectMake(35, 175-20, 120, 35)];
        [self.registerButton setFrame:CGRectMake(165, 175-20, 120, 35)];
    }
    else
    {
        [self.username setFrame:CGRectMake(35, 70+44, 250, 35)];
        [self.password setFrame:CGRectMake(35, 115+44, 250, 35)];
        [self.loginButton setFrame:CGRectMake(35, 175+44, 120, 35)];
        [self.registerButton setFrame:CGRectMake(165, 175+44, 120, 35)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [contentView setImage:[UIImage imageNamed:@"background_login.jpg"]];
    [contentView setUserInteractionEnabled:YES];
    self.view = contentView;
    self.username = [[UITextField alloc]initWithFrame:CGRectMake(35, 50, 250, 35)];
    self.username.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.username setDelegate:self];
    self.password = [[UITextField alloc]initWithFrame:CGRectMake(35, 95, 250, 35)];
    [self.username setPlaceholder:@"用户名"];
    [self.password setPlaceholder:@"密码"];
    UIImage *buttonImage = [[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:6.0 topCapHeight:0.0];
    self.username.borderStyle=UITextBorderStyleRoundedRect;
    self.password.borderStyle=UITextBorderStyleRoundedRect;
    [self.password setSecureTextEntry:YES];
    
    [self.username addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.password addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:self.username];
    [self.view addSubview:self.password];
    self.loginButton = [[UIButton alloc]initWithFrame:CGRectMake(35, 155, 120, 35)];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [self.loginButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.registerButton = [[UIButton alloc]initWithFrame:CGRectMake(165, 155, 120, 35)];
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registerButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.loginButton setShowsTouchWhenHighlighted:YES];
    [self.registerButton setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:self.loginButton];
    [self.loginButton addTarget:self action:@selector(loginStart) forControlEvents:UIControlEventTouchUpInside];
    [self.registerButton addTarget:self action:@selector(pushToregister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
//    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 收键盘

- (void)removeKeyboard
{
    [self resignFirstResponder];
}

#pragma mark login

- (void)loginStart
{
    //
    if (![self.nowloading boolValue]) {
        if (![[self.username text] isEqualToString:@""] && ![[self.password text] isEqualToString:@""]) {
            self.nowloading = [NSNumber numberWithBool:YES];
            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"]  parameters:@{@"action":@"Login",@"username":[self.username text],@"password":[self.password text]} error:nil];
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
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录信息错误" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
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
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请将信息填写完整" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alert show];
        }
    }
    
    
}

#pragma mark pushToregister

- (void)pushToregister
{
    JARegisterViewController *nextpage = [[JARegisterViewController alloc]initWithNibName:@"JARegisterViewController" bundle:nil];
    [self.navigationController pushViewController:nextpage animated:YES];
}
- (void)showProgressDialog {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    
    //设置对话框文字
    HUD.labelText = @"登录中";
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
