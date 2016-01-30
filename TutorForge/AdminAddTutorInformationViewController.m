//
//  AdminAddTutorInformationViewController.m
//  TutorForge
//
//  Created by Marisa Gomez on 11/23/15.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import "AdminAddTutorInformationViewController.h"
#import "Tutor.h"

@interface AdminAddTutorInformationViewController ()

@end

@implementation AdminAddTutorInformationViewController
@synthesize nextBarButton;
@synthesize fullNameTextField;
@synthesize studentIdTextField;
@synthesize departmentPicker;
@synthesize subjects;
@synthesize subject;
@synthesize tutor;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    tutor = [[Tutor alloc] init];
    NSData *encodedTutor = [NSKeyedArchiver archivedDataWithRootObject:tutor];
    [defaults setObject:encodedTutor forKey:@"tutor"];
    [defaults synchronize];
    
    nextBarButton.action = @selector(addTutorInformation:);
    subjects = [[NSMutableArray alloc] init];
    
    //Get all departments
    //Connect to server and database
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://tutorme.stetson.edu/api/courses/getMajorTags"]]];
    
    //Setting up for response
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //Get response
    id json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: nil];
    NSArray *responseJSON = [json objectForKey:@"result"];
    
    //Add subjects to subjects array
    for (int i = 0; i < responseJSON.count; i++) {
        NSDictionary *subject = [responseJSON objectAtIndex:i];
        [subjects addObject:[subject objectForKey:@"MajorSubject"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addTutorInformation:(id)sender {
    //Check if valid input
    if ([fullNameTextField.text isEqualToString:@""]) {
        UIAlertController *errorAlert=   [UIAlertController
                                     alertControllerWithTitle:@"Error"
                                     message:[NSString stringWithFormat:@"You must enter a name."]
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmation = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [errorAlert dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
        
        [errorAlert addAction:confirmation];
        [self presentViewController:errorAlert animated:YES completion:nil];
        return;
    } else if ([studentIdTextField.text isEqualToString:@""]) {
        UIAlertController *errorAlert=   [UIAlertController
                                          alertControllerWithTitle:@"Error"
                                          message:[NSString stringWithFormat:@"You must enter a student ID."]
                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmation = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [errorAlert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        
        [errorAlert addAction:confirmation];
        [self presentViewController:errorAlert animated:YES completion:nil];
        return;
    } else if (![[studentIdTextField.text substringToIndex:3] isEqualToString:@"800"]) {
        UIAlertController *errorAlert=   [UIAlertController
                                          alertControllerWithTitle:@"Error"
                                          message:[NSString stringWithFormat:@"You must enter a valid student ID."]
                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmation = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [errorAlert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        
        [errorAlert addAction:confirmation];
        [self presentViewController:errorAlert animated:YES completion:nil];
        return;
    }
    
    //Check if student exists
    //Connect to server and database
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://tutorme.stetson.edu/api/students/get?field=ID&value=%@", studentIdTextField.text]]];
    
    //Setting up for response
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //Get response
    id json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: nil];

    if ([[json objectForKey:@"success"] isEqual:@YES]) {
        //Confirm input
        UIAlertController *check=   [UIAlertController
                                     alertControllerWithTitle:@"Confirmation"
                                     message:[NSString stringWithFormat:@"Full name: %@ \n Student ID: %@ \n Department: %@", fullNameTextField.text, studentIdTextField.text, subject]
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesConfirmation = [UIAlertAction
                                          actionWithTitle:@"YES"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action) {
                                              //Set as tutor
                                              tutor.fullname = fullNameTextField.text;
                                              tutor.studentID = studentIdTextField.text;
                                              tutor.department = subject;
                                              
                                              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                              NSData *encodedTutor = [NSKeyedArchiver archivedDataWithRootObject:tutor];
                                              [defaults setObject:encodedTutor forKey:@"tutor"];
                                              [defaults synchronize];
                                              
                                              //Connect to server and database
                                              NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://tutorme.stetson.edu/api/administrator/setAsTutor"]]];
                                              [request setHTTPMethod:@"POST"];
                                              
                                              NSString *postBodyStr = [NSString stringWithFormat:@"ID=%@&Subject=%@&isStudentTutor=%@", studentIdTextField.text, subject, @true];
                                              
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
                                                  //Perform segue
                                                  [self performSegueWithIdentifier:@"showSchedule" sender:self];
                                                  return;
                                              }
                                              
                                              UIAlertController *requestError=   [UIAlertController
                                                                           alertControllerWithTitle:@"Error"
                                                                           message:[NSString stringWithFormat:@"Error setting student as tutor."]
                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                              UIAlertAction *confirmation = [UIAlertAction
                                                                               actionWithTitle:@"OK"
                                                                               style:UIAlertActionStyleDefault
                                                                               handler:^(UIAlertAction * action)
                                                                               {
                                                                                   [requestError dismissViewControllerAnimated:YES completion:nil];
                                                                                   
                                                                               }];
                                              [requestError addAction:confirmation];
                                              [self presentViewController:requestError animated:YES completion:nil];
                                          }];
        UIAlertAction *noConfirmation = [UIAlertAction
                                         actionWithTitle:@"NO"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             [check dismissViewControllerAnimated:YES completion:nil];
                                         }];
        
        [check addAction:yesConfirmation];
        [check addAction:noConfirmation];
        [self presentViewController:check animated:YES completion:nil];
    } else {
        UIAlertController *errorAlert=   [UIAlertController
                                          alertControllerWithTitle:@"Error"
                                          message:[NSString stringWithFormat:@"Student does not exist."]
                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmation = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                           return;
                                           
                                       }];
        
        [errorAlert addAction:confirmation];
        [self presentViewController:errorAlert animated:YES completion:nil];
    }
}

#pragma mark - UIPickerViewDelegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return subjects.count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //Set inital value
    if (row == 0) {
        subject = [subjects objectAtIndex:row];
    }
    
    NSString *title = [subjects objectAtIndex:row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    subject = [subjects objectAtIndex:row];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showSchedule"]) {
        
    }
}

@end
