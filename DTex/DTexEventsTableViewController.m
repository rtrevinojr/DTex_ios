//
//  DTexEventsTableViewController.m
//  DTex
//
//  Created by Rene  Trevino Jr. on 10/17/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import "DTexAppDelegate.h"
#import "DTexEventsTableViewController.h"
#import "DTexEventTableViewCell.h"
#import "DTexBarDetailViewController.h"



@interface DTexEventsTableViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *DTexEventCell;

//@property (weak, nonatomic) IBOutlet UIPickerView *DayPickerView;
@property (strong, nonatomic) NSArray * weekdayEnum;
@property NSInteger selectedPickerRow;

@property (weak, nonatomic) IBOutlet UISearchBar *searchEventBar;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UIButton *leftDayBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightDayBtn;

@property (strong, nonatomic) NSMutableArray * eventFavorites;
@property (strong, nonatomic) NSMutableArray * eventFavorites_str;

@property (weak, nonatomic) IBOutlet UIButton *likeEventBtn;
@property (weak, nonatomic) IBOutlet UILabel *eventRatingLabel;

- (IBAction)backDayListener:(id)sender;
- (IBAction)forwardDayListener:(id)sender;



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
        
        self.selectedPickerRow = [self getDayOfWeek];
    }
    return self;
}


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
        return @"Sunday";
    else if (daynum == 1)
        return @"Monday";
    else if (daynum == 2)
        return @"Tuesday";
    else if (daynum == 3)
        return @"Wednesday";
    else if (daynum == 4)
        return @"Thursday";
    else if (daynum == 5)
        return @"Friday";
    else if (daynum == 6)
        return @"Saturday";
    else if (daynum == 7)
        return @"Sunday";
    else
        return @"Everyday";
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabBarController setDelegate:self];
    
    _weekdayEnum = [[NSMutableArray alloc] initWithObjects:@"Sunday", @"Monday",@"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Everyday", nil];
    //NSLog(@"Day: %ld", [self getDayOfWeek]);
    
    _selectedPickerRow = (NSInteger) [self getDayOfWeek];
    
    _dayLabel.text = [self getDayOfWeekString:[self getDayOfWeek]];
    

    //get instance of app delegate
    DTexAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    //create managed object context
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    //get entity description
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"EventLikes" inManagedObjectContext:context];
    //create a fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    NSManagedObject *matches = nil;
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    self.eventFavorites = [objects mutableCopy];
    
    self.eventFavorites_str = [[NSMutableArray alloc]init];
    
    
    //test the results of the search request
    if ([objects count] == 0 ) {
        NSLog(@"No objects found in Core Data");
         //[_eventFavorites_str addObject:@"hoavPAw51d"];
    }
    else {
        matches = objects[0];
        //get the arrayData (string) and add it to a sting object.
        NSString *arrayString = [matches valueForKey:@"objectId"];
        //make an array from the string.
        //NSArray *array = [arrayString componentsSeparatedByString:@","];
        //cast the index as an int
        //int theIndex = [_arrayIndexTextField.text intValue];
        //output the results
        NSLog(@"Core Data element = %@", arrayString);
        NSLog(@"Core Data count = %ld", [_eventFavorites count]);
        
        long count = 0;
        NSManagedObject *matches2 = nil;
        /*
        for (int i = 0; i < _eventFavorites.count; i++) {
            
            matches2 = _eventFavorites[i];

            NSLog(@"element %ld = %@", count, [matches2 valueForKey:@"objectId"]);
            [_eventFavorites_str addObject:[matches2 valueForKey:@"objectId"]];
            count++;
        }
         */
    }
    
    NSLog(@"Event Favorites............");
    for (NSString * str in _eventFavorites_str) {
        NSLog(@"%@", str);
    }
    

     
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

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _selectedPickerRow = row;
    //NSString * rowvalue = [NSString stringWithFormat:@"%ld", (long)_selectedPickerRow];
    [self loadObjects];
    [self.tableView reloadData];
    [self queryForTable];
    //NSLog(@"Selected Picker Row: %@", rowvalue);
    
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_weekdayEnum objectAtIndex:row];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
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
    NSInteger defaultrow = _selectedPickerRow;
    NSString * dayString = [self getDayOfWeekString:defaultrow];

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
    
    NSNumber *cellbar_rating = [object objectForKey:@"Rating"];
    NSString * rating_str = [cellbar_rating stringValue];
    rating_str = [rating_str stringByAppendingString:@" Likes"];
    cell.eventRatingLabel.text = rating_str;
    
    NSString * button_tag = [object objectId];
    [cell.likeEventBtn setTitle:button_tag forState:UIControlStateNormal];
    //NSLog(@"cell.likeEventBtn Title = %@", cell.likeEventBtn.currentTitle);
    
    if ([_eventFavorites_str containsObject:object.objectId]) {
            NSLog(@"NO");
            //[cell.likeEventBtn setTitle:@"YES" forState:UIControlStateSelected];
            [cell.likeEventBtn setBackgroundColor:[UIColor greenColor]];
            //cell.eventRatingLabel.textColor = [UIColor greenColor];
    }
    else {
        NSLog(@"YES. ObjectId = %@", object.objectId);
        //[cell.likeEventBtn setTitle:@"NO" forState:UIControlStateSelected];
        [cell.likeEventBtn setBackgroundColor:[UIColor redColor]];
        //cell.eventRatingLabel.textColor = [UIColor redColor];
    }
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowActionStyleNormal];
    
    return cell;
}

 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
     return [_weekdayEnum objectAtIndex:indexPath.row];
 }

- (IBAction)likeButtonPressed:(id)sender {
    
    NSLog(@"LIKE Button Pressed: ");
    UIButton *btn = (UIButton *)sender;

    //DTexEventTableViewCell * cell = (DTexEventTableViewCell*)[[sender superview] superview];
    //From the cell get its index path.
    //NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // Find Point in Superview
    CGPoint pointInSuperview = [btn.superview convertPoint:btn.center toView:self.tableView];
    // Infer Index Path
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pointInSuperview];
    NSLog(@"%ld", indexPath.row);
    
    NSString * btn_title = btn.currentTitle;
    NSLog(@"Button Title on Press = %@", btn_title);
    
    DTexAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    //create managed object context
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    //get entity description
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"EventLikes" inManagedObjectContext:context];
    //create a fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    //NSManagedObject *matches = nil;
    //NSError *error;
    
    PFQuery *query = [PFQuery queryWithClassName:@"DTex_Events"];
    PFObject* obj = [query getObjectWithId:btn.currentTitle];
    
    // Create a pointer to an object of class Point with id dlkj83d
    //PFObject *obj = [PFObject objectWithoutDataWithClassName:@"DTex_Events" objectId:btn.currentTitle];
    
    //NSNumber * val = obj[@"Rating"];
    NSNumber * val = [obj objectForKey:@"Rating"];
    
    if ([_eventFavorites_str containsObject:btn.currentTitle]) {
        
        int valint = [val intValue];
        NSLog(@"val int = %d", valint);
        val = [NSNumber numberWithInt:valint - 1];
        
        NSLog(@"val int + 1 = %@", val);
        [obj setObject:val forKey:@"Rating"];
        [obj save];
        [_eventFavorites_str removeObject:btn.currentTitle];
        
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        //NSManagedObject *removeObj = [NSEntityDescription insertNewObjectForEntityForName:@"EventLikes" inManagedObjectContext:context];
        
        //NSString *testEntityId = idTaxi;
        //NSManagedObjectContext *moc2 = [appDelegate managedObjectContext];
        
        NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
        fetch.entity = [NSEntityDescription entityForName:@"EventLikes" inManagedObjectContext:context];
        fetch.predicate = [NSPredicate predicateWithFormat:@"objectId == %@", [btn currentTitle]];
        NSArray *array = [context executeFetchRequest:fetch error:nil];
        
        for (NSManagedObject *managedObject in array) {
            [context deleteObject:managedObject];
        }
        
        //[context deleteObject:removeObj];
        
    }
    else {
        int valint = [val intValue];
        NSLog(@"val int = %d", valint);
        val = [NSNumber numberWithInt:valint + 1];
        NSLog(@"val int + 1 = %@", val);
        [obj setObject:val forKey:@"Rating"];
        [obj save];
        [_eventFavorites_str addObject:btn.currentTitle];
        
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"EventLikes" inManagedObjectContext:context];
        [newDevice setValue:btn.currentTitle forKey:@"objectId"];
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    NSLog(@"UPDATED RATING = %@", [obj objectForKey:@"Rating"]);


    //[context delete:@"hoavPAw51d"];
    NSArray *indexPaths = [NSArray arrayWithObjects:
                           [NSIndexPath indexPathForRow:indexPath.row inSection:0],
                           // Add some more index paths if you want here
                           nil];
    
    
    //[self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation: UITableViewRowAnimationFade];
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPaths] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView endUpdates];
    
    //[self.tableView reloadData];
    [self loadObjects];

}


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
    if ([segue.identifier isEqualToString:@"eventsegue"]) {
        
        // Capture the object (e.g. exam) the user has selected from the list
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        NSString * bar = object[@"Name"];
        NSLog(@"bar string = %@", bar);
        PFQuery *query = [PFQuery queryWithClassName:@"DTexBars"];
        [query whereKey:@"Bar_Name" equalTo:bar];
        //[query orderByAscending:@"Special"];
        DTexBarDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.exam = [query getFirstObject];
    }

}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        [(UINavigationController*)viewController popToRootViewControllerAnimated:NO];
    }
}

- (IBAction)backDayListener:(id)sender {
    NSLog(@"back Day Listener");
    _selectedPickerRow -= 1;
    _dayLabel.text = [self getDayOfWeekString:_selectedPickerRow];
    [self loadObjects];
}

- (IBAction)forwardDayListener:(id)sender {
    NSLog(@"forward Day Button");
    _selectedPickerRow += 1;
    _dayLabel.text = [self getDayOfWeekString:_selectedPickerRow];
    [self loadObjects];
    //[self.tableView reloadData];
    //[self queryForTable];
}

@end

