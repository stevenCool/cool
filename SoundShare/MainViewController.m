//
//  MainViewController.m
//  SoundShare
//
//  Created by steven on 11/23/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import "MainViewController.h"
#import "SettingViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
}

- (IBAction)SetAction:(id)sender{
    SettingViewController* controller = [[SettingViewController alloc] init];
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

- (IBAction)ConnectToServer:(id)sender{
    NSString *host = HOST;
    uint16_t port = PORT;
    DDLogInfo(@"Connecting to \"%@\" on port %hu...", host, port);
    NSError *error = nil;
    if (![[Utility GetInstance].asyncSocket connectToHost:host onPort:port error:&error])
    {
        DDLogError(@"Error connecting: %@", error);
    }
}

- (IBAction)DisconnectFromServer:(id)sender{
    NSString *requestStr = [NSString stringWithFormat:@"quit"];
	NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    [[Utility GetInstance].asyncSocket writeData:requestData withTimeout:-1 tag:0];
	[[Utility GetInstance].asyncSocket readDataWithTimeout:-1 tag:0];
    [[Utility GetInstance].asyncSocket disconnect];
}

@end
