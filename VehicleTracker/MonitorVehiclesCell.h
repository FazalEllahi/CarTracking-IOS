//
//  MonitorVehiclesCell.h
//  VehicleTracker
//
//  Created by fazal on 9/19/15.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonitorVehiclesCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *iconImg;
@property (nonatomic,weak) IBOutlet UILabel *textlbl;
@property (nonatomic,weak) IBOutlet UIImageView *carImg;
@property (nonatomic,weak) IBOutlet UIButton *stopCarBtn;


@end
