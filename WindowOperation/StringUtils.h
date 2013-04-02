//
//  StringUtils.h
//  WindowOperation
//
//  Created by MURONAKA HIROAKI on 2013/03/13.
//  Copyright (c) 2013年 Muronaka Hiroaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

+(NSString*)replaceEscapeSeq:(NSString*)target;

+(NSArray*)split:(NSString*)target delimiter:(NSString*)delimiter;

@end
