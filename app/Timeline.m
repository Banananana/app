//
//  Timeline.m
//  app
//
//  Created by blitz on 2013/12/24.
//  Copyright (c) 2013年 blitz. All rights reserved.
//

#import "Timeline.h"
#import "News.h"

@interface Timeline ()

@end

@implementation Timeline

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"screw you";
    
    
    // [self fetchNews:@"https://api.github.com/users/banacorn/gists"];
    [self fetchNews:@"http://openhouse.nctu.edu.tw/2014/index.php?r=announce%2Ffeed"];
    
    // fix some shit
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    // init test
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)fetchNews:(NSString*)urlString {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *someShit = [NSData dataWithContentsOfURL:url];
    NSString *ret = [[NSString alloc] initWithData:someShit encoding:NSUTF8StringEncoding];
    NSData* fetched = [ret dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    id object = [NSJSONSerialization
                 JSONObjectWithData: fetched
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
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];

        NSArray *allOldNews = [News MR_findAll];
        
        // add news if not already in core data
        for (NSDictionary * dict in object) {
            
            NSNumber * newID = [f numberFromString:[dict objectForKey:@"id"]];
            
            BOOL existed = false;
            
            for (News * news in allOldNews) {
                    
                NSNumber * oldID = news.id;
                
                if ([newID isEqualToNumber:oldID]) {
                    existed = true;
                }
            }
            
            if (!existed) {
                News *news = [News MR_createEntity];
                news.id = newID;
                news.createdAt = [dict objectForKey:@"created_at"];
            }
        }
        
        // remove news if redundent in core data
        for (News * news in allOldNews) {
            
            NSNumber * oldID = news.id;
            
            
            BOOL redundent = true;
            
            for (NSDictionary * dict in object) {
                
                NSNumber * newID = [f numberFromString:[dict objectForKey:@"id"]];
                
                if ([newID isEqualToNumber:oldID]) {
                    redundent = false;
                }
            }
            
            if (redundent) {
                [news MR_deleteEntity];
            }
        }
        
        
        

        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    NSLog(@"count %d", [[News MR_findAll] count]);
    return [[News MR_findAll] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TimelineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    News * news = [[News MR_findAll] objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:[news.id stringValue]];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"fuck me");
//    [self performSegueWithIdentifier:@"showNewsDetail"];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"fuck");
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
