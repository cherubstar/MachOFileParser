//
//  MPLCBuildVersion.m
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import "MPLCBuildVersion.h"

@implementation MPLCBuildVersion

- (instancetype)initWithDataCmd:(uint32_t)cmd
                        cmdsize:(uint32_t)_cmdsize
                       platform:(uint32_t)_platform
                          minos:(uint32_t)_minos
                            sdk:(uint32_t)_sdk
                         ntools:(uint32_t)_ntools {
    
    if (self = [super init]) {
        self.cmd = cmd;
        self.cmdsize = _cmdsize;
        self.platform = _platform;
        self.minos = _minos;
        self.sdk = _sdk;
        self.ntools = _ntools;
        self.tool = 0;
        self.version = 0;
        
        // descriptions
        self.descriptions = [NSMutableArray arrayWithObjects:
                             @"Command",
                             @"Command Size",
                             @"Platform",
                             @"Minimum OS",
                             @"Sdk",
                             @"Number of Tool Entries",
                             @"Tool",
                             @"Version", nil];
        
        // values
        self.values = [NSMutableArray arrayWithObjects:
                       [MPLoadComand getNameForCommand:cmd],
                       [NSString stringWithFormat:@"%d", _cmdsize],
                       [self getPlatform:_platform],
                       [self getMinOS:_minos],
                       [self getSdk:_sdk],
                       [NSString stringWithFormat:@"%d", _ntools],
                       [NSString stringWithFormat:@"%d", self.tool],
                       [NSString stringWithFormat:@"%d", self.version], nil];
    }
    
    return self;
}

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                        platform:(uint32_t)_platform
                           minos:(uint32_t)_minos
                             sdk:(uint32_t)_sdk
                          ntools:(uint32_t)_ntools {
    
    return [[self alloc] initWithDataCmd:cmd
                                 cmdsize:_cmdsize
                                platform:_platform
                                   minos:_minos
                                     sdk:_sdk
                                  ntools:_ntools];
}

# pragma mark -
- (NSString *)getPlatform:(uint32_t)platform
{
    switch (platform)
    {
        default:                            return @"???";
        case PLATFORM_MACOS:                return @"macOS";
        case PLATFORM_IOS:                  return @"iOS";
        case PLATFORM_TVOS:                 return @"tvOS";
        case PLATFORM_WATCHOS:              return @"watchOS";
        case PLATFORM_BRIDGEOS:             return @"bridgeOS";
        case PLATFORM_MACCATALYST:          return @"iOS Mac";
        case PLATFORM_IOSSIMULATOR:         return @"iOS Simulator";
        case PLATFORM_TVOSSIMULATOR:        return @"tvOS Simulator";
        case PLATFORM_WATCHOSSIMULATOR:     return @"watchOS Simulator";
        case PLATFORM_DRIVERKIT:            return @"Driver Kit";
        case PLATFORM_FIRMWARE:             return @"Firmware";
        case PLATFORM_SEPOS:                return @"SepOS";
    }
}

int DectoHex(int dec, unsigned char *hex, int length)
{
    for(int i = length-1; i >= 0; i--)
    {
        hex[i] = (dec % 256) & 0xFF;
        dec /= 256;
    }
    
    return 0;
}

unsigned long HextoDec(const unsigned char *hex, int length)
{
    unsigned long rslt = 0;
    
    for(int i=0; i<length; i++)
    {
        rslt += (unsigned long)(hex[i])<<(8*(length-1-i));
    }
    
    return rslt;
}

- (NSString *)getMinOS:(uint32_t)minos
{
    char buffer[4];
    DectoHex(minos, &buffer, sizeof(buffer));
    
    return [NSString stringWithFormat:@"%d.%d.%d", buffer[1], buffer[2], buffer[3]];
}

- (NSString *)getSdk:(uint32_t)sdk
{
    char buffer[4];
    DectoHex(sdk, &buffer, sizeof(buffer));
    
    return [NSString stringWithFormat:@"%d.%d.%d", buffer[1], buffer[2], buffer[3]];
}

- (NSString *)getTool:(NSUInteger)tool
{
    switch (tool)
    {
        default:                return @"???";
        case TOOL_CLANG:        return @"clang";
        case TOOL_SWIFT:        return @"swift";
        case TOOL_LD:           return @"ld";
        case TOOL_LLD:          return @"lld";
    }
}

# pragma mark Details
- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor {
    
    NSMutableArray *details = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.descriptions.count; i++) {
        
        NSUInteger offset = cursor->_current_offset;
        NSUInteger data = [cursor readLittleInt32];
        NSString *description = self.descriptions[i];
        NSString *value = self.values[i];
        
        if ( [self.descriptions[i] isEqualToString:@"Tool"]) {
            value = [self getTool:data];
        } else if ( [self.descriptions[i] isEqualToString:@"Version"] ) {
            value = [NSString stringWithFormat:@"%.lX", data];
        }
        
        MPRow* row = [MPRow _initWithDataOffset:[NSString stringWithFormat:@"%.8lX", offset]
                                           data:[NSString stringWithFormat:@"%.8lX", data]
                                    description:description
                                          value:value];
        
        [details addObject:row];
    }
    
    // offset
//    cursor->_offset += self.cmdsize - sizeof(build_version_command_t);
//    cursor->_current_offset += self.cmdsize - sizeof(build_version_command_t);
    
    return details;
}

#pragma mark - Debugging
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@:%p> cmd: 0x%08x, cmdsize: %d, platform: %d, minos: %d, sdk: %d, ntools: %d",
            NSStringFromClass([self class]), self,
            self.cmd, self.cmdsize, self.platform, self.minos, self.sdk, self.ntools];
}

@end
