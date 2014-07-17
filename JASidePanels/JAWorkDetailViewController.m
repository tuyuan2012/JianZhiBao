//
//  JAWorkDetailViewController.m
//  JASidePanels
//
//  Created by admin on 14-3-4.
//
//

#import "JAWorkDetailViewController.h"
#import "JAInputUserInfoTableViewController.h"

@interface JAWorkDetailViewController ()
@property (nonatomic) NSInteger type;
@property (strong, nonatomic) NSNumber *nowloading;
@property (nonatomic) CLLocationCoordinate2D nowlocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSNumber *nowTaskDoing;   //0-无,1-上岗,2-下岗
@end

@implementation JAWorkDetailViewController
@synthesize taskId;
@synthesize mainDetail;
@synthesize startWorking;
@synthesize endWorking;
@synthesize detail;
@synthesize mainList;
@synthesize score;
@synthesize price;
@synthesize workState;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.nowloading = [[NSNumber alloc]initWithBool:NO];
        self.nowTaskDoing = [[NSNumber alloc]initWithInt:0];
        // Custom initialization
    }
    return self;
}

- (id)initWithType:(NSInteger)type {
    if (self = [super init]) {
        self.type = type;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.mainList setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [self.startWorking setFrame:CGRectMake(self.view.frame.size.width/2-5-80, self.view.frame.size.height-5-34, 70, 34)];
//    [self.endWorking setFrame:CGRectMake(self.view.frame.size.width/2+15, self.view.frame.size.height-5-34, 70, 34)];
    [self refresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    //    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"user_id"];
    // Do any additional setup after loading the view from its nib.
    self.mainList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.mainList.delegate = self;
    self.mainList.dataSource = self;
    [self.view addSubview:self.mainList];
    
//    self.startWorking = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-5-80, self.view.frame.size.height-5-34, 70, 34)];
//    [self.startWorking setTitle:@"上岗" forState:UIControlStateNormal];
//    [self.startWorking addTarget:self action:@selector(startwork:) forControlEvents:UIControlEventTouchUpInside];
//    [self.startWorking setEnabled:NO];
//    [self.startWorking.titleLabel setFont:[UIFont fontWithName:self.startWorking.titleLabel.font.fontName size:15]];
//    [self.startWorking setBackgroundColor:[UIColor grayColor]];
//    [self.view addSubview:self.startWorking];
//    self.endWorking = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+15, self.view.frame.size.height-5-34, 70, 34)];
//    [self.endWorking setTitle:@"下岗" forState:UIControlStateNormal];
//    [self.endWorking addTarget:self action:@selector(endwork:) forControlEvents:UIControlEventTouchUpInside];
//    [self.endWorking setEnabled:NO];
//    [self.endWorking.titleLabel setFont:[UIFont fontWithName:self.endWorking.titleLabel.font.fontName size:15]];
//    [self.endWorking setBackgroundColor:[UIColor grayColor]];
//    [self.view addSubview:self.endWorking];
    [self showProgressDialog];
    
    [self refresh];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 44;
    }
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (view == nil) {
        view = [[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        if (section == 0) {
            self.detail = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, self.view.frame.size.width-40, 20)];
            [self.detail setText:[self.mainListDic objectForKey:@"标题"]];
            [view addSubview:self.detail];
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(20, 43, self.view.frame.size.width-40, 0.5)];
            [line setBackgroundColor:[UIColor grayColor]];
            [view addSubview:line];
        }
        else
        {
            self.score = [[UILabel alloc]initWithFrame:CGRectMake(25, 30, 100, 30)];
            self.price = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 200, 30)];
            [self.score setText:@""];
            [self.score setTextColor:[UIColor blackColor]];
            [self.score setFont:[UIFont fontWithName:self.price.font.fontName size:15]];
            [self.price setText:[self.mainListDic objectForKey:@"金额"]];
            [self.price setTextColor:[UIColor redColor]];
            [self.price setFont:[UIFont fontWithName:self.price.font.fontName size:23]];
            [view addSubview:self.score];
            [view addSubview:self.price];
            self.workState = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, 10, 100, 40)];
            [self.workState setBackgroundColor:[UIColor grayColor]];
            if ([[self.mainListDic objectForKey:@"审核状态"] isEqualToString:@"已关闭"] || [[self.mainListDic objectForKey:@"审核状态"] isEqualToString:@"已完成"]) {
                [self.workState setBackgroundColor:[UIColor grayColor]];
                [self.workState setEnabled:NO];
            }
            if ([[self.mainListDic objectForKey:@"审核状态"] isEqualToString:@"已关闭"] || [[self.mainListDic objectForKey:@"审核状态"] isEqualToString:@"已完成"]) {
                [self.workState setTitle:[self.mainListDic objectForKey:@"审核状态"] forState:UIControlStateNormal];
            } else if ([[self.mainListDic objectForKey:@"审核状态"] isEqualToString:@"工作中"]) {
                if (_type) {
                    [self.workState setTitle:@"添加信息" forState:UIControlStateNormal];
                    [self.workState addTarget:self action:@selector(inputPersonInfo) forControlEvents:UIControlEventTouchUpInside];
                    [self.workState setBackgroundColor:[UIColor redColor]];
                } else {
                    [self.workState setTitle:[self.mainListDic objectForKey:@"审核状态"] forState:UIControlStateNormal];
                }
            } else {
                if ([[self.mainListDic objectForKey:@"审核状态"] isEqualToString:@"未申请"]) {
                    [self.workState setTitle:@"点击申请" forState:UIControlStateNormal];
                    [self.workState addTarget:self action:@selector(applyTask:) forControlEvents:UIControlEventTouchUpInside];
                    [self.workState setBackgroundColor:[UIColor redColor]];
                }
                else {
                    if (_type) {
                        [self.workState setTitle:@"添加信息" forState:UIControlStateNormal];
                        [self.workState addTarget:self action:@selector(inputPersonInfo) forControlEvents:UIControlEventTouchUpInside];
                        [self.workState setBackgroundColor:[UIColor redColor]];
                    } else {
                        [self.workState setTitle:@"已申请" forState:UIControlStateNormal];
                    }
                }
            }
            [self.workState.titleLabel setFont:[UIFont fontWithName:self.workState.titleLabel.font.fontName size:15]];
            [view addSubview:self.workState];
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(20, 59, self.view.frame.size.width-40, 0.5)];
            [line setBackgroundColor:[UIColor redColor]];
            [view addSubview:line];
        }
    }
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        return 0;
    }
    else
    {
        return self.mainList.frame.size.height - 44 - 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableviewcell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableviewcell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if ([indexPath section] == 1) {
            NSLog(@"%@", NSStringFromCGRect(self.view.frame));
            
            self.mainDetail = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - 60)];
            [self.mainDetail.scrollView setBounces:NO];
            [cell addSubview:self.mainDetail];
            //加载返回的内容
        }
    }
    if ([indexPath section] == 1) {
        [self.mainDetail loadHTMLString:[self.mainListDic objectForKey:@"html"] baseURL:[[NSURL alloc]init]];
    }
    return cell;
}

#pragma mark applytask
- (IBAction)applyTask:(id)sender
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] isEqualToString:@""]) {
        JALoginViewController *nextpage = [[JALoginViewController alloc]init];
        [self.navigationController pushViewController:nextpage animated:YES];
        return;
    }
    if (![self.nowloading boolValue]) {
        self.nowloading = [NSNumber numberWithBool:YES];
        [self showProgressDialog];
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"ApplyTask",@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"taskid":self.taskId} error:nil];
        NSLog(@"%@", request);
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            [HUD removeFromSuperview];
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"ok"]) {
                if ([[responseObject objectForKey:@"status"] isEqualToString:@"成功"]) {
                    if (_type) {
                        [self refresh];
                    } else {
                        [self.workState setTitle:@"已申请" forState:UIControlStateNormal];
                        [self.workState setBackgroundColor:[UIColor grayColor]];
                        [self.workState setEnabled:NO];
                    }
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"申请成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                    [alert show];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"出错" message:[responseObject objectForKey:@"status"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
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
}

- (void)inputPersonInfo {
    JAInputUserInfoTableViewController *infoVC = [[JAInputUserInfoTableViewController alloc] init];
    infoVC.taskID = taskId;
    
//    [self presentViewController:infoVC animated:YES completion:nil];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)refresh {
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"GetTaskHTML",@"taskid":self.taskId,@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} error:nil];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [HUD removeFromSuperview];
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"ok"]) {
            self.mainListDic = responseObject;
            //            if ([[responseObject objectForKey:@"审核状态"] isEqualToString:@"工作中"]) {
            //                [self.startWorking setEnabled:YES];
            //                [self.startWorking setBackgroundColor:[UIColor redColor]];
            //                [self.endWorking setEnabled:YES];
            //                [self.endWorking setBackgroundColor:[UIColor redColor]];
            //            }
            [self.mainList reloadData];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"服务器出错" message:[responseObject objectForKey:@"result"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [HUD removeFromSuperview];
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

#pragma mark startwork/endwork

- (IBAction)startwork:(id)sender
{
    if (![self.nowloading boolValue]) {
        self.nowloading = [NSNumber numberWithBool:YES];
        //        CLLocationManager *locationManager;//定义Manager
        // 判断定位操作是否被允许
        if([CLLocationManager locationServicesEnabled]) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            // 开始定位
            NSLog(@"start update location");
            self.nowTaskDoing = [NSNumber numberWithInt:1];
            [self.locationManager startUpdatingLocation];
        }
        else {
            //提示用户无法进行定位操作
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您需要打开定位功能才能上岗" delegate:nil cancelButtonTitle:@"好吧" otherButtonTitles:nil];
            [alert show];
            self.nowloading = [NSNumber numberWithBool:NO];
        }
    }
}

- (IBAction)endwork:(id)sender
{
    if (![self.nowloading boolValue]) {
        self.nowloading = [NSNumber numberWithBool:YES];
        //        CLLocationManager *locationManager;//定义Manager
        // 判断定位操作是否被允许
        if([CLLocationManager locationServicesEnabled]) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            // 开始定位
            NSLog(@"start update location");
            self.nowTaskDoing = [NSNumber numberWithInt:2];
            [self.locationManager startUpdatingLocation];
        }
        else {
            //提示用户无法进行定位操作
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您需要打开定位功能才能上岗" delegate:nil cancelButtonTitle:@"好吧" otherButtonTitles:nil];
            [alert show];
            self.nowloading = [NSNumber numberWithBool:NO];
        }
    }
}

#pragma mark 定位delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    [self showProgressDialog];
    self.nowlocation = currentLocation.coordinate;
    NSLog(@"%lf,%lf",self.nowlocation.longitude,self.nowlocation.latitude);
    NSMutableURLRequest *request = nil;
    if ([self.nowTaskDoing intValue] == 1) {
        request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"TaskStart",@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"taskid":self.taskId,@"address":[NSString stringWithFormat:@"%lf,%lf",self.nowlocation.longitude,self.nowlocation.latitude]} error:nil];
    }
    if ([self.nowTaskDoing intValue] == 2) {
        request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"TaskEnd",@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"taskid":self.taskId,@"address":[NSString stringWithFormat:@"%lf,%lf",self.nowlocation.longitude,self.nowlocation.latitude]} error:nil];
    }
    NSLog(@"%@",request);
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [HUD removeFromSuperview];
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[responseObject objectForKey:@"status"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alert show];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"服务器出错" message:[responseObject objectForKey:@"result"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alert show];
        }
        self.nowTaskDoing = [NSNumber numberWithInt:0];
        self.nowloading = [NSNumber numberWithBool:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        self.nowTaskDoing = [NSNumber numberWithInt:0];
        self.nowloading = [NSNumber numberWithBool:NO];
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
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

@end

