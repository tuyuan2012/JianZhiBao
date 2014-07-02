//
//  CustomAlertView.m
//  JieXinIphone
//
//  Created by tony on 14-2-21.
//  Copyright (c) 2014年 sunboxsoft. All rights reserved.
//

#import "CustomAlertView.h"
#import "SynUserIcon.h"
#import "GetContantValue.h"
#define GroupChartCreate 11111
#define SendMessage  22222
#import "SDImageCache.h"
#import "HttpReachabilityHelper.h"
@implementation CustomAlertView
{
    Department *_department;
    UIImageView *_enlargView;
}
@synthesize delegate = _delegate;
@synthesize groupInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithAlertStyle:(CustomAlertStyle)style withObject:(id)object
{
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShow:) name:KGModalWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShow:) name:KGModalDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHide:) name:KGModalWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHide:) name:KGModalDidHideNotification object:nil];
    
    if(self)
    {
        switch (style) {
            case Department_Style:
            {
                _department = (Department *)object;
                [self initDepartmentAlertViewWithDepartment:_department];
            }
                break;
            case User_Style:
            {
                self.user = (User *)object;
                [self initUserAlertViewWithUser:_user];
            }
                break;
            case Group_Style:
            {
                //长按
                self.groupInfo = (NSMutableDictionary *)object;
                [self initGroupAlertViewWithUsers:nil];
            }break;
            case Update_Style:
            {
                NSString *updateInfo = (NSString *)object;
                [self initUpdateAlertViewWithInfomation:updateInfo];
            }break;
            case MustUpdate_style:
            {
                NSString *updateInfo = (NSString *)object;
                [self initMustUpdateAlertViewWithInfomation:updateInfo];
            }break;
                
            default:
                break;
        }
    }
    return self;
}

- (void)dealloc
{
    self.user = nil;
    self.groupInfo = nil;
    RELEASE_SAFELY(_department);
    RELEASE_SAFELY(_enlargView);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void)initDepartmentAlertViewWithDepartment:(Department *)department
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    
    CGFloat marginX = 15.0f;
    CGFloat labelHeigth = 50.0f;
    
    //背景
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(contentView.frame), CGRectGetHeight(contentView.frame))];
    imageView.image = [UIImage imageNamed:@"tanchu_bg2.png"];
    [contentView addSubview:imageView];
    [imageView release];
    
    //弹跳框的内容
//    UIImageView *leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, marginY, leftIconWidth, leftIconHeight)];
//    leftIcon.image = [UIImage imageNamed:@"list_grouphead_normal.png"];
//    [contentView addSubview:leftIcon];
//    [leftIcon release];
    
    //标题
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, 160.0f, labelHeigth)];
    nameLabel.textColor = kMAIN_THEME_COLOR;
    nameLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 4];
    nameLabel.text = department.departmentname;
    nameLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:nameLabel];
    [nameLabel release];
    
    //多人会话
    UIButton *groupChat = [UIButton buttonWithType:UIButtonTypeCustom];
    [groupChat setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[groupChat setImage:[UIImage imageNamed:@"chat_bottom_bg.png"] forState:UIControlStateNormal];
    [groupChat setTitle:@"多人会话" forState:UIControlStateNormal];
    [groupChat setTintColor:[UIColor clearColor]];
    groupChat.backgroundColor = [UIColor clearColor];
    groupChat.titleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 2];
    [contentView addSubview:groupChat];
    [groupChat setTitleColor:kDarkerGray forState:UIControlStateNormal];
    [groupChat setFrame:CGRectMake(0 , labelHeigth, 200, labelHeigth)];
    groupChat.titleEdgeInsets = UIEdgeInsetsMake(0, -groupChat.titleLabel.bounds.size.width-35, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    [groupChat addTarget:self action:@selector(groupChat:) forControlEvents:UIControlEventTouchUpInside];
    
    //群发短信
    UIButton *groupMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    [groupMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    groupMessage.titleLabel.textAlignment = NSTextAlignmentLeft;
    [groupMessage setTintColor:[UIColor clearColor]];
    groupMessage.backgroundColor = [UIColor clearColor];
    [groupMessage setTitle:@"群发短信" forState:UIControlStateNormal];
    groupMessage.titleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 2];
    [contentView addSubview:groupMessage];
    [groupMessage setTitleColor:kDarkerGray forState:UIControlStateNormal];
    [groupMessage setFrame:CGRectMake(0 , labelHeigth*2, 200, labelHeigth)];
    groupMessage.titleEdgeInsets = UIEdgeInsetsMake(0, -groupMessage.titleLabel.bounds.size.width-35, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    [groupMessage addTarget:self action:@selector(sendGroupMess:) forControlEvents:UIControlEventTouchUpInside];
    
    [[KGModal sharedInstance] setCloseButtonLocation:KGModalCloseButtonLocationRight];
    [[KGModal sharedInstance] setModalBackgroundColor:kMAIN_BACKGROUND_COLOR];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}

-(void)initUserAlertViewWithUser:(User *)user
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 300)];
    
    CGFloat marginX = 15.0f;
    CGFloat labelHeigth = 50.0f;
    //背景
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(contentView.frame), CGRectGetHeight(contentView.frame))];
    imageView.image = [UIImage imageNamed:@"alertView_bg.png"];
    [contentView addSubview:imageView];
    
    //弹跳框的内容
//    UIImageView *leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, marginY, leftIconWidth, leftIconHeight)];
//    if([user.sex isEqualToString:@"0"])
//        leftIcon.image = [UIImage imageNamed:@"user_picture_girl.png"];//女孩
//    else
//        leftIcon.image = [UIImage imageNamed:@"user_picture_boy.png"];//男孩
//    [contentView addSubview:leftIcon];
//    [leftIcon release];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, 25.0/2.0, 25, 25)];
    [self setImageView:headImageView withUserId:user.userid];
    UIButton *enlargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enlargeBtn.frame = CGRectMake(0, 0, 25, 25);
    [enlargeBtn setTitle:@"" forState:UIControlStateNormal];
    [enlargeBtn addTarget:self action:@selector(enlargeView:) forControlEvents:UIControlEventTouchUpInside];
    headImageView.userInteractionEnabled = YES;
    [headImageView addSubview:enlargeBtn];
    [contentView addSubview:headImageView];

    _enlargView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _enlargView.backgroundColor = [UIColor blackColor];
    _enlargView.contentMode = UIViewContentModeCenter;
    
    UIButton *smallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    smallBtn.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    [smallBtn setTitle:@"" forState:UIControlStateNormal];
    [smallBtn addTarget:self action:@selector(removeEnlargeView:) forControlEvents:UIControlEventTouchUpInside];
    _enlargView.userInteractionEnabled = YES;
    [_enlargView addSubview:smallBtn];
    
    //标题
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+5, 0, 120.0f, labelHeigth)];
    nameLabel.textColor = kMAIN_THEME_COLOR;
    nameLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 4];
    nameLabel.text = user.nickname;
    nameLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:nameLabel];
    [nameLabel release];
    
    //下划线
//    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginX + 3, marginY*2 + leftIconHeight, CGRectGetWidth(contentView.frame)- (marginX + 3)*2, 1.5)];
//    lineImageView.image = [UIImage imageNamed:@"blueLine.png"];
//    [contentView addSubview:lineImageView];
//    [lineImageView release];
    
    //签名
    UILabel *signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, labelHeigth, 270, labelHeigth)];
//    signatureLabel.textColor = klightGray;
//    signatureLabel.backgroundColor = [UIColor clearColor];
//    signatureLabel.font = [UIFont boldSystemFontOfSize:kCommonFont];
//    signatureLabel.text = @"签名 : ";
//    [contentView addSubview:signatureLabel];
//    [signatureLabel release];
    
    //signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, labelHeigth+labelHeigth/2.0, 300, labelHeigth/2.0)];
    signatureLabel.backgroundColor = [UIColor clearColor];
    signatureLabel.numberOfLines = 2;
    signatureLabel.textColor = kDarkGray;
    signatureLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 2];
    if(!user.field_char1 || [user.field_char1 isEqualToString:@""])
        signatureLabel.text = @"这家伙很懒，暂时没有发表心情!";
    else
        signatureLabel.text = [NSString stringWithFormat:@"%@",user.field_char1];
    [contentView addSubview:signatureLabel];
    [signatureLabel release];
    
    //部门
    UILabel *departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, labelHeigth*2, 200, labelHeigth/2.0)];
    departmentLabel.textColor = klightGray;
    departmentLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont];
    departmentLabel.text = @"部门 : ";
    departmentLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:departmentLabel];
    [departmentLabel release];
    
    departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, labelHeigth*2+labelHeigth/2.0, 200, labelHeigth/2.0)];
    departmentLabel.textColor = kDarkGray;
    departmentLabel.backgroundColor = [UIColor clearColor];
    departmentLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 2];
    departmentLabel.text = user.deparment.departmentname;
    [contentView addSubview:departmentLabel];
    [departmentLabel release];
    
    //职务
    UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, labelHeigth*3, 200, labelHeigth/2.0)];
    positionLabel.textColor = klightGray;
    positionLabel.backgroundColor = [UIColor clearColor];
    positionLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont ];
    positionLabel.text = @"职务 : ";
    [contentView addSubview:positionLabel];
    [positionLabel release];
    
    positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, labelHeigth*3+labelHeigth/2.0, 200, labelHeigth/2.0)];
    positionLabel.textColor = kDarkGray;
    positionLabel.backgroundColor = [UIColor clearColor];
    positionLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 2];
    positionLabel.text = user.usersig;
    [contentView addSubview:positionLabel];
    [positionLabel release];
    
    //手机
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, labelHeigth*4, 100, labelHeigth/2.0)];
    telLabel.textColor = klightGray;
    telLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont];
    telLabel.text = @"手机 : ";
    telLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:telLabel];
    [telLabel release];
    
    telLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, labelHeigth*4+labelHeigth/2.0, 150, labelHeigth/2.0)];
    telLabel.textColor = kDarkGray;
    telLabel.backgroundColor = [UIColor clearColor];
    telLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 2];
    telLabel.text = user.mobile;
    [contentView addSubview:telLabel];
    [telLabel release];
    
    //三个按钮
    CGFloat btnWidth = 25.0f;
    for(int index = 0 ;index < 3;index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(160-10+btnWidth*index+25*index, labelHeigth*4+labelHeigth/4.0, labelHeigth/2.0, labelHeigth/2.0)];
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        button.tag = index;
        switch (index) {
            case 0:
            {
                [button setImage:[UIImage imageNamed:@"add_contact_btn_normal.png"] forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                [button setImage:[UIImage imageNamed:@"tab_sms_normal.png"] forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                [button setImage:[UIImage imageNamed:@"tab_dial_normal.png"] forState:UIControlStateNormal];
                [button setFrame:CGRectMake(160-10+btnWidth*index+25*index, labelHeigth*4+labelHeigth/4.0, 15, labelHeigth/2.0)];
            }
                break;
            default:
                break;
        }
    }
    
    //固定电话
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, labelHeigth*5, 100, labelHeigth/2.0)];
    phoneLabel.textColor = klightGray;
    phoneLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont];
    phoneLabel.text = @"固话 : ";
    [contentView addSubview:phoneLabel];
    [phoneLabel release];
    
    phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, labelHeigth*5+labelHeigth/2.0, 150, labelHeigth/2.0)];
    phoneLabel.textColor = kDarkGray;
    phoneLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 2];
    phoneLabel.backgroundColor = [UIColor clearColor];
    phoneLabel.text = user.telephone;
    [contentView addSubview:phoneLabel];
    [phoneLabel release];
    
    //两个按钮
    for(int i = 3 ;i < 5;i++)
    {
        int index = i-3;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(160+40+btnWidth*index+25*index, labelHeigth*5+labelHeigth/4.0, labelHeigth/2.0, labelHeigth/2.0)];
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        button.tag = i;
        switch (i) {
            case 3:
            {
                [button setImage:[UIImage imageNamed:@"add_contact_btn_normal.png"] forState:UIControlStateNormal];
            }
                break;
            case 4:
            {
                [button setImage:[UIImage imageNamed:@"tab_dial_normal.png"] forState:UIControlStateNormal];
                [button setFrame:CGRectMake(160+40+btnWidth*index+25*index, labelHeigth*5+labelHeigth/4.0, 15, labelHeigth/2.0)];
            }
                break;
            default:
                break;
        }
    }
    
    //邮箱
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, labelHeigth*6, 200, labelHeigth/2.0)];
    emailLabel.textColor = klightGray;
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont];
    emailLabel.text = @"邮箱 : ";
    [contentView addSubview:emailLabel];
    [emailLabel release];
    
    emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, labelHeigth*6+labelHeigth/2.0, 280, labelHeigth/2.0)];
    emailLabel.textColor = kDarkGray;
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 2];
    emailLabel.text = user.email;
    [contentView addSubview:emailLabel];
    [emailLabel release];
    
    //传真
    UILabel *faxLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, labelHeigth*7, 200, labelHeigth/2.0)];
    faxLabel.textColor = klightGray;
    faxLabel.backgroundColor = [UIColor clearColor];
    faxLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont];
    faxLabel.text = @"传真 : ";
    [contentView addSubview:faxLabel];
    [faxLabel release];
    
    faxLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, labelHeigth*7+labelHeigth/2.0, 280, labelHeigth/2.0)];
    faxLabel.textColor = kDarkGray;
    faxLabel.backgroundColor = [UIColor clearColor];
    faxLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 2];
    faxLabel.text = user.field_char2;
    [contentView addSubview:faxLabel];
    [faxLabel release];

    
    
    //下划线
    for(int i = 1;i<8;i++)
    {
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, labelHeigth*i, 280, 1.5)];
        [contentView addSubview:lineImageView];
        if(i == 1)
            lineImageView.image = [UIImage imageNamed:@"line_green.png"];
        else
            lineImageView.image = [UIImage imageNamed:@"line_gray.png"];
        [lineImageView release];
    }
    
    [contentView setFrame:CGRectMake(0, 0, 280,CGRectGetMaxY(faxLabel.frame))];
    [imageView setFrame:contentView.frame];
    [[KGModal sharedInstance] setCloseButtonLocation:KGModalCloseButtonLocationRight];
    [[KGModal sharedInstance] setModalBackgroundColor:kMAIN_BACKGROUND_COLOR];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}

-(void)initGroupAlertViewWithUsers:(NSString *)groupid
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    
    CGFloat marginX = 15.0f;
    CGFloat labelHeigth = 50.0f;
    
    //背景
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(contentView.frame), CGRectGetHeight(contentView.frame))];
    imageView.image = [UIImage imageNamed:@"tanchu_bg2.png"];
    [contentView addSubview:imageView];
    [imageView release];
    
    //弹跳框的内容
    //    UIImageView *leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, marginY, leftIconWidth, leftIconHeight)];
    //    leftIcon.image = [UIImage imageNamed:@"list_grouphead_normal.png"];
    //    [contentView addSubview:leftIcon];
    //    [leftIcon release];
    
    //标题
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, 120.0f, labelHeigth)];
    nameLabel.textColor = kMAIN_THEME_COLOR;
    nameLabel.font =[UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 4];
    nameLabel.text = @"群组操作";
    nameLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:nameLabel];
    [nameLabel release];
    
    //多人会话
    UIButton *groupChat = [UIButton buttonWithType:UIButtonTypeCustom];
    [groupChat setTitleColor:kDarkerGray forState:UIControlStateNormal];
    //[groupChat setImage:[UIImage imageNamed:@"chat_bottom_bg.png"] forState:UIControlStateNormal];
    [groupChat setTitle:@"多人会话" forState:UIControlStateNormal];
    [groupChat setTag:GroupChartCreate];
    [groupChat setTintColor:[UIColor clearColor]];
    groupChat.backgroundColor = [UIColor clearColor];
    groupChat.titleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 2];
    [contentView addSubview:groupChat];
//    [groupChat setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [groupChat setFrame:CGRectMake(0 , labelHeigth, 200, labelHeigth)];
    groupChat.titleEdgeInsets = UIEdgeInsetsMake(0, -groupChat.titleLabel.bounds.size.width-35, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    [groupChat addTarget:self action:@selector(groupMember:) forControlEvents:UIControlEventTouchUpInside];
    
    //群发短信
    UIButton *groupMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    [groupMessage setTitleColor:kDarkerGray forState:UIControlStateNormal];
    groupMessage.titleLabel.textAlignment = NSTextAlignmentLeft;
    [groupMessage setTintColor:[UIColor clearColor]];
    [groupMessage setTag:SendMessage];
    groupMessage.backgroundColor = [UIColor clearColor];
    [groupMessage setTitle:@"群发短信" forState:UIControlStateNormal];
//    [groupMessage setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    groupMessage.titleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 2];
    [contentView addSubview:groupMessage];
    [groupMessage setFrame:CGRectMake(0 , labelHeigth*2, 200, labelHeigth)];
    groupMessage.titleEdgeInsets = UIEdgeInsetsMake(0, -groupMessage.titleLabel.bounds.size.width-35, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    [groupMessage addTarget:self action:@selector(groupMember:) forControlEvents:UIControlEventTouchUpInside];
    
    [[KGModal sharedInstance] setCloseButtonLocation:KGModalCloseButtonLocationRight];
    [[KGModal sharedInstance] setModalBackgroundColor:kMAIN_BACKGROUND_COLOR];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}


-(void)initUpdateAlertViewWithInfomation:(NSString *)info
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 270)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat margin = 15.0f;
    CGFloat labelHeigth = 45.0f;
    CGFloat textViewHeight = 130.0f;
    CGFloat buttonWidth = 120.0f;
    CGFloat buttonHeight = 45.0f;
    
    //背景
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, labelHeigth, CGRectGetWidth(contentView.frame), 1)];
    imageView.image = [UIImage imageNamed:@"line_green.png"];
    [contentView addSubview:imageView];
    [imageView release];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), CGRectGetWidth(contentView.frame), textViewHeight)];
    textView.editable = NO;
    NSString *msg = info;
    textView.text = msg;

    textView.textColor = kDarkerGray;
    textView.font =[UIFont systemFontOfSize:kCommonFont+2];
    [contentView addSubview:textView];
    [textView release];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(5, CGRectGetMaxY(textView.frame), 20, 20);
    [selectBtn setImage:[UIImage imageNamed:@"fuxuan_1.png"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"fuxuan_2.png"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:selectBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(textView.frame), 240, 20)];
    label.text = @"以后不再提示";
    label.textColor = kDarkerGray;
    label.font = [UIFont systemFontOfSize:kCommonFont];
    [contentView addSubview:label];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(selectBtn.frame)+1, CGRectGetWidth(contentView.frame), 1)];
    imageView2.image = [UIImage imageNamed:@"line_gray.png"];
    [contentView addSubview:imageView2];
    
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    updateBtn.frame = CGRectMake(margin, CGRectGetMaxY(imageView2.frame)+margin, buttonWidth, buttonHeight);
    [updateBtn setImage:[UIImage imageNamed:@"shengji.png"] forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(update:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:updateBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(CGRectGetMaxX(updateBtn.frame)+margin, CGRectGetMaxY(imageView2.frame)+margin, buttonWidth, buttonHeight);
    [cancelBtn setImage:[UIImage imageNamed:@"shaohou.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    
    //标题
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, 120.0f, labelHeigth)];
    nameLabel.textColor = kMAIN_THEME_COLOR;
    nameLabel.font =[UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 4];
    nameLabel.text = @"企信升级提醒";
    nameLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:nameLabel];
    [nameLabel release];
    
    
    [[KGModal sharedInstance] setCloseButtonLocation:KGModalCloseButtonLocationRight];
    [[KGModal sharedInstance] setModalBackgroundColor:kMAIN_BACKGROUND_COLOR];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}

-(void)initMustUpdateAlertViewWithInfomation:(NSString *)info
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 270)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat margin = 15.0f;
    CGFloat labelHeigth = 45.0f;
    CGFloat textViewHeight = 130.0f;
    CGFloat buttonWidth = 120.0f;
    CGFloat buttonHeight = 45.0f;
    
    //背景
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, labelHeigth, CGRectGetWidth(contentView.frame), 1)];
    imageView.image = [UIImage imageNamed:@"line_green.png"];
    [contentView addSubview:imageView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), CGRectGetWidth(contentView.frame), textViewHeight)];
    textView.editable = NO;
    NSString *msg = info;
    textView.text = msg;
    
    textView.textColor = kDarkerGray;
    textView.font =[UIFont systemFontOfSize:kCommonFont+2];
    [contentView addSubview:textView];
    [textView release];
    
//    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    selectBtn.frame = CGRectMake(5, CGRectGetMaxY(textView.frame), 20, 20);
//    [selectBtn setImage:[UIImage imageNamed:@"fuxuan_1.png"] forState:UIControlStateNormal];
//    [selectBtn setImage:[UIImage imageNamed:@"fuxuan_2.png"] forState:UIControlStateSelected];
//    [selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [contentView addSubview:selectBtn];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(textView.frame), 240, 20)];
//    label.text = @"以后不再提示";
//    label.textColor = kDarkerGray;
//    label.font = [UIFont systemFontOfSize:kCommonFont];
//    [contentView addSubview:label];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textView.frame)+1, CGRectGetWidth(contentView.frame), 1)];
    imageView2.image = [UIImage imageNamed:@"line_gray.png"];
    [contentView addSubview:imageView2];
    [imageView2 release];
    
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    updateBtn.frame = CGRectMake(buttonWidth/2, CGRectGetMaxY(imageView2.frame)+margin, CGRectGetWidth(contentView.frame)/2, buttonHeight);
    [updateBtn setImage:[UIImage imageNamed:@"shengji.png"] forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(update:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:updateBtn];
    
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelBtn.frame = CGRectMake(CGRectGetMaxX(updateBtn.frame)+margin, CGRectGetMaxY(imageView2.frame)+margin, buttonWidth, buttonHeight);
//    [cancelBtn setImage:[UIImage imageNamed:@"shaohou.png"] forState:UIControlStateNormal];
//    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [contentView addSubview:cancelBtn];
    
    //标题
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, 120.0f, labelHeigth)];
    nameLabel.textColor = kMAIN_THEME_COLOR;
    nameLabel.font =[UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 4];
    nameLabel.text = @"企信强制升级提醒";
    nameLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:nameLabel];
    [nameLabel release];
    
    
    [[KGModal sharedInstance] setCloseButtonLocation:KGModalCloseButtonLocationRight];
    [[KGModal sharedInstance] setModalBackgroundColor:kMAIN_BACKGROUND_COLOR];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}


- (void)cancelBtn:(UIButton *)sender
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"KGModalGradientViewTapped" object:nil];
}

- (void)selectBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self.delegate hintOrNotTransmission:sender.selected];
}

- (void)update:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KGModalGradientViewTapped" object:nil];
    [self.delegate update];
}

#pragma mark - btn methods
-(void)groupChat:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KGModalGradientViewTapped" object:nil];
    [self.delegate groupChat:_department];
}

-(void)sendGroupMess:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KGModalGradientViewTapped" object:nil];
    [self.delegate sendGroupMess:_department];
}

- (void)groupMember:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KGModalGradientViewTapped" object:nil];
    if (sender.tag == GroupChartCreate)
    {
        [self.delegate groupMember:groupInfo andType:GroupChat];
    }
    else
    {
        [self.delegate groupMember:groupInfo andType:SendMess];
    }
}

-(void)clickBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KGModalGradientViewTapped" object:nil];
    switch (sender.tag) {
        case 0:{
            NSLog(@"手机 增加联系人");
            [self.delegate contactAlertViewWith:_user withStyel:ContactBtn_addPerson];
        }
            break;
        case 1:{
            [self.delegate contactAlertViewWith:_user withStyel:ContactBtn_sendMess];
            NSLog(@"手机 短信");
        }
            break;
        case 2:{
            [self.delegate contactAlertViewWith:_user withStyel:ContactBtn_callMobile];
            NSLog(@"手机 打电话");
        }
            break;
        case 3:{
            [self.delegate contactAlertViewWith:_user withStyel:ContactBtn_addPerson];
            NSLog(@"电话 添加人");
        }
            break;
        case 4:{
            [self.delegate contactAlertViewWith:_user withStyel:ContactBtn_callPhone];
            NSLog(@"电话 打电话");
        }
            break;
        default:
            break;
    }
}

-(void)setImageView:(UIImageView *)iconImageView withUserId:(NSString *)id
{
    if(![id isEqualToString:@""]){
        [iconImageView setImage:[self getImageViewUserId:id withImageView:iconImageView]];
    }
}

-(UIImage *)getImageViewUserId:(NSString *)id withImageView:(UIImageView *)iconImageView
{
    if(![id isEqualToString:@""]){
        //看某文件是否存在
        NSString *filePath = [NSString stringWithString:[NSString stringWithFormat:@"%@/%@.jpg",[[SynUserIcon sharedManager] getCurrentUserBigIconPath],id]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath] != NO) {
            return [UIImage imageWithContentsOfFile:filePath];
        }
        else
        {
            if([_user.sex isEqualToString:@"1"])
                return [UIImage imageNamed:@"m_online.png"];
            else
                return [UIImage imageNamed:@"fm_online.png"];
        }
    }
    return nil;
}

-(void)enlargeView:(UIButton *)sender
{
    NSString *mainURL = [[NSUserDefaults standardUserDefaults] objectForKey:Main_Domain];
    NSString *domainid = [GetContantValue getDomaiId];
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/webimadmin/uploads/avatarSuper/domain_%@/%@.jpg",mainURL,domainid,self.user.userid];
    if([[HttpReachabilityHelper sharedService] checkNetwork:@""]){
        //有网则下载（先删除本地的），没网则优先读取本地的（没有则下载）
        [[SDImageCache sharedImageCache] removeImageForKey:urlStr];
    }
    [_enlargView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[self getImageViewUserId:self.user.userid withImageView:nil]];
    //全屏
    NSArray* windows = [UIApplication sharedApplication].windows;
    UIWindow *currentWindow = [windows objectAtIndex:1];
    [currentWindow addSubview:_enlargView];
}

-(void)removeEnlargeView:(UIButton *)sender
{
    [_enlargView removeFromSuperview];
}


#pragma mark - notification method
- (void)willShow:(NSNotification *)notification{
    NSLog(@"will show");
}

- (void)didShow:(NSNotification *)notification{
    NSLog(@"did show");
}

- (void)willHide:(NSNotification *)notification{
    NSLog(@"will hide");
}

- (void)didHide:(NSNotification *)notification{
    NSLog(@"did Hide");
    self.tag = kAlertUnShowTag;
   // [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
