//
//  DetailViewController.h
//  VehicleTracker
//
//  Created by Iftikhar on 14/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic,assign) NSDictionary *myDict;

@end
