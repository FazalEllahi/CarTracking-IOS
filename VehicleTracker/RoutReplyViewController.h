//
//  RoutReplyViewController.h
//  VehicleTracker
//
//  Created by Iftikhar on 30/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoutReplyViewController : UIViewController<UIActionSheetDelegate>{
    UIActionSheet *actionSheet;
}

@property(nonatomic,retain) IBOutlet UILabel *lbl;
@property(nonatomic,assign) NSDictionary *myDictionary;

-(IBAction)backButtonPressed:(id)sender;
-(IBAction)yestButtonPressed:(id)sender;
-(IBAction)todayButtonPressed:(id)sender;
-(IBAction)rangeButtonPressed:(id)sender;

@end
