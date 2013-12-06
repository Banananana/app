//
//  FirstViewController.m
//  app
//
//  Created by blitz on 2013/12/1.
//  Copyright (c) 2013年 blitz. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)fetchAndParseDataFrom:(NSString*)urlString {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *rawData = [NSData dataWithContentsOfURL:url];
    NSString *ret = [[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding];
    NSData* fetched = [ret dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    id object = [NSJSONSerialization
                 JSONObjectWithData:fetched
                 options:0
                 error:&error];
    
    if(error) {
        NSLog(@"JSON malformed");
    }
    
    if([object isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"JSON: Object");
    }
    else if([object isKindOfClass:[NSArray class]])
    {
        NSLog(@"%@", object);
        data = object;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // example usage of fetchAndParseDataFrom
    [self fetchAndParseDataFrom:@"http://banacorn.org:3000/api/board?parent=0"];
    NSLog(@"ggg %@", data);
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
