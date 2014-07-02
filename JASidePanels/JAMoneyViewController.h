//
//  JAMoneyViewController.h
//  JASidePanels
//
//  Created by syy on 14-3-4.
//
//

#import <UIKit/UIKit.h>
#import "JAMECell.h"
#import "JABillViewController.h"

@interface JAMoneyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *jifen;
    UILabel *me;
}

@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableDictionary *mainListDic;
@end
