//
//  DTexBarsTableViewController.m
//  DTex
//
//  Created by Rene  Trevino Jr. on 10/16/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import "DTexBarsTableViewController.h"
#import "DTexBarDetailViewController.h"
#import "DTexBarTableViewCell.h"
#import "DTexAppDelegate.h"


@interface DTexBarsTableViewController ()

@property (weak, nonatomic) IBOutlet DTexBarTableViewCell *DTexBarCell;

@property (strong, nonatomic) NSMutableArray * barFavorites;
@property (strong, nonatomic) NSMutableArray * barFavorites_ids;

@end


@implementation DTexBarsTableViewController

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        // The className to query on
        self.parseClassName = @"DTexBars";
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"Bar_Name";
        //NSString * bars_str = @"Bars";
        //NSString * bars_ustr = @"BARS";
        NSString * venues_ustr = @"Venues";
        self.title = venues_ustr;
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
 
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    
    self.barFavorites = [objects mutableCopy];
    
    self.barFavorites_ids = [[NSMutableArray alloc]init];
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
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

/*
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
 */

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    [query orderByAscending:@"Bar_Name"];
    return query;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"DTexBarCell";
    DTexBarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[DTexBarTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.accessoryType = UITableViewCellAccessoryNone;

    cell.CellBarNameLabel.text = [object objectForKey:@"Bar_Name"];
    cell.CellBarAddressLabel.text = [object objectForKey:@"Address"];
    cell.CellBarAreaLabel.text = [object objectForKey:@"Area"];
    
    [cell.CellBarLikeBtn addTarget:self
                            action:@selector(likeBtnPress:forEvent:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    cell.CellBarLikeBtn.tag = indexPath.row;
    
    NSString * button_tag = [object objectId];
    [cell.CellBarLikeBtn setTitle:button_tag forState:UIControlStateNormal];
    //temp button attributes
    CALayer *likebtnLayer = [cell.CellBarLikeBtn layer];
    [likebtnLayer setMasksToBounds:YES];
    [likebtnLayer setCornerRadius:10.0f];
    // Apply a 1 pixel, black border
    [likebtnLayer setBorderWidth:1.0f];
    [likebtnLayer setBorderColor:[[UIColor blackColor] CGColor]];
    
    NSNumber *cellbar_rating = [object objectForKey:@"Rating"];
    NSString * rating_str = [cellbar_rating stringValue];
    rating_str = [rating_str stringByAppendingString:@" Likes"];
    
    if ([_barFavorites_ids containsObject:object.objectId]) {
        NSLog(@"NO");
        //[cell.likeEventBtn setTitle:@"YES" forState:UIControlStateSelected];
        [cell.CellBarLikeBtn setBackgroundColor:[UIColor greenColor]];
    }
    else {
        NSLog(@"YES. ObjectId = %@", object.objectId);
        //[cell.likeEventBtn setTitle:@"NO" forState:UIControlStateSelected];
        [cell.CellBarLikeBtn setBackgroundColor:[UIColor redColor]];
    }
    
    //[cell.CellBarRatingBtn setTitle:rating_str forState:UIControlStateNormal];
    cell.CellBarRatingLabel.text = rating_str;
    cell.CellIsLiked = NO;
    return cell;
}


// -(IBAction) likeBtnPress: (id)sender forEvent:(UIEvent*)
- (IBAction)likeBtnPress:(id)sender forEvent:(UIEvent *)event {
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
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"BarLikes" inManagedObjectContext:context];
    //create a fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    //NSManagedObject *matches = nil;
    //NSError *error;
    
    PFQuery *query = [PFQuery queryWithClassName:@"DTexBars"];
    PFObject* obj = [query getObjectWithId:btn.currentTitle];
    // Create a pointer to an object of class Point with id dlkj83d
    //PFObject *obj = [PFObject objectWithoutDataWithClassName:@"DTex_Events" objectId:btn.currentTitle];
    NSNumber * val = [obj objectForKey:@"Rating"];
    
    //NSManagedObjectContext *context = [appDelegate managedObjectContext];

    if ([_barFavorites_ids containsObject:btn.currentTitle]) {
        
        int valint = [val intValue];
        NSLog(@"val int = %d", valint);
        val = [NSNumber numberWithInt:valint - 1];
        
        NSLog(@"val int + 1 = %@", val);
        [obj setObject:val forKey:@"Rating"];
        [obj save];
        [_barFavorites_ids removeObject:btn.currentTitle];
        //NSManagedObject *removeObj = [NSEntityDescription insertNewObjectForEntityForName:@"EventLikes" inManagedObjectContext:context];
        
        //NSString *testEntityId = idTaxi;
        //NSManagedObjectContext *moc2 = [appDelegate managedObjectContext];
        
        NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
        fetch.entity = [NSEntityDescription entityForName:@"BarLikes" inManagedObjectContext:context];
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
        [_barFavorites_ids addObject:btn.currentTitle];
        
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"BarLikes" inManagedObjectContext:context];
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
                           [NSIndexPath indexPathForRow:indexPath.row inSection:0], nil];
    
    //[self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation: UITableViewRowAnimationFade];
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPaths] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView endUpdates];
    
    //[self.tableView reloadData];
    [self loadObjects];
    
}








/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [objects objectAtIndex:indexPath.row];
 }
 */

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
 */

/*
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
     if ([segue.identifier isEqualToString:@"viewsegue"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         PFObject *object = [self.objects objectAtIndex:indexPath.row];
         DTexBarDetailViewController *detailViewController = [segue destinationViewController];
         detailViewController.exam = object;
     }
 }


@end


