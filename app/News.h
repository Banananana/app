//
//  News.h
//  app
//
//  Created by blitz on 2013/12/31.
//  Copyright (c) 2013年 blitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface News : NSManagedObject

@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSNumber * id;

@end
