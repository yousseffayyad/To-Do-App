//
//  DetailsViewController.m
//  ToDo_App
//
//  Created by User on 07/05/2025.
//

#import "DetailsViewController.h"
#import "TaskManager.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskName;
@property (weak, nonatomic) IBOutlet UITextField *taskDescriotion;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskPriority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskStatus;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDate;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = @"Task Details";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor systemBlueColor];
    [titleLabel sizeToFit];
    
    CGRect frame = self.taskDescriotion.frame;
    frame.size.height = 150;
    frame.size.width = 330;
    self.taskDescriotion.frame = frame;

    self.navigationItem.titleView = titleLabel;

    if (self.task) {
        NSLog(@"Task: %@", self.task.taskName);

        self.taskName.text = self.task.taskName;
        self.taskDescriotion.text = self.task.taskDescription;
        self.taskPriority.selectedSegmentIndex = self.task.taskPriority;

        if ([self.task.taskStatus isEqualToString:@"ToDo"]) {
            self.taskStatus.selectedSegmentIndex = 0;
        } else if ([self.task.taskStatus isEqualToString:@"InProgress"]) {
            self.taskStatus.selectedSegmentIndex = 1;
        } else if ([self.task.taskStatus isEqualToString:@"Done"]) {
            self.taskStatus.selectedSegmentIndex = 2;
        } else {
            self.taskStatus.selectedSegmentIndex = UISegmentedControlNoSegment;
        }

        NSLog(@"%@", self.task.taskDate);
        NSLog(@"%@", self.task.taskTime);

        NSString *dateTimeString = [NSString stringWithFormat:@"%@ %@", self.task.taskDate, self.task.taskTime];
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";

        NSDate *fullDate = [formatter dateFromString:dateTimeString];
        if (fullDate) {
            self.taskDate.date = fullDate;
        }
    }
    
    if ([self.task.taskStatus isEqualToString:@"Done"]) {
        self.taskName.enabled = NO;
        self.taskDescriotion.enabled = NO;
        self.taskPriority.enabled = NO;
        self.taskStatus.enabled = NO;
        self.taskDate.enabled = NO;
        self.editButton.hidden = YES;
    
    }

    self.taskDate.datePickerMode = UIDatePickerModeDateAndTime;
}



- (IBAction)editButton:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm Edit"
        message:@"Are you sure you want to update this task?"
        preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {

        NSString *name = self.taskName.text;
        NSString *desc = self.taskDescriotion.text;
        NSInteger priority = self.taskPriority.selectedSegmentIndex;

        NSInteger newStatusIndex = self.taskStatus.selectedSegmentIndex;
        NSString *currentStatus = self.task.taskStatus;
        
        if (name.length == 0) {
            [self showAlertWithTitle:@"Missing Title" message:@"Please enter a task name."];
            return;
        }

    
        NSString *newStatus;
        switch (newStatusIndex) {
            case 0: newStatus = @"ToDo"; break;
            case 1: newStatus = @"InProgress"; break;
            case 2: newStatus = @"Done"; break;
            default: newStatus = @"Unknown"; break;
        }

        if ([currentStatus isEqualToString:@"InProgress"] && [newStatus isEqualToString:@"ToDo"]) {
            [self showAlertWithMessage:@"You cannot change status from InProgress to ToDo."];
            return;
        }  
        
        if ([currentStatus isEqualToString:@"Done"] && [newStatus isEqualToString:@"InProgress"]) {
            [self showAlertWithMessage:@"You cannot change status from Done to InProgress."];
            return;
        }
        
        if ([currentStatus isEqualToString:@"Done"] && [newStatus isEqualToString:@"ToDo"]) {
            [self showAlertWithMessage:@"You cannot change status from Done to ToDo."];
            return;
        }
        

        NSDate *selectedDate = self.taskDate.date;
        
        if ([selectedDate timeIntervalSinceNow] < 0) {
            [self showAlertWithTitle:@"Invalid Date" message:@"Please select a future date and time."];
            return;
        }

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [formatter stringFromDate:selectedDate];

        formatter.dateFormat = @"HH:mm";
        NSString *timeString = [formatter stringFromDate:selectedDate];

        self.task.taskName = name;
        self.task.taskDescription = desc;
        self.task.taskPriority = (int)priority;
        self.task.taskStatus = newStatus;
        self.task.taskDate = dateString;
        self.task.taskTime = timeString;

        [[TaskManager sharedManager] updateTask:self.task];

        [self.navigationController popViewControllerAnimated:YES];
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:confirm];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Status Change"
        message:message
        preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
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
