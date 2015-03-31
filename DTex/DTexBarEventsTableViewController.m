//
//  DTexBarEventsTableViewController.m
//  DTex
//
//  Created by Rene  Trevino Jr. on 10/17/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import "DTexBarEventsTableViewController.h"

#import "DTexBarEventTableViewCell.h"

@interface DTexBarEventsTableViewController ()

@property (strong, nonatomic) NSString * BarSelection;
@property (strong, nonatomic) NSNumber * BarFKeySelection;

@property (weak, nonatomic) IBOutlet UILabel *BarEventsNameLabel;

@property (nonatomic, retain) NSMutableDictionary *sections;
@property (nonatomic, retain) NSMutableDictionary *sectionToDayTypeMap;

@property (weak, nonatomic) UIView * emptyView;
@property (weak, nonatomic) UIView *nomatchesView;

@end

@implementation DTexBarEventsTableViewController


- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        // The className to query on
        self.parseClassName = @"DTex_Events";
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"Special";
        self.title = @"Bar Events";
        //PFObject * selection = _object;
        //self.title = [selection objectForKey:@"Bar_Name"];
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        // The number of objects to show per page
        self.objectsPerPage = 100;
        
        self.sections = [NSMutableDictionary dictionary];
        self.sectionToDayTypeMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void) setBarSelection:(NSString *)name
{
    _BarSelection = name;
}
- (void) setBarFKeySelection:(NSNumber *)key
{
    _BarFKeySelection = key;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFObject * selection = _object;
    
    //self.BarEventsNameLabel.text = [selection objectForKey:@"Bar_Name"];
    
    self.BarEventsNameLabel.text = _BarSelection;
    
// UT Orangle Color Hex Code
// PANTONE: 159|CMYK: 0, 65, 100, 9|RGB: 191, 87, 0|HEX: #BF5700

    /*
    self.nomatchesView = [[UIView alloc] initWithFrame:self.view.frame];
    self.nomatchesView.backgroundColor = [UIColor clearColor];
    
    UILabel *matchesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,320)];
    matchesLabel.font = [UIFont boldSystemFontOfSize:18];
    matchesLabel.minimumFontSize = 12.0f;
    matchesLabel.numberOfLines = 1;
    matchesLabel.lineBreakMode = UILineBreakModeWordWrap;
    matchesLabel.shadowColor = [UIColor lightTextColor];
    matchesLabel.textColor = [UIColor darkGrayColor];
    matchesLabel.shadowOffset = CGSizeMake(0, 1);
    matchesLabel.backgroundColor = [UIColor clearColor];
    matchesLabel.textAlignment =  UITextAlignmentCenter;
    
    //Here is the text for when there are no results
    matchesLabel.text = @"No Matches";
    
    
    nomatchesView.hidden = YES;
    [nomatchesView addSubview:matchesLabel];
    [self.tableView insertSubview:nomatchesView belowSubview:self.tableView];
     */
    
    //self.sections = [NSMutableDictionary dictionary];
    //self.sectionToDayTypeMap = [NSMutableDictionary dictionary];
    
    //self.title = [selection objectForKey:@"Bar_Name"];
    //self.navigationController.title = [selection objectId];

    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.navigationItem.rightBarButtonItem = [UIBarButtonItem alloc] initWithBarButtonSystemItem:[UIBarButtonSystemItemAction] target:<#(id)#> action:<#(SEL)#>
    
    //Here's the selector in my overlay.
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                   UIBarButtonSystemItemSearch target:self action:@selector(searchButtonPressed)];
    self.navigationItem.rightBarButtonItem = searchBarButton;
    
    /*
    CALayer *barNameLabelbtnLayer = [_BarEventsNameLabel layer];
    [barNameLabelbtnLayer setCornerRadius:10.0f];
    [barNameLabelbtnLayer setMasksToBounds:YES];
    // Apply a 1 pixel, black border
    [barNameLabelbtnLayer setBorderWidth:1.0f];
    [barNameLabelbtnLayer setBorderColor:[[UIColor blackColor] CGColor]];
     */

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadObjects];
    
    /*
    if ([self numberOfSectionsInTableView:self.tableView] == 0) {
        UIView *emptyView = [[UIView alloc] initWithFrame:self.tableView.frame];
        // Customize your view here or load it from a NIB
        self.tableView.tableHeaderView = emptyView;
        self.tableView.userInteractionEnabled = NO;
    }
    else {
        self.tableView.tableHeaderView = nil;
        self.tableView.userInteractionEnabled = YES;
    }
    */

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:@"No DTex Events Available" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
                                 [actionSheetController dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    

    [actionSheetController addAction:cancel];
    
    // UT Orangle Color Hex Code
    // PANTONE: 159 |  CMYK: 0, 65, 100, 9  |  RGB: 191, 87, 0  |  HEX: #BF5700
    
    UIColor * utOrangle = [UIColor colorWithRed:191/255 green:87/255 blue:0 alpha:1];
    
    UIColor * ut_orange = [self colorFromHex:@"BF5700"];
    
    //actionSheetController.view.tintColor = [UIColor blackColor];
    actionSheetController.view.tintColor = ut_orange;
    
    //[self presentViewController:actionSheetController animated:YES completion:nil];
    
    if ([self numberOfSectionsInTableView:self.tableView] == 0) {
        NSLog(@"Empty tableView------------------------------");
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DTex"
                                                        message:@"No Events Available for this week"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
      
        [alert show];
         */
        //[alert release];
         actionSheetController.view.tintColor = [UIColor blackColor];
        actionSheetController.view.tintColor = ut_orange;
        
        /*
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Really delete the selected contact?"
                                                                 delegate:self
                                                        cancelButtonTitle:@"No, I changed my mind"
                                                   destructiveButtonTitle:@"Yes, delete it"
                                                        otherButtonTitles:nil];
         */
        //[actionSheet showInView:self.tableView];
        //[actionSheet showInView:self.navigationController.];
        //[actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
        //[actionSheet showFromToolbar:self.toolbarItems];
        
        
        /*
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // In this case the device is an iPad.
            [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];
        }
        else{
            // In this case the device is an iPhone/iPod Touch.
            [actionSheet showInView:self.view];
        }
        */
        
         
         [self presentViewController:actionSheetController animated:YES completion:nil];
    }
    
}




-(void)searchButtonPressed {
    /*
    TableViewController *tableView = [[TableViewController alloc]
                                      initWithNibName:@"TableViewController" bundle:nil];
    tableView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:tableView animated:YES];
     */
}

-(UIColor *)colorFromHex:(NSString *)hex {
    unsigned int c;
    if ([hex characterAtIndex:0] == '#') {
        [[NSScanner scannerWithString:[hex substringFromIndex:1]] scanHexInt:&c];
    } else {
        [[NSScanner scannerWithString:hex] scanHexInt:&c];
    }
    return [UIColor colorWithRed:((c & 0xff0000) >> 16)/255.0
                           green:((c & 0xff00) >> 8)/255.0
                            blue:(c & 0xff)/255.0 alpha:1.0];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    // This method is called every time objects are loaded from Parse via the PFQuery
    NSLog(@"objectsDidLoad");
    
    [self.sections removeAllObjects];
    [self.sectionToDayTypeMap removeAllObjects];
    
    NSInteger section = 0;
    NSInteger rowIndex = 0;
    for (PFObject *object in self.objects) {
        NSString *dayType = [object objectForKey:@"Day"];
        NSMutableArray *objectsInSection = [self.sections objectForKey:dayType];
        if (!objectsInSection) {
            objectsInSection = [NSMutableArray array];
            // this is the first time we see this dayType - increment the section index
            [self.sectionToDayTypeMap setObject:dayType forKey:[NSNumber numberWithInt:section++]];
        }
        [objectsInSection addObject:[NSNumber numberWithInt:rowIndex++]];
        [self.sections setObject:objectsInSection forKey:dayType];
    }
    //[self printDictionary:self.sections];
    //[self printDictionary:self.sectionToDayTypeMap];
    
}

- (NSArray *) sortObjectsDay: (NSArray*) objects {
    NSMutableArray * objects_copy = [[NSMutableArray alloc] init];

    for (PFObject * obj in self.objects) {
        if ([[obj objectForKey:@"Day"] isEqualToString:@"Sunday"]) {
             [objects_copy addObject:obj];
        }
    }
    for (PFObject * obj in self.objects) {
        if ([[obj objectForKey:@"Day"] isEqualToString:@"Monday"]) {
            [objects_copy addObject:obj];
        }
    }
    for (PFObject * obj in self.objects) {
        if ([[obj objectForKey:@"Day"] isEqualToString:@"Tuesday"]) {
            [objects_copy addObject:obj];
        }
    }
    for (PFObject * obj in self.objects) {
        if ([[obj objectForKey:@"Day"] isEqualToString:@"Wednesday"]) {
            [objects_copy addObject:obj];
        }
    }
    for (PFObject * obj in self.objects) {
        if ([[obj objectForKey:@"Day"] isEqualToString:@"Thursday"]) {
            [objects_copy addObject:obj];
        }
    }
    for (PFObject * obj in self.objects) {
        if ([[obj objectForKey:@"Day"] isEqualToString:@"Friday"]) {
            [objects_copy addObject:obj];
        }
    }
    for (PFObject * obj in self.objects) {
        if ([[obj objectForKey:@"Day"] isEqualToString:@"Saturday"]) {
            [objects_copy addObject:obj];
        }
    }
    for (PFObject * obj in self.objects) {
        if ([[obj objectForKey:@"Day"] isEqualToString:@"Everyday"]) {
            [objects_copy addObject:obj];
        }
    }
    NSArray * result = [objects_copy copy];
    return result;
}

- (void) printDictionary: (NSMutableDictionary *) dict {
    NSLog(@"DICTIONARY.........................");
    for (id key in dict) {
        NSLog(@"key=%@ value=%@", key, [dict objectForKey:key]);
    }
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    // This method is called before a PFQuery is fired to get more objects
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    //NSLog(@"BAR SELECION = %@", _BarSelection);
    //NSLog(@"BAR FOREIGN KEY SELECTION = %@", _BarFKeySelection);
    //[query whereKey:@"Name" equalTo:_BarSelection];
    [query whereKey:@"ID" equalTo:_BarFKeySelection];
    //[query orderByAscending:@"Special"];
    //[query orderByAscending:@"Day"];
    
    NSSortDescriptor *sunDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Sunday" ascending:YES];
    NSSortDescriptor *monDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Monday" ascending:YES];
    NSSortDescriptor *tuesDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Tuesday" ascending:YES];
    NSSortDescriptor *wedDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Wednesday" ascending:YES];
    NSSortDescriptor *thursDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Thursday" ascending:YES];
    NSSortDescriptor *friDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Friday" ascending:YES];
    NSSortDescriptor *satDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Saturday" ascending:YES];
    NSSortDescriptor *everydayDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Everday" ascending:YES];
    NSArray *sortDescriptors = @[sunDescriptor, monDescriptor, tuesDescriptor, wedDescriptor, thursDescriptor, friDescriptor, satDescriptor, everydayDescriptor];

    [query orderBySortDescriptors:sortDescriptors];
    
    return query;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"DTexBarEventCell";
    DTexBarEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DTexBarEventTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell
    cell.BarCellBarNameLabel.text = [object objectForKey:@"Name"];
    cell.BarCellSummaryLabel.text = [object objectForKey:@"Summary"];
    cell.BarCellSpecialLabel.text = [object objectForKey:@"Special"];
    cell.BarCellDayLabel.text = [object objectForKey:@"Day"];
    NSNumber *cellbar_rating = [object objectForKey:@"Rating"];
    NSString * rating_str = [cellbar_rating stringValue];
    rating_str = [rating_str stringByAppendingString:@" Likes"];
    cell.BarCellRatingLabel.text = rating_str;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //NSArray * weekDays = @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Everday"];
    
    NSString *dayType = [self dayTypeForSection:section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    //Create custom view to display section header...
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    //NSString *string =[list objectAtIndex:section];
    //NSString * string = [weekDays objectAtIndex:section];
    NSString * string = dayType;
    //Section header is in 0th index...
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}


-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {

    NSString *message = @"";
    NSInteger numberOfRowsInSection = [self tableView:self.tableView numberOfRowsInSection:section ];
    if (numberOfRowsInSection == 0) {
        message = @"This list is now empty";
    }
    return message;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray * weekDays = @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Everday"];
    //return weekDays[section];
    NSString *dayType = [self dayTypeForSection:section];
    return dayType;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //NSLog(@"self.sections.allKeys.count = %ld", self.sections.allKeys.count);
    return self.sections.allKeys.count;
    //return self.sections.count;
    //return 8;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *dayType = [self dayTypeForSection:section];
    NSArray *rowIndecesInSection = [self.sections objectForKey:dayType];
    return rowIndecesInSection.count;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dayType = [self dayTypeForSection:indexPath.section];
    NSArray *rowIndecesInSection = [self.sections objectForKey:dayType];
    NSNumber *rowIndex = [rowIndecesInSection objectAtIndex:indexPath.row];
    return [self.objects objectAtIndex:[rowIndex intValue]];
}

- (NSString *) dayTypeForSection:(NSInteger)section {
    //NSArray * weekdays = @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Everyday"];
    return [self.sectionToDayTypeMap objectForKey:[NSNumber numberWithInt:section]];
    //return weekdays[section];
}


/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NextPage";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"Load more...";
    return cell;
 }
 */

#pragma mark - Table view data source

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    PFObject *selectedObject = [self objectAtIndexPath:indexPath];
}
 */

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end

