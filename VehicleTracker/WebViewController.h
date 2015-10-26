//
//  WebViewController.h
//  VehicleTracker
//
//  Created by fazal on 10/4/15.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *webView;
}
-(IBAction)backButtonPressed:(id)sender;
@end
