//
//  MPSection.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/6.
//

#import "MPSection.h"

@implementation MPSection

- (instancetype)initWithDataSectname:(char *)_sectname
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
                           reserved3:(uint32_t)_reserved3 {
    
    if (self = [super init]) {
        self.sectname = _sectname;
        self.segname = _segname;
        self.addr = _addr;
        self.size = _size;
        self.offset = _offset;
        self.algin = 1 << _algin;
        self.reloff = _reloff;
        self.nreloc = _nreloc;
        self.flags = _flags;
        self.reserved1 = _reserved1;
        self.reserved2 = _reserved2;
        self.reserved3 = _reserved3;
        
        // descriptions
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"Section Name",
                             @"Segment Name",
                             @"Address",
                             @"Size",
                             @"Offset",
                             @"Alignment",
                             @"Relocations Offset",
                             @"Number of Relocations",
                             @"Flags",
                             @"Reserved1",
                             @"Reserved2",
                             @"Reserved3", nil];
        
        NSString *current_sectname = [NSString stringWithFormat:@"%s", _sectname];
        if ([current_sectname length] > 16) {
            current_sectname = [current_sectname substringToIndex:16];
        }
        
        // values
        self.values = [NSMutableArray arrayWithObjects:
                       current_sectname,
                       [NSString stringWithFormat:@"%s", _segname],
                       [NSString stringWithFormat:@"%lld", _addr],
                       [NSString stringWithFormat:@"%lld", _size],
                       [NSString stringWithFormat:@"%d", _offset],
                       [NSString stringWithFormat:@"%d", 1 << _algin],
                       [NSString stringWithFormat:@"%d", _reloff],
                       [NSString stringWithFormat:@"%d", _nreloc],
//                       [NSString stringWithFormat:@"%d", _flags],
                       [NSString stringWithFormat:@"%@", @""],
                       [NSString stringWithFormat:@"%d", _reserved1],
                       [NSString stringWithFormat:@"%d", _reserved2],
                       [NSString stringWithFormat:@"%d", _reserved3], nil];
    }
    
    return self;
}

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
                            reserved3:(uint32_t)_reserved3 {
    
    return [[self alloc] initWithDataSectname:_sectname
                                      segname:_segname
                                         addr:_addr
                                         size:_size
                                       offset:_offset
                                        algin:_algin
                                       reloff:_reloff
                                       nreloc:_nreloc
                                        flags:_flags
                                    reserved1:_reserved1
                                    reserved2:_reserved2
                                    reserved3:_reserved3];
}

- (NSMutableArray *)getFlags:(uint32_t)flags {
    
    NSMutableArray *flagDetails = [[NSMutableArray alloc] init];
    
    uint32_t flagConsts[] = {
        S_REGULAR,
        S_ZEROFILL,
        S_CSTRING_LITERALS,
        S_4BYTE_LITERALS,
        S_8BYTE_LITERALS,
        S_LITERAL_POINTERS,
        S_NON_LAZY_SYMBOL_POINTERS,
        S_LAZY_SYMBOL_POINTERS,
        S_SYMBOL_STUBS,
        S_MOD_INIT_FUNC_POINTERS,
        S_MOD_TERM_FUNC_POINTERS,
        S_COALESCED,
        S_GB_ZEROFILL,
        S_INTERPOSING,
        S_16BYTE_LITERALS,
        S_DTRACE_DOF,
        S_LAZY_DYLIB_SYMBOL_POINTERS,
        S_THREAD_LOCAL_REGULAR,
        S_THREAD_LOCAL_ZEROFILL,
        S_THREAD_LOCAL_VARIABLES,
        S_THREAD_LOCAL_VARIABLE_POINTERS,
        S_THREAD_LOCAL_INIT_FUNCTION_POINTERS,
        S_INIT_FUNC_OFFSETS
    };
    
    uint32_t flagConsts2[] = {
//        SECTION_ATTRIBUTES_USR,
        S_ATTR_PURE_INSTRUCTIONS,
        S_ATTR_NO_TOC,
        S_ATTR_STRIP_STATIC_SYMS,
        S_ATTR_NO_DEAD_STRIP,
        S_ATTR_LIVE_SUPPORT,
        S_ATTR_SELF_MODIFYING_CODE,
        S_ATTR_DEBUG,
//        SECTION_ATTRIBUTES_SYS,
        S_ATTR_SOME_INSTRUCTIONS,
        S_ATTR_EXT_RELOC,
        S_ATTR_LOC_RELOC
    };
    
    
    NSMutableArray *flagConstsStr = [NSMutableArray arrayWithObjects:
                                     @"S_REGULAR",
                                     @"S_ZEROFILL",
                                     @"S_CSTRING_LITERALS",
                                     @"S_4BYTE_LITERALS",
                                     @"S_8BYTE_LITERALS",
                                     @"S_LITERAL_POINTERS",
                                     @"S_NON_LAZY_SYMBOL_POINTERS",
                                     @"S_LAZY_SYMBOL_POINTERS",
                                     @"S_SYMBOL_STUBS",
                                     @"S_MOD_INIT_FUNC_POINTERS",
                                     @"S_MOD_TERM_FUNC_POINTERS",
                                     @"S_COALESCED",
                                     @"S_GB_ZEROFILL",
                                     @"S_INTERPOSING",
                                     @"S_16BYTE_LITERALS",
                                     @"S_DTRACE_DOF",
                                     @"S_LAZY_DYLIB_SYMBOL_POINTERS",
                                     @"S_THREAD_LOCAL_REGULAR",
                                     @"S_THREAD_LOCAL_ZEROFILL",
                                     @"S_THREAD_LOCAL_VARIABLES",
                                     @"S_THREAD_LOCAL_VARIABLE_POINTERS",
                                     @"S_THREAD_LOCAL_INIT_FUNCTION_POINTERS", nil];
    
    NSMutableArray *flagConstsStr2 = [NSMutableArray arrayWithObjects:
//                                     @"SECTION_ATTRIBUTES_USR",
                                     @"S_ATTR_PURE_INSTRUCTIONS",
                                     @"S_ATTR_NO_TOC",
                                     @"S_ATTR_STRIP_STATIC_SYMS",
                                     @"S_ATTR_NO_DEAD_STRIP",
                                     @"S_ATTR_LIVE_SUPPORT",
                                     @"S_ATTR_SELF_MODIFYING_CODE",
                                     @"S_ATTR_DEBUG",
//                                     @"SECTION_ATTRIBUTES_SYS",
                                     @"S_ATTR_SOME_INSTRUCTIONS",
                                     @"S_ATTR_EXT_RELOC",
                                     @"S_ATTR_LOC_RELOC", nil];
                                     
    //
    for (int i = 0; i < flagConstsStr.count; i++) {
        if ((flags & SECTION_TYPE) == flagConsts[i]) {
            MPRow* row = [MPRow _initWithDataOffset:@"-"
                                               data:@"-"
                                        description:[NSString stringWithFormat:@"%.8X", flagConsts[i]]
                                              value:flagConstsStr[i]];
            
            [flagDetails addObject:row];
        }
    }
    
    for (int i = 0; i < flagConstsStr2.count; i++) {
        if (flags & flagConsts2[i]) {
            MPRow* row = [MPRow _initWithDataOffset:@"-"
                                               data:@"-"
                                        description:[NSString stringWithFormat:@"%.8X", flagConsts2[i]]
                                              value:flagConstsStr2[i]];
            
            [flagDetails addObject:row];
        }
    }
    
    return flagDetails;
}

# pragma mark Details
- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor {
    
    NSMutableArray *details = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.descriptions.count; i++) {
        
        NSUInteger offset = cursor->_current_offset;
        NSUInteger data = 0;
        NSString *description = self.descriptions[i];
        NSString *value = self.values[i];
        
        if ( [self.descriptions[i] isEqualToString:@"Section Name"] ||
             [self.descriptions[i] isEqualToString:@"Segment Name"] ) {
            
            data = [cursor readBigInt64];
            data = [cursor readBigInt64];
            
        } else if ( [self.descriptions[i] isEqualToString:@"Address"] ||
                    [self.descriptions[i] isEqualToString:@"Size"] ) {
            
            data = [cursor readLittleInt64];
            
        } else {
           data = [cursor readLittleInt32];
        }
        
        MPRow* row = [MPRow _initWithDataOffset:[NSString stringWithFormat:@"%.8lX", offset]
                                           data:[NSString stringWithFormat:@"%.8lX", data]
                                    description:description
                                          value:value];
        
        [details addObject:row];
        
        // Flag bit
        if ( [self.descriptions[i] isEqualToString:@"Flags"] ) {
            [details addObjectsFromArray:[self getFlags:self.flags]];
        }
    }
    
    // offset
//    cursor->_offset += self.cmdsize - sizeof(dylinker_command_t);
//    cursor->_current_offset += self.cmdsize - sizeof(dylinker_command_t);
    
    return details;
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> sectname: %s, segname: %s, addr: %lld, size: %lld, offset: %d, algin: %d, reloff: %d, nreloc: %d, flags: %d, reserved1: %d, reserved2: %d, reserved3: %d",
            NSStringFromClass([self class]), self,
            self.sectname, self.segname, self.addr, self.size, self.offset, self.algin, self.reloff, self.nreloc, self.flags, self.reserved1, self.reserved2, self.reserved3];
}

@end
