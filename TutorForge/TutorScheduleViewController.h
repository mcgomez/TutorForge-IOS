//
//  TutorScheduleViewController.h
//  TutorForge
//
//  Created by Marisa Gomez on 01/29/16.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SACalendar.h"

@interface TutorScheduleViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    //Global Variable
    UIDatePicker *datePicker;
    UIToolbar *toolBar;
    //Tutor Picker
    UIPickerView *tutorPicker;
    UIToolbar *tutorPickerToolbar;
    //Time Picker
    UIPickerView *timePicker;
    UIToolbar *timePickerToolbar;
    //Subject Picker
    UIPickerView *subjectPicker;
    UIToolbar *subjectToolbar;
}

@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) IBOutlet UITextField *TutorTextField;
@property (strong, nonatomic) IBOutlet UITextField *TimeTextField;
@property (strong, nonatomic) IBOutlet UITextField *DateTextField;
@property (weak, nonatomic) IBOutlet UIButton *requestAppointmentForMyself;
@property (strong, nonatomic) IBOutlet UITextField *SubjectTextField;


@end
