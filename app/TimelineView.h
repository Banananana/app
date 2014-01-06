//
//  Timeline.h
//  app
//
//  Created by blitz on 2013/12/24.
//  Copyright (c) 2013年 blitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TimelineView : UITableViewController <NSFetchedResultsControllerDelegate> {}

-(void) fetchAnnouncement: (NSString*) urlString;

//@property (strong, nonatomic) AnnouncementD

@end
