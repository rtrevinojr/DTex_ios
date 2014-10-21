//
//  DTexBarEventTableViewCell.h
//  DTex
//
//  Created by Rene  Trevino Jr. on 10/21/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTexBarEventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *BarCellBarNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *BarCellSummaryLabel;

@property (weak, nonatomic) IBOutlet UILabel *BarCellSpecialLabel;
@property (weak, nonatomic) IBOutlet UILabel *BarCellDayLabel;

@end
