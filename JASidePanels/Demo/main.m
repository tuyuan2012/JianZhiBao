//
//  main.m
//  JASidePanels
//
//  Created by Jesse Andersen on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JAAppDelegate.h"

int main(int argc, char *argv[])
{
	@autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([JAAppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"CRASH!!!");
            NSLog(@"exception name: %@, exception reason: %@\n", exception.name, exception.reason);
            NSLog(@"stack trace: %@\n", [exception callStackSymbols]);
        }
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([JAAppDelegate class]));
        
	}
}
