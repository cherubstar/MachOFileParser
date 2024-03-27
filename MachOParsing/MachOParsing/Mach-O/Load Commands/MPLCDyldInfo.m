//
//  MPLCDyldInfo.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import "MPLCDyldInfo.h"

@implementation MPLCDyldInfo

- (instancetype)initWithDataCmd:(uint32_t)cmd
                        cmdsize:(uint32_t)_cmdsize
                     rebase_off:(uint32_t)_rebase_off
                    rebase_size:(uint32_t)_rebase_size
                       bind_off:(uint32_t)_bind_off
                      bind_size:(uint32_t)_bind_size
                  weak_bind_off:(uint32_t)_weak_bind_off
                 weak_bind_size:(uint32_t)_weak_bind_size
                  lazy_bind_off:(uint32_t)_lazy_bind_off
                 lazy_bind_size:(uint32_t)_lazy_bind_size
                     export_off:(uint32_t)_export_off
                    export_size:(uint32_t)_export_size {
    
    if (self = [super init]) {
        self.cmd = cmd;
        self.cmdsize = _cmdsize;
        self.rebase_off = _rebase_off;
        self.rebase_size = _rebase_size;
        self.bind_off = _bind_off;
        self.bind_size = _bind_size;
        self.weak_bind_off = _weak_bind_off;
        self.weak_bind_size = _weak_bind_size;
        self.lazy_bind_off = _lazy_bind_off;
        self.lazy_bind_size = _lazy_bind_size;
        self.export_off = _export_off;
        self.export_size = _export_size;
        
        // descriptions
//        self.descriptions = [NSMutableArray arrayWithObjects:
//                             @"Command",
//                             @"Command Size",
//                             @"Crypto Offset",
//                             @"Crypto Size",
//                             @"Crypto ID",
//                             @"Padding", nil];
//
//        // values
//        self.values = [NSMutableArray arrayWithObjects:
//                       [MPLoadComand getNameForCommand:cmd],
//                       [NSString stringWithFormat:@"%d", _cmdsize],
//                       [NSString stringWithFormat:@"%d", _cryptoff],
//                       [NSString stringWithFormat:@"%d", _cryptsize],
//                       [NSString stringWithFormat:@"%d", _cryptid],
//                       [NSString stringWithFormat:@"%d", _pad], nil];
    }
    
    return self;
}

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                      rebase_off:(uint32_t)_rebase_off
                     rebase_size:(uint32_t)_rebase_size
                        bind_off:(uint32_t)_bind_off
                       bind_size:(uint32_t)_bind_size
                   weak_bind_off:(uint32_t)_weak_bind_off
                  weak_bind_size:(uint32_t)_weak_bind_size
                   lazy_bind_off:(uint32_t)_lazy_bind_off
                  lazy_bind_size:(uint32_t)_lazy_bind_size
                      export_off:(uint32_t)_export_off
                     export_size:(uint32_t)_export_size {
    
    return [[self alloc] initWithDataCmd:cmd
                                 cmdsize:_cmdsize
                              rebase_off:_rebase_off
                             rebase_size:_rebase_size
                                bind_off:_bind_off
                               bind_size:_bind_size
                           weak_bind_off:_weak_bind_off
                          weak_bind_size:_weak_bind_size
                           lazy_bind_off:_lazy_bind_off
                          lazy_bind_size:_lazy_bind_size
                              export_off:_export_off
                             export_size:_export_size];
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> cmd: 0x%08x, cmdsize: %d, rebase_off: %d, rebase_size: %d, bind_off: %d, bind_size: %d, weak_bind_off: %d, weak_bind_size: %d, lazy_bind_off: %d, lazy_bind_size: %d, export_off: %d, export_size: %d",
            NSStringFromClass([self class]), self, self.cmd, self.cmdsize, self.rebase_off, self.rebase_size, self.bind_off, self.bind_size, self.weak_bind_off, self.weak_bind_size, self.lazy_bind_off, self.lazy_bind_size, self.export_off, self.export_size];
}

@end
