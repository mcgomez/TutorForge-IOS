//
//  LogInStudentDetailsViewController.m
//  TutorForge
//
//  Created by Marisa Gomez on 11/1/15.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import "LogInStudentDetailsViewController.h"
#import "LogInStudentViewController.h"
#import "Student.h"

@interface LogInStudentDetailsViewController ()

@end

@implementation LogInStudentDetailsViewController
@synthesize logInStudentViewController;
@synthesize student;
@synthesize courses;
@synthesize topicTextField;
@synthesize emailProfessor;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedStudent = [defaults objectForKey:@"student"];
    student = [NSKeyedUnarchiver unarchiveObjectWithData:encodedStudent];
    
    //courses = student.courses;
    courses = [[NSMutableArray alloc]initWithObjects:@"", @"CSCI", @"Math", @"Science", @"CS", @"Art", nil];
    
    topicTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIPickerViewDelegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return courses.count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = courses[row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //Set the selected course for tutoring
    student.courseRequested = courses[row];
    
    NSData *encodedStudent = [NSKeyedArchiver archivedDataWithRootObject:student];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedStudent forKey:@"student"];
    [defaults synchronize];
}

#pragma mark - Log in student details

- (IBAction)logInStudent:(UIBarButtonItem *)sender {
    //Set fields for logging in a student, including topic and whether to email the professor
    student.topic = topicTextField.text;
    
    if ([emailProfessor isOn]) {
        student.emailProfessor = @"YES";
    } else {
        student.emailProfessor = @"NO";
    }
    
    student.sessionStart = [NSDate date];
    
    NSData *encodedStudent = [NSKeyedArchiver archivedDataWithRootObject:student];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *studentsLoggedIn = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"loggedInStudents"]]];
    [studentsLoggedIn addObject:student];
    NSData *encodedStudentsLoggedIn = [NSKeyedArchiver archivedDataWithRootObject:studentsLoggedIn];
    
    [defaults setObject:encodedStudent forKey:@"student"];
    [defaults setObject:encodedStudentsLoggedIn forKey:@"loggedInStudents"];
    
    [defaults synchronize];
    
//    [logInStudentViewController.loggedInStudents addObject:student];
    
    [self performSegueWithIdentifier:@"unwindWithInfo" sender:self];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

/*
 * Dismiss keyboard when return key is pressed when entering topic
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [topicTextField resignFirstResponder];
    return NO;
}

@end
