//
//  DTexEventsTableViewController.m
//  DTex
//
//  Created by Rene  Trevino Jr. on 10/17/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import "DTexEventsTableViewController.h"

#import "DTexEventTableViewCell.h"

@interface DTexEventsTableViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *DTexEventCell;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIPickerView *DayPickerView;
@property (nonatomic) NSInteger weekdayNum;
@property (strong, nonatomic) NSArray * weekdayEnum;
@property NSInteger selectedPickerRow;

@end


@implementation DTexEventsTableViewController

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
    
        // The className to query on
        self.parseClassName = @"DTex_Events";
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"Special";
        self.title = @"Events";
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        // The number of objects to show per page
        self.objectsPerPage = 100;
    }
    return self;
}

/*
 - (id)initWithStyle:(UITableViewStyle)style
 {
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        // The className to query on
        self.parseClassName = @"DTexBars";
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"Bar_Name";
        // The title for this table in the Navigation Controller.
        self.title = @"DTexBars";
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
 }

 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

- (NSInteger) getDayOfWeek
{
    CFAbsoluteTime at = CFAbsoluteTimeGetCurrent();
    CFTimeZoneRef tz = CFTimeZoneCopySystem();
    SInt32 WeekdayNumber = CFAbsoluteTimeGetDayOfWeek(at, tz);
    return (NSInteger) WeekdayNumber;
}

- (NSString *) getDayOfWeekString:(NSInteger)daynum
{
    if (daynum == 0)
        return @"Monday";
    else if (daynum == 1)
        return @"Tuesday";
    else if (daynum == 2)
        return @"Wednesday";
    else if (daynum == 3)
        return @"Thursday";
    else if (daynum == 4)
        return @"Friday";
    else if (daynum == 5)
        return @"Saturday";
    else
        return @"Sunday";
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    //_weekdayEnum = [NSArray arrayWithObjects:
                        @"Monday", @"Tuesday", @"Wednesday",
                        @"Thursday", @"Friday", @"Saturday", @"Sunday",
                        nil];
     */
    
    _weekdayEnum = [[NSMutableArray alloc] initWithObjects:@"Monday",@"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
    
    //_selectedPickerRow = [self getDayOfWeek];
    _selectedPickerRow = 1;
    
    NSLog(@"GetDayOfWeek////////////////////");
    /*
    _DayPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    _DayPickerView.delegate = self;
    _DayPickerView.showsSelectionIndicator =YES;
    _DayPickerView.backgroundColor = [UIColor clearColor];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-3.14/2);
    rotate = CGAffineTransformScale(rotate, 0.25, 2.0);
    [self.DayPickerView setTransform:rotate];
    [self.view addSubview:_DayPickerView];
     */
    
    _DayPickerView.delegate = self;
    _DayPickerView.dataSource = self;
    _DayPickerView.showsSelectionIndicator = YES;
    _DayPickerView.opaque = NO;
    
    
    /*
    _searchBar.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uiWasTapped)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    [searchField setValue:[UIColor orangeColor] forKeyPath:@"_placeholderLabel.textColor"];
    
     */
     
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    //[self setPickerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _weekdayEnum.count;
}

/*
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    CGRect rect = CGRectMake(0, 0, 120, 80);
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(3.14/2);
    rotate = CGAffineTransformScale(rotate, 0.25, 2.0);
    [label setTransform:rotate];
    label.text = [_weekdayEnum objectAtIndex:row];
    label.font = [UIFont systemFontOfSize:22.0];
    //label.textAlignment = UITextAlignmentCenter;
    label.numberOfLines = 2;
    //label.lineBreakMode = UILineBreakModeWordWrap;
    label.backgroundColor = [UIColor clearColor];
    label.clipsToBounds = YES;
    return label ;
}
*/

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _selectedPickerRow = row;
    NSString * rowvalue = [NSString stringWithFormat:@"%ld", (long)_selectedPickerRow];
    
    //[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    [self loadObjects];
    
    [self.tableView reloadData];
    
    [self queryForTable];
    
    
    
    NSLog(@"Selected Picker Row :::::::::::::::::: %@", rowvalue);
    
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_weekdayEnum objectAtIndex:row];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([_searchBar isFirstResponder])
        return YES;
    
    // UITableViewCellContentView => UITableViewCellScrollView => UITableViewCell
    if([touch.view.superview.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    
    // UITableViewCellContentView => UITableViewCell
    if([touch.view.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    if ([touch.view isKindOfClass:[UIControl class]])
        return NO;
    return YES;
}

-(void)uiWasTapped
{
    [_searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    
    //NSString * dayString = [_weekdayEnum objectAtIndex:_selectedPickerRow];
    NSString * dayString = [self getDayOfWeekString:_selectedPickerRow];
    
    NSLog(@"Day String::::::::::::::::: %@", dayString);
    
    [query whereKey:@"Day" equalTo:dayString];
    [query orderByAscending:@"Special"];
    
    /*
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [self.tableView reloadData];
    }];
     */
    
    //[self loadObjects];
    
    //[self loadView];
    
    return query;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"DTexCell";
    DTexEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[DTexEventTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    cell.CellBarNameLabel.text = [object objectForKey:@"Name"];
    cell.CellSummaryLabel.text = [object objectForKey:@"Summary"];
    cell.CellSpecialLabel.text = [object objectForKey:@"Special"];
    cell.CellDayLabel.text = [object objectForKey:@"Day"];
    return cell;
}

 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
     return [_weekdayEnum objectAtIndex:indexPath.row];
 }
 

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Check that a new transition has been requested to the DetailViewController and prepares for it
    if ([segue.identifier isEqualToString:@"viewsegue"]) {
        // Capture the object (e.g. exam) the user has selected from the list
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];

        // Set destination view controller to DetailViewController to avoid the NavigationViewController in the middle (if you have it embedded into a navigation controller, if not ignore that part)
        /*
         UINavigationController *nav = [segue destinationViewController];
         DTexBarDetailViewController *detailViewController = (DTexBarDetailViewController *) nav.topViewController;
         detailViewController.exam = object;
         */
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addsegue"]) {
        NSLog(@"prepareForSegue: addsegue");
    }
    else if ([segue.identifier isEqualToString:@"viewsegue"]) {
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *viewObject = [PFObject objectWithClassName:@"DTexBars"];
    }
}


@end

