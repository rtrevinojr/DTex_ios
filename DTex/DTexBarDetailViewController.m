//
//  DTexBarDetailViewController.m
//  DTex
//
//  Created by Rene  Trevino Jr. on 10/17/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import "DTexBarDetailViewController.h"

@interface DTexBarDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label_barname;

@property (weak, nonatomic) IBOutlet UILabel *BarNameLabel;
@property (weak, nonatomic) NSString * BarName;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

//@property (strong, nonatomic) PFObject * exam;

@end

@implementation DTexBarDetailViewController

@synthesize BarName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFObject * selection = _exam;
    BarName = [selection objectForKey:@"Bar_Name"];
    
    _AddressLabel.text = [selection objectForKey:@"Address"];
    _phoneLabel.text = [selection objectForKey:@"Phone"];
    _websiteLabel.text = [selection objectForKey:@"Website"];
    
    
    
    NSLog(@"Bar Name = %@", BarName);
    
    _BarNameLabel.text = BarName;
    _label_barname.text = BarName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setBarName:(NSString *) name
{
    BarName = name;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
