----------> uses
# use BesPolicy BesPolicy-01-* 
#   use BesCxxPolicy BesCxxPolicy-* 
#     use GaudiPolicy v*  (no_version_directory)
#       use LCG_Settings *  (no_version_directory)
#         use LCG_SettingsCompat *  (no_version_directory)
#       use Python * LCG_Interfaces (no_auto_imports) (no_version_directory) (native_version=2.5.4p2)
#         use LCG_Configuration v*  (no_version_directory)
#         use LCG_Settings v*  (no_version_directory)
#       use tcmalloc v* LCG_Interfaces (no_auto_imports) (no_version_directory) (native_version=1.4)
#         use LCG_Configuration v*  (no_version_directory)
#         use LCG_Settings v*  (no_version_directory)
#   use BesFortranPolicy BesFortranPolicy-* 
#     use LCG_Settings v*  (no_version_directory)
# use GaudiInterface GaudiInterface-01-* External
#   use GaudiKernel *  (no_version_directory)
#     use GaudiPolicy v*  (no_version_directory)
#     use ROOT v* LCG_Interfaces (no_version_directory) (native_version=5.24.00b)
#       use LCG_Configuration v*  (no_version_directory)
#       use LCG_Settings v*  (no_version_directory)
#       use GCCXML v* LCG_Interfaces (no_auto_imports) (no_version_directory) (native_version=0.9.0_20090601)
#         use LCG_Configuration v*  (no_version_directory)
#         use LCG_Settings v*  (no_version_directory)
#       use Python v* LCG_Interfaces (no_auto_imports) (no_version_directory)
#     use Reflex v* LCG_Interfaces (no_version_directory)
#       use LCG_Configuration v*  (no_version_directory)
#       use LCG_Settings v*  (no_version_directory)
#       use ROOT v* LCG_Interfaces (no_auto_imports) (no_version_directory) (native_version=5.24.00b)
#     use Boost v* LCG_Interfaces (no_version_directory) (native_version=1.39.0_python2.5)
#       use LCG_Configuration v*  (no_version_directory)
#       use LCG_Settings v*  (no_version_directory)
#       use Python v* LCG_Interfaces (no_auto_imports) (no_version_directory) (native_version=2.5.4p2)
#     use CppUnit v* LCG_Interfaces (private) (no_auto_imports) (no_version_directory) (native_version=1.12.1_p1)
#       use LCG_Configuration v*  (no_version_directory)
#       use LCG_Settings v*  (no_version_directory)
#   use GaudiSvc *  (no_version_directory)
#     use GaudiKernel v*  (no_version_directory)
#     use Reflex v* LCG_Interfaces (no_auto_imports) (no_version_directory)
#     use CLHEP v* LCG_Interfaces (no_auto_imports) (no_version_directory) (native_version=2.0.4.5)
#       use LCG_Configuration v*  (no_version_directory)
#       use LCG_Settings v*  (no_version_directory)
#     use AIDA v* LCG_Interfaces (no_auto_imports) (no_version_directory) (native_version=3.2.1)
#       use LCG_Configuration v*  (no_version_directory)
#       use LCG_Settings v*  (no_version_directory)
#     use Boost v* LCG_Interfaces (no_auto_imports) (no_version_directory) (native_version=1.39.0_python2.5)
#     use ROOT v* LCG_Interfaces (no_auto_imports) (no_version_directory) (native_version=5.24.00b)
#     use PCRE v* LCG_Interfaces (no_auto_imports) (no_version_directory) (native_version=4.4)
#       use LCG_Configuration v*  (no_version_directory)
#       use LCG_Settings v*  (no_version_directory)
# use BesCLHEP BesCLHEP-* External
#   use CLHEP v* LCG_Interfaces (no_version_directory) (native_version=2.0.4.5)
#   use HepMC * LCG_Interfaces (no_version_directory) (native_version=2.03.11)
#     use LCG_Configuration v*  (no_version_directory)
#     use LCG_Settings v*  (no_version_directory)
#   use HepPDT * LCG_Interfaces (no_version_directory) (native_version=2.05.04)
#     use LCG_Configuration v*  (no_version_directory)
#     use LCG_Settings v*  (no_version_directory)
#   use BesExternalArea BesExternalArea-* External
# use McTruth McTruth-* Event
#   use BesPolicy BesPolicy-01-* 
#   use EventModel EventModel-* Event
#     use BesPolicy BesPolicy-* 
#     use GaudiInterface GaudiInterface-* External
#   use GaudiInterface GaudiInterface-01-* External
#   use Identifier Identifier-* DetectorDescription
#     use BesPolicy BesPolicy-* 
#   use RelTable RelTable-* Event
#     use BesPolicy BesPolicy-01-* 
#     use GaudiInterface GaudiInterface-01-* External
#   use BesCLHEP BesCLHEP-* External (private)
#
# Selection :
use CMT v1r20p20090520 (/software/BES/bes6.6.4.p01)
use BesExternalArea BesExternalArea-00-00-21 External (/software/BES/bes6.6.4.p01/dist/6.6.4.p01/)
use LCG_Configuration v1  (/software/BES/bes6.6.4.p01/lcg/app/releases/LCGCMT/LCGCMT_57a_clhep2.0.4.5)
use LCG_SettingsCompat v1  (/software/BES/bes6.6.4.p01/lcg/app/releases/LCGCMT/LCGCMT_57a_clhep2.0.4.5)
use LCG_Settings v1  (/software/BES/bes6.6.4.p01/lcg/app/releases/LCGCMT/LCGCMT_57a_clhep2.0.4.5)
use HepPDT v1 LCG_Interfaces (/software/BES/bes6.6.4.p01/lcg/app/releases/LCGCMT/LCGCMT_57a_clhep2.0.4.5/)
use HepMC v1 LCG_Interfaces (/software/BES/bes6.6.4.p01/lcg/app/releases/LCGCMT/LCGCMT_57a_clhep2.0.4.5/)
use PCRE v1 LCG_Interfaces (/software/BES/bes6.6.4.p01/lcg/app/releases/LCGCMT/LCGCMT_57a_clhep2.0.4.5/) (no_auto_imports)
use AIDA v1 LCG_Interfaces (/software/BES/bes6.6.4.p01/lcg/app/releases/LCGCMT/LCGCMT_57a_clhep2.0.4.5/) (no_auto_imports)
use CLHEP v1 LCG_Interfaces (/software/BES/bes6.6.4.p01/lcg/app/releases/LCGCMT/LCGCMT_57a_clhep2.0.4.5/)
use BesCLHEP BesCLHEP-00-00-09 External (/software/BES/bes6.6.4.p01/dist/6.6.4.p01/)
use CppUnit v1 LCG_Interfaces (/software/BES/bes6.6.4.p01/lcg/app/releases/LCGCMT/LCGCMT_57a_clhep2.0.4.5/) (no_auto_imports)
use GCCXML v1 LCG_Interfaces (/software/BES/bes6.6.4.p01/lcg/app/releases/LCGCMT/LCGCMT_57a_clhep2.0.4.5/) (no_auto_imports)
use BesFortranPolicy BesFortranPolicy-00-01-03  (/software/BES/bes6.6.4.p01/dist/6.6.4.p01)
use tcmalloc v1 LCG_Interfaces (/software/BES/bes6.6.4.p01/lcg/app/releases/LCGCMT/LCGCMT_57a_clhep2.0.4.5/) (no_auto_imports)
use Python v1 LCG_Interfaces (/software/BES/bes6.6.4.p01/lcg/app/releases/LCGCMT/LCGCMT_57a_clhep2.0.4.5/) (no_auto_imports)
use Boost v1 LCG_Interfaces (/software/BES/bes6.6.4.p01/lcg/app/releases/LCGCMT/LCGCMT_57a_clhep2.0.4.5/)
use ROOT v1 LCG_Interfaces (/software/BES/bes6.6.4.p01/lcg/app/releases/LCGCMT/LCGCMT_57a_clhep2.0.4.5/)
use Reflex v1 LCG_Interfaces (/software/BES/bes6.6.4.p01/lcg/app/releases/LCGCMT/LCGCMT_57a_clhep2.0.4.5/)
use GaudiPolicy v10r4  (/software/BES/bes6.6.4.p01/Gaudi/GAUDI_v21r6/x86_64-slc5-gcc43-clhep2.0.4.5)
use GaudiKernel v27r6  (/software/BES/bes6.6.4.p01/Gaudi/GAUDI_v21r6/x86_64-slc5-gcc43-clhep2.0.4.5)
use GaudiSvc v18r6  (/software/BES/bes6.6.4.p01/Gaudi/GAUDI_v21r6/x86_64-slc5-gcc43-clhep2.0.4.5)
use GaudiInterface GaudiInterface-01-03-07 External (/software/BES/bes6.6.4.p01/dist/6.6.4.p01/)
use BesCxxPolicy BesCxxPolicy-00-01-01  (/software/BES/bes6.6.4.p01/dist/6.6.4.p01)
use BesPolicy BesPolicy-01-05-03  (/software/BES/bes6.6.4.p01/dist/6.6.4.p01)
use RelTable RelTable-00-00-02 Event (/software/BES/bes6.6.4.p01/dist/6.6.4.p01/)
use Identifier Identifier-00-02-13 DetectorDescription (/software/BES/bes6.6.4.p01/dist/6.6.4.p01/)
use EventModel EventModel-01-05-31 Event (/software/BES/bes6.6.4.p01/dist/6.6.4.p01/)
use McTruth McTruth-00-02-19 Event (/software/BES/bes6.6.4.p01/dist/6.6.4.p01/)
----------> tags
CMTv1 (from CMTVERSION)
CMTr20 (from CMTVERSION)
CMTp20090520 (from CMTVERSION)
Linux (from uname) package BesPolicy implies [Unix host-linux]
x86_64-linux (from HOSTTYPE)
x86_64-slc5-gcc43-opt (from CMTCONFIG) package LCG_Settings implies [Linux slc5-amd64 gcc43 optimized target-linux target-x86_64 target-slc5 target-gcc43 target-opt]
LOCAL (from CMTSITE)
boss_no_config (from PROJECT) excludes [boss_config]
boss_root (from PROJECT) excludes [boss_no_root]
boss_cleanup (from PROJECT) excludes [boss_no_cleanup]
boss_no_prototypes (from PROJECT) excludes [boss_prototypes]
boss_with_installarea (from PROJECT) excludes [boss_without_installarea]
boss_with_version_directory (from PROJECT) excludes [boss_without_version_directory]
boss (from PROJECT)
STCF_no_config (from PROJECT) excludes [STCF_config]
STCF_root (from PROJECT) excludes [STCF_no_root]
STCF_cleanup (from PROJECT) excludes [STCF_no_cleanup]
STCF_no_prototypes (from PROJECT) excludes [STCF_prototypes]
STCF_with_installarea (from PROJECT) excludes [STCF_without_installarea]
STCF_with_version_directory (from PROJECT) excludes [STCF_without_version_directory]
BOSS_no_config (from PROJECT) excludes [BOSS_config]
BOSS_root (from PROJECT) excludes [BOSS_no_root]
BOSS_cleanup (from PROJECT) excludes [BOSS_no_cleanup]
BOSS_no_prototypes (from PROJECT) excludes [BOSS_prototypes]
BOSS_with_installarea (from PROJECT) excludes [BOSS_without_installarea]
BOSS_with_version_directory (from PROJECT) excludes [BOSS_without_version_directory]
GAUDI_no_config (from PROJECT) excludes [GAUDI_config]
GAUDI_root (from PROJECT) excludes [GAUDI_no_root]
GAUDI_cleanup (from PROJECT) excludes [GAUDI_no_cleanup]
GAUDI_prototypes (from PROJECT) excludes [GAUDI_no_prototypes]
GAUDI_with_installarea (from PROJECT) excludes [GAUDI_without_installarea]
GAUDI_without_version_directory (from PROJECT) excludes [GAUDI_with_version_directory]
LCGCMT_no_config (from PROJECT) excludes [LCGCMT_config]
LCGCMT_no_root (from PROJECT) excludes [LCGCMT_root]
LCGCMT_cleanup (from PROJECT) excludes [LCGCMT_no_cleanup]
LCGCMT_prototypes (from PROJECT) excludes [LCGCMT_no_prototypes]
LCGCMT_without_installarea (from PROJECT) excludes [LCGCMT_with_installarea]
LCGCMT_with_version_directory (from PROJECT) excludes [LCGCMT_without_version_directory]
x86_64 (from package CMT) package LCG_Settings implies [host-x86_64]
sl57 (from package CMT) package GaudiPolicy implies [host-slc5]
gcc432 (from package CMT) package LCG_Settings implies [gcc43 host-gcc43]
Unix (from package CMT) package LCG_Settings implies [host-unix] package LCG_Settings excludes [WIN32 Win32]
gcc43 (from package LCG_SettingsCompat)
amd64 (from package LCG_SettingsCompat)
slc5 (from package LCG_SettingsCompat)
slc5-amd64 (from package LCG_SettingsCompat) package LCG_SettingsCompat implies [slc5 amd64]
optimized (from package LCG_SettingsCompat) package BesPolicy implies [opt]
target-unix (from package LCG_Settings)
host-x86_64 (from package LCG_Settings)
host-gcc4 (from package LCG_Settings) package LCG_Settings implies [host-gcc]
host-gcc43 (from package LCG_Settings) package LCG_Settings implies [host-gcc4]
host-gcc (from package LCG_Settings)
host-linux (from package LCG_Settings)
host-unix (from package LCG_Settings)
host-slc5 (from package LCG_Settings) package LCG_Settings implies [host-slc]
host-slc (from package LCG_Settings)
target-linux (from package LCG_Settings) package LCG_Settings implies [target-unix]
target-slc5 (from package LCG_Settings) package LCG_Settings implies [target-slc]
target-opt (from package LCG_Settings)
target-gcc43 (from package LCG_Settings) package LCG_Settings implies [target-gcc4]
target-x86_64 (from package LCG_Settings)
target-slc (from package LCG_Settings)
target-gcc4 (from package LCG_Settings) package LCG_Settings implies [target-gcc]
target-gcc (from package LCG_Settings)
ROOT_GE_5_15 (from package LCG_Configuration)
ROOT_GE_5_19 (from package LCG_Configuration)
opt (from package BesCxxPolicy) package BesPolicy implies [optimized]
HasAthenaRunTime (from package BesPolicy)
----------> CMTPATH
# Add path /home/lliu/boss/Workarea-6.6.4.p01 from initialization
# Add path /software/STCF/stcf1.0.0 from initialization
# Add path /software/BES/bes6.6.4.p01/dist/6.6.4.p01 from initialization
# Add path /software/BES/bes6.6.4.p01/Gaudi/GAUDI_v21r6/x86_64-slc5-gcc43-clhep2.0.4.5 from initialization
# Add path /software/BES/bes6.6.4.p01/lcg/app/releases/LCGCMT/LCGCMT_57a_clhep2.0.4.5 from initialization
