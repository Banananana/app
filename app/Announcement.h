//
//  Announcement.h
//  app
//
//  Created by blitz on 2013/12/31.
//  Copyright (c) 2013年 blitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Announcement : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * authorID;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSString * authorPosition;
@property (nonatomic, retain) NSString * authorCompany;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSString * updatedAt;

@end
