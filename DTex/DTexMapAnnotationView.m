//
//  DTexMapAnnotationView.m
//  DTex
//
//  Created by Rene  Trevino Jr. on 11/12/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import "DTexMapAnnotationView.h"

@interface DTexMapAnnotationView ()

@end

@implementation DTexMapAnnotationView

/*
@synthesize accessory = _accessory;

- (id) initWithAnnotation:(id <mkannotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.accessory = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        self.accessory.exclusiveTouch = YES;
        self.accessory.enabled = YES;
        [self.accessory addTarget: self
                           action: @selector(calloutAccessoryTapped)
                 forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchCancel];
        [self addSubview:self.accessory];
    }
    return self;
}

- (void)prepareContentFrame {
    CGRect contentFrame = CGRectMake(	self.bounds.origin.x + 10,
                                     self.bounds.origin.y + 3,
                                     self.bounds.size.width - 20,
                                     self.contentHeight);
    
    self.contentView.frame = contentFrame;
}

- (void)prepareAccessoryFrame {
    self.accessory.frame = CGRectMake(self.bounds.size.width - self.accessory.frame.size.width - 15,
                                      (self.contentHeight + 3 - self.accessory.frame.size.height) / 2,
                                      self.accessory.frame.size.width,
                                      self.accessory.frame.size.height);
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self prepareAccessoryFrame];
}

- (void) calloutAccessoryTapped {
    if ([self.mapView.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]) {
        [self.mapView.delegate mapView:self.mapView
                        annotationView:self.parentAnnotationView
         calloutAccessoryControlTapped:self.accessory];
    }
} 
 
 */

@end
