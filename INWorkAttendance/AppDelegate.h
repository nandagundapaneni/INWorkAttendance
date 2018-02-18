//
//  AppDelegate.h
//  INWorkAttendance
//
//  Created by Nanda Gundapaneni on 2/17/18.
//  Copyright © 2018 Nanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

