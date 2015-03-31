//
//  DTexMapViewController.m
//  DTex
//
//  Created by Rene  Trevino Jr. on 11/10/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import "DTexMapViewController.h"
#import "DTexBarDetailViewController.h"
#import "DTexMapTableViewCell.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface DTexMapViewController ()

@property (strong, nonatomic) NSString * BarAnnotation;

@end


@implementation DTexMapViewController

@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"DTex Map";
    self.tableView.scrollEnabled = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    //mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        //[self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
    
    //mapView.showsUserLocation = YES;
    //[mapView setMapType:MKMapTypeStandard];
    //[mapView setZoomEnabled:YES];
    //[mapView setScrollEnabled:YES];
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
- (void)viewWillDisappear:(BOOL)animated
{
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    /*
    self.locationManager.distanceFilter = kCLDistanceFilterNone; //Whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    NSLog(@"%@", [self deviceLocation]);
    //View Area
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    // UT Tower Coordinates
    // latitude = 30.28565
    // longitude = -97.73921
    region.center.latitude = 30.28565;
    region.center.longitude = -97.73921;
    region.span.longitudeDelta = 0.115f;
    region.span.longitudeDelta = 0.115f;
    [mapView setRegion:region animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"DTexBars"];
    NSArray * barlst = [query findObjects];
    //NSArray * barlst = [query findObjectsInBackground];
    //[query findObjectsInBackgroundWithBlock:<#^(NSArray *objects, NSError *error)block#>]
        for (PFObject * obj in barlst) {
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            CLLocationCoordinate2D coordinate;
            NSNumber * lat = [obj objectForKey:@"latitude"];
            NSNumber * lng = [obj objectForKey:@"longitude"];
            coordinate.latitude = [lat floatValue];
            coordinate.longitude = [[obj objectForKey:@"longitude"] floatValue];
            point.coordinate = coordinate;
            point.title = [obj objectForKey:@"Bar_Name"];
            point.subtitle = [obj objectForKey:@"Address"];
            [self.mapView addAnnotation:point];
    }
    */
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //MKMapView *map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    //MKMapView * map = [[MKMapView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aaaa"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:mapView];
    
    mapView.delegate = self;
    
    //mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        //[self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
    mapView.showsUserLocation = YES;
    
    //View Area
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    // UT Tower Coordinates
    region.center.latitude = 30.28565;
    region.center.longitude = -97.73921;
    region.span.longitudeDelta = 0.115f;
    region.span.longitudeDelta = 0.115f;
    [mapView setRegion:region animated:YES];
    [mapView setRegion:region animated:YES];
    
    PFQuery *query = [PFQuery queryWithClassName:@"DTexBars"];
    //NSArray * barlst = [query findObjects];
    //NSArray * barlst = [query findObjectsInBackground];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject * obj in objects) {
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            CLLocationCoordinate2D coordinate;
            NSNumber * lat = [obj objectForKey:@"latitude"];
            //NSNumber * lng = [obj objectForKey:@"longitude"];
            coordinate.latitude = [lat floatValue];
            coordinate.longitude = [[obj objectForKey:@"longitude"] floatValue];
            point.coordinate = coordinate;
            point.title = [obj objectForKey:@"Bar_Name"];
            point.subtitle = [obj objectForKey:@"Address"];
            //[mapView addOverlay:[MKCircle circleWithCenterCoordinate:coordinate radius:20]];
            [mapView addAnnotation:point];
    
        }
    }];
    
    return cell;
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSLog(@"mapView viewForAnnotation ");
    if (![annotation isKindOfClass:[MKUserLocation class]]) {
        MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
        annotationView.canShowCallout = YES;
        UIButton * detail = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = detail;
        return annotationView;
    }
    return nil;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"mapView calloutAccessoryControlTapped ");
    _BarAnnotation = view.annotation.title;
    [self performSegueWithIdentifier:@"mapselect" sender:view];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
//    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
//        self.mapView.showsUserLocation = YES;
//    }
}

/*
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}
*/

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceLat {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
}
- (NSString *)deviceLon {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceAlt {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.altitude];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Check that a new transition has been requested to the DetailViewController and prepares for it
    if ([segue.identifier isEqualToString:@"mapselect"]){

        PFQuery *query = [PFQuery queryWithClassName:@"DTexBars"];
        
        NSString * BarName = _BarAnnotation;
        
      
        
        [query whereKey:@"Bar_Name" equalTo:BarName];
        
        PFObject * obj = [query getFirstObject];
        
        
        //PFObject * o = [query getObjectWithId:<#(NSString *)#>]
        
        /*
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            DTexBarDetailViewController *detailViewController = [segue destinationViewController];
            detailViewController.exam = object;
        }];
         */
        
        //[query whereKey:@"objectId" equalTo:objectID];
        //PFObject * object = [query getObjectWithId:objectID];
        /*
        [query getObjectInBackgroundWithId:objectID block:^(PFObject *object, NSError *error) {
            //NSLog(@"%@", object);
            DTexBarDetailViewController *detailViewController = [segue destinationViewController];
            detailViewController.exam = obj;

        }];
         */
        
         /*
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            
            DTexBarDetailViewController *detailViewController = [segue destinationViewController];
            detailViewController.exam = [objects firstObject];
        }];
          */

        DTexBarDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.exam = obj;

    }


    
}


@end
