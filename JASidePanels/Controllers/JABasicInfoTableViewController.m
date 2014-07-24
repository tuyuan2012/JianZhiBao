//
//  JABasicInfoTableViewController.m
//  JASidePanels
//
//  Created by Stan Zhang on 5/12/14.
//
//

#import "JABasicInfoTableViewController.h"
#import "JAEditInfoTableViewController.h"
#import "JAInfoPhotoTableViewCell.h"
#import "JABankInfoTableViewCell.h"
#import "IBActionSheet.h"
#import "ValidateTool.h"
#define kTextCellID @"textCellID"
#define kPhotoCellID @"photoCellID"
#define kBankCellID @"bankCellID"

static int maxFileSize = 250*1024;

@interface JABasicInfoTableViewController () <UIActionSheetDelegate, IBActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic) NSArray *sectionTextArray;
@property (nonatomic) NSMutableArray *cellTextArrayList;
@property (nonatomic) NSArray *cellTextArray;

@property (nonatomic) NSMutableArray *bankInfos;
@property(nonatomic)NSMutableArray *userInfoArray;

@property (nonatomic) NSInteger index;
@property (nonatomic) NSIndexPath *selectedCellIndex;

@property (nonatomic) NSMutableDictionary *mainInfoDic;

@property (strong, nonatomic) IBOutlet UITableViewCell *portraitCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *genderCell;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImgView;


@end

@implementation JABasicInfoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // _sectionTextArray = @[@"基本信息",@"支付宝",@"银行账号", @"身份证", @"健康证", @"学生证", @"修改登录密码"];
     _sectionTextArray = @[@"个人信息", @"支付宝",@"银行账号", @"身份证", @"健康证", @"学生证", @"修改登录密码"];
    _cellTextArrayList = [[NSMutableArray alloc] initWithCapacity:[_sectionTextArray count]];
    
    //0
    [_cellTextArrayList addObject:@[@"头像", @"姓名", @"性别", @"年龄",@"邮箱", @"手机号", @"电话号码", @"qq号"]];
    
    //[_cellTextArrayList addObject:@[@"邮箱", @"手机号", @"电话号码", @"qq号"]];
    
    //1支付宝
    [_cellTextArrayList addObject:@[@"账户类型", @"用户名", @"支付宝账号", @"确认支付宝"]];
    //2银行
    [_cellTextArrayList addObject:@[@"账户类型", @"开户姓名", @"开户银行", @"所在城市", @"所属支行", @"银行账号", @"确认账号"]];
    //3身份证
    [_cellTextArrayList addObject:@[@"身份证照片正面", @"身份证照片反面"]];
    //4健康证
    [_cellTextArrayList addObject:@[@"健康证照片正面", @"健康证照片反面"]];
    //5学生证
    [_cellTextArrayList addObject:@[@"学生证照片"]];
    //6修改登陆密码
    [_cellTextArrayList addObject:@[@"当前密码", @"设置新密码", @"确认新密码"]];

    _index = [_sectionTextArray indexOfObject:self.title];
    _cellTextArray = _cellTextArrayList[_index];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JAInfoPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:kPhotoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"JABankInfoTableViewCell" bundle:nil] forCellReuseIdentifier:kBankCellID];
    
    [_genderSwitch addTarget:self
                      action:@selector(genderSwitchChanged)
            forControlEvents:UIControlEventValueChanged];
    
    
    __weak JABasicInfoTableViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf beginLoad];
    }];
    
    [self.tableView triggerPullToRefresh];
}

- (void)beginLoad {
    if (_index == 2) {
        [self loadCreditCardInfo];
    } else if (_index == 1) {
        [self loadAlipayInfo];
    } else{
        [self loadUserInfo];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cellTextArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = _cellTextArray[indexPath.row];
    
    //擦，这代码些的真是，擦...
    if (_index == 3 || _index == 4 || _index == 5) {  //身份认证部分
        JAInfoPhotoTableViewCell *cell = (JAInfoPhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kPhotoCellID];
        
        if (!cell) {
            cell = [[JAInfoPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPhotoCellID];
        }
        
        cell.key = key;
        cell.imageURL = [[_mainInfoDic valueForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        return cell;
        
    } else if (_index == 1 || _index == 2) {  //支付信息部分
        JABankInfoTableViewCell *cell = (JABankInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kBankCellID];
        
        if (!cell) {
            cell = [[JABankInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBankCellID];
        }
        
        cell.key = key;
        cell.valueTextField.tag = indexPath.row;
        [cell.valueTextField addTarget:self
                                action:@selector(textFieldDidChange:)
                      forControlEvents:UIControlEventEditingChanged];
        
        cell.valueTextField.delegate = self;
        if ([key isEqualToString:@"账户类型"]) {
            cell.value = _index == 2 ? @"银联卡" : @"支付宝";
        } else if (_bankInfos) {
            cell.value = _bankInfos[indexPath.row];
        }
        
        return cell;
    
    } else if ([key isEqualToString:@"头像"]) {
        NSString *imageURL = [[_mainInfoDic valueForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ([imageURL length]) {
            NSURL *url = [NSURL URLWithString:imageURL];
            [_portraitImgView setImageWithURL:url
                             placeholderImage:nil];
            
        }
        
        return _portraitCell;
    } else if ([key isEqualToString:@"性别"]) {
        return _genderCell;
    } else  {
        //个人信息，此时采用在同一个页面布局
        
        JABankInfoTableViewCell *cell = (JABankInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kBankCellID];
        
        if (!cell) {
            cell = [[JABankInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBankCellID];
        }
        
        cell.key = key;
        if((indexPath.row - 1) > -1)
            cell.valueTextField.tag = indexPath.row - 1;
        NSLog(@"cell.valueTextField.tag%d",cell.valueTextField.tag);
        //cell.value = [key isEqualToString:@"年龄"] ? [_mainInfoDic valueForKey:@"出生日期"] : [_mainInfoDic valueForKey:key];
        cell.value = _userInfoArray[cell.valueTextField.tag];
        [cell.valueTextField addTarget:self
                                action:@selector(textFieldDidChange:)
                      forControlEvents:UIControlEventEditingChanged];
        
        cell.valueTextField.delegate = self;
        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextCellID];
//        
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kTextCellID];
//        }
//        
//        cell.textLabel.text = key;
       // cell.detailTextLabel.text = [key isEqualToString:@"年龄"] ? [_mainInfoDic valueForKey:@"出生日期"] : [_mainInfoDic valueForKey:key];
        
       // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_cellTextArray[indexPath.row] isEqualToString:@"头像"]) {
        return 76.0f;
    } else if (_index == 3 || _index == 4 || _index == 5) {     //照片信息
        return 150.0f;
    } else {
        return 44.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_index == 1 || _index == 2 || _index == 0) {
        return 70.0f;
    }
    
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_index == 1 || _index == 2 || _index == 0) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        
        UIImage* buttonImage = [[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:6.0 topCapHeight:0.0];
        UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-70, 25, 140, 40)];
        [submit setTitle:@"提交" forState:UIControlStateNormal];
        [submit setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submit setShowsTouchWhenHighlighted:YES];
        [submit addTarget:self action:@selector(updateBankInfo) forControlEvents:UIControlEventTouchUpInside];
        
        [footerView addSubview:submit];
        
        return footerView;
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = _cellTextArray[indexPath.row];
    
    //3：身份认证 4：健康证 5：学生证
    if ((_index > 2 && _index < 6) || [key isEqualToString:@"头像"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:key delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
        
        actionSheet.title = key;
        
        [actionSheet showInView:self.view];
        
        _selectedCellIndex = indexPath;
    }
  // } else if ([key isEqualToString:@"性别"]) {//_index != 5 && _index != 6 && ，全部在本页面编辑，信息类
//        JAEditInfoTableViewController *vc = [[JAEditInfoTableViewController alloc] init];
//        vc.title = _cellTextArray[indexPath.row];
//        vc.prevText = [[[tableView cellForRowAtIndexPath:indexPath] detailTextLabel] text];
//        
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    
}

#pragma mark - IBActionSheet/UIActionSheet Delegate Method

// the delegate method to receive notifications is exactly the same as the one for UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.title = actionSheet.title;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.title = actionSheet.title;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if(_index == 1 || _index == 2)//银行卡，支付宝
        [self.bankInfos replaceObjectAtIndex:textField.tag withObject:textField.text];
    else if(_index == 0)
        [self.userInfoArray replaceObjectAtIndex:textField.tag withObject:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark -
#pragma mark imagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self showProgressDialog];
    
    NSString *key = _cellTextArray[_selectedCellIndex.row];
    
    NSLog(@"Selected %@", key);
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    NSData *photoData = UIImageJPEGRepresentation(originalImage, 0.5);
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    
    while ([photoData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        photoData = UIImageJPEGRepresentation(originalImage, compression);
    }
    
    [self uploadPhotoForKey:key imageData:photoData];
}

#pragma mark - Helper Functions
- (void)genderSwitchChanged {
    NSString *value = _genderSwitch.selectedSegmentIndex ? @"女" : @"男";
    //[self updateInfoForKey:@"性别" value:value];
    [self.userInfoArray replaceObjectAtIndex:1 withObject:value];
}

- (void)updateBankInfo {
    
    NSUInteger nrow = [self.tableView numberOfRowsInSection:0];
    NSString *info = [[NSString alloc] init];
    
    if (_bankInfos) {
        if (![_bankInfos[nrow-2] isEqualToString:_bankInfos[nrow-1]]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"账号不一致" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alert show];
            
            return;
        }
        for (int i = 0 ; i < nrow - 2; i ++) {
            info = [info stringByAppendingString:[NSString stringWithFormat:@"%@|", _bankInfos[i]]];
        }
        info = [info stringByAppendingString:_bankInfos[nrow - 2]];
        [self showProgressDialog];
        
        NSMutableURLRequest *request;
        
        if (_index == 2) {  //银行卡信息
            request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"CreditCard", @"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"], @"operation":@"set", @"info":info} error:nil];
        } else if(_index == 1) {  //支付宝信息
            request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"PayPal",@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"], @"operation":@"set", @"info":info} error:nil];
        }
        
        NSLog(@"REQUEST:%@",request);
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            [HUD removeFromSuperview];
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"ok"]) {
                NSLog(@"%@",[responseObject objectForKey:@"用户ID"]);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改成功！" message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"服务器出错" message:[responseObject objectForKey:@"result"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [[NSOperationQueue mainQueue] addOperation:op];
    } else if(_userInfoArray) {//个人信息
        for (int i = 0 ; i < [_userInfoArray count] - 1; i ++) {
            info = [info stringByAppendingString:[NSString stringWithFormat:@"%@|", _userInfoArray[i]]];
        }
        info = [info stringByAppendingString:[_userInfoArray lastObject]];
        
        //检查数据的有效性
        if([self checkInfoWith:_userInfoArray]){
            [self updateUserAllInfoWith:_userInfoArray];
           // [self updateUserInfo:_userInfoArray];
        }
    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请等待数据加载完毕" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
//        [alert show];
//        
//        return;
//    }
    
}

-(BOOL)checkInfoWith:(NSArray *)infoArray
{
    NSArray *temparray = @[@"姓名", @"性别", @"年龄",@"邮箱", @"手机号", @"电话号码", @"qq号"];
    for(int i = 0;i < [infoArray count];i++)
    {
        if([[temparray objectAtIndex:i] isEqualToString:@"姓名"]
           ||[[temparray objectAtIndex:i] isEqualToString:@"性别"]
           ||[[temparray objectAtIndex:i] isEqualToString:@"年龄"])
        {
            if([[infoArray objectAtIndex:i] isEqualToString:@""] || ![infoArray objectAtIndex:i])
            {   //不允许为空
                [self showAlertWithInfo:[NSString stringWithFormat:@"请输入%@",[temparray objectAtIndex:i]]];
                return false;
            }
        }
        else if([[temparray objectAtIndex:i] isEqualToString:@"手机号"])
        {//检验手机号
            if([[infoArray objectAtIndex:i] isEqualToString:@""] || ![infoArray objectAtIndex:i])
            {   //不允许为空
                [self showAlertWithInfo:[NSString stringWithFormat:@"请输入%@",[temparray objectAtIndex:i]]];
                return false;
            }
            else{
                if(![ValidateTool isMobileNumber:[infoArray objectAtIndex:i]])
                {
                    [self showAlertWithInfo:@"请输入有效的手机号!"];
                    return false;
                }
            }
        }
        else if([[temparray objectAtIndex:i] isEqualToString:@"邮箱"])
        {//检验邮箱，要么为空，要么正规！
            if(![ValidateTool isValidateEmail:[infoArray objectAtIndex:i]])
            {
                [self showAlertWithInfo:@"请输入有效的邮箱!"];
                return false;
            }
        }
    }
    return true;
}

/**
 @[@"姓名", @"性别", @"年龄",@"邮箱", @"手机号", @"电话号码", @"qq号"];
 */
#pragma mark - 整体更新用户信息
-(void)updateUserAllInfoWith:(NSArray *)info
{
    if(_index == 0)
    {
        [self showProgressDialog];
        NSMutableURLRequest *request;
        
        //更新个人信息
        request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@",Main_Domain,@"/api/user/update"] parameters:@{@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"], @"name":[info objectAtIndex:0],@"gender":[info objectAtIndex:1],@"age":[info objectAtIndex:2],@"email":[info objectAtIndex:3],@"phone":[info objectAtIndex:4],@"telephone":[info objectAtIndex:5], @"qq":[info objectAtIndex:6]} error:nil];
        
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            [HUD removeFromSuperview];
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"ok"]) {
                NSLog(@"%@",[responseObject objectForKey:@"用户ID"]);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"修改成功，是否调整支付宝信息编辑页面？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"稍等",nil];
                alert.tag = 1212;
                [alert show];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"服务器出错" message:[responseObject objectForKey:@"result"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [HUD removeFromSuperview];
            NSLog(@"Error: %@", error);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"服务器异常！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }];
        [[NSOperationQueue mainQueue] addOperation:op];
    }
}

#pragma mark - 更加key一条一条更新用户信息
- (void)updateInfoForKey:(NSString *)key value:(NSString *)value{
    key = [key isEqualToString:@"年龄"] ? @"出生日期" : key;
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"UpdateUserInfo", @"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"], @"key":key, @"value":value} error:nil];
    NSLog(@"REQUEST:%@",request);
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"JSON: %@", responseObject);
        
        NSLog(@"%@", [_mainInfoDic valueForKey:key]);
        [_mainInfoDic setValue:value forKey:key];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"信息错误" message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alert show];
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
}

#pragma mark - 获取用户信息
- (void)loadUserInfo {
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"GetUserInfo",@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} error:nil];
    NSLog(@"REQUEST:%@",request);
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"JSON: %@", responseObject);
        /*
		 * {"健康证照片正面":"","result":"ok","是否显示推荐人":"","简介":"",
		 * "姓名":"涂Ty","status":"ok","学生证照片":"","用户名":"tuyuanyuan",
		 * "用户密码":"608819ty","身份证号":"","电话号码":"","身份证照片正面":"",
		 * "性别":"女","健康证照片反面":"","身份证照片反面":"",
		 * "手机号":"13972372582","qq号":"","头像":"","出生日期":"","邮箱":""}
		 * */
        if(responseObject){
            self.mainInfoDic = [responseObject mutableCopy];
            
            _userInfoArray = [[NSMutableArray alloc] initWithObjects:_mainInfoDic[@"姓名"], ![_mainInfoDic[@"性别"] isEqualToString:@""]?_mainInfoDic[@"性别"]:@"女",_mainInfoDic[@"出生日期"],_mainInfoDic[@"邮箱"],_mainInfoDic[@"手机号"],_mainInfoDic[@"电话号码"],_mainInfoDic[@"qq号"], nil];
            
            if ([_mainInfoDic[@"性别"] isEqualToString:@"男"]) {
                _genderSwitch.selectedSegmentIndex = 0;
            } else {
                _genderSwitch.selectedSegmentIndex = 1;
            }
        }
        else
        {
            
        }
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"Error: %@", error);
        [self.tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
}

#pragma mark - 获取银行卡的信息
- (void)loadCreditCardInfo {
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"CreditCard", @"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"], @"operation":@"get"} error:nil];
    NSLog(@"REQUEST:%@",request);
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"JSON: %@", responseObject);
        self.mainInfoDic = [responseObject mutableCopy];
        _bankInfos = [[NSMutableArray alloc] initWithObjects:_mainInfoDic[@"账户类型"], _mainInfoDic[@"开户姓名"],_mainInfoDic[@"开户银行"],_mainInfoDic[@"所在城市"],_mainInfoDic[@"所属支行"],_mainInfoDic[@"银行账号"],@"", nil];
        
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"Error: %@", error);
        [self.tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
}

#pragma mark - 获取支付宝的信息
- (void)loadAlipayInfo {
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"] parameters:@{@"action":@"PayPal", @"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"], @"operation":@"get"} error:nil];
    NSLog(@"REQUEST:%@",request);
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"JSON: %@", responseObject);
        self.mainInfoDic = [responseObject mutableCopy];
        _bankInfos = [[NSMutableArray alloc] initWithObjects:_mainInfoDic[@"账户类型"], _mainInfoDic[@"用户名"],_mainInfoDic[@"银行账号"],@"", nil];
        
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"Error: %@", error);
        [self.tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
}

#pragma mark - 更新图片
- (void)uploadPhotoForKey:(NSString *)key imageData:(NSData *)imageData{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                 @"key":key,
                                 @"value":[imageData base64Encoding]
                                 };
    NSString *postURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"rootURL"];
    postURL = [postURL stringByAppendingString:@"?action=UpdateUserImg"];
    
    [manager POST:postURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSLog(@"%@", formData);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        [self loadUserInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1212)
    {
        switch (buttonIndex) {
            case 1:
                [self.navigationController popViewControllerAnimated:YES];
                break;
            case 0:
            {
                JABasicInfoTableViewController *vc = [[JABasicInfoTableViewController alloc] init];
                vc.title = @"支付宝";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}
@end
