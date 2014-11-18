//
//  DTexMapViewController.m
//  DTex
//
//  Created by Rene  Trevino Jr. on 11/10/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import "DTexMapViewController.h"

#import "DTexBarDetailViewController.h"


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
    self.title = @"Map";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    mapView.delegate = self;
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
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone; //Whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    NSLog(@"%@", [self deviceLocation]);
    
    //View Area
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    
    //region.center.latitude = 30.266f;
    //region.center.longitude = -97.742;
    
    region.span.longitudeDelta = 0.115f;
    region.span.longitudeDelta = 0.115f;
    [mapView setRegion:region animated:YES];
 
    // Add an annotation
    //MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    //point.coordinate = userLocation.coordinate;

    //CLLocationCoordinate2D coordinate;
    //coordinate.latitude = 30.266f;
    //coordinate.longitude = -97.742f;
    
    //point.coordinate = coordinate;
     
    //point.title = @"Where am I?";
    //point.subtitle = @"I'm here!!!";
    
    //[self.mapView addAnnotation:point];
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"mapselect" sender:view];
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
    }
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


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    /*
  
    //CLLocationDistance distance = 1000;
    //CLLocationCoordinate2D myCoordinate;
    //myCoordinate.latitude = 13.04016;
    //myCoordinate.longitude = 80.243044;
    
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(myCoordinate,
                                                                   distance,
                                                                   distance);
    
    //MKCoordinateRegion adjusted_region = [self.mapView regionThatFits:region];
    //[self.mapView setRegion:adjusted_region animated:YES];
     
     */
    
/*
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
 
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    //point.coordinate = userLocation.coordinate;
    
    //point.coordinate.latitude = 30.0f;
    //point.coordinate.longitude = -97.0f;
    
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    [self.mapView addAnnotation:point];
 
 */
 
}

/*
-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:    (id<MKAnnotation>)annotation {
    
     // Add an annotation
     MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
     //point.coordinate = userLocation.coordinate;
     
     CLLocationCoordinate2D coordinate;
     coordinate.latitude = 30.266f;
     coordinate.longitude = -97.742f;
     
     point.coordinate = coordinate;
     
     point.title = @"Where am I?";
     point.subtitle = @"I'm here!!!";
     
     [self.mapView addAnnotation:point];
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    MKPinAnnotationView *MyPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"User"];
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    
    MyPin.rightCalloutAccessoryView = rightButton;
    MyPin.draggable = NO;
    MyPin.highlighted = YES;
    MyPin.animatesDrop=TRUE;
    MyPin.canShowCallout = YES;
    
    //UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CorgiRunner2 Final.png"]];
    //myCustomImage.image = profPic;
    
    //myCustomImage.frame = CGRectMake(0,0,31,31);
    //MyPin.leftCalloutAccessoryView = myCustomImage;
    
    return MyPin;
}

*/

/*
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.latitudeDelta = 0.0187f;
    region.span.longitudeDelta = 0.0137f;
    [self.mapView setRegion:region animated:YES];
    
    //_initialPosition = NO;
}
*/




#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Check that a new transition has been requested to the DetailViewController and prepares for it
    if ([segue.identifier isEqualToString:@"mapselect"]){
        
        // Capture the object (e.g. exam) the user has selected from the list
        
        PFQuery *query = [PFQuery queryWithClassName:@"DTexBars"];
        
        NSLog(@"prepare for segue........");
        
        //__block PFObject * obj = nil;

        /*
        
        [query getObjectInBackgroundWithId:@"DJlo4DCZCi" block:^(PFObject *bar, NSError *error) {
            // Do something with the returned PFObject in the gameScore variable.
            NSLog(@"ERROR = %@", error);
            NSLog(@"----------------%@", bar);
            
            NSLog(@"Bar Name: %@", bar[@"Bar_Name"]);
            NSLog(@"Bar id: %@", bar[@"ID"]);
            
            NSString * name = [bar objectForKey:@"Bar_Name"];
            
            NSLog(@"test = %@", name);
            
            DTexBarDetailViewController *detailViewController = [segue destinationViewController];
            detailViewController.exam = bar;
            
            NSString * barname = obj[@"Bar_Name"];
            NSNumber * barid = obj[@"ID"];
            
            [[segue destinationViewController] setBarObject:bar];
            
            [[segue destinationViewController] setBarName:barname];
            [[segue destinationViewController] setBarKey:barid];
            
            obj = bar;
            
        }];
         
         */
        
        //NSLog(@"testttttttt ========== %@", obj);
        
        
        PFObject * obj = [query getObjectWithId:@"DJlo4DCZCi"];
        
        NSLog(@"testttttttt ========== %@", obj);
        
        
        DTexBarDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.exam = obj;
        
        /*
        
        NSString * barname = obj[@"Bar_Name"];
        NSNumber * barid = obj[@"ID"];
        
        [[segue destinationViewController] setBarName:barname];
        [[segue destinationViewController] setBarKey:barid];
         */
 
    }


    
}


@end
