//
//  JAMeController.m
//  JASidePanels
//
//  Created by syy on 14-3-3.
//
//

#import "JAMeController.h"
@interface JAMeController ()

@end

@implementation JAMeController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的信誉";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated 
{
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"GetMyCredit",@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} error:nil];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.mainListDic = responseObject;
        [self.tableView reloadData];
        [self reloadlabel];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

- (void)reloadlabel
{
    [jifen setText:[self.mainListDic objectForKey:@"total"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //添加标题栏。
    UIView *headView = [[UIView alloc]init];
    headView.frame =CGRectMake(0, 64, 320, 60);
    headView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255 alpha:1.0];
    me =  [[UILabel alloc]initWithFrame:CGRectMake(20.0, 5.0, 200.0, 50.0)];
    [me setText:@"我的信誉："];
    me.font = [UIFont boldSystemFontOfSize:16];
    me.textColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255 alpha:1.0];
    me.backgroundColor=[UIColor clearColor];
    jifen =  [[UILabel alloc]initWithFrame:CGRectMake(105.0, 5.0, 200.0, 50.0)];
    [jifen setText:@"加载中"];
    jifen.font = [UIFont boldSystemFontOfSize:16];
    jifen.textColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255 alpha:1.0];
    jifen.backgroundColor=[UIColor clearColor];
    //添加tableview
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 124, self.view.frame.size.width, self.view.frame.size.height-124)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    [tableView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255 alpha:1.0]];
    [tableView setSeparatorColor:[UIColor blackColor]];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.bounces = YES;
    [headView addSubview:jifen];
    [headView addSubview:me];
    [self.view addSubview:headView];
    [self.view addSubview:tableView];
    
    [Frontia initWithApiKey:APP_KEY];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BDSocialShareEditButton.png"] style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem.title = @"分享";
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blueColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    headerView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255 alpha:1.0];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 150, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.text = @"兼职/时间";
    [headerView addSubview:headerLabel];
    UILabel *header2Label = [[UILabel alloc] initWithFrame:CGRectMake(275, 8, 150, 20)];
    header2Label.backgroundColor = [UIColor clearColor];
    header2Label.font = [UIFont boldSystemFontOfSize:14.0];
    header2Label.textColor = [UIColor blackColor];
    header2Label.text = @"信誉";
    [headerView addSubview:header2Label];
    
    UILabel *header3Label = [[UILabel alloc] initWithFrame:CGRectMake(145 , 8, 150, 20)];
    header3Label.backgroundColor = [UIColor clearColor];
    header3Label.font = [UIFont boldSystemFontOfSize:14.0];
    header3Label.textColor = [UIColor blackColor];
    header3Label.text = @"时间";
    //[headerView addSubview:header3Label];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JAMECell *cell = [[JAMECell alloc]init];
     NSMutableDictionary *singleInfo = [[self.mainListDic objectForKey:@"list"] objectAtIndex:[indexPath row]];
    cell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255 alpha:1.0];
    [cell.title setText:[singleInfo objectForKey:@"兼职"]];
    [cell.time setText:[singleInfo objectForKey:@"时间"]];
    [cell.credit setText:[singleInfo objectForKey:@"信誉度"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[self.mainListDic objectForKey:@"list"]count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"122234");
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.3f];
}

- (void)deselect
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}


#pragma mark - 分享
-(void)share:(UIButton *)sender
{
    FrontiaShare *share = [Frontia getShare];
    
    //[share registerQQAppId:@"100358052" enableSSO:YES];
    //微信，测试的appId
    [share registerWeixinAppId:kWeiXin_APP_KEY];
    [share registerQQAppId:kTenXunWeibo_APP_ID enableSSO:YES];
    //[share registerSinaweiboAppId:@""];
    
    //授权取消回调函数
    FrontiaShareCancelCallback onCancel = ^(){
        NSLog(@"OnCancel: share is cancelled");
        [self showAlertWithInfo:@"取消分享"];
    };
    
    //授权失败回调函数
    FrontiaShareFailureCallback onFailure = ^(int errorCode, NSString *errorMessage){
        NSLog(@"OnFailure: %d  %@", errorCode, errorMessage);
        [self showAlertWithInfo:@"分享失败"];
    };
    
    //授权成功回调函数
    FrontiaMultiShareResultCallback onResult = ^(NSDictionary *respones){
        NSLog(@"OnResult: %@", [respones description]);
        [self showAlertWithInfo:@"分享成功"];
    };
    
    FrontiaShareContent *content=[[FrontiaShareContent alloc] init];
    content.url = @"http://www.jzb24.com";
    content.title = @"兼职宝分享";
    content.description = [NSString stringWithFormat:@"%@！猛戳详情连接：",@"秀秀我的信誉!"];
    
    /*
     图片是截view,截取tableView
     */
    UIGraphicsBeginImageContext(self.view.bounds.size);     //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    [self.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    
    content.imageObj = viewImage;//@"http://www.jzb24.com/index/images/logo_l.gif";
    
    NSArray *platforms = @[FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE,FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_SESSION,FRONTIA_SOCIAL_SHARE_PLATFORM_SINAWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_QQWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_QQ,FRONTIA_SOCIAL_SHARE_PLATFORM_RENREN,FRONTIA_SOCIAL_SHARE_PLATFORM_KAIXIN];
    
    [share showShareMenuWithShareContent:content displayPlatforms:platforms supportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait isStatusBarHidden:NO targetViewForPad:sender cancelListener:onCancel failureListener:onFailure resultListener:onResult];
}

- (void)showAlertWithInfo:(NSString *)str
{
    UILabel *alert = [[UILabel alloc]init];
    alert.bounds = CGRectMake(0, 0, 150, 30);
    alert.center = CGPointMake(kScreen_Width / 2, kScreen_Height - 200);
    alert.backgroundColor = [UIColor colorWithWhite:.2 alpha:.8];
    alert.text = str;
    alert.textColor = [UIColor whiteColor];
    alert.textAlignment = NSTextAlignmentCenter;
    alert.font = [UIFont systemFontOfSize:12];
    alert.alpha = 0.0;
    alert.layer.cornerRadius = 10.0;
    alert.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    alert.layer.shadowRadius = 10.0;
    alert.layer.shadowOpacity = 5;
    alert.clipsToBounds = YES;
    [self.view addSubview:alert];
    [UIView animateWithDuration:.5 animations:^{
        alert.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
            alert.alpha = 0.0;
        } completion:^(BOOL finished) {
            [alert removeFromSuperview];
        }];
    }];
}


@end
