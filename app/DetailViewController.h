//
//  DetailViewController.h
//  app
//
//  Created by blitz on 2013/12/1.
//  Copyright (c) 2013年 blitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
