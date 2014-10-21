//
//  DTexEventTableViewCell.h
//  DTex
//
//  Created by Rene  Trevino Jr. on 10/18/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import <Parse/Parse.h>

@interface DTexEventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *CellBarNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *CellSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *CellSpecialLabel;
@property (weak, nonatomic) IBOutlet UILabel *CellDayLabel;

@end
