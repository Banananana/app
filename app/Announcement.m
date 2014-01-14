//
//  Announcement.m
//  app
//
//  Created by blitz on 2013/12/31.
//  Copyright (c) 2013年 blitz. All rights reserved.
//

#import "Announcement.h"

@implementation Announcement

@dynamic id;
@dynamic time;
@dynamic title;
@dynamic content;
@dynamic authorID;
@dynamic authorName;
@dynamic authorCompany;
@dynamic authorPosition;
@dynamic link;
@dynamic createdAt;
@dynamic updatedAt;

+ (Announcement *) create: (NSDictionary *) dict
{
    // NSString to NSNumber hack
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    Announcement * announcement = [Announcement MR_createEntity];

    announcement.id             = [f numberFromString:[dict objectForKey:@"id"]];
    announcement.title          = [dict objectForKey:@"title"];
    announcement.content        = [dict objectForKey:@"content"];
    announcement.authorID       = [dict objectForKey:@"author_id"];
    announcement.authorName     = [dict objectForKey:@"author_name"];
    announcement.authorPosition = [dict objectForKey:@"author_position"];
    announcement.authorCompany  = [dict objectForKey:@"author_company"];
    
    // fuck php, fuck you all, dynamic typed junk, and all of these predated static type system = =
    if ([[dict objectForKey:@"author_company_id"] isKindOfClass:[NSString class]]) {
        announcement.authorCompanyID = [f numberFromString:[dict objectForKey:@"author_company_id"]];
    } else {
        announcement.authorCompanyID = [dict objectForKey:@"author_company_id"];
    }
    
    announcement.time           = [dict objectForKey:@"time"];
    announcement.createdAt      = [dict objectForKey:@"created_at"];
    announcement.updatedAt      = [dict objectForKey:@"updated_at"];
    
    return announcement;
}

+ (void) removeAll
{
    [Announcement MR_truncateAll];
}

- (void) remove
{
    [self MR_deleteEntity];
}

@end

