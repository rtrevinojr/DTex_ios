//
//  DTexBarDetailViewController.m
//  DTex
//
//  Created by Rene  Trevino Jr. on 10/17/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import "DTexBarDetailViewController.h"

#import "DTexBarEventsTableViewController.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface DTexBarDetailViewController ()

@property (strong, nonatomic) NSString * BarName;
@property (strong, nonatomic) NSNumber * BarKey;

@property (weak, nonatomic) IBOutlet UILabel *label_barname;
@property (weak, nonatomic) IBOutlet UILabel *BarNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
//@property (strong, nonatomic) PFObject * exam;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) CLLocationManager *locationManager;

@property (nonatomic) NSNumber * BarLatitude;
@property (nonatomic) NSNumber * BarLongitude;


@end


@implementation DTexBarDetailViewController

@synthesize BarName;
@synthesize mapView;
@synthesize BarKey;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFObject * selection = _exam;
    
    BarName = [selection objectForKey:@"Bar_Name"];
    BarKey = [selection objectForKey:@"ID"];
    
    _AddressLabel.text = [selection objectForKey:@"Address"];
    _phoneLabel.text = [selection objectForKey:@"Phone"];
    _websiteLabel.text = [selection objectForKey:@"Website"];
    
    _BarLatitude = [selection objectForKey:@"latitude"];
    _BarLongitude = [selection objectForKey:@"longitude"];
    
    NSLog(@"Bar Name = %@", BarName);
    _BarNameLabel.text = BarName;
    _label_barname.text = BarName;
 
    /*
    mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        //[self.locationManager requestAlwaysAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
    
    //mapView.showsUserLocation = YES;
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
     */
    
    //View Area
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    //region.center.latitude = self.locationManager.location.coordinate.latitude;
    //region.center.longitude = self.locationManager.location.coordinate.longitude;
    
    region.center.latitude = [_BarLatitude floatValue];
    region.center.longitude = [_BarLongitude floatValue];
    
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [mapView setRegion:region animated:NO];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    //point.coordinate = userLocation.coordinate;
    
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [_BarLatitude floatValue];
    coordinate.longitude = [_BarLongitude floatValue];
    
    point.coordinate = coordinate;
    
    point.title = BarName;
    point.subtitle = _AddressLabel.text;
    
    [self.mapView addAnnotation:point];
    [self.mapView selectAnnotation:point animated:YES];
 
}

/*
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
     CLLocationDistance distance = 1000;
     CLLocationCoordinate2D myCoordinate;
     myCoordinate.latitude = [_BarLatitude floatValue];
     myCoordinate.longitude = [_BarLongitude floatValue];
    
     MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(myCoordinate,
     distance,
     distance);
     
     MKCoordinateRegion adjusted_region = [self.mapView regionThatFits:region];
     [self.mapView setRegion:adjusted_region animated:YES];

 
 
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    [self.mapView addAnnotation:point];
    
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setBarName:(NSString *) name
{
    BarName = name;
}
- (void) setBarKey:(NSNumber *)BarKey {
    BarKey = BarKey;
}

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"drinkspecialsegue"]){
        [[segue destinationViewController] setBarSelection:BarName];
        [[segue destinationViewController] setBarFKeySelection:BarKey];
        
        DTexBarEventsTableViewController *detailViewController = [segue destinationViewController];
    
        NSLog(@"BAR SELECTION ---------------- %@", BarName);
        //detailViewController.object = _exam;
    }
}

@end

