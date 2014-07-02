//
//  JARightCell.m
//  JASidePanels
//
//  Created by syy on 14-3-3.
//
//

#import "JARightCell.h"

@implementation JARightCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor grayColor];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 160, 20)];
        self.title.font = [UIFont boldSystemFontOfSize:12.0f];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.textColor = [UIColor whiteColor];
        [self addSubview:self.title];
        
        self.describe = [[UILabel alloc] initWithFrame:CGRectMake(80, 25, 200, 20)];
        self.describe.font = [UIFont boldSystemFontOfSize:11.0f];
        self.describe.backgroundColor = [UIColor clearColor];
        self.describe.textColor = [UIColor whiteColor];
        [self addSubview:self.describe];
        
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(215, 15, 100, 20)];
        self.price.font = [UIFont boldSystemFontOfSize:11.0f];
        self.price.backgroundColor = [UIColor clearColor];
        self.price.textColor = [UIColor whiteColor];
        [self.price setTextAlignment:NSTextAlignmentRight];
        [self addSubview:self.price];
        
        self.credit = [[UILabel alloc] initWithFrame:CGRectMake(135, 25, 200, 20)];
        self.credit.font = [UIFont boldSystemFontOfSize:11.0f];
        self.credit.backgroundColor = [UIColor clearColor];
        self.credit.textColor = [UIColor whiteColor];
        [self addSubview:self.credit];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
