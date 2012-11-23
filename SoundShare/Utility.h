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

#define NotificationNeedRefresh @"NotificationNeedRefresh"

static const int ddLogLevel = LOG_LEVEL_INFO;

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

@interface Utility : NSObject<SinaWeiboDelegate,SinaWeiboRequestDelegate>{
    ABAddressBookRef addressBook;
    BOOL _isAddressBookAvailable;
    
    SinaWeibo *sinaweibo;
    BOOL _isWeiboAvailable;
    NSDictionary *userInfo;
    NSArray *statuses;
    NSString *postStatusText;
    NSString *postImageStatusText;
}

@property (assign, nonatomic) BOOL isAddressBookAvailable;
@property (assign, nonatomic) BOOL isWeiboAvailable;
@property (readonly, nonatomic) SinaWeibo *sinaweibo;
@property (strong, nonatomic) NSString * postStatusText;
@property (assign, nonatomic) ABAddressBookRef addressBook;

+(Utility*)GetInstance;

@end
