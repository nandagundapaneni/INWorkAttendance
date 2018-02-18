//
//  LocationDetails.h
//  INWorkAttendance
//
//  Created by Nanda Gundapaneni on 2/17/18.
//  Copyright © 2018 Nanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface LocationDetails : NSObject

@property (nonatomic, strong) CLLocation* location;
@property (nonatomic, copy) NSString* address;
@property (nonatomic, copy) NSString* vicinityAddress;

- (void) fillFromJSON:(NSDictionary*)json;
- (NSString*) getLocationDetailsDescription;

@end
