//
//  JAUserInfoViewController.m
//  JASidePanels
//
//  Created by Stan Zhang on 5/9/14.
//
//

#import "JAUserInfoViewController.h"
#import "JABasicInfoTableViewController.h"
#import "JAPasswordChangeViewController.h"

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
@interface JAUserInfoViewController ()

@property (nonatomic) NSArray *sectionTextArray;
@property (nonatomic) NSMutableArray *cellTextArray;

@end

@implementation JAUserInfoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sectionTextArray = @[@"基本资料",@"支付信息", @"身份认证", @"账号安全"];
    
    _cellTextArray = [[NSMutableArray alloc] initWithCapacity:[_sectionTextArray count]];
//    [_cellTextArray addObject:@[@"基本信息", @"联系方式"]];
    [_cellTextArray addObject:@[@"个人信息"]];
    [_cellTextArray addObject:@[@"支付宝", @"银行账号"]];
    [_cellTextArray addObject:@[@"身份证", @"健康证", @"学生证"]];
    [_cellTextArray addObject:@[@"修改登录密码"]];
    
    self.title = @"个人信息";
    
    [self.tableView setTableFooterView:[UIView new]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionTextArray count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == [_sectionTextArray count]) {
        return 1;
    }
    
    return [_cellTextArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == [_sectionTextArray count]) return 10.0f;
    if (section)  return 30.0f;
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == [_sectionTextArray count]) {
        return nil;
    }
    
    return _sectionTextArray[section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (indexPath.section == [_sectionTextArray count]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(113, 11, 94, 21)];
        label.text = @"清除缓存";
        
        [cell addSubview:label];
    } else {
        cell.textLabel.text = _cellTextArray[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == [_sectionTextArray count]) {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"清理成功";
        hud.mode = MBProgressHUDModeText;
        [self performSelector:@selector(clearCacheDone) withObject:nil afterDelay:1];
        
    } else if (indexPath.section != 3) {
        JABasicInfoTableViewController *vc = [[JABasicInfoTableViewController alloc] init];
        vc.title = _cellTextArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        JAPasswordChangeViewController *vc = [[JAPasswordChangeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) clearCacheDone
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
