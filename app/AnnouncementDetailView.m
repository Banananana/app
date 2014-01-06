//
//  AnnouncementDetailView.m
//  app
//
//  Created by blitz on 2014/1/6.
//  Copyright (c) 2014年 blitz. All rights reserved.
//

#import "AnnouncementDetailView.h"
#import "Announcement.h"
@interface AnnouncementDetailView ()

@end

@implementation AnnouncementDetailView

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
