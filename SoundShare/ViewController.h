//
//  ViewController.h
//  SoundShare
//
//  Created by steven on 10/25/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "GCDAsyncSocket.h"
#import "MMPDeepSleepPreventer.h"

//#define HOST @"192.168.100.100"
#define HOST @"192.168.1.1"
#define PORT 1010
#define NoLoginLabel   @"You need to Log in first!"

@interface ViewController : UIViewController
{
    GCDAsyncSocket *asyncSocket;
    
    //MMPDeepSleepPreventer *sleepPreventer;
    
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *logoutButton;
    
    IBOutlet UILabel  *label;
    IBOutlet UIButton *shareButton;
    
    NSString *voiceString;
}

-(void)outputPhoneNumber;
-(void)showAlertView;

- (IBAction)Done:(id)sender;
- (IBAction)ConnectToServer:(id)sender;
- (IBAction)DisconnectFromServer:(id)sender;

@end

@interface ViewController(sina)
-(IBAction)loginButtonPressed:(id)sender;
-(IBAction)logoutButtonPressed:(id)sender;
-(IBAction)postStatusButtonPressed:(id)sender;
@end
