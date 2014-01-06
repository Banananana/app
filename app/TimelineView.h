//
//  Timeline.h
//  app
//
//  Created by blitz on 2013/12/24.
//  Copyright (c) 2013年 blitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnnouncementDetailView;

#import <CoreData/CoreData.h>

@interface TimelineView : UITableViewController <NSFetchedResultsControllerDelegate> {}

-(void) fetchAnnouncement: (NSString*) urlString;

@property (strong, nonatomic) AnnouncementDetailView * announcementDetailView;

@end
