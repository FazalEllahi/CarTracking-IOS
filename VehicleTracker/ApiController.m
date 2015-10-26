//
//  ApiController.m
//  VehicleTracker
//
//  Created by Iftikhar on 09/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import "ApiController.h"

@implementation ApiController

@synthesize onRequestFinshed;
@synthesize onRequestFailed;
@synthesize securityKey;
@synthesize userID;
@synthesize onloginRequestCompleted;
@synthesize speedUnit;
@synthesize timeZone;

static ApiController *sharedManager;


+(ApiController *)sharedManager{
    
    if (sharedManager != nil) {
        return sharedManager;
    }
    
    static dispatch_once_t safer;
    dispatch_once( &safer, ^(void)
                  {
                      sharedManager = [[ApiController alloc] init];
                  });
    return sharedManager;
}

-(id)init{
    
    if (self = [super init]) {
        
        securityKey = @"a85hkrwm20jj584e@df6!km";
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"])
            userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
        else
            userID = nil;
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:AppSpeedUnitKey])
            speedUnit = [[NSUserDefaults standardUserDefaults] objectForKey:AppSpeedUnitKey];
        else
            speedUnit = @"1";
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:AppLanguageKey])
            self.userlang = [[NSUserDefaults standardUserDefaults] objectForKey:AppLanguageKey];
        else
            self.userlang = [NSDictionary dictionaryWithObjectsAndKeys:@"English",@"langName",@"1",@"languageID",nil];
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:AppTimeZoneKey])
            self.timeZone = [[NSUserDefaults standardUserDefaults] objectForKey:AppTimeZoneKey];
        else
            self.timeZone = @"America/New_York";

    }
    return self;
}
- (BOOL)prepareForLogout{
    self.userID = nil;
    self.userlang = [NSDictionary dictionaryWithObjectsAndKeys:@"English",@"langName",@"1",@"languageID",nil];
    speedUnit = @"1";
    [[NSUserDefaults standardUserDefaults] setObject:self.userID forKey:@"UserID"];
    return YES;
    
}


- (BOOL)isSessionAlive{
    
    if (userID == nil)
        return NO;
    return YES;
}

-(void)loginUserWithUserName:(NSString*)userName andPassword:(NSString*)password onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse{
    self.onloginRequestCompleted = loginResponse;
    
    NSString *loginStr = [NSString stringWithFormat:@"%@securityKey=%@&lang=%@&request=login&UserName=%@&PasswordHash=%@",loginApiUrl,self.securityKey,[self.userlang objectForKey:@"languageID"],userName,password];
    
    NSURL *uRL = [NSURL URLWithString:loginStr];
//    NSLog(@"%@",request);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:uRL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSLog(@" response = %@",response);
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        
        NSLog(@" data = %@",[json objectForKey:@"response"]);

        
        if(!connectionError){
            
            if([[[json objectForKey:@"response"] objectForKey:@"code"] isEqualToString:@"3"]){
                NSString *str = [[[json objectForKey:@"response"] objectForKey:@"data"] objectForKey:@"UserID"];
                if (str!=nil) {
                    self.userID = str;
                    [[NSUserDefaults standardUserDefaults] setObject:self.userID forKey:@"UserID"];
                    [[NSUserDefaults standardUserDefaults] synchronize];

                }
                onloginRequestCompleted(true,data);
            }
            else
                onloginRequestCompleted(false,data);

            // NSDictionary *dict = [[NSDictionary alloc] da]
        }
        else
        onloginRequestCompleted(false,data);
        
    }];
}

-(void)submitContactData:(NSString*)userName Phone:(NSString*)phone Email:(NSString*)email Subject:(NSString*)subject Message:(NSString*)message onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse
{
    self.onloginRequestCompleted = loginResponse;
    
    NSString *loginStr = [NSString stringWithFormat:@"%@securityKey=%@&lang=%@&request=contactUs&name=%@&phone=%@&email=%@&subject=%@&message=%@&device=%@&ipAddress=%@",contactUsUrl,self.securityKey,[self.userlang objectForKey:@"languageID"],userName,phone,email,subject,message,[UIDevice currentDevice].name,[UIDevice currentDevice].model];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:loginStr]];
    NSLog(@"%@",request);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@" response = %@",response);
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        
        NSLog(@" data = %@",[json objectForKey:@"response"]);
        
        
        if(!connectionError){
            
            if([[[json objectForKey:@"response"] objectForKey:@"code"] isEqualToString:@"2"]){
               
                onloginRequestCompleted(true,data);
            }
            else
                onloginRequestCompleted(false,data);
        }
        else
            onloginRequestCompleted(false,data);
        
    }];
}
-(void)getVehicleTripRange:(NSString*)DateRange withtrackerid:(NSString*)trackerID onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse{
    
    NSString *loginStr = [NSString stringWithFormat:@"%@securityKey=%@&lang=%@&request=routeReplay&trackerID=%@&startDate=%@&endDate=%@&alarmType=0&replayType=2&timeZone=%@&speedMeter=%@",VehicleTripsUrl,securityKey,[self.userlang objectForKey:@"languageID"],trackerID,[[DateRange componentsSeparatedByString:@","] firstObject],[[DateRange componentsSeparatedByString:@","] lastObject],self.timeZone,self.speedUnit];
    
    loginStr = [loginStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //   [url ]
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:loginStr]];
    
    NSLog(@"%@",request);
    
    self.onloginRequestCompleted = loginResponse;
    
    [self getTripResponseFromUrl:request];
    
    
}

-(void)getVehicleTrips:(NSString*)DateRange withtrackerid:(NSString*)trackerID onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse{

    NSString *loginStr = [NSString stringWithFormat:@"%@securityKey=%@&lang=%@&request=routeReplay&trackerID=%@&startDate=%@&endDate=%@&alarmType=0&replayType=1&timeZone=%@&speedMeter=%@",VehicleTripsUrl,securityKey,[self.userlang objectForKey:@"languageID"],trackerID,[[DateRange componentsSeparatedByString:@","] firstObject],[[DateRange componentsSeparatedByString:@","] lastObject],self.timeZone,self.speedUnit];

    loginStr = [loginStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //   [url ]
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:loginStr]];
    
    NSLog(@"%@",request);
    
    self.onloginRequestCompleted = loginResponse;
    
    [self getResponseFromUrl:request];
    
    
}

-(void)getAllVehivlesData:(NSString*)UserID onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse
{
    self.onloginRequestCompleted = loginResponse;
    
    NSString *loginStr = [NSString stringWithFormat:@"%@securityKey=%@&request=userVehicles&lang=%@&UserID=%@&timeZone=ASIA/DUBAI&speedMeter=1",allVehiclesUrl,self.securityKey,@"1",self.userID];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:loginStr]];
    NSLog(@"%@",request);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@" response = %@",response);
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        
        NSLog(@" data = %@",[json objectForKey:@"response"]);
        
        
        if(!connectionError){
            
            if([[[json objectForKey:@"response"] objectForKey:@"code"] isEqualToString:@"2"]){
                
                onloginRequestCompleted(true,data);
            }
            else
                onloginRequestCompleted(false,data);
        }
        else
            onloginRequestCompleted(false,data);
        
    }];
}

-(void)getCompanyInfoData:(NSString*)userId onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse{
    
    NSString *loginStr = [NSString stringWithFormat:@"%@securityKey=%@&lang=%@&request=info",infoApiUrl,securityKey,@"1"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:loginStr]];
    
    NSLog(@"%@",request);
    
    self.onloginRequestCompleted = loginResponse;
    
    [self getResponseFromUrl:request];


}

-(void)getVehicalData{
    
    NSString *loginStr = [NSString stringWithFormat:@"%@securityKey=%@&request=userVehicles&lang=%@&UserID=%@",allVehiclesUrl,securityKey,@"1"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:loginStr]];
    NSLog(@"%@",request);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@" response = %@",response);
        NSLog(@" data = %@",data);
        
        if(!connectionError){
        }
        //    onloginRequestCompleted(false,data);
        
    }];
    
}

-(void)getLanguageList:(NSString*)userId onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse{
    
    NSString *loginStr = [NSString stringWithFormat:@"%@securityKey=%@&request=langList&lang=%@",languageListUrl,securityKey,@"1"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:loginStr]];
    NSLog(@"%@",request);
    
    self.onloginRequestCompleted = loginResponse;
    
    [self getResponseFromUrl:request];

}

-(void)getSpeedMeter:(NSString*)userId onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse{
    
    NSString *loginStr = [NSString stringWithFormat:@"%@securityKey=%@&request=getSpeedUnits&lang=%@",speedMeterUrl,securityKey,@"1"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:loginStr]];
    NSLog(@"%@",request);
    
    self.onloginRequestCompleted = loginResponse;
   
    [self getResponseFromUrl:request];

}

-(void)getTimeZone:(NSString*)userId onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse{
    
    NSString *loginStr = [NSString stringWithFormat:@"%@securityKey=%@&request=timeZoneList&lang=%@",TimeZoneListUrl,securityKey,@"1"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:loginStr]];
    NSLog(@"%@",request);
    
    self.onloginRequestCompleted = loginResponse;
    
    [self getResponseFromUrl:request];
    
}

-(void)getAllAlarms:(NSString*)userId onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse{
    
    NSString *loginStr = [NSString stringWithFormat:@"%@securityKey=%@&request=alarmList&lang=%@",AlarmsListUrl,securityKey,@"1"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:loginStr]];
    NSLog(@"%@",request);
    
    self.onloginRequestCompleted = loginResponse;
    
    [self getResponseFromUrl:request];
    
}

-(void)getAllLabels:(NSString*)userId onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse{
    
    NSString *loginStr = [NSString stringWithFormat:@"%@securityKey=%@&lang=%@&request=label&labelFor=%@",labelsListUrl,securityKey,[self.userlang objectForKey:@"languageID"],userId];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:loginStr]];
    NSLog(@"%@",request);
    
    self.onloginRequestCompleted = loginResponse;
    
    [self getResponseFromUrl:request];
    
}

/*
 securityKey=a85hkrwm20jj584e@df6!km&request=action&lang=1&trackerID=8&action=turnOn
 {"response":{"code":"2","message":"Switched On Successfully","data":[]}}
 */
-(void)PostSwitchOnOff:(NSString*)Action trackerId:(NSString*)trackID onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse{
    
    NSString *loginStr = [NSString stringWithFormat:@"%@securityKey=%@&lang=%@&request=action&trackerID=%@&action=%@",SwitchCarUrl,securityKey,@"1",trackID,Action];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:loginStr]];
    NSLog(@"%@",request);
    
    self.onloginRequestCompleted = loginResponse;
    
    [self getResponseFromUrl:request];
    
}
-(void)getTripResponseFromUrl:(NSURLRequest*)request{
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if(!connectionError){
            
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            if([[[json objectForKey:@"response"] objectForKey:@"code"] isEqualToString:@"3"]){
                
                onloginRequestCompleted(true,data);
            }
            else
                onloginRequestCompleted(false,data);
        }
        else
            onloginRequestCompleted(false,data);
        
    }];
}
-(void)getResponseFromUrl:(NSURLRequest*)request{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:request.URL completionHandler:^(NSData *data,
                                                      NSURLResponse *response,
                                                      NSError *error) {
        if(!error){
            
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            if([[[json objectForKey:@"response"] objectForKey:@"code"] isEqualToString:@"2"]){
                
                onloginRequestCompleted(true,data);
            }
            else
                onloginRequestCompleted(false,data);
        }
        else
            onloginRequestCompleted(false,data);
        
    }] resume];


}

@end
