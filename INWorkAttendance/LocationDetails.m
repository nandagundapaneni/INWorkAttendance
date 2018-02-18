//
//  LocationDetails.m
//  INWorkAttendance
//
//  Created by Nanda Gundapaneni on 2/17/18.
//  Copyright © 2018 Nanda. All rights reserved.
//

#import "LocationDetails.h"
#import <CoreLocation/CoreLocation.h>

NSString* const results = @"results";
NSString* const formatted_address = @"formatted_address";
NSString* const geometry  = @"geometry";
NSString* const locationDetailsKey = @"location";
NSString* const vicinity = @"vicinity";
NSString* const lat  = @"lat";
NSString* const lng = @"lng";

@implementation LocationDetails

- (id) init
{
    self = [super init];
    
    if (self) {
        [self fillFromJSON:nil];
    }
    
    return self;
}

- (void) fillFromJSON:(NSDictionary*)json;
{
    NSArray* resultsArray = json[results];
    NSDictionary* topResult = resultsArray.firstObject;
    self.address = topResult[formatted_address];
    
    self.vicinityAddress = topResult[vicinity];
    
    NSDictionary* geometryDict = topResult[geometry];
    
    if (geometryDict != nil) {
        NSDictionary* locationDict = geometryDict[locationDetailsKey];
        NSNumber* latVal = locationDict[lat];
        NSNumber* lngVal = locationDict[lng];
        self.location = [[CLLocation alloc] initWithLatitude:latVal.doubleValue longitude:lngVal.doubleValue];
        
        
    }
    
}

- (NSString*) getLocationDetailsDescription {

    NSMutableString* mutable = [NSMutableString new];
    
    if (self.location) {
        
        [mutable appendFormat:@"Location=%f,%f\n",self.location.coordinate.latitude,self.location.coordinate.longitude];
        
    }
    
    if (self.address) {
        [mutable appendString:@"\n"];
        [mutable appendString:self.address];
        [mutable appendString:@"\n"];
    }
    
    if (self.vicinityAddress) {
        [mutable appendString:@"\n"];
        [mutable appendString:self.vicinityAddress];
        [mutable appendString:@"\n"];
    }
    
    return [NSString stringWithString:mutable];
    
}

@end
