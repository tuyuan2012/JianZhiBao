//
//  JAMeController.h
//  JASidePanels
//
//  Created by syy on 14-3-3.
//
//

#import <UIKit/UIKit.h>
#import "JAMECell.h"

@interface JAMeController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *jifen;
    UILabel *me;
}

@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableDictionary *mainListDic;
@end
