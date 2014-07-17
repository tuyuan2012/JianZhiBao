//
//  MainStatic.h
//  JASidePanels
//
//  Created by tony on 14-7-15.
//
//
/*
    存放所有的宏
 */

#import <Foundation/Foundation.h>

#define kScreen_Height   [[UIScreen mainScreen] bounds].size.height
#define kScreen_Width    [[UIScreen mainScreen] bounds].size.width

#define kUserInfoFull_Warm_Mess  @"您的个人信息不完整，请进行编辑！"
#define kPayInfo_Warm_Mess @"修改成功，请立刻完善支付信息，方便兼职结束之后给您直接支付！"

//所有涉及的key
/*******百度社会化********/
#define APP_KEY @"RkduGAZnNBMfQjof6HjfRGYO"   //你自己的应用百度社会化分享的api key
/*******微信************/
#define kWeiXin_APP_KEY @"wx8d1397c7f46ba8a6"
#define kWeiXin_APP_Secret @"18f59249d63fd093dcd622108181bef0"
/*******QQ：腾讯微博、QQ空间*******/
#define kTenXunWeibo_APP_ID @"1101260326"
#define kTenXunWeibo_APP_Secret @"SYqp6ZfbGINxMOvb"
/********QQ空间*******/
#define kQQ_APP_ID  @"1101260326"
#define kQQ_APP_KEY  @"SYqp6ZfbGINxMOvb"
/********人人*********/
#define kRenRen_APP_Id @"269971"
#define kRenRen_APP_Key @"f75a8a846d634db2bafda7906ff65481"
#define kRenRen_APP_Secret @"2e3d4cb3f6ce41ecb24a7120885b312e"


//[MobClick startWithAppkey:@"536b96ad56240b0a65023564"];
#define YouMengAPP_Key @"536b96ad56240b0a65023564" //友盟上应用的key
#define kIsUserInfoFull  @"kIsUserInfoFull"  //用户个人信息是否完善
#define kITUNES_LINK  @"http://itunes.apple.com/app/id844687136"

//主题颜色
#define kMAIN_THEME_COLOR [UIColor colorWithRed:0/255.0 green:149/255.0 blue:222/255.0 alpha:1.0]
//安全释放
#define RELEASE_SAFELY(_POINTER) if (nil != (_POINTER)){[_POINTER release];_POINTER = nil; }

#define Main_TestDomain @"http://mark2007081021.oicp.net/sulai-api/Client_v1.1.ashx"
#define Main_Domain     @"http://mark2007081021.oicp.net/sulai-api/Client_v1.1.ashx"
