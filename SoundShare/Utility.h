//
//  Utility.h
//  SoundShare
//
//  Created by steven on 11/23/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "GCDAsyncSocket.h"
#import "MMPDeepSleepPreventer.h"
#import "Constant.h"

static const int ddLogLevel = LOG_LEVEL_INFO;

@interface Utility : NSObject{
    GCDAsyncSocket *asyncSocket;
        
    SinaWeibo *sinaweibo;
    BOOL _isWeiboAvailable;
    
    NSDictionary *userInfo;
    NSArray *statuses;
    NSString *postStatusText;
    NSString *voiceString;
    
    ABAddressBookRef addressBook;
    BOOL _isAddressBookAvailable;
}

@property (readonly, nonatomic) GCDAsyncSocket *asyncSocket;
@property (readonly, nonatomic) SinaWeibo *sinaweibo;
@property (assign, nonatomic) BOOL isWeiboAvailable;
@property (strong, nonatomic) NSString * postStatusText;
@property (assign, nonatomic) ABAddressBookRef addressBook;
@property (assign, nonatomic) BOOL isAddressBookAvailable;

+ (Utility*)GetInstance;
- (void)parseAction;
- (void)removeAlertWindow;

@end

@interface Utility(sina)<SinaWeiboDelegate,SinaWeiboRequestDelegate>

- (void)storeAuthData;
- (void)removeAuthData;

- (void)sinaweiboDidLogIn:(SinaWeibo *)reponseSinaweibo;
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo;
- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo;
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error;
- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error;

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error;
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result;

@end

@interface Utility(socket)
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port;
- (void)socketDidSecure:(GCDAsyncSocket *)sock;
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag;
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err;
@end
