//
//  JACenterCell.h
//  JASidePanels
//
//  Created by syy on 14-3-2.
//
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
@interface JACenterCell : UITableViewCell

@property(strong,nonatomic)UIImageView * imageView;
@property(strong,nonatomic)UILabel * title;
@property(strong,nonatomic)UILabel * price;
@property(strong,nonatomic)UILabel * person;
@property(strong,nonatomic)UIImageView * cornermark;

@end