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
        self.title = @"Bars";
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
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
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
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
    
    cell.accessoryType = UITableViewCellAccessoryNone;

    cell.CellBarNameLabel.text = [object objectForKey:@"Bar_Name"];
    cell.CellBarAddressLabel.text = [object objectForKey:@"Address"];
    cell.CellBarAreaLabel.text = [object objectForKey:@"Area"];
    
    [cell.CellBarLikeBtn addTarget:self
               action:@selector(likeBtnPress:forEvent:)
     forControlEvents:UIControlEventTouchUpInside];
    
    cell.CellBarLikeBtn.tag = indexPath.row;

    NSNumber *cellbar_rating = [object objectForKey:@"Rating"];
    NSString * rating_str = [cellbar_rating stringValue];
    rating_str = [rating_str stringByAppendingString:@" Likes"];
    
    //[cell.CellBarRatingBtn setTitle:rating_str forState:UIControlStateNormal];
    cell.CellBarRatingLabel.text = rating_str;
    cell.CellIsLiked = NO;
    return cell;
}

- (IBAction)likeBtnPress:(id)sender {
    
    
    NSLog(@"LIKE Button Pressed: ");
    
    UIButton *btn = (UIButton *)sender;
    
    //NSLog(@"btn.tag %d",btn.tag);
    //UITouch * touch = [[event allTouches] anyObject];
    //CGPoint location = [touch locationInView: self.tableView];
    //NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint: location];
    //NSLog(@"%d", indexPath.row);
    //DTexBarTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    DTexBarTableViewCell * cell = (DTexBarTableViewCell*)[[sender superview] superview];
    
    //From the cell get its index path.
    //NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // Find Point in Superview
    CGPoint pointInSuperview = [btn.superview convertPoint:btn.center toView:self.tableView];
    // Infer Index Path
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pointInSuperview];
    NSLog(@"%ld", indexPath.row);
    
    NSString * btn_title = [[btn titleLabel] text];
    
    NSLog(@"Button Title on Press = %@", btn_title);
    
    
    if ([btn_title isEqualToString:@"NO"]) {
        NSLog(@"NO");
        [btn setTitle:@"YES" forState:UIControlStateSelected];
        
        if (btn.tag == indexPath.row) {
            [btn setBackgroundColor:[UIColor greenColor]];

        cell.CellBarRatingLabel.text = @"NO";
        cell.CellBarRatingLabel.textColor = [UIColor greenColor];
        }
        
        //NSLog(@"Favorites List = %ld", [_favorites count]);
        //NSLog(@"index path = %ld", indexPath.row);
        //NSLog( NSStringFromClass( [_favorites class] ));
        
        //NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
        //[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil];
        
        /*
         [self.tableView beginUpdates];
         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
         [self.tableView endUpdates];
         */
        
    }
    else if ([btn_title isEqualToString:@"YES"]) {
        NSLog(@"YES");
        
        [btn setTitle:@"NO" forState:UIControlStateNormal];
        //[btn setTitle:@"NO" forState:UIControlStateDisabled];
        //[btn setTitle:@"NO" forState:<#(UIControlState)#>];
        [btn setBackgroundColor:[UIColor redColor]];
        
        cell.CellBarRatingLabel.text = @"YES";
        cell.CellBarRatingLabel.textColor = [UIColor redColor];
        
        //NSLog(@"Favorites List = %ld", [_favorites count]);
        NSLog(@"index path = %ld", indexPath.row);
        //NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
        //[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil];
        
        /*
         [self.tableView beginUpdates];
         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
         [self.tableView endUpdates];
         */
        
        
    }
}

- (IBAction)likeBtnPress:(id)sender forEvent:(UIEvent *)event {
    
    NSLog(@"LIKE Button Pressed: ");
    
    UIButton *btn = (UIButton *)sender;
    
    //Get the superview from this button which will be our cell
    //UITableViewCell *owningCell = (UITableViewCell*)[sender superview];
    
    //From the cell get its index path.
    //NSIndexPath *pathToCell = [myTableView indexPathForCell:owningCell];

    
    //NSLog(@"btn.tag %d",btn.tag);
    //UITouch * touch = [[event allTouches] anyObject];
    //CGPoint location = [touch locationInView: self.tableView];
    //NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint: location];
    //NSLog(@"%d", indexPath.row);
    //DTexBarTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    DTexBarTableViewCell * cell = (DTexBarTableViewCell*)[[sender superview] superview];
    
    //From the cell get its index path.
    //NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // Find Point in Superview
    CGPoint pointInSuperview = [btn.superview convertPoint:btn.center toView:self.tableView];
    
    // Infer Index Path
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pointInSuperview];
    
    NSString * btn_title = [[btn titleLabel] text];
    
    NSLog(@"Button Title on Press = %@", btn_title);
    
    
    if ([btn_title isEqualToString:@"NO"]) {
        NSLog(@"NO");
        [btn setTitle:@"YES" forState:UIControlStateNormal];
        
        [btn setBackgroundColor:[UIColor greenColor]];
        
        cell.CellBarRatingLabel.text = @"NO";
        cell.CellBarRatingLabel.textColor = [UIColor greenColor];
        
        //NSLog(@"Favorites List = %ld", [_favorites count]);
        //NSLog(@"index path = %ld", indexPath.row);
        //NSLog( NSStringFromClass( [_favorites class] ));

        
        //NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
                                     //[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil];
        
        /*
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
         */

    }
    else if ([btn_title isEqualToString:@"YES"]) {
        NSLog(@"YES");
    
        [btn setTitle:@"NO" forState:UIControlStateNormal];
        //[btn setTitle:@"NO" forState:UIControlStateDisabled];
        //[btn setTitle:@"NO" forState:<#(UIControlState)#>];
        [btn setBackgroundColor:[UIColor redColor]];
        
        cell.CellBarRatingLabel.text = @"YES";
        cell.CellBarRatingLabel.textColor = [UIColor redColor];
        
        //NSLog(@"Favorites List = %ld", [_favorites count]);
        NSLog(@"index path = %ld", indexPath.row);
        //NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
        //[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil];
        
        /*
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
         */
        
        
    }
    
    
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
     // Check that a new transition has been requested to the DetailViewController and prepares for it
     if ([segue.identifier isEqualToString:@"viewsegue"]) {
         // Capture the object (e.g. exam) the user has selected from the list
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         PFObject *object = [self.objects objectAtIndex:indexPath.row];
         DTexBarDetailViewController *detailViewController = [segue destinationViewController];
         detailViewController.exam = object;

     }
 }


@end


