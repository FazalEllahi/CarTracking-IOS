//
//  AppDelegate.m
//  VehicleTracker
//
//  Created by Iftikhar on 05/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import "AppDelegate.h"
#import "ApiController.h"
#import "RearViewController.h"
#import "FrontViewController.h"
#import "SWRevealViewController.h"
#import "RightViewController.h"
#import "CustomAnnotation.h"
#import "CustomAnimationController.h"
#import "MBProgressHUD.h"
#import "TripViewController.h"

@interface AppDelegate ()<SWRevealViewControllerDelegate>

@end

@implementation AppDelegate

@synthesize loginData;

@synthesize viewController = _viewController;

@synthesize TripData;

-(NSAttributedString*)getCellAttributedText:(NSDictionary*)text{
    
    UIFont *titlefont = [UIFont fontWithName:@"Courier-Bold" size:14.0];
    UIFont *txtfont = [UIFont fontWithName:@"Courier" size:14.0];
    
    UIFont *detailfont = [UIFont fontWithName:@"Courier-Bold" size:12.0];
    UIFont *detailtxtfont = [UIFont fontWithName:@"Courier" size:12.0];
    
    NSArray *dictWord = @[[NSString stringWithFormat:@"NumberPlate : %@",[text objectForKey:@"NumberPlate"]],
                                                                          [NSString stringWithFormat:@"TrackerName : %@",[text objectForKey:@"TrackerName"]],
                                                                          [NSString stringWithFormat:@"Speed : %@",[text objectForKey:@"Speed"]],
                                                                          [NSString stringWithFormat:@"Mileage : %@",[text objectForKey:@"Mileage"]],
                                                                          [NSString stringWithFormat:@"Time : %@",[text objectForKey:@"Time"]]];
    
    NSArray *dictfonts = @[[NSDictionary dictionaryWithObject:titlefont forKey:NSFontAttributeName],
                                                     [NSDictionary dictionaryWithObject:txtfont forKey:NSFontAttributeName],
                                                     [NSDictionary dictionaryWithObject:detailfont forKey:NSFontAttributeName],
                                                     [NSDictionary dictionaryWithObject:detailtxtfont forKey:NSFontAttributeName],
                                                     [NSDictionary dictionaryWithObject:detailfont forKey:NSFontAttributeName],
                                                     [NSDictionary dictionaryWithObject:detailtxtfont forKey:NSFontAttributeName],
                                                     [NSDictionary dictionaryWithObject:detailfont forKey:NSFontAttributeName],
                                                     [NSDictionary dictionaryWithObject:detailtxtfont forKey:NSFontAttributeName],
                                                     [NSDictionary dictionaryWithObject:detailfont forKey:NSFontAttributeName],
                                                     [NSDictionary dictionaryWithObject:detailtxtfont forKey:NSFontAttributeName]];
    
    
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@""];
    
    int i = 0;
    
    for (NSString * word in dictWord) {
        
        NSDictionary *attrsDictionary = [dictfonts objectAtIndex:i++];
        
        NSAttributedString * subString = [[NSAttributedString alloc] initWithString:[[word componentsSeparatedByString:@":"] objectAtIndex:0] attributes:attrsDictionary];
        
        [string appendAttributedString:subString];
        
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@" : " attributes:nil]];
        
        
        attrsDictionary = [dictfonts objectAtIndex:i++];
        
        subString = [[NSAttributedString alloc] initWithString:[[word componentsSeparatedByString:@":"] objectAtIndex:1]  attributes:attrsDictionary];
        
        [string appendAttributedString:subString];
        
        if ([[[word componentsSeparatedByString:@":"] objectAtIndex:0] isEqualToString:@"TrackerName "] || [[[word componentsSeparatedByString:@":"] objectAtIndex:0] isEqualToString:@"Mileage "])
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\t" attributes:nil]];
        else
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
        
    }
    
    return string;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ApiController sharedManager];
      
    [self setUpSideBarController];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
+ ( AppDelegate *)sharedAppDelegate
{
    return ( AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (NSString *) getPlistFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    documentsDir = [documentsDir stringByAppendingPathComponent:@"LoginData.plist"];
    return documentsDir;
}
- (void) copyDataFile {
    
    NSString *documentsDir = [self getPlistFilePath];
    BOOL isDir;

    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDir isDirectory:&isDir])  {
        
        [[NSFileManager defaultManager] createFileAtPath:documentsDir contents:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LoginData" ofType:@"plist"]] attributes:Nil];
        
      //  NSArray *array = [[NSArray alloc]initWithContentsOfFile:documentsDir];
        self.loginData = [[NSMutableDictionary alloc]initWithContentsOfFile:documentsDir];
        
    }
    else{

        self.loginData = [[NSMutableDictionary alloc]initWithContentsOfFile:documentsDir];
        [self.loginData writeToFile:documentsDir atomically:YES];
    }
    
}
-(void)SaveFileToPlist{
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    documentsDir = [documentsDir stringByAppendingPathComponent:@"LoginData.plist"];
    
    [self.loginData writeToFile:documentsDir atomically:YES];
    
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.pitchapps.VehicleTracker" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"VehicleTracker" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"VehicleTracker.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)setUpSideBarController
{
    
    FrontViewController *frontViewController = [[FrontViewController alloc] init];
    RearViewController *rearViewController = [[RearViewController alloc] init];
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    revealController.delegate = self;
    
    revealController.rightViewController = nil;
    
    revealController.bounceBackOnOverdraw=NO;
    revealController.stableDragOnOverdraw=YES;
    
    self.viewController = revealController;
    
//    [self.window addSubview:self.viewController.view];
//    [self.window bringSubviewToFront:self.viewController.view];
  
}


#pragma mark - SWRevealViewDelegate

- (id <UIViewControllerAnimatedTransitioning>)revealController:(SWRevealViewController *)revealController animationControllerForOperation:(SWRevealControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if ( operation != SWRevealControllerOperationReplaceRightController )
        return nil;
    
    if ( [toVC isKindOfClass:[RightViewController class]] )
    {
        if ( [(RightViewController*)toVC wantsCustomAnimation] )
        {
            id<UIViewControllerAnimatedTransitioning> animationController = [[CustomAnimationController alloc] init];
            return animationController;
        }
    }
    
    return nil;
}


#define LogDelegates 0

#if LogDelegates
- (NSString*)stringFromFrontViewPosition:(FrontViewPosition)position
{
    NSString *str = nil;
    if ( position == FrontViewPositionLeftSideMostRemoved ) str = @"FrontViewPositionLeftSideMostRemoved";
    if ( position == FrontViewPositionLeftSideMost) str = @"FrontViewPositionLeftSideMost";
    if ( position == FrontViewPositionLeftSide) str = @"FrontViewPositionLeftSide";
    if ( position == FrontViewPositionLeft ) str = @"FrontViewPositionLeft";
    if ( position == FrontViewPositionRight ) str = @"FrontViewPositionRight";
    if ( position == FrontViewPositionRightMost ) str = @"FrontViewPositionRightMost";
    if ( position == FrontViewPositionRightMostRemoved ) str = @"FrontViewPositionRightMostRemoved";
    return str;
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position
{
    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealControllerPanGestureBegan:(SWRevealViewController *)revealController;
{
    NSLog( @"%@", NSStringFromSelector(_cmd) );
}

- (void)revealControllerPanGestureEnded:(SWRevealViewController *)revealController;
{
    NSLog( @"%@", NSStringFromSelector(_cmd) );
}

- (void)revealController:(SWRevealViewController *)revealController panGestureBeganFromLocation:(CGFloat)location progress:(CGFloat)progress
{
    NSLog( @"%@: %f, %f", NSStringFromSelector(_cmd), location, progress);
}

- (void)revealController:(SWRevealViewController *)revealController panGestureMovedToLocation:(CGFloat)location progress:(CGFloat)progress
{
    NSLog( @"%@: %f, %f", NSStringFromSelector(_cmd), location, progress);
}

- (void)revealController:(SWRevealViewController *)revealController panGestureEndedToLocation:(CGFloat)location progress:(CGFloat)progress
{
    NSLog( @"%@: %f, %f", NSStringFromSelector(_cmd), location, progress);
}

- (void)revealController:(SWRevealViewController *)revealController willAddViewController:(UIViewController *)viewController forOperation:(SWRevealControllerOperation)operation animated:(BOOL)animated
{
    NSLog( @"%@: %@, %d", NSStringFromSelector(_cmd), viewController, operation);
}

- (void)revealController:(SWRevealViewController *)revealController didAddViewController:(UIViewController *)viewController forOperation:(SWRevealControllerOperation)operation animated:(BOOL)animated
{
    NSLog( @"%@: %@, %d", NSStringFromSelector(_cmd), viewController, operation);
}

#endif


@end
