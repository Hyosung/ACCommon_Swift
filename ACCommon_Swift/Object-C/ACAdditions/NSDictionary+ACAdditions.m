//
//  NSDictionary+ACAdditions.m
//  ACCommon
//
//  Created by i云 on 14-4-20.
//  Copyright (c) 2014年 Alone Coding. All rights reserved.
//

#import "NSDictionary+ACAdditions.h"

@implementation NSDictionary (ACAdditions)
- (NSString *)JSONString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *JSONString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    return JSONString;
}
@end
