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
        
        
        
        // We will post on behalf of the user, these are the permissions we need:
        NSArray *permissionsNeeded = @[@"publish_actions"];
        
        // Request the permissions the user currently has
        [FBRequestConnection startWithGraphPath:@"/me/permissions"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (!error){
                                      NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
                                      NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                      
                                      // Check if all the permissions we need are present in the user's current permissions
                                      // If they are not present add them to the permissions to be requested
                                      for (NSString *permission in permissionsNeeded){
                                          if (![currentPermissions objectForKey:permission]){
                                              [requestPermissions addObject:permission];
                                          }
                                      }
                                      
                                      // If we have permissions to request
                                      if ([requestPermissions count] > 0){
                                          // Ask for the missing permissions
                                          [FBSession.activeSession requestNewPublishPermissions:requestPermissions
                                                                                defaultAudience:FBSessionDefaultAudienceFriends
                                                                              completionHandler:^(FBSession *session, NSError *error) {
                                                                                  if (!error) {
                                                                                      // Permission granted, we can request the user information
                                                                                      NSLog(@"permission granted");
                                                                                      [self makeRequestToShareLink];
                                                                                  } else {
                                                                                      // An error occurred, handle the error
                                                                                      // See our Handling Errors guide: https://developers.facebook.com/docs/ios/errors/
                                                                                      NSLog([NSString stringWithFormat:@"%@", error.description]);
                                                                                  }
                                                                              }];
                                      } else {
                                          // Permissions are present, we can request the user information
                                          [self makeRequestToShareLink];
                                          
                                          NSLog(@"permission granted");
                                      }
                                      
                                  } else {
                                      // There was an error requesting the permission information
                                      // See our Handling Errors guide: https://developers.facebook.com/docs/ios/errors/
                                      NSLog([NSString stringWithFormat:@"%@", error.description]);
                                  }
                              }];

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


- (void)makeRequestToShareLink {
    
    // NOTE: pre-filling fields associated with Facebook posts,
    // unless the user manually generated the content earlier in the workflow of your app,
    // can be against the Platform policies: https://developers.facebook.com/policy
    Announcement * announcement = self.announcement;

//    NSLog(@"%@", announcement.title);
    // Put together the dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Open House 2014", @"name",
                                   announcement.title, @"caption",
                                   announcement.content, @"description",
                                   [@"http://openhouse.nctu.edu.tw//2014" stringByAppendingString:announcement.feedLink], @"link",
                                   @"https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-prn1/t1/1235961_632780743420592_1793562406_n.jpg", @"picture",
                                   nil];
    
    // Make the request
    [FBRequestConnection startWithGraphPath:@"/me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Link posted successfully to Facebook
                                  NSLog([NSString stringWithFormat:@"result: %@", result]);
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                                  NSLog([NSString stringWithFormat:@"%@", error.description]);
                              }
                          }];
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
//        self.title = [announcement valueForKey:@"title"];

        // web view
        UIWebView * webView = self.view.subviews[0];
        [webView loadHTMLString:announcement.content baseURL:[NSURL URLWithString:@""]];

        // title label view
        UILabel * titleView = [self.view.subviews[1] subviews][0];
        titleView.text = announcement.title;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
