//
//  MPLCSegment.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import "MPLCSegment.h"

@implementation MPLCSegment

- (instancetype)initWithDataCmd:(uint32_t)cmd
                        cmdsize:(uint32_t)_cmdsize
                        segname:(char *)_segname
                         vmaddr:(uint64_t)_vmaddr
                         vmsize:(uint64_t)_vmsize
                        fileoff:(uint64_t)_fileoff
                       filesize:(uint64_t)_filesize
                        maxprot:(vm_prot_t)_maxprot
                       initprot:(vm_prot_t)_initprot
                         nsects:(uint32_t)_nsects
                          flags:(uint32_t)_flags {
    
    if (self = [super init]) {
        self.cmd = cmd;
        self.cmdsize = _cmdsize;
        self.segname = _segname;
        self.vmaddr = _vmaddr;
        self.vmsize = _vmsize;
        self.fileoff = _fileoff;
        self.filesize = _filesize;
        self.maxprot = _maxprot;
        self.initprot = _initprot;
        self.nsects = _nsects;
        self.flags = _flags;
        
        // descriptions
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"Command",
                             @"Command Size",
                             @"Segment Name",
                             @"VM Address",
                             @"VM Size",
                             @"File Offset",
                             @"File Size",
                             @"Maximum VM Protection",
                             @"Initial VM Protection",
                             @"Number of Sections",
                             @"Flags", nil];
        
        // values
        self.values = [NSMutableArray arrayWithObjects:
                       [MPLoadComand getNameForCommand:cmd],
                       [NSString stringWithFormat:@"%d", _cmdsize],
                       [NSString stringWithFormat:@"%s", _segname],
                       [NSString stringWithFormat:@"%llu", _vmaddr],
                       [NSString stringWithFormat:@"%llu", _vmsize],
                       [NSString stringWithFormat:@"%llu", _fileoff],
                       [NSString stringWithFormat:@"%llu", _filesize],
//                       [NSString stringWithFormat:@"%d", _maxprot],
//                       [NSString stringWithFormat:@"%d", _initprot],
                       [NSString stringWithFormat:@"%@", @""],
                       [NSString stringWithFormat:@"%@", @""],
                       [NSString stringWithFormat:@"%d", _nsects],
                       [NSString stringWithFormat:@"%d", _flags], nil];
    }
    
    return self;
}

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
                           flags:(uint32_t)_flags {
    
    return [[self alloc] initWithDataCmd:cmd
                                 cmdsize:_cmdsize
                                 segname:_segname
                                  vmaddr:_vmaddr
                                  vmsize:_vmsize
                                 fileoff:_fileoff
                                filesize:_filesize
                                 maxprot:_maxprot
                                initprot:_initprot
                                  nsects:_nsects
                                   flags:_flags];
}

- (NSMutableArray *)getVMProtection:(vm_prot_t)vm_prot {
    
    NSMutableArray *VMProtectionDetails = [[NSMutableArray alloc] init];
    
    MPRow* row = [[MPRow alloc] init];
    
    uint32_t VMProtections[] = {
        VM_PROT_NONE,
        VM_PROT_READ,
        VM_PROT_WRITE,
        VM_PROT_EXECUTE,
        VM_PROT_NO_CHANGE,
        VM_PROT_NO_CHANGE_LEGACY,
        VM_PROT_COPY,
        VM_PROT_WANTS_COPY,
        VM_PROT_IS_MASK,
        VM_PROT_STRIP_READ
    };
    
    NSMutableArray *VMProtectionsStr = [NSMutableArray arrayWithObjects:
                                     @"VM_PROT_NONE",
                                     @"VM_PROT_READ",
                                     @"VM_PROT_WRITE",
                                     @"VM_PROT_EXECUTE",
                                     @"VM_PROT_NO_CHANGE",
                                     @"VM_PROT_NO_CHANGE_LEGACY",
                                     @"VM_PROT_COPY",
                                     @"VM_PROT_WANTS_COPY",
                                     @"VM_PROT_IS_MASK",
                                     @"VM_PROT_STRIP_READ", nil];
    
    if (vm_prot == VM_PROT_NONE) {
        row = [MPRow _initWithDataOffset:@"-"
                                    data:@"-"
                             description:[NSString stringWithFormat:@"%.8X", VMProtections[0]]
                                   value:VMProtectionsStr[0]];
        
        [VMProtectionDetails addObject:row];
    }
    
    //
    for (int i = 0; i < VMProtectionsStr.count; i++) {
        
        if (vm_prot & VMProtections[i]) {
            row = [MPRow _initWithDataOffset:@"-"
                                        data:@"-"
                                 description:[NSString stringWithFormat:@"%.8X", VMProtections[i]]
                                       value:VMProtectionsStr[i]];
            
            [VMProtectionDetails addObject:row];
        }
    }
    
    return VMProtectionDetails;
}

# pragma mark Details
- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor {
    
    NSMutableArray *details = [[NSMutableArray alloc] init];
    
    NSString *segment_name_data;
    
    for (int i = 0; i < self.descriptions.count; i++) {
        
        NSUInteger offset = cursor->_current_offset;
        NSUInteger data = 0;
        NSString *description = self.descriptions[i];
        NSString *value = self.values[i];
        
        BOOL flag = false;
        BOOL is64bit = false;
        
        if ( [self.descriptions[i] isEqualToString:@"Command"] ||
             [self.descriptions[i] isEqualToString:@"Command Size"] ||
             [self.descriptions[i] isEqualToString:@"Maximum VM Protection"] ||
             [self.descriptions[i] isEqualToString:@"Initial VM Protection"] ||
             [self.descriptions[i] isEqualToString:@"Number of Sections"] ||
             [self.descriptions[i] isEqualToString:@"Flags"] ) {
            
            data = [cursor readLittleInt32];
            
        } else if ( [self.descriptions[i] isEqualToString:@"Segment Name"] ) {
            
            segment_name_data = [cursor readBigInt128];
            flag = true;
            
        } else if ( [self.descriptions[i] isEqualToString:@"VM Address"] ||
                    [self.descriptions[i] isEqualToString:@"VM Size"] ||
                    [self.descriptions[i] isEqualToString:@"File Offset"] ||
                    [self.descriptions[i] isEqualToString:@"File Size"] ) {
           
            data = [cursor readLittleInt64];
            is64bit = true;
        }
        
        MPRow* row = [MPRow _initWithDataOffset:[NSString stringWithFormat:@"%.8lX", offset]
                                           data:flag ? segment_name_data : (is64bit ? [NSString stringWithFormat:@"%.16lX", data] : [NSString stringWithFormat:@"%.8lX", data])
                                    description:description
                                          value:value];
        
        [details addObject:row];
        
        // Flag bit
        if ( [self.descriptions[i] isEqualToString:@"Maximum VM Protection"] ) {
            
            [details addObjectsFromArray:[self getVMProtection:self.maxprot]];
            
        } else if ( [self.descriptions[i] isEqualToString:@"Initial VM Protection"] ) {
            
            [details addObjectsFromArray:[self getVMProtection:self.initprot]];
        }
    }
    
    // offset
//    cursor->_offset += self.cmdsize - sizeof(segment_command_t);
//    cursor->_current_offset += self.cmdsize - sizeof(segment_command_t);
    
    return details;
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> cmd: 0x%08x, cmdsize: %d, segname: %s, vmaddr: %llu, vmsize: %llu, fileoff: %llu, filesize: %llu, maxprot: %d, initprot: %d, nsects: %d, flags: %d",
            NSStringFromClass([self class]), self,
            self.cmd, self.cmdsize, self->_segname, self.vmaddr, self.vmsize, self.fileoff, self.filesize, self.maxprot, self.initprot, self.nsects, self.flags];
}

@end
