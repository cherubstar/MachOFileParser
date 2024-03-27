//
//  MPLCLinkeditData.h
//  MachOParsing
//
//  Created by 小七 on 2023/12/6.
//

#import <Foundation/Foundation.h>
#import "Prefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLCLinkeditData : NSObject

// The parts of struct rpath_command pulled out so that our property accessors can be synthesized.
@property(assign, nonatomic) uint32_t cmd;
@property(assign, nonatomic) uint32_t cmdsize;
@property(assign, nonatomic) uint32_t dataoff;
@property(assign, nonatomic) uint32_t datasize;

@property(assign, nonatomic) NSMutableArray *descriptions;
@property(assign, nonatomic) NSMutableArray *values;

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                         dataoff:(uint32_t)_dataoff
                        datasize:(uint32_t)_datasize;

- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor;

@end

NS_ASSUME_NONNULL_END
