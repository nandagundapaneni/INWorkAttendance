//
//  ViewController.m
//  INWorkAttendance
//
//  Created by Nanda Gundapaneni on 2/17/18.
//  Copyright © 2018 Nanda. All rights reserved.
// Google API Key -- AIzaSyDEMEOeBzTm74-pTWGnEP98yYTjpSgbWo0


#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "LocationDetails.h"
#import "AppDelegate.h"
#import "AttendanceLogs.h"
#import "PlacesAPIController.h"

const double minDistance = 10;

@interface ViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *whereAmIButton;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic,assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) LocationDetails* locationDetails;

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.currentCoordinate = CLLocationCoordinate2DMake(17.45109, 78.37061);
    
    NSError *error = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"LocationDetails"
                                                         ofType:@"json"];
    NSData *dataFromFile = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:dataFromFile
                                                         options:kNilOptions
                                                           error:&error];
    if (error != nil) {
        NSLog(@"Error: was not able to load messages.");
    }
    else {
        self.locationDetails = [LocationDetails new];
        [self.locationDetails fillFromJSON:data];
    }
    
    
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager requestAlwaysAuthorization];

    }
    else
    {
        NSError* error = [NSError errorWithDomain:@"CLLOCATION" code:5 userInfo:@{@"desc":@"locationServices disabled"}];
        [self showAlertForError:error];
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:17.45109
                                                            longitude:78.37061
                                                                 zoom:14];

    [self.mapView setCamera:camera];
    self.mapView.delegate = self;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mapView.myLocationEnabled = YES;
    });


}

-(void)viewDidAppear:(BOOL)animated {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentCoordinate.latitude
                                                            longitude:self.currentCoordinate.longitude
                                                                 zoom:14];
    
    [self.mapView setCamera:camera];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)markAttendanceTapped:(id)sender {
    

    if ([self locationIsWithinWorkZone]) {
        // Implement core data save
        // if sucessfull show
        
        [self saveAttendanceLog];

    }
    else {
        
        NSString* desc = [NSString stringWithFormat:@"You are %f meters away work zone, Please make sure your atleast as close as 10 meters to workzone",[self distanceFromCurrentLocation]];
        NSError* error = [NSError errorWithDomain:@"Invalid Location" code:10 userInfo:@{@"desc":desc}];
        
        [self showAlertForError:error];

    }
}

- (IBAction)whereAmITapped:(id)sender {
    
    [self showActivity];
    
    [PlacesAPIController getPlaceDetailsWithLocation:self.currentCoordinate completion:^(LocationDetails *details, NSError *error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self hideActivity];
            
            if (error == nil) {
                UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"Location Details" message:[details getLocationDetailsDescription] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* close = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
                
                [controller addAction:close];
                
                [self presentViewController:controller animated:YES completion:nil];
                
            }
            else {
                [self showAlertForError:error];
            }

        });
    }];
}

- (void) showActivity {

    [self.activityIndicator setHidden:NO];
    [self.view bringSubviewToFront:self.activityIndicator];
    [self.activityIndicator startAnimating];
}


- (void) hideActivity {
    
    [self.activityIndicator stopAnimating];
}



- (void) saveAttendanceLog {

    NSDateFormatter* formatter = [self dateFormatter];
    
    [formatter setDateFormat:@"EEEE, dd MMMM yyyy hh:mm a"];
    NSDate* logDate = [NSDate date];
    
    NSPersistentContainer *container = [self persistentContainer];
    NSManagedObjectContext *context = [container viewContext];
    NSManagedObject *entryLog = [NSEntityDescription
                                 insertNewObjectForEntityForName:attendanceLogEntity
                                 inManagedObjectContext:container.viewContext];
    
    [entryLog setValue:logDate forKey:attendanceAttr];
    
    NSError *error;
    if (![context save:&error]) {
        [self showAlertForError:error];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:inviCoreDataSaveErrorNotification object:error];
    }
    else
    {
        NSString* cuurentDateString = [formatter stringFromDate:logDate];
        UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"You've entered work at" message:cuurentDateString preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* close = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        
        [controller addAction:close];
        
        [self presentViewController:controller animated:YES completion:nil];
    }

}


- (BOOL) locationIsWithinWorkZone {

    
    if ([self distanceFromCurrentLocation] <= minDistance) {
        return YES;
    }
    
    return NO;
}

- (double) distanceFromCurrentLocation {

    CLLocation* currentLoc = [[CLLocation alloc] initWithLatitude:self.currentCoordinate.latitude longitude:self.currentCoordinate.longitude];
    
    return [currentLoc distanceFromLocation:self.locationDetails.location];
    

}

- (NSDateFormatter*) dateFormatter
{
    static NSDateFormatter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NSDateFormatter new];
    });
    return instance;
    
}

- (NSPersistentContainer*) persistentContainer {

    AppDelegate * appDelegate =  (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    return appDelegate.persistentContainer;

}

- (void) showAlertForError:(NSError*)error
{
    
    NSString* body = error.userInfo[@"desc"];
    
    if (body.length == 0 || body == nil) {
        body = error.localizedDescription;
    }
    UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"ERROR" message:body preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:okAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [NSDateComponents new];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}

#pragma mark - CoreLocation Manager Delegate

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        
        [self.locationManager startUpdatingLocation];
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray*)locations
{
    CLLocation *location = [locations lastObject];
    
    self.currentCoordinate = location.coordinate;
}



@end
