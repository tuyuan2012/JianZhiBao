//
//  JAInfoPhotoTableViewCell.m
//  JASidePanels
//
//  Created by Stan Zhang on 5/12/14.
//
//

#import "JAInfoPhotoTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface JAInfoPhotoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end

@implementation JAInfoPhotoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"JAInfoPhotoTableViewCell" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setKey:(NSString *)key {
    _keyLabel.text = key;
}

- (void)setImageURL:(NSString *)imageURL {
    if ([imageURL length]) {
        
        NSURL *url = [NSURL URLWithString:imageURL];
        
        [_imgView setImageWithURL:url
                 placeholderImage:nil];
    
    }
}

- (NSString *)key {
    return _keyLabel.text;
}



@end
