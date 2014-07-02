//
//  JAMECell.m
//  JASidePanels
//
//  Created by syy on 14-3-4.
//
//

#import "JAMECell.h"

@implementation JAMECell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 260, 20)];
        self.title.font = [UIFont boldSystemFontOfSize:12.0f];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.textColor = [UIColor blackColor];
        [self addSubview:self.title];
        
        self.time = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 250, 20)];
        self.time.font = [UIFont boldSystemFontOfSize:12.0f];
        self.time.backgroundColor = [UIColor clearColor];
        self.time.textColor = [UIColor blackColor];
        [self addSubview:self.time];
        
        self.credit = [[UILabel alloc] initWithFrame:CGRectMake(258, 15, 40, 20)];
        self.credit.font = [UIFont boldSystemFontOfSize:11.0f];
        self.credit.backgroundColor = [UIColor clearColor];
        self.credit.textColor = [UIColor blackColor];
        [self.credit setTextAlignment:NSTextAlignmentRight];
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
