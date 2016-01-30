//
//  Student.m
//  TutorForge
//
//  Created by Marisa Gomez on 11/27/15.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import "Student.h"

@implementation Student
@synthesize email;
@synthesize firstName;
@synthesize fullname;
@synthesize gender;
@synthesize studentID;
@synthesize lastName;
@synthesize major;
@synthesize username;
@synthesize courses;
@synthesize referenceID;
@synthesize courseRequested;
@synthesize topic;
@synthesize emailProfessor;
@synthesize sessionStart;
@synthesize sessionEnd;
@synthesize sessionDidEnd;

- (id) init {
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.fullname forKey:@"fullname"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.studentID forKey:@"studentID"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.major forKey:@"major"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.courses forKey:@"courses"];
    [encoder encodeObject:self.referenceID forKey:@"referenceID"];
    [encoder encodeObject:self.courseRequested forKey:@"courseRequested"];
    [encoder encodeObject:self.topic forKey:@"topic"];
    [encoder encodeObject:self.emailProfessor forKey:@"emailProfessor"];
    [encoder encodeObject:self.sessionStart forKey:@"sessionStart"];
    [encoder encodeObject:self.sessionEnd forKey:@"sessionEnd"];
    [encoder encodeObject:self.sessionDidEnd forKey:@"sessionDidEnd"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.email = [decoder decodeObjectForKey:@"email"];
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.fullname = [decoder decodeObjectForKey:@"fullname"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        self.studentID = [decoder decodeObjectForKey:@"studentID"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.major = [decoder decodeObjectForKey:@"major"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.courses = [decoder decodeObjectForKey:@"courses"];
        self.referenceID = [decoder decodeObjectForKey:@"referenceID"];
        self.courseRequested = [decoder decodeObjectForKey:@"courseRequested"];
        self.topic = [decoder decodeObjectForKey:@"topic"];
        self.emailProfessor = [decoder decodeObjectForKey:@"emailProfessor"];
        self.sessionStart = [decoder decodeObjectForKey:@"sessionStart"];
        self.sessionEnd = [decoder decodeObjectForKey:@"sessionEnd"];
        self.sessionDidEnd = [decoder decodeObjectForKey:@"sessionDidEnd"];
    }
    return self;
}

@end
