//
//  MPMachHeader.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/8.
//

#import "MPMachHeader.h"

@implementation MPMachHeader

- (instancetype)initWithDataMagic:(uint32_t)_magic
                          cputype:(cpu_type_t)_cputype
                       cpusubtype:(cpu_subtype_t)_cpusubtype
                         filetype:(uint32_t)_filetype
                            ncmds:(uint32_t)_ncmds
                       sizeofcmds:(uint32_t)_sizeofcmds
                            flags:(uint32_t)_flags
                         reserved:(uint32_t)_reserved {

    if (self = [super init]) {
        self.magic = _magic;
        self.cputype = _cputype;
        self.cpusubtype = _cpusubtype;
        self.filetype = _filetype;
        self.ncmds = _ncmds;
        self.sizeofcmds = _sizeofcmds;
        self.flags = _flags;
        self.reserved = _reserved;
        
        // descriptions
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"Magic Number",
                             @"CPU Type",
                             @"CPU SubType",
                             @"File Type",
                             @"Number of Load Commands",
                             @"Size of Load Commands",
                             @"Flags",
                             @"Reserved", nil];
        
        // values
        self.values = [NSMutableArray arrayWithObjects:
                       [self getMagicNumber:_magic],
                       [self getCputype:_cputype],
                       [self getARM64CpuSubtype:_cpusubtype],
                       [self getFileType:_filetype],
                       [NSString stringWithFormat:@"%d", _ncmds],
                       [NSString stringWithFormat:@"%d", _sizeofcmds],
                       [NSString stringWithFormat:@"%X", _flags],
                       [NSString stringWithFormat:@"%d", _reserved], nil];
    }
    
    return self;
}

+ (instancetype)_initWithDataMagic:(uint32_t)_magic
                           cputype:(cpu_type_t)_cputype
                        cpusubtype:(cpu_subtype_t)_cpusubtype
                          filetype:(uint32_t)_filetype
                             ncmds:(uint32_t)_ncmds
                        sizeofcmds:(uint32_t)_sizeofcmds
                             flags:(uint32_t)_flags
                          reserved:(uint32_t)_reserved {
    
    return [[self alloc] initWithDataMagic:_magic cputype:_cputype cpusubtype:_cpusubtype filetype:_filetype ncmds:_ncmds sizeofcmds:_sizeofcmds flags:_flags reserved:_reserved];
}

# pragma mark -
- (NSString *)getMagicNumber:(uint32_t)magic
{
    switch (magic)
    {
        default:                return @"???";
        case MH_MAGIC:          return @"MH_MAGIC";        // big endian
        case MH_MAGIC_64:       return @"MH_MAGIC_64";
        case MH_CIGAM:          return @"MH_CIGAM";        // little endian
        case MH_CIGAM_64:       return @"MH_CIGAM_64";
    }
}

- (NSString *)getCputype:(cpu_type_t)cputype
{
    switch (cputype)
    {
        default:                    return @"???";
        case CPU_TYPE_ANY:          return @"ANY";
        case CPU_TYPE_MC680x0:      return @"MC680x0";
//        case CPU_TYPE_X86:          return @"X86";
        case CPU_TYPE_I386:         return @"X86";
        case CPU_TYPE_X86_64:       return @"X86_64";
        case CPU_TYPE_MC98000:      return @"MC98000";
        case CPU_TYPE_HPPA:         return @"HPPA";
        case CPU_TYPE_ARM:          return @"ARM";
        case CPU_TYPE_ARM64:        return @"ARM64";
        case CPU_TYPE_ARM64_32:     return @"ARM64_32";
        case CPU_TYPE_MC88000:      return @"MC88000";
        case CPU_TYPE_SPARC:        return @"SPARC";
        case CPU_TYPE_I860:         return @"I860";
        case CPU_TYPE_POWERPC:      return @"PPC";
        case CPU_TYPE_POWERPC64:    return @"PPC64";
    }
}

-(NSString *)getARMCpuSubtype:(cpu_subtype_t)cpusubtype
{
    switch (cpusubtype & ~CPU_SUBTYPE_MASK)
    {
        default:                        return @"???";
        case CPU_SUBTYPE_ARM_ALL:       return @"ARM_ALL";
        case CPU_SUBTYPE_ARM_V4T:       return @"ARM_V4T";
        case CPU_SUBTYPE_ARM_V6:        return @"ARM_V6";
        case CPU_SUBTYPE_ARM_V5TEJ:     return @"ARM_V5TEJ";
        case CPU_SUBTYPE_ARM_XSCALE:    return @"ARM_XSCALE";
        case CPU_SUBTYPE_ARM_V7:        return @"ARM_V7";
        case CPU_SUBTYPE_ARM_V7F:       return @"ARM_V7F";
        case CPU_SUBTYPE_ARM_V7S:       return @"ARM_V7S";
        case CPU_SUBTYPE_ARM_V7K:       return @"ARM_V7K";
        case CPU_SUBTYPE_ARM_V8:        return @"ARM_V8";
        case CPU_SUBTYPE_ARM_V6M:       return @"ARM_V6M";
        case CPU_SUBTYPE_ARM_V7M:       return @"ARM_V7M";
        case CPU_SUBTYPE_ARM_V7EM:      return @"ARM_V7EM";
        case CPU_SUBTYPE_ARM_V8M:       return @"ARM_V8M";
    }
}

- (NSString *)getARM64CpuSubtype:(cpu_subtype_t)cpusubtype
{
    switch (cpusubtype & ~CPU_SUBTYPE_MASK)
    {
        default:                      return @"???";
        case CPU_SUBTYPE_ARM64_ALL:   return @"ARM64_ALL";
        case CPU_SUBTYPE_ARM64_V8:    return @"ARM64_V8";
        case CPU_SUBTYPE_ARM64E:      return @"ARM64E";
    }
}

- (NSString *)getARM64_32CpuSubtype:(cpu_subtype_t)cpusubtype
{
    switch (cpusubtype & ~CPU_SUBTYPE_MASK)
    {
        default:                            return @"???";
        case CPU_SUBTYPE_ARM64_32_ALL:      return @"ARM64_32_ALL";
        case CPU_SUBTYPE_ARM64_32_V8:       return @"ARM64_32_V8";
    }
}

- (NSString *)getFileType:(uint32_t)filetype
{
    switch (filetype) {
        default:                return @"???";
        case MH_OBJECT:         return @"MH_OBJECT";
        case MH_EXECUTE:        return @"MH_EXECUTE";
        case MH_FVMLIB:         return @"MH_FVMLIB";
        case MH_CORE:           return @"MH_CORE";
        case MH_PRELOAD:        return @"MH_PRELOAD";
        case MH_DYLIB:          return @"MH_DYLIB";
        case MH_DYLINKER:       return @"MH_DYLINKER";
        case MH_BUNDLE:         return @"MH_BUNDLE";
        case MH_DYLIB_STUB:     return @"MH_DYLIB_STUB";
        case MH_DSYM:           return @"MH_DSYM";
        case MH_KEXT_BUNDLE:    return @"MH_KEXT_BUNDLE";
        case MH_FILESET:        return @"MH_FILESET";
    }
}

- (NSString *)getFileTypeDetail:(uint32_t)filetype
{
    switch (filetype) {
        default:                return @"???";
        case MH_OBJECT:         return @"Object";
        case MH_EXECUTE:        return @"Executable";
        case MH_FVMLIB:         return @"Fixed VM Shared Library";
        case MH_CORE:           return @"Core";
        case MH_PRELOAD:        return @"Preloaded Executable";
        case MH_DYLIB:          return @"Shared Library ";
        case MH_DYLINKER:       return @"Dynamic Link Editor";
        case MH_BUNDLE:         return @"Bundle";
        case MH_DYLIB_STUB:     return @"Shared Library Stub";
        case MH_DSYM:           return @"Debug Symbols";
        case MH_KEXT_BUNDLE:    return @"Kernel Extension";
        case MH_FILESET:        return @"File Set";
    }
}

- (NSMutableArray *)getFlags:(uint32_t)flags {
    
    NSMutableArray *flagDetails = [[NSMutableArray alloc] init];
    
    uint32_t flagConsts[] = {
        MH_NOUNDEFS,
        MH_INCRLINK,
        MH_DYLDLINK,
        MH_BINDATLOAD,
        MH_PREBOUND,
        MH_SPLIT_SEGS,
        MH_LAZY_INIT,
        MH_TWOLEVEL,
        MH_FORCE_FLAT,
        MH_NOMULTIDEFS,
        MH_NOFIXPREBINDING,
        MH_PREBINDABLE,
        MH_ALLMODSBOUND,
        MH_SUBSECTIONS_VIA_SYMBOLS,
        MH_CANONICAL,
        MH_WEAK_DEFINES,
        MH_BINDS_TO_WEAK,
        MH_ALLOW_STACK_EXECUTION,
        MH_ROOT_SAFE,
        MH_SETUID_SAFE,
        MH_NO_REEXPORTED_DYLIBS,
        MH_PIE,
        MH_DEAD_STRIPPABLE_DYLIB,
        MH_HAS_TLV_DESCRIPTORS,
        MH_NO_HEAP_EXECUTION,
        MH_APP_EXTENSION_SAFE,
        MH_NLIST_OUTOFSYNC_WITH_DYLDINFO,
        MH_SIM_SUPPORT,
        MH_DYLIB_IN_CACHE
    };
    
    NSMutableArray *flagConstsStr = [NSMutableArray arrayWithObjects:
                                     @"MH_NOUNDEFS",
                                     @"MH_INCRLINK",
                                     @"MH_DYLDLINK",
                                     @"MH_BINDATLOAD",
                                     @"MH_PREBOUND",
                                     @"MH_SPLIT_SEGS",
                                     @"MH_LAZY_INIT",
                                     @"MH_TWOLEVEL",
                                     @"MH_FORCE_FLAT",
                                     @"MH_NOMULTIDEFS",
                                     @"MH_NOFIXPREBINDING",
                                     @"MH_PREBINDABLE",
                                     @"MH_ALLMODSBOUND",
                                     @"MH_SUBSECTIONS_VIA_SYMBOLS",
                                     @"MH_CANONICAL",
                                     @"MH_WEAK_DEFINES",
                                     @"MH_BINDS_TO_WEAK",
                                     @"MH_ALLOW_STACK_EXECUTION",
                                     @"MH_ROOT_SAFE",
                                     @"MH_SETUID_SAFE",
                                     @"MH_NO_REEXPORTED_DYLIBS",
                                     @"MH_PIE",
                                     @"MH_DEAD_STRIPPABLE_DYLIB",
                                     @"MH_HAS_TLV_DESCRIPTORS",
                                     @"MH_NO_HEAP_EXECUTION",
                                     @"MH_APP_EXTENSION_SAFE",
                                     @"MH_NLIST_OUTOFSYNC_WITH_DYL",
                                     @"MH_SIM_SUPPORT",
                                     @"MH_DYLIB_IN_CACHE", nil];
    
    //
    for (int i = 0; i < flagConstsStr.count; i++) {
        if (flags & flagConsts[i]) {
            MPRow* row = [MPRow _initWithDataOffset:@"-"
                                               data:@"-"
                                        description:[NSString stringWithFormat:@"%.8X", flagConsts[i]]
                                              value:flagConstsStr[i]];
            
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
        NSUInteger data = [cursor readLittleInt32];
        NSString *description = self.descriptions[i];
        NSString *value = self.values[i];
        
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
    
    return details;
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> magic: 0x%08x, cputype: %x, cpusubtype: %x, filetype: %d, ncmds: %u, sizeofcmds: %d, flags: 0x%x, reserved: %d",
            NSStringFromClass([self class]), self,
            self.magic, self.cputype, self.cpusubtype, self.filetype, self.ncmds, self.sizeofcmds, self.flags, self.reserved];
}

@end
