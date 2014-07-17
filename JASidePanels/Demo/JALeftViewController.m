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


#import "JALeftViewController.h"
#import "JASidePanelController.h"

#import "UIViewController+JASidePanel.h"
#import "JARightViewController.h"
#import "JACenterViewController.h"
#import "JAUserInfoViewController.h"

#import "MobClick.h"


@interface JALeftViewController () <UIAlertViewDelegate>


@end

@implementation JALeftViewController

@synthesize tabletag;
@synthesize leftView;


- (void)viewDidLoad {
    [super viewDidLoad];
    tabletag = 0;
	self.view.backgroundColor = [UIColor whiteColor];
   UIView *leftheadView = [[UIView alloc]init];
    leftheadView.frame =CGRectMake(0, 20, 320, 44);
    leftheadView.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255 alpha:1.0];
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    homeButton.backgroundColor = [UIColor clearColor];
    [homeButton setTitle:@"首页" forState:UIControlStateNormal];
    [homeButton setTitle:@"首页" forState:UIControlStateSelected];
    [homeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    homeButton.frame = CGRectMake(0, 7, 100, 33);
    homeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    tabletag ++;
	leftView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    [leftView setBackgroundColor:[UIColor grayColor]];
    [leftView setSeparatorColor:[UIColor blackColor]];
    [leftView setDelegate:self];
    [leftView setDataSource:self];
    leftView.bounces = NO;
    [homeButton addTarget:self action:@selector(gotocenterPanel) forControlEvents:UIControlEventTouchDown];
    [leftheadView addSubview:homeButton];
    [self.view addSubview:leftView];
    [self.view addSubview:leftheadView];

}

- (void)viewWillAppear:(BOOL)animated {
    //[leftView reloadData];
//    [self.parentViewController.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
    tabletag ++;
    NSLog(@"%lf,%lf",leftView.frame.origin.x,leftView.frame.origin.y);
    if (tabletag > 2) {
        leftView.frame =CGRectMake(0, 44,self.view.frame.size.width, self.view.frame.size.height-44);
    }
    
    //网络获取数据
    self.mainListDic = [[NSMutableDictionary alloc]init];
    self.incomeListDic = [[NSMutableDictionary alloc]init];
    self.CreditListDic = [[NSMutableDictionary alloc]init];
    //个人信息
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"GetMyInfo",@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} error:nil];
    NSLog(@"REQUEST:%@",request);
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.mainListDic = responseObject;
        [self.leftView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    
    //个人信誉
    NSMutableURLRequest *request1 = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"GetMyCredit",@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} error:nil];
    NSLog(@"REQUEST:%@",request1);
    AFHTTPRequestOperation *op1 = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
    op1.responseSerializer = [AFJSONResponseSerializer serializer];
    op1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation1, id responseObject1) {
        NSLog(@"JSON: %@", responseObject1);
        self.CreditListDic = responseObject1;
        [self.leftView reloadData];
    } failure:^(AFHTTPRequestOperation *operation1, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op1];
    //个人收入
    NSMutableURLRequest *request2 = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"GetMyIncome",@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} error:nil];
    NSLog(@"REQUEST:%@",request2);
    AFHTTPRequestOperation *op2 = [[AFHTTPRequestOperation alloc] initWithRequest:request2];
    op2.responseSerializer = [AFJSONResponseSerializer serializer];
    op2.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op2 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation2, id responseObject2) {
        NSLog(@"JSON: %@", responseObject2);
        self.incomeListDic = responseObject2;
        [self.leftView reloadData];
    } failure:^(AFHTTPRequestOperation *operation2, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op2];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section ==0 && indexPath.row == 0 ) {
        return 76;
    }
    else
    return 40;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 3;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255 alpha:1.0];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 150, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:13.0];
    headerLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:headerLabel];
    if (section == 0) {
         headerLabel.text = @"设置";
    }
    if (section == 1) {
        headerLabel.text = @"帐号";
    }
    if (section == 2) {
        headerLabel.text = @"更多";
    }
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 5;
    }
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] isEqualToString:@""]) {
        return 2;
        }
        else
        return 3;
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    JALeftCell *cell = [[JALeftCell alloc]init];
    cell.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255 alpha:1.0];
    if (section == 0) {
        if (indexPath.row ==0) {
           if (self.mainListDic[@"用户名"] != nil)
            {
                [cell.title setText:[self.mainListDic objectForKey:@"用户名"]];
                cell.title.font = [UIFont boldSystemFontOfSize:12.0f];
                cell.title.frame =CGRectMake(80, 23, 100, 20);
                [cell.image setImage:[UIImage imageNamed:@"头像.png"]];
                //头像写死
//                NSString *imageURL = nil;
//                
//                if(_mainListDic[@"头像"] && ![_mainListDic[@"头像"] isEqualToString:@""])
//                    imageURL = [[@"http://www.jzb24.com/" stringByAppendingString:_mainListDic[@"头像"]]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                else
//                    [cell.image setImage:[UIImage imageNamed:@"头像.png"]];
//                
//                if ([imageURL length]) {
//                    NSURL *url = [NSURL URLWithString:imageURL];
//                    [cell.image setImageWithURL:url
//                               placeholderImage:nil];
//                }

                
                cell.image.frame = CGRectMake(10, 13, 50, 50);
            }
            else
            {
                [cell.title setText:@"请登录"];
                cell.title.font = [UIFont boldSystemFontOfSize:12.0f];
                cell.title.frame =CGRectMake(80, 23, 100, 20);
                [cell.image setImage:[UIImage imageNamed:@"头像.png"]];
                cell.image.frame = CGRectMake(10, 13, 50, 50);
            }
        }
        if (indexPath.row ==1)
        {
            [cell.title setText:@"城市"];
            [cell.image setImage:[UIImage imageNamed:@"城市.gif"]];
            [cell.allmark setText:@"北京"];
            [cell  setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }
    if (section == 1) {
        if (indexPath.row ==0) {
            [cell.title setText:@"信誉"];
            [cell.image setImage:[UIImage imageNamed:@"信誉.gif"]];
            [cell.allmark setText:[self.CreditListDic objectForKey:@"total"]];
        }
        if (indexPath.row ==1)
        {
            [cell.title setText:@"收入"];
            [cell.image setImage:[UIImage imageNamed:@"差饷.gif"]];
            [cell.allmark setText:[self.incomeListDic objectForKey:@"total"]];
        }
        if (indexPath.row ==2)
        {
            [cell.title setText:@"退出登录"];
            [cell.image setImage:[UIImage imageNamed:@"退出.gif"]];
        }
    }
    if (section == 2) {
        if (indexPath.row == 0) {
            [cell.title setText:@"使用帮助"];
            [cell.image setImage:[UIImage imageNamed:@"使用帮助.gif"]];
            [cell setTag:0];
        }
        if (indexPath.row == 1) {
            [cell.title setText:@"新手指导"];
            [cell.image setImage:[UIImage imageNamed:@"新手指导.gif"]];
            [cell setTag:1];
        }
        if (indexPath.row == 2) {
            [cell.title setText:@"系统版本"];
            [cell.image setImage:[UIImage imageNamed:@"系统版本.gif"]];
        }
        if (indexPath.row == 3) {
            [cell.title setText:@"意见反馈"];
            [cell.image setImage:[UIImage imageNamed:@"意见反馈.gif"]];
            [cell setTag:3];
        }
        if (indexPath.row == 4)
        {
            [cell.title setText:@"企业合作"];
            [cell.image setImage:[UIImage imageNamed:@"企业合作.gif"]];
            [cell setTag:4];
        }
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.3f];
    NSInteger section = indexPath.section;
    if (section == 0) {
        if(indexPath.row == 0){
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] isEqualToString:@""]) {
                JALoginViewController *nextpage = [[JALoginViewController alloc]init];
//                nextpage.frameSet = [NSNumber numberWithBool:YES];
                [self.sidePanelController toggleLeftPanel];
                UINavigationController *parentview = (UINavigationController *)self.sidePanelController.centerPanel;
                [parentview pushViewController:nextpage animated:YES];
            } else {
                JAUserInfoViewController *userInfoVC = [[JAUserInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
                //                nextpage.frameSet = [NSNumber numberWithBool:YES];
                [self.sidePanelController toggleLeftPanel];
                UINavigationController *parentview = (UINavigationController *)self.sidePanelController.centerPanel;
                [parentview pushViewController:userInfoVC animated:YES];
            }

        }
    }
    if (section == 1) {
        if (indexPath.row == 0) {
            JAMeController * nextpage=[[JAMeController alloc]init];
            [self.parentViewController.navigationController pushViewController:nextpage animated:YES];
        }
        if (indexPath.row == 1) {
            JAMoneyViewController * nextpage=[[JAMoneyViewController alloc]init];
            [self.parentViewController.navigationController pushViewController:nextpage animated:YES];
        }
        if (indexPath.row == 2) {
            //TODO: 退出登录
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否退出登录，退出后记得回来完成任务拿奖励哦！" delegate:self  cancelButtonTitle:@"取消" otherButtonTitles:@"确认退出", nil];
            [alert show];
        }
    }
    if (section == 2) {
//         [self showAllTextDialog];
        id nextpage = nil;
        switch (indexPath.row) {
            case 0:
                nextpage = [[JAHelpViewController alloc]init];
                break;
            case 1:
                nextpage = [[JANewIntroViewController alloc]init];
                break;
            case 2:
                break;
            case 3:
                nextpage = [[JASuggestionViewController alloc]init];
                break;
            case 4:
                nextpage = [[JACooperationViewController alloc]init];
                break;
            default:
                break;
        }
        if (indexPath.row == 2) {
            [MobClick checkUpdateWithDelegate:self selector:@selector(checkUpdateResult:)];
//             [self showAllTextDialog];
        }
        else
        {
        [self.parentViewController.navigationController pushViewController:nextpage animated:YES];
        }
    }
}

- (void)deselect
{
    [leftView deselectRowAtIndexPath:[leftView indexPathForSelectedRow] animated:YES];
}
#pragma mark - Button Actions

- (void)showAllTextDialog
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"已是最新版本！";
    HUD.labelFont = [UIFont boldSystemFontOfSize:12.0f];
    HUD.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
        HUD.yOffset = 150.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.2);
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
    }];
}

-(void)gotocenterPanel
{
    [self.sidePanelController toggleLeftPanel];
}

- (void)checkUpdateResult:(NSDictionary *)appInfo {
    NSLog(@"%@", appInfo);
    if ([appInfo[@"update"] boolValue]) {
        CustomAlertView *aler = [[CustomAlertView alloc] initWithAlertStyle:Update_Style withObject:
                                 [NSString stringWithFormat:@"有版本需要更新！\n%@",appInfo[@"update_log"]]];
        aler.delegate = self;
        [self.view addSubview:aler];
    } else {
        CustomAlertView *aler = [[CustomAlertView alloc] initWithAlertStyle:Update_NoStyl withObject:@"已经是最新版本了啦！"];
        aler.delegate = self;
        [self.view addSubview:aler];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            
        }
    } else if (buttonIndex == 1) {
        //退出操作!
        //TODO:这个ud在系统底层还是没有清空？
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@"" forKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        JAAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate.navController.viewControllers[0] viewWillAppear:YES];
        self.sidePanelController.centerPanel = [delegate navController];
        tabletag = 1;
        self.mainListDic = [[NSMutableDictionary alloc]init];
        [leftView reloadData];
        JARightViewController *right = (JARightViewController *)self.sidePanelController.rightPanel;
        [right viewWillAppear:YES];
        
    }
}

#pragma mark - CustomDelegate method
-(void)update
{
    //更新操作
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kITUNES_LINK]];
}
@end
