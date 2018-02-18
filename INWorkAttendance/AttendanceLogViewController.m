//
//  AttendanceLogViewController.m
//  INWorkAttendance
//
//  Created by Nanda Gundapaneni on 2/17/18.
//  Copyright © 2018 Nanda. All rights reserved.
//

#import "AttendanceLogViewController.h"
#import "AppDelegate.h"
#import "AttendanceLogs.h"

@interface AttendanceLogViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *sortBySegementedControl;

@property (weak, nonatomic) IBOutlet UITableView *logsTableView;
@property (nonatomic, strong) AttendanceLogs* attendanceLogs;


@end

@implementation AttendanceLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadAttendanceLogs];
}

- (void) loadAttendanceLogs
{
    NSManagedObjectContext* context = [[self persistentContainer] viewContext];
    
    if (context) {
        
        self.attendanceLogs = [AttendanceLogs new];
        
        NSError* error;
        
        NSFetchRequest *fetchRequestEntry = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityEntry = [NSEntityDescription entityForName:attendanceLogEntity
                                                       inManagedObjectContext:context];
        [fetchRequestEntry setEntity:entityEntry];
        NSArray *fetchedObjectsEntry = [context executeFetchRequest:fetchRequestEntry error:&error];
        [self.attendanceLogs setLogsArray:fetchedObjectsEntry];
        
        if (error == nil && self.attendanceLogs.logsArray.count != 0) {
            [self.attendanceLogs sortLogsUsingDateSortOption:DateSortOption_Day];
            [self.logsTableView reloadData];
        }else{
            
            if (error != nil) {
                [self showAlertForError:error];
                
            }
            else {
                [self showAlertNoData];
            }
        }
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sortOptionSelected:(id)sender {
    
    UISegmentedControl* control = (UISegmentedControl*)sender;
    
    [self.attendanceLogs sortLogsUsingDateSortOption:control.selectedSegmentIndex];
    
    [self.logsTableView reloadData];
}

- (NSPersistentContainer*) persistentContainer {
    
    AppDelegate * appDelegate =  (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    return appDelegate.persistentContainer;
    
}

- (void) showAlertForError:(NSError*)error
{
    UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"ERROR" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:okAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) showAlertNoData
{
    UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"No Logs!" message:@"The app has not starting logging yet. Go check in to mark attendance." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:okAction];
    
    [self presentViewController:controller animated:YES completion:nil];
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

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
              
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.attendanceLogs.sortedLogsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* kLogCell = @"kLogCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLogCell forIndexPath:indexPath];
    
    AttendanceLog* log = self.attendanceLogs.sortedLogsArray[indexPath.row];
    
    
    NSDateFormatter* formatter = [self dateFormatter];
    
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"EEEE, dd MMMM yyyy hh:mm a"];
    

    if (log != nil) {
        NSString *dateString = [formatter stringFromDate:log.attendanceLogDate];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",dateString]];
    }

    
    return cell;
}


@end
