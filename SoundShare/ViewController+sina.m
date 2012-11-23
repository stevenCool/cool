//
//  ViewController.m
//  SoundShare
//
//  Created by steven on 10/25/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController(sina)

-(IBAction)loginButtonPressed:(id)sender
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSLog(@"%@", [keyWindow subviews]);
    [[Utility GetInstance].sinaweibo logIn];
}

-(IBAction)logoutButtonPressed:(id)sender
{
    [[Utility GetInstance].sinaweibo logOut];
}

-(IBAction)postStatusButtonPressed:(id)sender
{
    [Utility GetInstance].postStatusText = [[NSString alloc] initWithFormat:@"test post status : %@", [NSDate date]];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:[NSString stringWithFormat:@"Will post status with text \"%@\"",  [Utility GetInstance].postStatusText]
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    alertView.tag = 0;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView.tag == 0)
        {
            // post status
            [[Utility GetInstance].sinaweibo requestWithURL:@"statuses/update.json"
                               params:[NSMutableDictionary dictionaryWithObjectsAndKeys: [Utility GetInstance].postStatusText, @"status", nil]
                           httpMethod:@"POST"
                             delegate:[Utility GetInstance]];
            
        }
    }
}

- (void)resetButtons
{
    BOOL authValid = [Utility GetInstance].sinaweibo.isAuthValid;
    
    loginButton.enabled = !authValid;
    logoutButton.enabled = authValid;
    
    if (!authValid) {
        label.text = NoLoginLabel;
    }
    else{
        label.text = [Utility GetInstance].sinaweibo.userID;
    }
}

@end
