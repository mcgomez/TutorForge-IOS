//
//  Student.h
//  TutorForge
//
//  Created by Marisa Gomez on 11/27/15.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

//Student information
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *fullname;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *studentID;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *major;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSArray *courses;
@property (strong, nonatomic) NSString *referenceID;

//Session variables
@property (strong, nonatomic) NSString *courseRequested;
@property (strong, nonatomic) NSString *topic;
@property (strong, nonatomic) NSString *emailProfessor;
@property (strong, nonatomic) NSDate *sessionStart;
@property (strong, nonatomic) NSDate *sessionEnd;
@property (strong, nonatomic) NSString *sessionDidEnd;

@end
