//
//  DTexFavoritesTableViewCell.h
//  DTex
//
//  Created by Rene Trevino Jr. on 3/15/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface DTexFavoritesTableViewCell : UITableViewCell <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *CellFavBarName;


@property (weak, nonatomic) IBOutlet UILabel *cellFavSummaryLabel;

@property (weak, nonatomic) IBOutlet UILabel *cellFavSpecialLabel;


//@property (weak, nonatomic) IBOutlet UILabel *CellFavBarAddress;
//@property (weak, nonatomic) IBOutlet UILabel *CellFavBarArea;

@property (weak, nonatomic) IBOutlet UIButton *cellLikeBtn;


@property (weak, nonatomic) IBOutlet UILabel *cellFavRatingLabel;

//@property (weak, nonatomic) IBOutlet UILabel *cellFavDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellFavDayLabel;



@end
