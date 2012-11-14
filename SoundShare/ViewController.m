//
//  ViewController.m
//  SoundShare
//
//  Created by steven on 10/25/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize sinaweibo = sinaweibo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
        [self sinaweiboDidLogIn:sinaweibo];
    }

//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    
//    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
//    NSString *host = HOST;
//    uint16_t port = PORT;
//    
//    DDLogInfo(@"Connecting to \"%@\" on port %hu...", host, port);
//    //self.viewController.label.text = @"Connecting...";
//    
//    NSError *error = nil;
//    if (![asyncSocket connectToHost:host onPort:port error:&error])
//    {
//        DDLogError(@"Error connecting: %@", error);
//        //self.viewController.label.text = @"Oops";
//    }
    
    //[self resetButtons];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Socket Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	DDLogInfo(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
	//self.viewController.label.text = @"Connected";
	
    DDLogInfo(@"localHost :%@ port:%hu", [sock localHost], [sock localPort]);
    
    NSString *requestStr = [NSString stringWithFormat:@"Client\r\n"];
	NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    [sock writeData:requestData withTimeout:-1 tag:0];
    
    [sock readDataWithTimeout:-1 tag:0];
    //    NSLog(@"didConnectToHost------beginReadData");
    //    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
    //    NSLog(@"didConnectToHost------endReadData");
    
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
	DDLogInfo(@"socketDidSecure:%p", sock);
	//self.viewController.label.text = @"Connected + Secure";
	
	NSString *requestStr = [NSString stringWithFormat:@"GET / HTTP/1.1\r\nHost: %@\r\n\r\n", HOST];
	NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
	
	[sock writeData:requestData withTimeout:-1 tag:0];
	[sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	DDLogInfo(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	DDLogInfo(@"socket:%p didReadData:withTag:%ld", sock, tag);
	
	NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	DDLogInfo(@"HTTP Response:\n%@", httpResponse);
    
    NSString *requestStr = [NSString stringWithFormat:@"Hello received!\r\n"];
	NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    [sock writeData:requestData withTimeout:-1 tag:0];
    
    if ([self respondsToSelector:@selector(postStatusButtonPressed:)])
    {
        [self postStatusButtonPressed:nil];
    }
    
	[sock readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	DDLogInfo(@"socketDidDisconnect:%p withError: %@", sock, err);
	//self.viewController.label.text = @"Disconnected";
}


@end
