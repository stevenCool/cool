//
//  Utility.m
//  SoundShare
//
//  Created by steven on 11/23/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import "Utility.h"

static Utility *utility = nil;

@implementation Utility
@synthesize asyncSocket;
@synthesize sinaweibo = sinaweibo;
@synthesize isWeiboAvailable = _isWeiboAvailable;
@synthesize postStatusText = postStatusText;
@synthesize addressBook = addressBook;
@synthesize isAddressBookAvailable = _isAddressBookAvailable;

+(Utility*)GetInstance{
	@synchronized(self) {
		if(utility == nil) {
			utility = [[self alloc] init];
		}
	}
	return utility;
}

- (id)init{
    if (self = [super init]) {
        //init Socket
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
        NSString *host = HOST;
        uint16_t port = PORT;
        DDLogInfo(@"Initialize socket \"%@\" on port %hu...", host, port);

        //init Weibo
		sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
        if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
        {
            sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
            sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
            sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
        }
        
        if ([sinaweibo isAuthValid]) {
            NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
            _isWeiboAvailable = YES;
        }
	}
	return self;
}

-(void)removeAlertWindow{
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        NSArray* subviews = window.subviews;
        if ([subviews count] > 0)
            if ([[subviews objectAtIndex:0] isKindOfClass:[UIAlertView class]])
                [(UIAlertView *)[subviews objectAtIndex:0] dismissWithClickedButtonIndex:[(UIAlertView *)[subviews objectAtIndex:0] cancelButtonIndex] animated:NO];
    }
}

- (void)parseAction{

}

@end
