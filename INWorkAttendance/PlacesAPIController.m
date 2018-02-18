//
//  PlacesAPIController.m
//  INWorkAttendance
//
//  Created by Nanda Gundapaneni on 2/18/18.
//  Copyright © 2018 Nanda. All rights reserved.

#import "PlacesAPIController.h"
#import <AFNetworking/AFNetworking.h>
#import "LocationDetails.h"

NSString* const placeAPIKey = @"AIzaSyAkwopY9YmgZU7c-0FnMqhlGTchf7FOCuQ";
NSString* const key = @"key";
NSString* const placeAPIRadius = @"radius";
NSString* const placeAPIKeyword = @"type";
NSString* const placeKeyword = @"point_of_interest";
NSString* const locationKey = @"location";
NSString* const placeAPIBase = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json";

@implementation PlacesAPIController

+ (void) getPlaceDetailsWithLocation:(CLLocationCoordinate2D)location completion:(PlaceApiCompletionBlock) completion {
    
    NSDictionary* params = [self placeAPIParams:location];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:placeAPIBase parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        LocationDetails* details = [LocationDetails new];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [details fillFromJSON:responseObject];
        }
        NSLog(@"JSON: %@", [details getLocationDetailsDescription]);
        
        if (completion) {
            completion(details,nil);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(nil,error);
    }];
    
    
}

+ (NSDictionary*) placeAPIParams:(CLLocationCoordinate2D)location {

    NSMutableDictionary* params = [NSMutableDictionary new];
    params[key] = placeAPIKey;
    params[placeAPIRadius] = @"50";
    params[placeAPIKeyword] = placeKeyword;
    params[locationKey] = [NSString stringWithFormat:@"%f,%f",location.latitude,location.longitude];
    
    return params;
}

@end
