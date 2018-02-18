//
//  AttendanceLogs.h
//  INWorkAttendance
//
//  Created by Nanda Gundapaneni on 2/17/18.
//  Copyright © 2018 Nanda. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef NS_ENUM(NSInteger, DateSortOption)
{
    DateSortOption_Day,
    DateSortOption_Month,
    DateSortOption_Year
};

extern NSString* const attendanceLogEntity;
extern NSString* const attendanceAttr;
extern NSString* const inviCoreDataSaveErrorNotification;

@interface AttendanceLog : NSManagedObject

@property (nonatomic, strong) NSDate* attendanceLogDate;

@end

@interface AttendanceLogs : NSObject

@property (nonatomic,strong) NSArray<AttendanceLog *>* logsArray;
@property (nonatomic,strong) NSArray<AttendanceLog *>* sortedLogsArray;

- (void) sortLogsUsingDateSortOption:(DateSortOption)dateSortOption;

@end
