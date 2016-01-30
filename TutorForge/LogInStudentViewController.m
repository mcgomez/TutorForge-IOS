//
//  LogInStudentViewController.m
//  TutorForge
//
//  Created by Marisa Gomez on 10/29/15.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import "LogInStudentViewController.h"
#import "LogInStudentDetailsViewController.h"
#import "Student.h"

@interface LogInStudentViewController ()

@end

@implementation LogInStudentViewController
@synthesize searchBar;
@synthesize studentObject;
@synthesize loggedInStudents;
@synthesize loggedInStudentsTableView;
@synthesize studentToLogIn;
@synthesize loggedInStudentsView;
@synthesize removeStudent;
@synthesize numberLoggedIn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Remove when log in works
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *loggedInStudents = [[NSMutableArray alloc] init];
    NSData *encodedStudentsLoggedIn = [NSKeyedArchiver archivedDataWithRootObject:loggedInStudents];
    [defaults setObject:encodedStudentsLoggedIn forKey:@"loggedInStudents"];
    [defaults synchronize];
    
    numberLoggedIn = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    loggedInStudents = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"loggedInStudents"]]];
    
    //Check how many students are logged in
    numberLoggedIn = 0;
    for (Student *student in loggedInStudents) {
        if ([student.sessionDidEnd isEqualToString:@"NO"]) {
            numberLoggedIn++;
        }
    }
    
    //Refresh table with students logged in
    
    //Add Table
    [self resetTable];
}

- (void)resetTable {
    //Set up logged in students table
    CGRect tableFrame = loggedInStudentsView.frame;
    tableFrame.origin.x = 0;
    tableFrame.origin.y = 0;
    loggedInStudentsTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    loggedInStudentsTableView.delegate = self;
    loggedInStudentsTableView.dataSource = self;
    
    loggedInStudentsTableView.backgroundColor = [UIColor colorWithRed:(74.0/255.0) green:(184.0/255.0) blue:(175.0/255.0) alpha:1];
    
    [loggedInStudentsView addSubview:loggedInStudentsTableView];
}

- (IBAction)addStudent:(id)sender {
    studentToLogIn = searchBar.text;
    
    //Check if input is 800 number or name
    if ([studentToLogIn isEqualToString:@""]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"You must enter in a students name or 800 number."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if ([[studentToLogIn substringToIndex:3] isEqualToString:@"800"]) {
        
        //Make a HTTP request to see if student if in the database
        //Connect to server and database
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://tutorme.stetson.edu/api/students/get?field=ID&value=%@", studentToLogIn]]];
        
        //Setting up for response
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        
        //Get response
        id json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: nil];
        NSArray *responseJSON = [json objectForKey:@"result"];
        
        //Set up Student Object
        [self setUpStudent:[responseJSON objectAtIndex:0]];
        
        NSLog(@"JSON: %@", responseJSON);
        
        //Double check that it is the correct student
        UIAlertController *check=   [UIAlertController
                                     alertControllerWithTitle:@"Confirmation"
                                     message:[NSString stringWithFormat:@"%@ %@", studentObject.studentID, studentObject.fullname]
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesConfirmation = [UIAlertAction
                                          actionWithTitle:@"YES"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                                          {
                                              searchBar.text = @"";
                                              
                                              //Perform segue
                                              [self performSegueWithIdentifier:@"showStudentDetail" sender:self];
                                              
                                          }];
        UIAlertAction *noConfirmation = [UIAlertAction
                                         actionWithTitle:@"NO"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [check dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
        
        [check addAction:yesConfirmation];
        [check addAction:noConfirmation];
        [self presentViewController:check animated:YES completion:nil];
    } else {
        NSArray *fullname = [studentToLogIn componentsSeparatedByString:@" "];
        NSString *firstName = [fullname objectAtIndex:0];
        NSString *lastName = [fullname objectAtIndex:1];
        
        //Make a HTTP request to see if student if in the database
        //Connect to server and database
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://tutorme.stetson.edu/api/students/get?field=FullName&value=%@%@%@", firstName, @"%20", lastName]]];
        
        //Setting up for response
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        
        //Get response
        id json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: nil];
        NSArray *responseJSON = [json objectForKey:@"result"];
        NSLog(@"Student: %@", responseJSON);
        
        //Set up Student Object
        [self setUpStudent:[responseJSON objectAtIndex:0]];
        
        NSLog(@"JSON: %@", responseJSON);
        
        //Double check that it is the correct student
        UIAlertController *check=   [UIAlertController
                                     alertControllerWithTitle:@"Confirmation"
                                     message:[NSString stringWithFormat:@"%@ %@", studentObject.studentID, studentObject.fullname]
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesConfirmation = [UIAlertAction
                             actionWithTitle:@"YES"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 searchBar.text = @"";
                                 
                                 //Perform segue
                                 [self performSegueWithIdentifier:@"showStudentDetail" sender:self];
                                 
                             }];
        UIAlertAction *noConfirmation = [UIAlertAction
                                 actionWithTitle:@"NO"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [check addAction:yesConfirmation];
        [check addAction:noConfirmation];
        [self presentViewController:check animated:YES completion:nil];
        
        //Perform segue
        [self performSegueWithIdentifier:@"showStudentDetail" sender:self];
    }
}

- (void) setUpStudent:(NSDictionary *)studentResponse {
    //Update the student object
    studentObject = [[Student alloc] init];
    
    studentObject.courses = [studentResponse objectForKey:@"Courses"];
    studentObject.email = [studentResponse objectForKey:@"Email"];
    studentObject.firstName = [studentResponse objectForKey:@"FirstName"];
    studentObject.fullname = [studentResponse objectForKey:@"FullName"];
    studentObject.gender = [studentResponse objectForKey:@"Gender"];
    studentObject.studentID = [studentResponse objectForKey:@"ID"];
    studentObject.lastName = [studentResponse objectForKey:@"LastName"];
    studentObject.major = [studentResponse objectForKey:@"Major"];
    studentObject.username = [studentResponse objectForKey:@"Username"];
    studentObject.referenceID = [studentResponse objectForKey:@"id"];
    studentObject.sessionDidEnd = @"NO";
}

- (IBAction)removeStudent:(id)sender {
    //End the session for that student
    NSIndexPath *index = [loggedInStudentsTableView indexPathForCell:removeStudent];
    Student *studentToRemove = [loggedInStudents objectAtIndex:index.row];
    studentToRemove.sessionEnd = [NSDate date];
    studentToRemove.sessionDidEnd = @"YES";
    
    //Update logged in students mutable array
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedStudentsLoggedIn = [NSKeyedArchiver archivedDataWithRootObject:loggedInStudents];
    [defaults setObject:encodedStudentsLoggedIn forKey:@"loggedInStudents"];
    [defaults synchronize];
    
    numberLoggedIn--;
    
    //End session on database
    //Connect to server and database
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://tutorme.stetson.edu/api/sessions/endSession"]]];
    [request setHTTPMethod:@"POST"];
    
    bool emailProfesserBool;
    if ([studentObject.emailProfessor isEqualToString:@"YES"]) {
        emailProfesserBool = @true;
    } else {
        emailProfesserBool = @false;
    }
    
    NSString *postBodyStr = [NSString stringWithFormat:@"Impromptu=%@&Start=%@&End=%@&Subject=%@&Location=%@&Student=%@&Tutor=%@&ForClass=%@&RequestProfessorNotification=%@&", @true, studentObject.sessionStart, studentObject.sessionEnd, @"subject", @"location", @"student", @"tutor", @"forclass", [NSString stringWithFormat:@"%d", emailProfesserBool]];
    
    NSData *encodedPostBody = [postBodyStr dataUsingEncoding:NSASCIIStringEncoding];
    [request setHTTPBody:encodedPostBody];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //Setting up for response
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //Get response
    id json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: nil];
    
    if ([[json objectForKey:@"success"] isEqual:@YES]) {
        //Remove student from UITableView
        if (numberLoggedIn == 0) {
            [self resetTable];
        } else {
            [loggedInStudentsTableView reloadData];
        }
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Problem ending session. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Search Bar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return true;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return true;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (numberLoggedIn == 0) {
        return 0;
    } else {
        return [loggedInStudents count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *loggedInStudentsIdentifer = @"LoggedStudentsIdentifier";
    
    //Create each table cell with the student logged in
    UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:loggedInStudentsIdentifer];
        
        if (cell == nil) {
            Student *student = [loggedInStudents objectAtIndex:indexPath.row];
            if ([student.sessionDidEnd isEqualToString:@"NO"]) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loggedInStudentsIdentifer];
                cell.textLabel.text = student.fullname;
            }
        }

    cell.backgroundColor = [UIColor colorWithRed:(74.0/255.0) green:(184.0/255.0) blue:(175.0/255.0) alpha:1];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
       removeStudent = [tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - Navigation

- (IBAction)unwindForSegue:(UIStoryboardSegue *)unwindSegue {
//    LogInStudentDetailsViewController *detailsViewController = [unwindSegue sourceViewController];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showStudentDetail"])
    {
        LogInStudentDetailsViewController *detailsViewController = segue.destinationViewController;
        detailsViewController.logInStudentViewController = self;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *encodedStudent = [NSKeyedArchiver archivedDataWithRootObject:studentObject];
        [defaults setObject:encodedStudent forKey:@"student"];
        [defaults synchronize];
    }
}
@end
