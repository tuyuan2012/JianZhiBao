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

#import "JACenterViewController.h"
#import "AFHTTPRequestOperationManager.h"


static const CGFloat kHeightOfTopScrollView = 44.0f;
static const CGFloat kHeightOfNavigationBar = 44.0f;
static const CGFloat kHeightOfStatusBar = 20.0f;

@interface JACenterViewController ()

@property (nonatomic) NSDictionary *getTaskListParams;

@end

@implementation JACenterViewController
{
    BOOL _isActivityApp;
    NSString *_activityDetailId;
}

@synthesize rootView;

- (id)init {
    if (self = [super init]) {
        self.title = @"所有兼职";
    }
    return self;
}

- (id)initWithType:(NSInteger)type {
    if (self = [super init]) {
        self.type = type;
        _getTaskListParams = type ? @{@"action" : @"GetTaskList", @"type" : @"全职"} : @{@"action" : @"GetTaskList", @"type" : @"兼职"};
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self.rootView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kHeightOfTopScrollView - kHeightOfNavigationBar - kHeightOfStatusBar)];
    } else {
        [self.rootView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kHeightOfTopScrollView - kHeightOfNavigationBar)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainListDic = [[NSMutableDictionary alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        rootView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kHeightOfTopScrollView - kHeightOfNavigationBar - kHeightOfStatusBar)];
    } else {
        rootView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kHeightOfTopScrollView - kHeightOfNavigationBar)];
    }
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.rootView setTableFooterView:v];
    [rootView setBackgroundColor:[UIColor whiteColor]];
    [rootView setDelegate:self];
    [rootView setDataSource:self];
    [self.view addSubview:rootView];
    
    __weak JACenterViewController *weakSelf = self;
    
    [rootView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    //获取列表信息
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:_getTaskListParams error:nil];
    
//    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"androidRootURL"] parameters:@{@"action":@"GetTaskList"} error:nil];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [self showProgressDialog];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.mainListDic = responseObject;
        
        [HUD removeFromSuperview];
        [self.rootView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    
    //获取广告信息
    NSDictionary *getIndexTopPicParams = _type ? @{@"action" : @"GetIndexTopPic", @"type" : @"全职"} : @{@"action" : @"GetIndexTopPic", @"type" : @"兼职"};
    
    NSMutableURLRequest *request1 = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"]  parameters:getIndexTopPicParams error:nil];
    
    AFHTTPRequestOperation *ad = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
    ad.responseSerializer = [AFJSONResponseSerializer serializer];
    ad.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ad setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.adDic = responseObject;
        [self.rootView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:ad];
}

- (void)insertRowAtTop {
        [rootView beginUpdates];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"]  parameters:_getTaskListParams error:nil];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.mainListDic = responseObject;
        [self.rootView reloadData];
        [self.rootView.pullToRefreshView stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.rootView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
        [rootView endUpdates];
//        [rootView.pullToRefreshView stopAnimating];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.mainListDic count]) {
        return [[self.mainListDic objectForKey:@"list"]  count]+1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JACenterCell *cell = [[JACenterCell alloc]init];
    
    if (indexPath.row == 0) {
        [cell.imageView.layer setCornerRadius:0];
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:[self.adDic objectForKey:@"url"]]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
        cell.imageView.frame = CGRectMake(0, 0, 320, 80);
        [cell.cornermark setHidden:YES];
    }
    else
    {
        if ([self.mainListDic count]) {
            NSMutableDictionary *singleInfo = [[self.mainListDic objectForKey:@"list"] objectAtIndex:[indexPath row]-1];
            [cell.title setText:[singleInfo objectForKey:@"标题"]];
            NSURL *imgURL = [[NSURL alloc]initWithString:[singleInfo objectForKey:@"图片"]];
            [cell.imageView setImageWithURL:imgURL
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            [cell.price setText:[singleInfo objectForKey:@"金额"]];
            [cell.person setText:[singleInfo objectForKey:@"已参加人数"]];
            NSString * corner = [[NSString alloc]initWithString:[singleInfo objectForKey:@"角标"]];
            if ([corner  isEqual:@"火"]){
                [cell.cornermark setImage:[UIImage imageNamed:@"热.gif"]];
                [cell.cornermark setHidden:NO];
            }
            if ([corner  isEqual:@"新"]){
                [cell.cornermark setImage:[UIImage imageNamed:@"VIP.png"]];
                [cell.cornermark setHidden:NO];
            }
        }
        
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.3f];
    id nextpage = nil;
    if ([indexPath row]==0) {
        nextpage = [[JAAdvViewController alloc]initWithURL:[[NSURL alloc] init]];
        [nextpage addHTML:[self.adDic objectForKey:@"html"]];
    }
    else
    {
        nextpage = [[JAWorkDetailViewController alloc] initWithType:_type];
        [nextpage setTaskId:[NSString stringWithFormat:@"%@", [[[self.mainListDic objectForKey:@"list"] objectAtIndex:[indexPath row]-1] objectForKey:@"兼职ID"]]];
    }
    
    JAAppDelegate *delegate = (JAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.navController pushViewController:nextpage animated:YES];
}

- (void)deselect
{
    [rootView deselectRowAtIndexPath:[rootView indexPathForSelectedRow] animated:YES];
}

- (void)showProgressDialog {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    
    //设置对话框文字
    HUD.labelText = @"请稍等";
    
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

#pragma mark - 接受通知，跳转到相应的详细页面
-(void)showDetailWith:(NSString *)detailId
{
    _isActivityApp = NO;
    id nextpage = nil;
    nextpage = [[JAWorkDetailViewController alloc] initWithType:_type];
    [nextpage setTaskId:detailId];
    JAAppDelegate *delegate = (JAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.navController pushViewController:nextpage animated:YES];
}

@end
