//
//  MPSection.h
//  MachOParsing
//
//  Created by 小七 on 2023/12/6.
//

#import <Foundation/Foundation.h>
#import "Prefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPSection : NSObject

// The parts of struct section_64 pulled out so that our property accessors can be synthesized.
@property(assign, nonatomic) char *sectname;
@property(assign, nonatomic) char *segname;
@property(assign, nonatomic) uint64_t addr;
@property(assign, nonatomic) uint64_t size;
@property(assign, nonatomic) uint32_t offset;
@property(assign, nonatomic) uint32_t algin;
@property(assign, nonatomic) uint32_t reloff;
@property(assign, nonatomic) uint32_t nreloc;
@property(assign, nonatomic) uint32_t flags;
@property(assign, nonatomic) uint32_t reserved1;
@property(assign, nonatomic) uint32_t reserved2;
@property(assign, nonatomic) uint32_t reserved3;

@property(assign, nonatomic) NSMutableArray *descriptions;
@property(assign, nonatomic) NSMutableArray *values;

+ (instancetype)_initWithDataSectname:(char *)_sectname
                              segname:(char *)_segname
                                 addr:(uint64_t)_addr
                                 size:(uint64_t)_size
                               offset:(uint32_t)_offset
                                algin:(uint32_t)_algin
                               reloff:(uint32_t)_reloff
                               nreloc:(uint32_t)_nreloc
                                flags:(uint32_t)_flags
                            reserved1:(uint32_t)_reserved1
                            reserved2:(uint32_t)_reserved2
                            reserved3:(uint32_t)_reserved3;

- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor;

@end

NS_ASSUME_NONNULL_END
