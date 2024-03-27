//
//  MPLCMain.h
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import <Foundation/Foundation.h>
#import "Prefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLCMain : NSObject

// The parts of struct entry_point_command pulled out so that our property accessors can be synthesized.
@property(assign, nonatomic) uint32_t cmd;
@property(assign, nonatomic) uint32_t cmdsize;
@property(assign, nonatomic) uint64_t entryoff;
@property(assign, nonatomic) uint64_t stacksize;
@property(assign, nonatomic) uint64_t entrypoint;

@property(assign, nonatomic) NSMutableArray *descriptions;
@property(assign, nonatomic) NSMutableArray *values;

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                        entryoff:(uint64_t)_entryoff
                       stacksize:(uint64_t)_stacksize
                      entrypoint:(uint64_t)_entrypoint;

- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor;

@end

NS_ASSUME_NONNULL_END
