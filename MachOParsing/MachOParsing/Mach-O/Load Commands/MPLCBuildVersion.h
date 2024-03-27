//
//  MPLCBuildVersion.h
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import <Foundation/Foundation.h>
#import "Prefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLCBuildVersion : NSObject

// The parts of struct build_version_command pulled out so that our property accessors can be synthesized.
@property(assign, nonatomic) uint32_t cmd;
@property(assign, nonatomic) uint32_t cmdsize;
@property(assign, nonatomic) uint32_t platform;
@property(assign, nonatomic) uint32_t minos;
@property(assign, nonatomic) uint32_t sdk;
@property(assign, nonatomic) uint32_t ntools;

// The parts of struct build_version_command pulled out so that our property accessors can be synthesized.
@property(assign, nonatomic) uint32_t tool;
@property(assign, nonatomic) uint32_t version;

@property(assign, nonatomic) NSMutableArray *descriptions;
@property(assign, nonatomic) NSMutableArray *values;

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                        platform:(uint32_t)_platform
                           minos:(uint32_t)_minos
                             sdk:(uint32_t)_sdk
                          ntools:(uint32_t)_ntools;

- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor;

@end

NS_ASSUME_NONNULL_END
