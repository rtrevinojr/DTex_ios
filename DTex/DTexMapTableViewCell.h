//
//  DTexMapTableViewCell.h
//  DTex
//
//  Created by Rene Trevino Jr. on 3/18/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h> 


@interface DTexMapTableViewCell : UITableViewCell <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;

@end
