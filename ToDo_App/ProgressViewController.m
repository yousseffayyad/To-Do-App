//
//  ProgressViewController.m
//  ToDo_App
//
//  Created by User on 07/05/2025.
//

#import "ProgressViewController.h"
#import "AddViewController.h"
#import "Task.h"
#import "TaskManager.h"
#import "TaskTableViewCell.h"
#import "DetailsViewController.h"

@interface ProgressViewController ()

@property (weak, nonatomic) IBOutlet UITableView *progressTableView;
@property NSMutableArray<Task *> *allTasks;
@property NSMutableArray<Task *> *highPriorityTasks;
@property NSMutableArray<Task *> *mediumPriorityTasks;
@property NSMutableArray<Task *> *lowPriorityTasks;
@property UIBarButtonItem *sortButton;
@property BOOL isSorted;

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.progressTableView.delegate = self;
    self.progressTableView.dataSource = self;
    
    self.progressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.progressTableView.separatorInset = UIEdgeInsetsZero;
    self.progressTableView.layoutMargins = UIEdgeInsetsZero;

    self.allTasks = [NSMutableArray array];
    self.highPriorityTasks = [NSMutableArray array];
    self.mediumPriorityTasks = [NSMutableArray array];
    self.lowPriorityTasks = [NSMutableArray array];

    self.isSorted = NO;
    self.sortButton = [[UIBarButtonItem alloc]
                       initWithTitle:@"UnSort"
                       style:UIBarButtonItemStylePlain
                       target:self
                       action:@selector(toggleSort)];

    self.navigationItem.rightBarButtonItem = self.sortButton;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = @"InProgress";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor systemBlueColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    TaskManager *manager = [TaskManager sharedManager];
    NSArray<Task *> *allTasks = [manager getAllTasks];

    [self.highPriorityTasks removeAllObjects];
    [self.mediumPriorityTasks removeAllObjects];
    [self.lowPriorityTasks removeAllObjects];
    [self.allTasks removeAllObjects];


    for (Task *task in allTasks) {
        if ([task.taskStatus isEqualToString:@"InProgress"]) {
            [self.allTasks addObject:task];

            switch (task.taskPriority) {
                case 0: [self.highPriorityTasks addObject:task]; break;
                case 1: [self.mediumPriorityTasks addObject:task]; break;
                case 2: [self.lowPriorityTasks addObject:task]; break;
            }
        }
    }

    [self.progressTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isSorted ? 1 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSorted) {
        return self.allTasks.count;
    } else {
        switch (section) {
            case 0: return self.highPriorityTasks.count;
            case 1: return self.mediumPriorityTasks.count;
            case 2: return self.lowPriorityTasks.count;
            default: return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TaskCell";
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TaskTableViewCell" owner:self options:nil];
        cell = [nib firstObject];
    }

    Task *task;
    if (self.isSorted) {
        task = self.allTasks[indexPath.row];
    } else {
        switch (indexPath.section) {
            case 0: task = self.highPriorityTasks[indexPath.row]; break;
            case 1: task = self.mediumPriorityTasks[indexPath.row]; break;
            case 2: task = self.lowPriorityTasks[indexPath.row]; break;
            default: return cell;
        }
    }

    cell.taskTitleLabel.text = task.taskName;
    cell.taskDateLabel.text = [NSString stringWithFormat:@"%@", task.taskDate];
    cell.taskImage.image = [UIImage systemImageNamed:@"chevron.right"];
    cell.taskImage.tintColor = [UIColor systemBlueColor];
    
    if (task.taskPriority == 0) {
        cell.priorityImage.image = [UIImage imageNamed:@"high"];
    } else if (task.taskPriority == 1) {
        cell.priorityImage.image = [UIImage imageNamed:@"medium"];
    } else {
        cell.priorityImage.image = [UIImage imageNamed:@"low"];
    }

    cell.backgroundColor = UIColor.clearColor;
    cell.contentView.backgroundColor = UIColor.clearColor;
    cell.contentView.layer.cornerRadius = 16;
    cell.contentView.layer.masksToBounds = YES;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.isSorted) return nil;
    switch (section) {
        case 0: return @"High Priority";
        case 1: return @"Medium Priority";
        case 2: return @"Low Priority";
        default: return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isSorted) return nil;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    headerView.backgroundColor = [UIColor whiteColor];

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width - 30, 25)];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.backgroundColor = [UIColor clearColor];

    switch (section) {
        case 0:
            headerLabel.text = @"High Priority";
            headerLabel.textColor = [UIColor systemRedColor];
            break;
        case 1:
            headerLabel.text = @"Medium Priority";
            headerLabel.textColor = [UIColor systemOrangeColor];
            break;
        case 2:
            headerLabel.text = @"Low Priority";
            headerLabel.textColor = [UIColor systemGreenColor];
            break;
    }

    [headerView addSubview:headerLabel];
    return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Delete";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Task"
            message:@"Are you sure you want to delete this task?"
            preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
        style:UIAlertActionStyleDestructive
        handler:^(UIAlertAction * _Nonnull action) {
            Task *taskToDelete = nil;

            if (self.isSorted) {
                taskToDelete = self.allTasks[indexPath.row];
                [self.allTasks removeObjectAtIndex:indexPath.row];
                [self.highPriorityTasks removeObject:taskToDelete];
                [self.mediumPriorityTasks removeObject:taskToDelete];
                [self.lowPriorityTasks removeObject:taskToDelete];
            } else {
                switch (indexPath.section) {
                    case 0:
                        taskToDelete = self.highPriorityTasks[indexPath.row];
                        [self.highPriorityTasks removeObjectAtIndex:indexPath.row];
                        break;
                    case 1:
                        taskToDelete = self.mediumPriorityTasks[indexPath.row];
                        [self.mediumPriorityTasks removeObjectAtIndex:indexPath.row];
                        break;
                    case 2:
                        taskToDelete = self.lowPriorityTasks[indexPath.row];
                        [self.lowPriorityTasks removeObjectAtIndex:indexPath.row];
                        break;
                }
                [self.allTasks removeObject:taskToDelete];
            }

            [[TaskManager sharedManager] removeTask:taskToDelete];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];

        [alert addAction:deleteAction];
        [alert addAction:cancelAction];

        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *selectedTask = nil;

    if (self.isSorted) {
        selectedTask = self.allTasks[indexPath.row];
    } else {
        switch (indexPath.section) {
            case 0: selectedTask = self.highPriorityTasks[indexPath.row]; break;
            case 1: selectedTask = self.mediumPriorityTasks[indexPath.row]; break;
            case 2: selectedTask = self.lowPriorityTasks[indexPath.row]; break;
        }
    }

    if (selectedTask) {
        [self navigateToTaskDetails:selectedTask];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)toggleSort {
    self.isSorted = !self.isSorted;
    self.sortButton.title = self.isSorted ? @"Sort" : @"UnSort";
    [self.progressTableView reloadData];
}

- (void)navigateToTaskDetails:(Task *)selectedTask {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailsViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"detailsTask"];
    detailVC.task = selectedTask;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
