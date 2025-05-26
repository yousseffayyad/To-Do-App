//
//  AddViewController.m
//  ToDo_App
//
//  Created by User on 07/05/2025.
//

#import "AddViewController.h"
#import "Task.h"
#import "TaskManager.h"
#import <UserNotifications/UserNotifications.h>


@interface AddViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskName;
@property (weak, nonatomic) IBOutlet UITextField *taskDescriotion;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskPriority;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDate;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = @"Add Task";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor systemBlueColor];
    [titleLabel sizeToFit];
    
    CGRect frame = self.taskDescriotion.frame;
    frame.size.height = 150;
    frame.size.width = 330;
    self.taskDescriotion.frame = frame;
    
    self.navigationItem.titleView = titleLabel;
}

- (IBAction)saveTaskTapped:(id)sender {
    NSString *title = [self.taskName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDate *selectedDate = self.taskDate.date;

    if (title.length == 0) {
        [self showAlertWithTitle:@"Missing Title" message:@"Please enter a task name."];
        return;
    }

    if ([selectedDate timeIntervalSinceNow] < 0) {
        [self showAlertWithTitle:@"Invalid Date" message:@"Please select a future date and time."];
        return;
    }

    Task *newTask = [Task new];
    newTask.taskName = self.taskName.text;
    newTask.taskDescription = self.taskDescriotion.text;
    newTask.taskPriority = (int)self.taskPriority.selectedSegmentIndex;

    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    newTask.taskDate = [formatter stringFromDate:selectedDate];

    formatter.dateFormat = @"HH:mm";
    newTask.taskTime = [formatter stringFromDate:selectedDate];

    newTask.taskStatus = @"ToDo";

    [[TaskManager sharedManager] saveTask:newTask];


    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Task Reminder";
    content.body = newTask.taskName;
    content.sound = [UNNotificationSound defaultRingtoneSound];

    NSLog(@"%@",selectedDate);
    NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
        components:(NSCalendarUnitYear |
                    NSCalendarUnitMonth |
                    NSCalendarUnitDay |
                    NSCalendarUnitHour |
                    NSCalendarUnitMinute)
        fromDate:selectedDate];

    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];


    NSString *identifier = [[NSUUID UUID] UUIDString];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error scheduling notification: %@", error.localizedDescription);
        } else {
            NSLog(@"Notification will fire in %@",selectedDate);
        }
    }];

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
    message:message
    preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
