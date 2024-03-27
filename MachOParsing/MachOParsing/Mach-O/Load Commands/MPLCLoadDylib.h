//
//  MPLCLoadDylib.h
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import <Foundation/Foundation.h>
#import "Prefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLCLoadDylib : NSObject

// The parts of struct dylib_command pulled out so that our property accessors can be synthesized.
@property(assign, nonatomic) uint32_t cmd;
@property(assign, nonatomic) uint32_t cmdsize;
@property(assign, nonatomic) uint32_t offset;
@property(assign, nonatomic) uint32_t timestamp;
@property(assign, nonatomic) uint32_t current_version;
@property(assign, nonatomic) uint32_t compatibility_version;
@property(copy, nonatomic) NSString *name;

@property(assign, nonatomic) NSMutableArray *descriptions;
@property(assign, nonatomic) NSMutableArray *values;

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                          offset:(uint32_t)_offset
                       timestamp:(uint32_t)_timestamp
                 current_version:(uint32_t)_current_version
           compatibility_version:(uint32_t)_compatibility_version;

- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor;

@end

NS_ASSUME_NONNULL_END
