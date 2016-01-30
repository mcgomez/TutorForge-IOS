//
//  Tutor.m
//  TutorForge
//
//  Created by Marisa Gomez on 11/29/15.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import "Tutor.h"

@implementation Tutor
@synthesize fullname;
@synthesize studentID;
@synthesize department;
@synthesize schedule;

- (id) init {
    
    //Initialize schedule dictionary
    schedule = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.fullname forKey:@"fullname"];
    [encoder encodeObject:self.studentID forKey:@"studentID"];
    [encoder encodeObject:self.department forKey:@"department"];
    [encoder encodeObject:self.schedule forKey:@"schedule"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.fullname = [decoder decodeObjectForKey:@"fullname"];
        self.studentID = [decoder decodeObjectForKey:@"studentID"];
        self.department = [decoder decodeObjectForKey:@"department"];
        self.schedule = [decoder decodeObjectForKey:@"schedule"];
    }
    return self;
}

@end
