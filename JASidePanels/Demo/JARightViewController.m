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


#import "JARightViewController.h"
#import "JASidePanelController.h"

#import "UIViewController+JASidePanel.h"

@interface JARightViewController ()

@property (nonatomic) NSMutableArray *partJobList;     //兼职列表
@property (nonatomic) NSMutableArray *fullJobList;     //全职列表
@property (nonatomic) NSMutableArray *currentJobList;

@end

@implementation JARightViewController {
    UISegmentedControl *stateSwitch;
}

@synthesize rightView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showProgressDialog];
    
    _partJobList = [[NSMutableArray alloc] init];
    _fullJobList = [[NSMutableArray alloc] init];
    _currentJobList = _partJobList;
    
	self.view.backgroundColor = [UIColor whiteColor];
    //添加标题栏。
    UIView *rightheadView = [[UIView alloc]init];
    rightheadView.frame =CGRectMake(0, 20, 320, 44);
    rightheadView.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255 alpha:1.0];
    
    stateSwitch = [[UISegmentedControl alloc] initWithItems:@[@"我的兼职", @"我的全职"]];
    [stateSwitch setFrame:CGRectMake(95, 7, 200, 28)];
    stateSwitch.selectedSegmentIndex = 0;
    [stateSwitch addTarget:self
                    action:@selector(changeJobList:)
          forControlEvents:UIControlEventValueChanged];
    
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(155.0, 14.0, 200.0, 18.0)];
//    title.text = @"我的兼职";
//    title.backgroundColor = [UIColor clearColor];
//    title.font = [UIFont boldSystemFontOfSize:17.0];
//    title.textColor = [UIColor whiteColor];
//    [rightheadView addSubview:title];
    [rightheadView addSubview:stateSwitch];
    [self.view addSubview:rightheadView];
    //添加tableview
    rightView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.rightView setTableFooterView:v];
    [rightView setBackgroundColor:[UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255 alpha:1.0]];
    [rightView setSeparatorColor:[UIColor blackColor]];
    [rightView setDelegate:self];
    [rightView setDataSource:self];
    rightView.bounces = YES;
    [self.view addSubview:rightView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDictionary *getMyTaskParams = @{@"action":@"GetMyTask",@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]};
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"]  parameters:getMyTaskParams error:nil];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray *jobList = responseObject[@"list"];
        [_partJobList removeAllObjects];
        [_fullJobList removeAllObjects];
        [jobList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *type = obj[@"类别"];
            if ([type isEqualToString:@"兼职"]) {
                [_partJobList addObject:obj];
            } else {
                [_fullJobList addObject:obj];
            }
        }];
        
        [HUD removeFromSuperview];
        [self.rightView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    // [self.rightView setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height064)];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255 alpha:1.0];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 8, 150, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
    headerLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:headerLabel];
    
    
    headerLabel.text = stateSwitch.selectedSegmentIndex ? @"工作中的全职" : @"工作中的兼职";
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *singleInfo = [_currentJobList objectAtIndex:[indexPath row]];
    JARightCell *cell = [[JARightCell alloc]init];
    cell.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255 alpha:1.0];
    [cell.title setText:[singleInfo objectForKey:@"标题"]];
   // [cell.describe setText:@"结束时间："];
    [cell.price setText:[singleInfo objectForKey:@"金额"]];
   // [cell.credit setText:[singleInfo objectForKey:@"结束时间"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_currentJobList count]) {
        return 35;
    } else {
        return 0;
    }
    
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_currentJobList count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.3f];
     id nextpage = nil;
    nextpage = [[JAWorkDetailViewController alloc] initWithType:stateSwitch.selectedSegmentIndex];
    [nextpage setTaskId:[[_currentJobList objectAtIndex:[indexPath row]] objectForKey:@"兼职ID"]];
    
    [self.navigationController pushViewController:nextpage animated:YES];
}


#pragma mark - Help Functions
- (void)changeJobList:(UISegmentedControl *)segControl {
    _currentJobList = segControl.selectedSegmentIndex ? _fullJobList : _partJobList;
    
    [self.rightView reloadData];
}

- (void)deselect
{
    [rightView deselectRowAtIndexPath:[rightView indexPathForSelectedRow] animated:YES];
}

- (void)showProgressDialog {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    
    //设置对话框文字
    HUD.labelText = @"加载中";
    
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
