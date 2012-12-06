//
//  SettingViewController.h
//  SoundShare
//
//  Created by steven on 12/5/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UITableViewController

- (IBAction)Done:(id)sender;
- (void)sinaPressed;
- (void)NotifyRefresh:(NSNotification *)notification;

@end
