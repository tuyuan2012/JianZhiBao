//
//  ValidateTool.h
//  JASidePanels
//
//  Created by tony on 14-7-22.
//
//

#import <Foundation/Foundation.h>

@interface ValidateTool : NSObject
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)isValidateEmail:(NSString *)email;
@end
