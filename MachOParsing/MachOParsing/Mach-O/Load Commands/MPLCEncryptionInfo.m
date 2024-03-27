//
//  MPLCEncryptionInfo.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import "MPLCEncryptionInfo.h"

@implementation MPLCEncryptionInfo

- (instancetype)initWithDataCmd:(uint32_t)cmd
                        cmdsize:(uint32_t)_cmdsize
                       cryptoff:(uint32_t)_cryptoff
                      cryptsize:(uint32_t)_cryptsize
                        cryptid:(uint32_t)_cryptid
                            pad:(uint32_t)_pad {
    
    if (self = [super init]) {
        self.cmd = cmd;
        self.cmdsize = _cmdsize;
        self.cryptoff = _cryptoff;
        self.cryptsize = _cryptsize;
        self.cryptid = _cryptid;
        self.pad = _pad;
        
        // descriptions
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"Command",
                             @"Command Size",
                             @"Crypto Offset",
                             @"Crypto Size",
                             @"Crypto ID",
                             @"Padding", nil];
        
        // values
        self.values = [NSMutableArray arrayWithObjects:
                       [MPLoadComand getNameForCommand:cmd],
                       [NSString stringWithFormat:@"%d", _cmdsize],
                       [NSString stringWithFormat:@"%d", _cryptoff],
                       [NSString stringWithFormat:@"%d", _cryptsize],
                       [NSString stringWithFormat:@"%d", _cryptid],
                       [NSString stringWithFormat:@"%d", _pad], nil];
    }
    
    return self;
}

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                        cryptoff:(uint32_t)_cryptoff
                       cryptsize:(uint32_t)_cryptsize
                         cryptid:(uint32_t)_cryptid
                             pad:(uint32_t)_pad {
    
    return [[self alloc] initWithDataCmd:cmd
                                 cmdsize:_cmdsize
                                cryptoff:_cryptoff
                               cryptsize:_cryptsize
                                 cryptid:_cryptid
                                     pad:_pad];
}

# pragma mark Details
- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor {
    
    NSMutableArray *details = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.descriptions.count; i++) {
        
        NSUInteger offset = cursor->_current_offset;
        NSUInteger data = [cursor readLittleInt32];;
        NSString *description = self.descriptions[i];
        NSString *value = self.values[i];
        
        MPRow* row = [MPRow _initWithDataOffset:[NSString stringWithFormat:@"%.8lX", offset]
                                           data:[NSString stringWithFormat:@"%.8lX", data]
                                    description:description
                                          value:value];
        
        [details addObject:row];
    }
    
    // offset
//    cursor->_offset += self.cmdsize - sizeof(encryption_info_command_t);
//    cursor->_current_offset += self.cmdsize - sizeof(encryption_info_command_t);
    
    return details;
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> cmd: 0x%08x, cmdsize: %d, cryptoff: %d, cryptsize: %d, cryptid: %d, pad: %d",
            NSStringFromClass([self class]), self,
            self.cmd, self.cmdsize, self.cryptoff, self.cryptsize, self.cryptid, self.pad];
}
@end
