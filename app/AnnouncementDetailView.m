//
//  AnnouncementDetailView.m
//  app
//
//  Created by blitz on 2014/1/6.
//  Copyright (c) 2014年 blitz. All rights reserved.
//

#import "AnnouncementDetailView.h"
#import "Announcement.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation AnnouncementDetailView
- (IBAction)shareToFB:(id)sender {
    
//    
//    
//    
//    // Whenever a person opens the app, check for a cached session
//    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
//        
//        NSLog(@"logged");
//        
//        
//        // If there's one, just open the session silently, without showing the user the login UI
//        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
//                                           allowLoginUI:NO
//                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
//                                          // Handler for session state changes
//                                          // This method will be called EACH time the session state changes,
//                                          // also for intermediate states and NOT just when the session open
//                                          // [self sessionStateChanged:session state:state error:error];
//                                      }];
//    }
//
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        NSLog(@"dafaq");
        
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
//        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
//             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
//             [appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Announcement * announcement = self.announcement;
    
    if (announcement) {
        self.title = [announcement valueForKey:@"title"];
        
        UIWebView * webView = self.view.subviews[0];
        [webView loadHTMLString:announcement.content baseURL:[NSURL URLWithString:@""]];
//        NSLog(@"%@", self.view.subviews[0]);
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
