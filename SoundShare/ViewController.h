//
//  ViewController.h
//  SoundShare
//
//  Created by steven on 10/25/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "GCDAsyncSocket.h"
#import "MMPDeepSleepPreventer.h"
#import <AddressBook/AddressBook.h>

#define HOST @"192.168.1.1"
#define PORT 1010

//sinaWeibo
#define kAppKey             @"2817012231"
#define kAppSecret          @"d8eca57fdd2b82ede044985f06e23c39"
#define kAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"

#ifndef kAppKey
#error
#endif

#ifndef kAppSecret
#error
#endif

#ifndef kAppRedirectURI
#error
#endif

#define NoLoginLabel   @"You need to Log in first!"

@interface ViewController : UIViewController
{
    GCDAsyncSocket *asyncSocket;
    
    SinaWeibo *sinaweibo;
    
    ABAddressBookRef addressBook;
    
    //MMPDeepSleepPreventer *sleepPreventer;
    
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *logoutButton;
    
    IBOutlet UILabel  *label;
    IBOutlet UIButton *shareButton;
    
    NSDictionary *userInfo;
    NSArray *statuses;
    NSString *postStatusText;
    NSString *postImageStatusText;
}

@property (readonly, nonatomic) SinaWeibo *sinaweibo;
-(void)outputPhoneNumber;
-(void)showAlertView;

@end

@interface ViewController(sina)<SinaWeiboDelegate,SinaWeiboRequestDelegate>
-(IBAction)loginButtonPressed:(id)sender;
-(IBAction)logoutButtonPressed:(id)sender;
-(IBAction)postStatusButtonPressed:(id)sender;
-(IBAction)postImageStatusButtonPressed:(id)sender;
@end
