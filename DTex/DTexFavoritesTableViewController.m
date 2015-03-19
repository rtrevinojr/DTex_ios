//
//  DTexFavoritesTableViewController.m
//  DTex
//
//  Created by Rene Trevino Jr. on 3/15/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "DTexFavoritesTableViewController.h"
#import "DTexAppDelegate.h"
#import "DTexFavoritesTableViewCell.h"
#import <Parse/Parse.h>


@interface DTexFavoritesTableViewController ()

@property (strong, nonatomic) NSMutableArray * favorites;

@end

@implementation DTexFavoritesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Favorites";
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
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    //create predicate to filter request. We will be filtering our search by whatever is in the name text field.
    //NSPredicate *pred  = [NSPredicate predicateWithFormat:@"(objectId = %@)", obj.objectId];
    //[request setPredicate:pred];
    //put the results in a managed object
    NSManagedObject *matches = nil;
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    self.favorites = [[NSMutableArray alloc] init];
    self.favorites = [objects mutableCopy];
    
    
    //test the results of the search request
    if ([objects count] == 0 ) {
        NSLog(@"No objects found in Core Data");
    }
    else {
        NSLog(@"Favorite Objects Count = %ld", [objects count]);
        matches = objects[0];
        //get the arrayData (string) and add it to a sting object.
        NSString *arrayString = [matches valueForKey:@"objectId"];
        //make an array from the string.
        //NSArray *array = [arrayString componentsSeparatedByString:@","];
        //cast the index as an int
        //int theIndex = [_arrayIndexTextField.text intValue];
        //output the results
        NSLog(@"Core Data element = %@", arrayString);
    }
    

    [request setEntity:entityDesc];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [NSEntityDescription entityForName:@"EventLikes" inManagedObjectContext:context];
    //fetch.predicate = [NSPredicate predicateWithFormat:@"objectId == %@", [btn currentTitle]];
    NSArray *array = [context executeFetchRequest:fetch error:nil];
    NSLog(@"Request array Count = %ld", [array count]);
    
    for (NSManagedObject *managedObject in array) {
        [context deleteObject:managedObject];
        if ([_favorites containsObject:managedObject])
            [_favorites removeObject:managedObject];
    }
    [_favorites removeAllObjects];
    
    NSLog(@"NEW CORE DATA COUNT = %ld", [_favorites count]);
    NSLog(@"NEW CORE DATA COUNT = %ld", [_favorites count]);
    
 
    
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    //[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return [self.favorites count];
    return [_favorites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DTexFavCell";
    DTexFavoritesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[DTexFavoritesTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    NSManagedObject *matches = nil;
    NSError *error;
    //NSArray *objects = [context executeFetchRequest:request error:&error];
    //test the results of the search request
    if ([self.favorites count] == 0 ) {
        NSLog(@"No objects found in Core Data");
    }
    else if ( indexPath.row >= [_favorites count]) {
        NSLog(@"No other objects found in Core Data");
    }
    else {
        matches = self.favorites[indexPath.row];
        //get the arrayData (string) and add it to a sting object.
        NSString *objectID = [matches valueForKey:@"objectId"];
        NSLog(@"Bar Object = %@", objectID);
        //NSString * bar_obj = [self.favorites objectAtIndex:indexPath.row];

        PFQuery *query = [PFQuery queryWithClassName:@"DTex_Events"];
        [query whereKey:@"objectId" equalTo:objectID];
        PFObject * object = [query getObjectWithId:objectID];
    
        /*
         [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
         PFObject *obj = [objects firstObject];
         NSLog(@"%@", obj);
         }];
         */
        cell.CellFavBarName.text = [object objectForKey:@"Name"];
        cell.cellFavSummaryLabel.text = [object objectForKey:@"Summary"];
        cell.cellFavSpecialLabel.text = [object objectForKey:@"Special"];
        
        [cell.cellLikeBtn setTitle:[object objectId] forState:UIControlStateNormal];
        
        NSNumber *cellbar_rating = [object objectForKey:@"Rating"];
        NSString * rating_str = [cellbar_rating stringValue];
        rating_str = [rating_str stringByAppendingString:@" Likes"];
        cell.cellFavRatingLabel.text = rating_str;
        
        //cell.cellFavRatingLabel.text = [[object objectForKey:@"Rating"] stringValue];
        
        [cell.cellLikeBtn addTarget: self
                               action: @selector(unLikeBtnPress:forEvent:)
                     forControlEvents: UIControlEventTouchUpInside];
        cell.cellLikeBtn.tag = indexPath.row;
    }
    
    return cell;
    
}



- (IBAction)unLikeBtnPress:(id)sender forEvent:(UIEvent *)event {
    
    UIButton *btn = (UIButton *)sender;
    //NSLog(@"btn.tag %d",btn.tag);
    UITouch * touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView: self.tableView];
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint: location];
    //NSLog(@"%d", indexPath.row);
    
    //if ([btn_title isEqualToString:@"YES"]) {
        //[btn setTitle:@"NO" forState:UIControlStateNormal];
        
        NSLog(@"Favorites List = %ld", [_favorites count]);
        NSLog(@"index path = %ld", indexPath.row);
        
        //NSLog( NSStringFromClass( [_favorites class] ));
        
        [_favorites removeObjectAtIndex: (long)indexPath.row];
        //[_favorites removeObject: item];
        //[_favorites removeLastObject];
        

        
        //UITableView *tv = (UITableView *)self.view;
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
        
        int valint = [val intValue];
        NSLog(@"val int = %d", valint);
        val = [NSNumber numberWithInt:valint - 1];
        
        NSLog(@"val int - 1 = %@", val);
        [obj setObject:val forKey:@"Rating"];
        [obj save];
        //[_eventFavorites_str removeObject:btn.currentTitle];
        
        //NSManagedObjectContext *context = [appDelegate managedObjectContext];
        //NSManagedObject *removeObj = [NSEntityDescription insertNewObjectForEntityForName:@"EventLikes" inManagedObjectContext:context];

        NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
        fetch.entity = [NSEntityDescription entityForName:@"EventLikes" inManagedObjectContext:context];
        fetch.predicate = [NSPredicate predicateWithFormat:@"objectId == %@", [btn currentTitle]];
        NSArray *array = [context executeFetchRequest:fetch error:nil];
        
        for (NSManagedObject *managedObject in array) {
            [context deleteObject:managedObject];
            if ([_favorites containsObject:managedObject])
                [_favorites removeObject:managedObject];
        }
        
    //}
    
    NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
                                 [NSIndexPath indexPathForRow:indexPath.row inSection:0], nil];
    
    [self.tableView beginUpdates];
    //[tv insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
