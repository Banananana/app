//
//  Timeline.m
//  app
//
//  Created by blitz on 2013/12/24.
//  Copyright (c) 2013年 blitz. All rights reserved.
//

#import "TimelineView.h"
#import "AnnouncementDetailView.h"
#import "Announcement.h"
#import <FacebookSDK/FacebookSDK.h>


@interface TimelineView ()

@end

@implementation TimelineView

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
    
    self.title = @"廠商訊息";
    
    [self fetchAnnouncement:@"http://openhouse.nctu.edu.tw/2014/index.php?r=announce%2Ffeed"];
    
    // fix some core data & magical record shit
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
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


- (void)fetchAnnouncement:(NSString*)urlString {
    
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
        
        [Announcement removeAll];
        // NSString to NSNumber hack
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSArray *allOldAnnouncement = [Announcement MR_findAll];
        
        // add announcement if not already in core data
        for (NSDictionary * dict in object) {
            
            NSNumber * newID = [f numberFromString:[dict objectForKey:@"id"]];
            
            BOOL existed = false;
            
            for (Announcement * announcement in allOldAnnouncement) {
                
                NSNumber * oldID = announcement.id;
                
                if ([newID isEqualToNumber:oldID]) {
                    existed = true;
                }
            }
            
            if (!existed) {
                [Announcement create:dict];
            }
        }
        
        // remove announcements if redundent in core data
        for (Announcement * announcement in allOldAnnouncement) {
            
            NSNumber * oldID = announcement.id;
            
            BOOL redundent = true;
            
            for (NSDictionary * dict in object) {
                
                NSNumber * newID = [f numberFromString:[dict objectForKey:@"id"]];
                
                if ([newID isEqualToNumber:oldID]) {
                    redundent = false;
                }
            }
            
            if (redundent) {
                [announcement remove];
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
    return [[Announcement MR_findAll] count];
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
    Announcement * announcement = [[Announcement MR_findAll] objectAtIndex:indexPath.row];
    cell.textLabel.text = announcement.title;
    cell.detailTextLabel.text = [TimelineView companyTable][announcement.authorCompanyID];
    
//    NSDate * date = [[NSDate alloc] initWithTimeIntervalSince1970:[announcement.time doubleValue]];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"dd' in the month of 'MMMM' in the year of 'yyyy"];
//    NSString *s = [formatter stringFromDate:[NSDate date]];
//    NSLog(s);
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
//    Announcement * announcement = [[Announcement MR_findAll] objectAtIndex:indexPath.row];
    //NSLog(@"%@", announcement.content);
//    [self performSegueWithIdentifier:@"showNewsDetail"];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAnnouncementDetail"]) {
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        Announcement * announcement = [[Announcement MR_findAll] objectAtIndex:indexPath.row];
        
        AnnouncementDetailView * view = [segue destinationViewController];
        view.announcement = announcement;
//        NSLog(@"segue: %@", announcement);
//
//        DetailViewController *detailViewController = [segue destinationViewController];
//        detailViewController.sighting = [self.dataController objectInListAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
//    AnnouncementDetailView * view = [segue a]
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


+ (NSDictionary *) companyTable {
    static NSDictionary * table = nil;
    
    if (table == nil) {
        table = @{
                  @0: @"Open House",
                  @2: @"台積電",
                  @4: @"友達光電",
                  @5: @"瑞昱半導體",
                  @6: @"台達電子",
                  @7: @"慧榮科技",
                  @8: @"1111人力銀行",
                  @9: @"研華科技",
                  @10: @"晶電",
                  @11: @"聯華電子",
                  @12: @"普安科技",
                  @13: @"工研院",
                  @14: @"廣達電腦",
                  @15: @"頎邦科技",
                  @16: @"群創光電",
                  @18: @"創意電子",
                  @19: @"NVIDIA",
                  @20: @"晨星半導體",
                  @21: @"丕文科技",
                  @22: @"義隆電子",
                  @23: @"緯創資通",
                  @24: @"鈊象電子",
                  @25: @"凌陽科技",
                  @26: @"松翰科技",
                  @27: @"原相科技",
                  @28: @"和碩聯合科技",
                  @29: @"新日光能源科技",
                  @31: @"訊連",
                  @32: @"GARMIN",
                  @33: @"宏碁",
                  @34: @"環鴻科技",
                  @35: @"華碩電腦",
                  @36: @"隆達電子",
                  @37: @"智原科技",
                  @38: @"衡宇科技",
                  @39: @"MOXA四零四",
                  @40: @"智易科技",
                  @41: @"合勤投控",
                  @42: @"盟創科技",
                  @43: @"群聯電子",
                  @44: @"資策會",
                  @45: @"大立光電",
                  @46: @"鴻海",
                  @47: @"HTC",
                  @48: @"欣興電子",
                  @49: @"東訊",
                  @50: @"明泰科技",
                  @51: @"日月光集團中壢分公司",
                  @54: @"CPS",
                  @55: @"奇景光電",
                  @56: @"聯發科技",
                  @57: @"中光電",
                  @59: @"建興電子",
                  @61: @"世界先進",
                  @62: @"崇越科技",
                  @64: @"WORK IN JAPAN",
                  @68: @"采鈺科技",
                  @69: @"昱晶",
                  @70: @"富邦金控",
                  @71: @"台新金控",
                  @72: @"威盛電子",
                  @73: @"花王(台灣)",
                  @78: @"正文科技",
                  @79: @"立錡科技",
                  @86: @"第一銀行",
                  @87: @"漢民科技",
                  @88: @"康舒科技",
                  @89: @"野村總合研究所",
                  @90: @"達興材料",
                  @91: @"士林電機廠股份有限公司",
                  @92: @"UT",
                  @93: @"根基營造",
                  @94: @"偉詮電子股份有限公司",
                  @95: @"IBM",
                  @96: @"億霈科技",
                  @97: @"瑞健集團",
                  @99: @"新漢電腦",
                  @100: @"天鈺科技",
                  @101: @"台灣應材",
                  @102: @"KLA-Tencor",
                  @103: @"點晶科技",
                  @104: @"液空亞東",
                  @105: @"中租迪和",
                  @106: @"奕力科技",
                  @107: @"日盛企業集團",
                  @108: @"聯合利華",
                  @109: @"廣明光電",
                  @110: @"太古汽車",
                  @111: @"聯景光電",
                  @112: @"TPV",
                  @113: @"台灣愛立信股份有限公司",
                  @114: @"鉅晶",
                  @115: @"上銀科技",
                  @116: @"京城銀行",
                  @117: @"正達國際光電",
                  @118: @"留學家IEEUC",
                  @119: @"東元電機",
                  @120: @"寶成工業",
                  @121: @"德州儀器",
                  @122: @"向上遊戲",
                  @123: @"戴爾美語",
                  @124: @"安國國際",
                  @125: @"勝華科技",
                  @126: @"麥肯錫公司",
                  @127: @"鼎新電腦",
                  @128: @"立達國際電子",
                  @129: @"聯詠科技",
                  @130: @"Dell Taiwan",
                  @131: @"億光電子",
                  @132: @"鈺寶科技",
                  @133: @"晶碩光學",
                  @134: @"台塑關係企業",
                  @135: @"陽明海運",
                  @136: @"玉山銀行",
                  @137: @"裕隆集團",
                  @138: @"特力屋",
                  @139: @"喬鼎資訊",
                  @140: @"趨勢科技",
                  @141: @"NI美商國家儀器",
                  @142: @"104人力銀行",
                  @143: @"中鼎集團",
                  @144: @"禾多 HODo Mobile",
                  @145: @"太陽光電集團",
                  @146: @"復興航空",
                  @147: @"揚明光學",
                  @148: @"群光電子",
                  @149: @"中華航空",
                  @150: @"Cellopoint",
                  @151: @"建漢科技",
                  @152: @"就業新加坡",
                  @153: @"神準科技",
                  @154: @"華南商業銀行",
                  @155: @"穩懋半導體",
                  @156: @"欣銓科技",
                  @157: @"DNI",
                  @158: @"Marvell",
                  @159: @"HP惠普",
                  @160: @"聯茂電子ITEQ",
                  @161: @"ITE",
                  @162: @"Goodix",
                  @163: @"KKBOX",
                  @164: @"美商科林研發",
                  @165: @"居易科技",
                  @166: @"擎泰科技",
                  @167: @"豐邑建設",
                  @168: @"友達晶材",
                  @169: @"高鼎化工",
                  @170: @"緯穎科技",
                  @171: @"AAU",
                  @172: @"信義房屋",
                  @173: @"雄獅旅遊",
                  @174: @"yes123",
                  @175: @"芯鼎科技",
                  @176: @"宏祺國際人力",
                  @177: @"元太科技",
                  @178: @"career",
                  @179: @"漢微科",
                  @180: @"美商謀智",
                  @181: @"鑫晶鑽科技",
                  @182: @"M31",
                  @183: @"三陽工業",
                  @184: @"致茂",
                  @186: @"台灣大哥大",
                  @187: @"my plus",
                  @188: @"同致電子企業股份有限公司",
                  @189: @"調查局",
                  @190: @"TutorABC",
                  @191: @"大潤發",
                  @192: @"北部地區人才招募中心",
                  @193: @"牧德科技",
                  @194: @"力旺電子",
                  @195: @"漢翔",
                  @196: @"cacaFly",
                  @197: @"Adecco",
                  @198: @"台灣美光記憶體",
                  @199: @"新竹就業服務站",
                  @200: @"元大金控",
                  @201: @"Timberland",
                  @202: @"美商博通",
                  @203: @"漢磊科技股份有限公司",
                  @205: @"傑瑞生技",
                  @206: @"友順科技",
                  @207: @"舒適牌",
                  @208: @"磐石保險經紀人"
                  };
    }
    
    return table;
}




@end
