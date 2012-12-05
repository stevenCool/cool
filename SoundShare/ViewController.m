//
//  ViewController.m
//  SoundShare
//
//  Created by steven on 10/25/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

//static MMPDeepSleepPreventer *sleepPreventer;
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NotifyRefresh:)
                                                 name:NotificationNeedRefresh
                                               object:nil];
//    if (!sleepPreventer) {        
//        sleepPreventer = [[MMPDeepSleepPreventer alloc] init];
//    }
//    [sleepPreventer startPreventSleep];
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();

    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    NSString *host = HOST;
    uint16_t port = PORT;

    DDLogInfo(@"Connecting to \"%@\" on port %hu...", host, port);
    //self.viewController.label.text = @"Connecting...";

    NSError *error = nil;
    if (![asyncSocket connectToHost:host onPort:port error:&error])
    {
        DDLogError(@"Error connecting: %@", error);
        //self.viewController.label.text = @"Oops";
    }
    
    //[self resetButtons];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter]removeObserver:self
												   name:NotificationNeedRefresh
												 object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    //self.navigationController.navigationBarHidden = NO;
    
    if ([[Utility GetInstance] isWeiboAvailable]) {
        label.text = [Utility GetInstance].sinaweibo.userID;;
    }
    else{
        label.text = NoLoginLabel;
    }
    
    [super viewWillAppear:animated];
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
    
    voiceString = [[NSString alloc] initWithString:httpResponse];
    
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


-(IBAction)accessAddressbook:(id)sender
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    __block ViewController *controller = self;
    
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef,^(bool granted, CFErrorRef error) {
            if (granted)
                [controller outputPhoneNumber];
        });
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self outputPhoneNumber];
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
        [self showAlertView];
    }
    
#else
    [self outputPhoneNumber];
#endif
    
//    addressBook = ABAddressBookCreate();
//    __block BOOL accessGranted = NO;
//    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
//        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
//            accessGranted = granted;
//            dispatch_semaphore_signal(sema);
//        });
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//        //dispatch_release(sema);
//    }
//    else { // we're on iOS 5 or older
//        accessGranted = YES;
//        [self outputPhoneNumber];
//    }
//    
//    if (accessGranted) {
//        // Do whatever you want here.
//        [self outputPhoneNumber];
//    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if ([alertView.message isEqualToString:@"use contact"] || alertView.message == @"use contact") {
//        accessGranted = YES;
//        [self outputPhoneNumber];
//    }
}

- (void)outputPhoneNumber{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    NSMutableArray *dataSource = [[NSMutableArray alloc]init]; // dataSouce is delared in .h file
    NSMutableArray *allPeople = (__bridge NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    int nPeople = ABAddressBookGetPersonCount(addressBook);
    
    NSMutableArray *arrContacts = [[NSMutableArray alloc] init];
    
    for(int i=0; i < nPeople; i++ ){
        ABRecordRef person = (__bridge ABRecordRef)([allPeople objectAtIndex:i]);
        NSString *name = @"";
        
        if(ABRecordCopyValue(person, kABPersonFirstNameProperty) != NULL)
            name = [[NSString stringWithFormat:@"%@", ABRecordCopyValue(person, kABPersonFirstNameProperty)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [dataSource addObject: name];
        
        ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSArray* _phoneNumbers = (__bridge NSArray*)ABMultiValueCopyValueAtIndex(phoneNumberProperty, 0);
        //CFRelease(phoneNumberProperty);
        NSLog(@"Phone numbers = %@", _phoneNumbers);
        [arrContacts addObject:_phoneNumbers];
    }
    NSLog(@"Phone numbers : %@",arrContacts);

}

-(void)showAlertView{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Deny Access" message:@"Deny" delegate:self cancelButtonTitle:nil otherButtonTitles:@"cancel", nil];
    [alertView show];
}

- (void)NotifyRefresh:(NSNotification *)notification{
    //NSDictionary* dic = [notification userInfo];
    [self viewWillAppear:NO];
}

- (IBAction)Done:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ConnectToServer:(id)sender{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    if (!asyncSocket) {
        asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    }
    NSString *host = HOST;
    uint16_t port = PORT;
    DDLogInfo(@"Connecting to \"%@\" on port %hu...", host, port);
    NSError *error = nil;
    if (![asyncSocket connectToHost:host onPort:port error:&error])
    {
        DDLogError(@"Error connecting: %@", error);
    }
}

- (IBAction)DisconnectFromServer:(id)sender{
    NSString *requestStr = [NSString stringWithFormat:@"quit"];
	NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    [asyncSocket writeData:requestData withTimeout:-1 tag:0];
	[asyncSocket readDataWithTimeout:-1 tag:0];
    [asyncSocket disconnect];
}

@end
