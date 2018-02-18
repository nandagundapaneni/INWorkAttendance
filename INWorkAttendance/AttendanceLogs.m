//
//  AttendanceLogs.m
//  INWorkAttendance
//
//  Created by Nanda Gundapaneni on 2/17/18.
//  Copyright © 2018 Nanda. All rights reserved.
//

#import "AttendanceLogs.h"

NSString* const attendanceLogEntity = @"AttendanceLog";
NSString* const attendanceAttr = @"attendanceLogDate";
NSString* const inviCoreDataSaveErrorNotification = @"inviCoreDataSaveErrorNotification";

@implementation AttendanceLog

@dynamic attendanceLogDate;

@end

@implementation AttendanceLogs

- (void) sortLogsUsingDateSortOption:(DateSortOption)dateSortOption
{
    NSMutableArray* logsMutable = [NSMutableArray new];

    unsigned units = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents* currentDateComponents = [calendar components:units fromDate:[NSDate date]];
    
    for (AttendanceLog* log in self.logsArray) {
        NSDateComponents* components = [calendar components:units fromDate:log.attendanceLogDate];
        
        switch (dateSortOption) {
            case DateSortOption_Day:
            {
                if ([calendar isDate:log.attendanceLogDate inSameDayAsDate:[NSDate date]]) {
                    [logsMutable addObject:log];
                } else {
                
                }
            }
                break;
                
            case DateSortOption_Month:
            {
                if(components.year == currentDateComponents.year && components.month == currentDateComponents.month){
                    
                    [logsMutable addObject:log];
                }else {
                    
                }

            }
                break;
            
            case DateSortOption_Year:
            {
                if(components.year == currentDateComponents.year)
                {
                    
                    [logsMutable addObject:log];
                }else {
                    
                }


            }
                break;
            default:
                break;
        }

    }
    
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:attendanceAttr ascending:NO];
    [logsMutable sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    
    self.sortedLogsArray = [NSArray arrayWithArray:logsMutable];
}



@end
