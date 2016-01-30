//
//  LogInStudentDetailsViewController.h
//  TutorForge
//
//  Created by Marisa Gomez on 11/1/15.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "LogInStudentViewController.h"

@interface LogInStudentDetailsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) LogInStudentViewController *logInStudentViewController;
@property (strong, nonatomic) Student *student;
@property (weak, nonatomic) IBOutlet UIPickerView *coursePickerView;
@property (weak, nonatomic) IBOutlet UITextField *topicTextField;
@property (weak, nonatomic) IBOutlet UISwitch *emailProfessor;
@property (strong, nonatomic) NSMutableArray *courses;

- (IBAction)logInStudent:(UIBarButtonItem *)sender;

@end
