//
//  PlacesAPIController.h
//  INWorkAttendance
//
//  Created by Nanda Gundapaneni on 2/18/18.
//  Copyright © 2018 Nanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class LocationDetails;

typedef void(^PlaceApiCompletionBlock)(LocationDetails *details,NSError*error);

@interface PlacesAPIController : NSObject

+ (void) getPlaceDetailsWithLocation:(CLLocationCoordinate2D)location completion:(PlaceApiCompletionBlock) completion;

@end
