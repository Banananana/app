//
//  AnnouncementDetailView.m
//  app
//
//  Created by blitz on 2014/1/6.
//  Copyright (c) 2014年 blitz. All rights reserved.
//

#import "AnnouncementDetailView.h"

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
    
    if (self.announcement) {
        self.title = [self.announcement valueForKey:@"title"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
