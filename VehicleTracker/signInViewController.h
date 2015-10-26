//
//  signUpViewCellType.h
//  uRecorder
//
//  Created by Fazal Ellahi on 18/03/2014.
//  Copyright (c) 2014 Fazal Ellahi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginCompletedDelegate;

@interface signInViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>{
    
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *passTextField;
    IBOutlet UISwitch *passSwitch;
    int validtextFields;
    
    NSMutableArray *savedLogins;

}
@property (nonatomic,assign) NSObject<LoginCompletedDelegate> *delegate;

-(IBAction)LoginPressedSelector:(id)sender;
-(IBAction)contactButtonPressed:(id)sender;
-(IBAction)registerButtonPressed:(id)sender;

@end
@protocol LoginCompletedDelegate

- (void)loginView:(signInViewController*)loginView DidLoginUser:(BOOL)success;


@end
