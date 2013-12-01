//
//  FirstViewController.h
//  app
//
//  Created by blitz on 2013/12/1.
//  Copyright (c) 2013年 blitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController {
    __weak IBOutlet UITableView *tableView;
    NSArray *data;
}

-(void) fetchAndParseDataFrom: (NSString*) urlString;

@end
