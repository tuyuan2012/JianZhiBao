//
//  JAMoneyViewController.m
//  JASidePanels
//
//  Created by syy on 14-3-4.
//
//

#import "JAMoneyViewController.h"

@interface JAMoneyViewController ()

@end

@implementation JAMoneyViewController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的收入";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"排行榜" style:UIBarButtonItemStylePlain target:self action:@selector(perFormAdd:)];//为导航栏添加右侧
    //添加标题栏。
    UIView *headView = [[UIView alloc]init];
    headView.frame =CGRectMake(0, 64, 320, 60);
    headView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255 alpha:1.0];
    me =  [[UILabel alloc]initWithFrame:CGRectMake(20.0, 5.0, 200.0, 50.0)];
    [me setText:@"我的收入："];
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
}
-(void)viewWillAppear:(BOOL)animated
{
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"GetMyIncome",@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} error:nil];
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
    header2Label.text = @"收入";
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
    [cell.credit setText:[singleInfo objectForKey:@"收入"]];
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

-(void)perFormAdd:(id)paramSender{
    JABillViewController * nextpage=[[JABillViewController alloc]init];
    [self.navigationController pushViewController:nextpage animated:YES];
}
@end
