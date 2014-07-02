//
//  JAPasswordChangeViewController.m
//  JASidePanels
//
//  Created by admin on 14-3-2.
//
//

#import "JAPasswordChangeViewController.h"

@interface JAPasswordChangeViewController ()
@property (strong, nonatomic)NSNumber *nowloading;
@end

@implementation JAPasswordChangeViewController
@synthesize oldpassword;
@synthesize password;
@synthesize repeatpassword;
@synthesize submit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"修改密码";
        // Custom initialization
        self.nowloading = [[NSNumber alloc]initWithBool:NO];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.oldpassword setFrame:CGRectMake(35, 135, 250, 35)];
    [self.password setFrame:CGRectMake(35, 180, 250, 35)];
    [self.repeatpassword setFrame:CGRectMake(35, 225, 250, 35)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [contentView setImage:[UIImage imageNamed:@"background_login.jpg"]];
    [contentView setUserInteractionEnabled:YES];
    self.view = contentView;
    UIImage* buttonImage = [[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:6.0 topCapHeight:0.0];
    self.oldpassword = [[UITextField alloc]init];
    self.password = [[UITextField alloc]init];
    self.repeatpassword = [[UITextField alloc]init];
    self.oldpassword = [[UITextField alloc]initWithFrame:CGRectMake(35, 90, 250, 35)];
    self.password = [[UITextField alloc]initWithFrame:CGRectMake(35, 135, 250, 35)];
    self.repeatpassword = [[UITextField alloc]initWithFrame:CGRectMake(35, 180, 250, 35)];
    self.oldpassword.borderStyle=UITextBorderStyleRoundedRect;
    self.password.borderStyle=UITextBorderStyleRoundedRect;
    self.repeatpassword.borderStyle=UITextBorderStyleRoundedRect;
    [self.oldpassword setPlaceholder:@"旧密码"];
    [self.password setPlaceholder:@"新密码"];
    [self.repeatpassword setPlaceholder:@"重复密码"];
    [self.repeatpassword setDelegate:self];
    [self.oldpassword setSecureTextEntry:YES];
    [self.password setSecureTextEntry:YES];
    [self.repeatpassword setSecureTextEntry:YES];
    [self.oldpassword addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.password addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.repeatpassword addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:self.oldpassword];
    [self.view addSubview:self.password];
    [self.view addSubview:self.repeatpassword];
    self.submit = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-70, 285, 140, 40)];
    [self.submit setTitle:@"提交" forState:UIControlStateNormal];
    [self.submit setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submit setShowsTouchWhenHighlighted:YES];
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
        if (![[self.oldpassword text] isEqualToString:@""] && ![[self.repeatpassword text] isEqualToString:@""]) {
            [self showProgressDialog];
            if ([[self.password text] isEqualToString:[self.repeatpassword text]]) {
                self.nowloading = [NSNumber numberWithBool:YES];
                NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"UpdatePassword",@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"password0":[self.oldpassword text],@"password1":[self.password text],@"password2":[self.repeatpassword text]} error:nil];
                NSLog(@"REQUEST:%@",request);
                AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                op.responseSerializer = [AFJSONResponseSerializer serializer];
                op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    [HUD removeFromSuperview];
                    if ([[responseObject objectForKey:@"result"] isEqualToString:@"ok"]) {
                        
                        NSLog(@"%@",[responseObject objectForKey:@"用户ID"]);
                        if ([[responseObject objectForKey:@"status"] isEqualToString:@"密码错误"]) {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"密码错误！" message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                            [alert show];
                            
                            
                        } else {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改成功！" message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                            [alert show];
                            [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark 收键盘

- (void)removeKeyboard
{
    [self resignFirstResponder];
}

#pragma mark uitextfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view setFrame:self.view.window.bounds];
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
