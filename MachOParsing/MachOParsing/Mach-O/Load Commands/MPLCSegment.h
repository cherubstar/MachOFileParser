//
//  MPLCSegment.h
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import <Foundation/Foundation.h>
#import "Prefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLCSegment : NSObject

// The parts of struct segment_command_64 pulled out so that our property accessors can be synthesized.
@property(assign, nonatomic) uint32_t cmd;
@property(assign, nonatomic) uint32_t cmdsize;
@property(assign, nonatomic) char *segname;
@property(assign, nonatomic) uint64_t vmaddr;
@property(assign, nonatomic) uint64_t vmsize;
@property(assign, nonatomic) uint64_t fileoff;
@property(assign, nonatomic) uint64_t filesize;
@property(assign, nonatomic) vm_prot_t maxprot;
@property(assign, nonatomic) vm_prot_t initprot;
@property(assign, nonatomic) uint32_t nsects;
@property(assign, nonatomic) uint32_t flags;

@property(assign, nonatomic) NSMutableArray *descriptions;
@property(assign, nonatomic) NSMutableArray *values;

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                         segname:(char *)_segname
                          vmaddr:(uint64_t)_vmaddr
                          vmsize:(uint64_t)_vmsize
                         fileoff:(uint64_t)_fileoff
                        filesize:(uint64_t)_filesize
                         maxprot:(vm_prot_t)_maxprot
                        initprot:(vm_prot_t)_initprot
                          nsects:(uint32_t)_nsects
                           flags:(uint32_t)_flags;

- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor;

@end

NS_ASSUME_NONNULL_END
