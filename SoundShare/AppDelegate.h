//
//  AppDelegate.h
//  SoundShare
//
//  Created by steven on 10/25/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "Utility.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MainViewController* mainViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainViewController;

@end
