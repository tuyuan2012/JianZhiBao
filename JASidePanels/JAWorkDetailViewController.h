//
//  JAWorkDetailViewController.h
//  JASidePanels
//
//  Created by admin on 14-3-4.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JALoginViewController.h"
#import "MBProgressHUD.h"
@interface JAWorkDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) NSString *taskId;
@property (strong, nonatomic) NSMutableDictionary *mainListDic;
@property (strong, nonatomic) UIWebView *mainDetail;
@property (strong, nonatomic) UITableView *mainList;
@property (strong, nonatomic) UILabel *detail;
@property (strong, nonatomic) UILabel *score;
@property (strong, nonatomic) UILabel *price;
@property (strong, nonatomic) UIButton *workState;
@property (strong, nonatomic) UIButton *startWorking;
@property (strong, nonatomic) UIButton *endWorking;

- (id)initWithType:(NSInteger)type;

@end
