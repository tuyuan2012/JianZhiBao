//
//  JABillViewController.m
//  JASidePanels
//
//  Created by syy on 14-3-4.
//
//

#import "JABillViewController.h"

@interface JABillViewController ()

@end


@implementation JABillViewController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self.title = @"排行榜";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //添加标题栏。
    UIView *headView = [[UIView alloc]init];
    headView.frame =CGRectMake(0, 64, 320, 60);
    headView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255 alpha:1.0];
    UILabel *jifen =  [[UILabel alloc]initWithFrame:CGRectMake(20.0, 5.0, 75.0, 50.0)];
    jifen.text = @"我的排名：";
    jifen.font = [UIFont boldSystemFontOfSize:14];
    jifen.textColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255 alpha:1.0];
    jifen.backgroundColor=[UIColor clearColor];
    merank =  [[UILabel alloc]initWithFrame:CGRectMake(95.0, 5.0, 200.0, 50.0)];
    merank.text = @"载入中";
    merank.font = [UIFont boldSystemFontOfSize:14];
    merank.textColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255 alpha:1.0];
    merank.backgroundColor=[UIColor clearColor];
    //添加tableview
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 124, self.view.frame.size.width, self.view.frame.size.height-124)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    [tableView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255 alpha:1.0]];
    [tableView setSeparatorColor:[UIColor blackColor]];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.bounces = NO;
    [headView addSubview:jifen];
    [headView addSubview:merank];
    [self.view addSubview:headView];
    [self.view addSubview:tableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"GetIncomeList",@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} error:nil];
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
    [merank setText:[self.mainListDic objectForKey:@"my"]];
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
    return 35;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255 alpha:1.0];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 8, 110, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.text = @"排名";
    [headerView addSubview:headerLabel];
    UILabel *header1Label = [[UILabel alloc] initWithFrame:CGRectMake(145, 8, 80, 20)];
    header1Label.backgroundColor = [UIColor clearColor];
    header1Label.font = [UIFont boldSystemFontOfSize:14.0];
    header1Label.textColor = [UIColor blackColor];
    header1Label.text = @"姓名";
    [headerView addSubview:header1Label];
    
    UILabel *header2Label = [[UILabel alloc] initWithFrame:CGRectMake(262, 8, 80, 20)];
    header2Label.backgroundColor = [UIColor clearColor];
    header2Label.font = [UIFont boldSystemFontOfSize:14.0];
    header2Label.textColor = [UIColor blackColor];
    header2Label.text = @"收入";
    [headerView addSubview:header2Label];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JABillCell *cell = [[JABillCell alloc]init];
    NSMutableDictionary *singleInfo = [[self.mainListDic objectForKey:@"list"] objectAtIndex:[indexPath row]];
    cell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255 alpha:1.0];
    [cell.name setText:[singleInfo objectForKey:@"姓名"]];
    [cell.rank setText:[singleInfo objectForKey:@"排行"]];
    [cell.money setText:[singleInfo objectForKey:@"收入"]];
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

@end
