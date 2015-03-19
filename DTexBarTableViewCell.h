//
//  DTexBarTableViewCell.h
//  DTex
//
//  Created by Rene Trevino Jr. on 3/14/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h> 


@interface DTexBarTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *CellBarNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *CellBarAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *CellBarAreaLabel;

@property (weak, nonatomic) IBOutlet UIButton *CellBarLikeBtn;

@property (weak, nonatomic) IBOutlet UILabel *CellBarRatingLabel;


@property (nonatomic, assign) BOOL CellIsLiked;


@end
