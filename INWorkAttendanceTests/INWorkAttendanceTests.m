//
//  INWorkAttendanceTests.m
//  INWorkAttendanceTests
//
//  Created by Nanda Gundapaneni on 2/17/18.
//  Copyright © 2018 Nanda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AttendanceLogs.h"
#import <AFNetworking/AFNetworking.h>
#import "PlacesAPIController.h"


@interface INWorkAttendanceTests : XCTestCase

@end

@implementation INWorkAttendanceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWorkingPlacesApiCall {

    NSString* urlString = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=50&keyword=address&key=AIzaSyAkwopY9YmgZU7c-0FnMqhlGTchf7FOCuQ";
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    XCTAssertTrue(url != nil);
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession* session = [NSURLSession sharedSession];
    
   [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
       XCTAssertTrue(data != nil);
       XCTAssertTrue(error == nil);
   }];
}

- (void)testNotWorkingPlacesApiCall {
    
    NSString* urlString = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=50&keyword=address";
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    XCTAssertTrue(url != nil);
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession* session = [NSURLSession sharedSession];
    
    [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        XCTAssertTrue(data == nil);
        XCTAssertTrue(error != nil);
    }];
}


- (void) testLocationDetailsFetch {
    
    NSError *error = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"LocationDetails"
                                                         ofType:@"json"];
    NSData *dataFromFile = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:dataFromFile
                                                         options:kNilOptions
                                                           error:&error];
    
    XCTAssertTrue(data != nil);
    
}

- (NSDate*) dateWithYear:(NSInteger)year month:(NSInteger) month day:(NSInteger) day {
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:year];
    [dateComponents setMonth:month];
    [dateComponents setDay:day];
    
    NSCalendar *calendar = [[NSCalendar alloc]  initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    return [calendar dateFromComponents:dateComponents];
}

@end
