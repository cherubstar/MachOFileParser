//
//  MPMachHeader.h
//  MachOParsing
//
//  Created by 小七 on 2023/12/8.
//

#import <Foundation/Foundation.h>
#import "Prefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPMachHeader : NSObject

// The parts of struct mach_header_64 pulled out so that our property accessors can be synthesized.
@property(assign, nonatomic) uint32_t magic;
@property(assign, nonatomic) cpu_type_t cputype;
@property(assign, nonatomic) cpu_subtype_t cpusubtype;
@property(assign, nonatomic) uint32_t filetype;
@property(assign, nonatomic) uint32_t ncmds;
@property(assign, nonatomic) uint32_t sizeofcmds;
@property(assign, nonatomic) uint32_t flags;
@property(assign, nonatomic) uint32_t reserved;

@property(assign, nonatomic) NSMutableArray *descriptions;
@property(assign, nonatomic) NSMutableArray *values;

- (NSString *)getFileType:(uint32_t)filetype;
- (NSString *)getFileTypeDetail:(uint32_t)filetype;

+ (instancetype)_initWithDataMagic:(uint32_t)_magic
                           cputype:(cpu_type_t)_cputype
                        cpusubtype:(cpu_subtype_t)_cpusubtype
                          filetype:(uint32_t)_filetype
                             ncmds:(uint32_t)_ncmds
                        sizeofcmds:(uint32_t)_sizeofcmds
                             flags:(uint32_t)_flags
                          reserved:(uint32_t)_reserved;

- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor;

@end

NS_ASSUME_NONNULL_END
