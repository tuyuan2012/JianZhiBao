//
//  JAInputUserInfoTableViewController.m
//  JASidePanels
//
//  Created by Stan Zhang on 5/16/14.
//
//

#import "JAInputUserInfoTableViewController.h"
#import "JABankInfoTableViewCell.h"

#define kBankCellID @"bankCellID"

@interface JAInputUserInfoTableViewController () <UITextFieldDelegate>

@property (nonatomic) NSArray *keyArray;
@property (strong, nonatomic) IBOutlet UITableViewCell *genderCell;

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSwitch;
@end

@implementation JAInputUserInfoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _keyArray = @[@"姓名", @"性别", @"年龄", @"手机号", @"简介"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JABankInfoTableViewCell" bundle:nil] forCellReuseIdentifier:kBankCellID];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_keyArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = _keyArray[indexPath.row];
    
    if (![key isEqualToString:@"性别"]) {
        JABankInfoTableViewCell *cell = (JABankInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kBankCellID];
        
        if (!cell) {
            cell = [[JABankInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBankCellID];
        }
        
        cell.key = key;
        cell.valueTextField.delegate = self;
        
        return cell;
    } else {
        return _genderCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 70.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"请输入个人信息";
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    UIImage* buttonImage = [[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:6.0 topCapHeight:0.0];
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-70, 25, 140, 40)];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    [submit setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit setShowsTouchWhenHighlighted:YES];
    [submit addTarget:self action:@selector(uploadPersonInfo) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:submit];
    
    return footerView;
}

- (void)uploadPersonInfo {
    
    JABankInfoTableViewCell *nameCell = (JABankInfoTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    JABankInfoTableViewCell *ageCell = (JABankInfoTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    JABankInfoTableViewCell *phoneCell = (JABankInfoTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    JABankInfoTableViewCell *introCell = (JABankInfoTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    if (![nameCell.value length] || ![ageCell.value length] || ![phoneCell.value length]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请将信息填写完整" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    
    NSString *gender = _genderSwitch.selectedSegmentIndex ? @"女" : @"男";
    
    NSString *content = [NSString stringWithFormat:@"%@，%@，%@，%@，%@", nameCell.value, gender, phoneCell.value, ageCell.value, introCell.value];
    
    [self showProgressDialog];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"AddMember",@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"], @"taskid":_taskID, @"content":content} error:nil];
    
    NSLog(@"REQUEST:%@",request);
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [HUD removeFromSuperview];
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"ok"]) {
            NSLog(@"%@",[responseObject objectForKey:@"status"]);
            NSString *status = [responseObject objectForKey:@"status"];
            
            if ([status isEqualToString:@"成功"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"添加成功" message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                [alert show];
                
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:status message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                [alert show];
    
                return;
            }
            
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"服务器出错" message:[responseObject objectForKey:@"result"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)showProgressDialog {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    
    //设置对话框文字
    HUD.labelText = @"请稍候";
    HUD.yOffset = -90.0f;
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
