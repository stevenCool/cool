//
//  AppDelegate.h
//  SoundShare
//
//  Created by steven on 10/25/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
static const int ddLogLevel = LOG_LEVEL_INFO;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    ViewController* viewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

@end
