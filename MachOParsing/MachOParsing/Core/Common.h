//
//  Common.h
//  MachOParsing
//
//  Created by 小七 on 2023/12/1.
//

#ifndef Common_h
#define Common_h

#include <UIKit/UIKit.h>
#include <mach-o/dyld.h>
#include <mach-o/loader.h>
#include <mach-o/nlist.h>
#include <sys/utsname.h>

#ifndef SEG_DATA_CONST
#define SEG_DATA_CONST  "__DATA_CONST"
#endif

#ifndef SEG_SELF
#define SEG_SELF  @"__SELF"
#endif

#ifdef __LP64__
typedef struct mach_header_64               mach_header_t;
typedef struct segment_command_64           segment_command_t;
typedef struct section_64                   section_t;
typedef struct nlist_64                     nlist_t;
typedef struct routines_command_64          routines_command_t;
typedef struct encryption_info_command_64   encryption_info_command_t;
#define LC_SEGMENT_ARCH_DEPENDENT           LC_SEGMENT_64
#else
typedef struct mach_header                  mach_header_t;
typedef struct segment_command              segment_command_t;
typedef struct section                      section_t;
typedef struct nlist                        nlist_t;
typedef struct routines_command             routines_command_t;
typedef struct encryption_info_command      encryption_info_command_t;
#define LC_SEGMENT_ARCH_DEPENDENT           LC_SEGMENT
#endif

typedef struct fvmlib_command               fvmlib_command_t;
typedef struct dylib_command                dylib_command_t;
typedef struct sub_framework_command        sub_framework_command_t;
typedef struct sub_client_command           sub_client_command_t;
typedef struct sub_umbrella_command         sub_umbrella_command_t;
typedef struct sub_library_command          sub_library_command_t;
typedef struct prebound_dylib_command       prebound_dylib_command_t;
typedef struct dylinker_command             dylinker_command_t;
typedef struct thread_command               thread_command_t;
typedef struct symtab_command               symtab_command_t;
typedef struct dysymtab_command             dysymtab_command_t;
typedef struct twolevel_hints_command       twolevel_hints_command_t;
typedef struct prebind_cksum_command        prebind_cksum_command_t;
typedef struct uuid_command                 uuid_command_t;
typedef struct rpath_command                rpath_command_t;
typedef struct linkedit_data_command        linkedit_data_command_t;
typedef struct fileset_entry_command        fileset_entry_command_t;
typedef struct version_min_command          version_min_command_t;
typedef struct build_version_command        build_version_command_t;
typedef struct dyld_info_command            dyld_info_command_t;
typedef struct linker_option_command        linker_option_command_t;
typedef struct symseg_command               symseg_command_t;
typedef struct ident_command                ident_command_t;
typedef struct fvmfile_command              fvmfile_command_t;
typedef struct entry_point_command          entry_point_command_t;
typedef struct source_version_command       source_version_command_t;
typedef struct note_command                 note_command_t;

#endif /* Common_h */
