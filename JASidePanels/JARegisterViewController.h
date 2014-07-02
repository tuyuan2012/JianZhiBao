//
//  JARegisterViewController.h
//  JASidePanels
//
//  Created by admin on 14-3-2.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
@interface JARegisterViewController : UIViewController <UITextFieldDelegate>
{
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) UITextField *username;
@property (strong, nonatomic) UITextField *password;
@property (strong, nonatomic) UITextField *repeatpassword;
@property (strong, nonatomic) UITextField *phonenumber;
@property (strong, nonatomic) UITextField *idCode;
@property (strong, nonatomic) UIButton *registerButton;
@property (strong, nonatomic) UIButton *yanzhengButton;
@property (strong, nonatomic) UITextField *recommender;

@end
