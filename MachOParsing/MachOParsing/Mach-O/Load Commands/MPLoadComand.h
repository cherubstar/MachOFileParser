//
//  MPLoadComand.h
//  MachOParsing
//
//  Created by 小七 on 2023/12/4.
//

#import <Foundation/Foundation.h>
#import "Prefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLoadComand : NSObject

+ (NSString *)getNameForCommand:(uint32_t)cmd;

@end

NS_ASSUME_NONNULL_END
