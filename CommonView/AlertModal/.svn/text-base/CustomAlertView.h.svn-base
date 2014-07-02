//
//  CustomAlertView.h
//  JieXinIphone
//
//  Created by tony on 14-2-21.
//  Copyright (c) 2014年 sunboxsoft. All rights reserved.
//

typedef enum
{
   Department_Style = 1,
   User_Style,
    Group_Style,
    Update_Style,
    MustUpdate_style
}CustomAlertStyle;

typedef enum
{
    ContactBtn_addPerson = 0,//增加联系人
    ContactBtn_sendMess =1 ,//发送消息
    ContactBtn_callMobile = 2,//拨手机
    ContactBtn_callPhone = 3,//拨座机
}ContactBtnStyle;

#define kAlertShowTag 110
#define kAlertUnShowTag 111

#import <UIKit/UIKit.h>
#import "Department.h"
#import "User.h"
#import "KGModal.h"
#import "UIImageView+WebCache.h"
@protocol CustomeAlertViewDelegate ;
@interface CustomAlertView : UIView
{
    NSMutableDictionary *groupInfo;
}

@property(assign,nonatomic)id<CustomeAlertViewDelegate> delegate;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSMutableDictionary *groupInfo;
-(id)initWithAlertStyle:(CustomAlertStyle)style withObject:(id)object;
@end

@protocol CustomeAlertViewDelegate
@optional
-(void)CustomeAlertViewDismiss:(CustomAlertView *) alertView withBtnIndex:(NSInteger)index;
-(void)CustomeAlertViewDismiss:(CustomAlertView *) alertView;

-(void)contactAlertViewWith:(id)object withStyel:(ContactBtnStyle)style;

-(void)groupChat:(Department *)deparment;
-(void)sendGroupMess:(Department *)department;
-(void)groupMember:(NSMutableDictionary *)dic andType:(WhatTodo)operateType;
-(void)update;
-(void)hintOrNotTransmission:(BOOL)status;

@end
