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

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:@"user_id"] == Nil) {
        [ud setObject:@"" forKey:@"user_id"];
    }
//    [ud setObject:@"http://jzb.cloudapp.net/Client.ashx" forKey:@"rootURL"];
    [ud setObject:Main_Domain forKey:@"rootURL"];//@"http://www.jzb24.com/Client_v1.1.ashx"
    
    [MobClick startWithAppkey:@"536b96ad56240b0a65023564"];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [MobClick checkUpdate];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
	_jaside = [[JASidePanelController alloc] init];
    
    //    self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
    
	_jaside.leftPanel = [[JALeftViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[JACenterViewController alloc] init]];
    _navController = [[UINavigationController alloc] initWithRootViewController:[[JASlideSwitchDemoViewController alloc] init]];
    _navController.navigationBar.translucent = NO;
	_jaside.centerPanel = _navController;
	_jaside.rightPanel = [[JARightViewController alloc] init];
	UINavigationController *rootnav = [[UINavigationController alloc]initWithRootViewController:_jaside];
    [rootnav setNavigationBarHidden:YES];
//    rootnav.navigationBar.translucent = NO;
	self.window.rootViewController = rootnav;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
