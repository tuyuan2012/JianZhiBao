/*
Copyright (c) 2012 Jesse Andersen. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

If you happen to meet one of the copyright holders in a bar you are obligated
to buy them one pint of beer.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#import "JAAppDelegate.h"

#import "JASidePanelController.h"
#import "JACenterViewController.h"
#import "JALeftViewController.h"
#import "JARightViewController.h"

#import "JASlideSwitchDemoViewController.h"

#import "MobClick.h"
@implementation JAAppDelegate
{
    //成员变量
    BOOL _isInBackGround;
    int _tag;
    BOOL _isFirstLoad;
    JASlideSwitchDemoViewController *_jASlideSwitchDemoViewController;
    NSDictionary *_userInfo;
}

@synthesize window = _window;
@synthesize viewController = _viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _userInfo = [NSDictionary dictionary];
    _isFirstLoad = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:@"user_id"] == Nil) {
        [ud setObject:@"" forKey:@"user_id"];
    }
    //    [ud setObject:@"http://jzb.cloudapp.net/Client.ashx" forKey:@"rootURL"];
    [ud setObject:Main_TestDomain forKey:@"rootURL"];//@"http://www.jzb24.com/Client_v1.1.ashx"
    
    [MobClick startWithAppkey:YouMengAPP_Key reportPolicy:BATCH   channelId:nil];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithAppkey:YouMengAPP_Key];
    
    //自动更新
    [MobClick checkUpdateWithDelegate:self selector:@selector(checkUpdateResult:)];
    
    application.applicationIconBadgeNumber = 0;
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    _jaside = [[JASidePanelController alloc] init];
    
    //  self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
    
    _jaside.leftPanel = [[JALeftViewController alloc] init];
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[JACenterViewController alloc] init]];
    
    _jASlideSwitchDemoViewController = [[JASlideSwitchDemoViewController alloc] init];
    _navController = [[UINavigationController alloc] initWithRootViewController:_jASlideSwitchDemoViewController];
    _navController.navigationBar.translucent = NO;
    _jaside.centerPanel = _navController;
    _jaside.rightPanel = [[JARightViewController alloc] init];
    UINavigationController *rootnav = [[UINavigationController alloc]initWithRootViewController:_jaside];
    [rootnav setNavigationBarHidden:YES];
    //    rootnav.navigationBar.translucent = NO;
    self.window.rootViewController = rootnav;
    [self.window makeKeyAndVisible];
    
    //推送入口
    [self registerForRemoteNotification:nil];
    
    return YES;
}

#pragma mark 推送
//请求获取动态令牌
- (void)registerForRemoteNotification:(id)sender
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeSound
     | UIRemoteNotificationTypeAlert];
}

// 请求令牌错误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *str = [NSString stringWithFormat: @"Error: %@", error];
    NSLog(@"获取devicetoken出错:%@",str);
}

//得到令牌
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *tokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *finalString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"finalString---->%@",finalString);
    NSLog(@"返回的token--->%@==%@",deviceToken,finalString);
    
    //    [ShowAlertView showAlertViewStr:finalString];
    
    //    NSString *oldDevStr = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceTokenDefault];
    //[self sendDeviceToken:finalString];
    //[self updateDeviceToken:finalString withOldToken:oldDevStr];
    //return;
    //第一次发
    //    if(![oldDevStr length])
    //    {
    //发送DeviceToken发送到服务器
    // [self sendDeviceToken:finalString];
    //    }
    //    //更新
    //    else if (![finalString isEqualToString:oldDevStr])
    //    {
    //        NSLog(@"更换新的DeviceToken");
    //        [self updateDeviceToken:finalString withOldToken:oldDevStr];
    //    }
    
    
}

-(void)applicationDidEnterBackground:(UIApplication *)application
{
    //应用是否进入后台
    _isInBackGround = YES;
    _tag ++;
    _isFirstLoad = NO;
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    //应用复活
    _isInBackGround = NO;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
}

- (void)addMessageFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
    if([userInfo objectForKey:@"detailId"])
    {
        [_jASlideSwitchDemoViewController.vc1 showDetailWith:[userInfo objectForKey:@"detailId"]];
    }
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    if(_isInBackGround)
        [self addMessageFromRemoteNotification:userInfo updateUI:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"didReceiveRemoteNotification" message:nil delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alertView show];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    _userInfo = userInfo;
    //点击消息，启动程序
    if(_isFirstLoad || _isInBackGround)
    {
        [self addMessageFromRemoteNotification:_userInfo updateUI:YES];
        _isFirstLoad = NO;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲" message:@"你有新消息了啦~\(≧▽≦)/~!" delegate:self cancelButtonTitle:@"暂时不看了" otherButtonTitles:@"马上去看", nil];
        alertView.delegate = self;
        alertView.tag = 110;
        [alertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 110)
    {
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
                [self addMessageFromRemoteNotification:_userInfo updateUI:YES];
                break;
            default:
                break;
        }
    }
}

- (void)appUpdate:(NSDictionary *)appInfo
{
    
}
#pragma mark - 版本更新
- (void)checkUpdateResult:(NSDictionary *)appInfo {
    NSLog(@"appInfo--->%@", appInfo);
    if ([appInfo[@"update"] boolValue]) {
        CustomAlertView *aler = [[CustomAlertView alloc] initWithAlertStyle:Update_Style withObject:
                                 [NSString stringWithFormat:@"有版本需要更新！\n%@",appInfo[@"update_log"]]];
        aler.delegate = self;
        [self.window addSubview:aler];
    } else {
//        CustomAlertView *aler = [[CustomAlertView alloc] initWithAlertStyle:Update_NoStyl withObject:@"已经是最新版本了啦！"];
//        aler.delegate = self;
//        [self.window addSubview:aler];
    }
}

-(void)update
{
    //更新操作
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kITUNES_LINK]];
}

@end

