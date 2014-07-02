//
//  JAInputUserInfoTableViewController.h
//  JASidePanels
//
//  Created by Stan Zhang on 5/16/14.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface JAInputUserInfoTableViewController : UITableViewController {
    MBProgressHUD *HUD;
}

@property (nonatomic) NSString *taskID;

@end
