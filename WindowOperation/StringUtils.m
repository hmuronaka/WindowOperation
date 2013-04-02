//
//  StringUtils.m
//  WindowOperation
//
//  Created by MURONAKA HIROAKI on 2013/03/13.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils

+(NSString*)replaceEscapeSeq:(NSString*)target {
    
    NSArray* olds = [NSArray arrayWithObjects:
                     @"\\",
                     @"@",
                     @";",
                     @"#",
                     nil
                     ];
    
    NSMutableString* result = [[NSMutableString alloc] initWithString:target];
    for(NSString* anOld in olds) {
        NSString* replacedStr = [NSString stringWithFormat:@"\\%@", anOld];
        [result replaceOccurrencesOfString:anOld withString:replacedStr options:NSLiteralSearch range:NSMakeRange(0, result.length)];
    }
    return result;
}


+(NSArray*)split:(NSString*)target delimiter:(NSString*)delimiter
{
    NSMutableArray* resultList = [[NSMutableArray alloc] init];
    
    NSString* pattern = [NSString stringWithFormat:@"[^\\\\]%@", delimiter];

    NSRegularExpression* regexp = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    
    NSInteger position = 0;
    NSArray* results =
        [regexp matchesInString:target
                        options:0
                          range:NSMakeRange(position, target.length - position)];
    
    NSString* escapedDelimiter = [NSString stringWithFormat:@"\\%@", delimiter];
    for(NSTextCheckingResult* result in results) {
        NSString* aText = [target
                           substringWithRange:
                                NSMakeRange(position, result.range.location + delimiter.length - position)];
        aText = [aText stringByReplacingOccurrencesOfString:escapedDelimiter withString:delimiter];
        [resultList addObject:aText];
        position = result.range.location + result.range.length;
    }
    
    if( position < target.length)
    {
        NSString* aText = [target substringWithRange:
                           NSMakeRange(position, target.length - position)];
        aText = [aText stringByReplacingOccurrencesOfString:escapedDelimiter withString:delimiter];
        [resultList addObject:aText];
    }
    return resultList;
}

@end
