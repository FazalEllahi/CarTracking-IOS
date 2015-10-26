//
//  RootViewController.h
//  VehicleTracker
//
//  Created by Iftikhar on 13/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property(nonatomic,strong) IBOutletCollection(UILabel) NSArray *lblCollection;
@property(nonatomic,strong) IBOutletCollection(UIButton) NSArray *btnCollection;
@property(nonatomic,strong) IBOutlet UIView *SpinnView;


-(IBAction)backButtonPressed:(id)sender;
-(IBAction)SubButtonPressed:(id)sender;


@end
