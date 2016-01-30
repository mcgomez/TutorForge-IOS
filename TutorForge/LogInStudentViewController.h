//
//  LogInStudentViewController.h
//  TutorForge
//
//  Created by Marisa Gomez on 10/29/15.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface LogInStudentViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) Student *studentObject;
@property (strong, nonatomic) NSMutableArray *loggedInStudents;
@property (strong, nonatomic) UITableView *loggedInStudentsTableView;
@property (weak, nonatomic) NSString *studentToLogIn;
@property (weak, nonatomic) IBOutlet UIView *loggedInStudentsView;
@property (strong, nonatomic) UITableViewCell *removeStudent;
@property (nonatomic) int numberLoggedIn;

- (void) resetTable;
- (IBAction)addStudent:(id)sender;
- (void) setUpStudent:(NSDictionary *)student;
- (IBAction)removeStudent:(id)sender;

@end
