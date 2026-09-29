import os
import sys

# Generate 24-character hexadecimal IDs like Xcode does
def make_id(val):
    import hashlib
    return hashlib.md5(val.encode('utf-8')).hexdigest()[:24].upper()

files = [
    "App/TrainSammlerApp.swift",
    "Models/Enums.swift",
    "Models/TrainModel.swift",
    "Models/SpottedTrain.swift",
    "Services/LocationManager.swift",
    "Services/DataSeeder.swift",
    "ViewModels/QuickSpotViewModel.swift",
    "ViewModels/StatsViewModel.swift",
    "Views/ContentView.swift",
    "Views/QuickSpotView.swift",
    "Views/TrainCatalogView.swift",
    "Views/TrainDetailView.swift",
    "Views/SpottedHistoryView.swift",
    "Views/StatsView.swift",
    "Views/SettingsView.swift",
    "Views/Components/RarityBadgeView.swift",
    "Views/Components/TrainImageView.swift",
    "Assets.xcassets",
    "Info.plist"
]

project_name = "trainSammler"
target_name = "trainSammler"

proj_id = make_id("PROJECT")
main_group_id = make_id("MAIN_GROUP")
products_group_id = make_id("PRODUCTS_GROUP")
target_id = make_id("TARGET")
product_file_id = make_id("PRODUCT_APP")
sources_build_phase_id = make_id("SOURCES_PHASE")
frameworks_build_phase_id = make_id("FRAMEWORKS_PHASE")
resources_build_phase_id = make_id("RESOURCES_PHASE")

proj_conf_list_id = make_id("PROJ_CONF_LIST")
proj_conf_debug_id = make_id("PROJ_CONF_DEBUG")
proj_conf_release_id = make_id("PROJ_CONF_RELEASE")

target_conf_list_id = make_id("TARGET_CONF_LIST")
target_conf_debug_id = make_id("TARGET_CONF_DEBUG")
target_conf_release_id = make_id("TARGET_CONF_RELEASE")

# File refs and build files
file_entries = []
for f in files:
    f_ref_id = make_id(f"REF_{f}")
    b_file_id = make_id(f"BUILD_{f}")
    filename = os.path.basename(f)
    is_resource = f.endswith(".xcassets")
    is_source = f.endswith(".swift")
    if is_resource:
        file_type = "folder.assetcatalog"
    elif is_source:
        file_type = "sourcecode.swift"
    elif f.endswith(".plist"):
        file_type = "text.plist.xml"
    else:
        file_type = "text"
        
    file_entries.append({
        "path": f,
        "filename": filename,
        "ref_id": f_ref_id,
        "build_id": b_file_id,
        "is_resource": is_resource,
        "is_source": is_source,
        "file_type": file_type
    })

pbx = []
pbx.append("// !$*UTF8*$!")
pbx.append("{")
pbx.append("\tarchiveVersion = 1;")
pbx.append("\tclasses = {")
pbx.append("\t};")
pbx.append("\tobjectVersion = 56;")
pbx.append("\tobjects = {")

# PBXBuildFile
pbx.append("\n/* Begin PBXBuildFile section */")
for item in file_entries:
    if item["is_resource"]:
        pbx.append(f"\t\t{item['build_id']} /* {item['filename']} in Resources */ = {{isa = PBXBuildFile; fileRef = {item['ref_id']} /* {item['filename']} */; }};")
    elif item["is_source"]:
        pbx.append(f"\t\t{item['build_id']} /* {item['filename']} in Sources */ = {{isa = PBXBuildFile; fileRef = {item['ref_id']} /* {item['filename']} */; }};")
pbx.append("/* End PBXBuildFile section */")

# PBXFileReference
pbx.append("\n/* Begin PBXFileReference section */")
pbx.append(f"\t\t{product_file_id} /* {target_name}.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = {target_name}.app; sourceTree = BUILT_PRODUCTS_DIR; }};")
for item in file_entries:
    pbx.append(f"\t\t{item['ref_id']} /* {item['filename']} */ = {{isa = PBXFileReference; lastKnownFileType = {item['file_type']}; path = \"{item['path']}\"; sourceTree = \"<group>\"; }};")
pbx.append("/* End PBXFileReference section */")

# PBXFrameworksBuildPhase
pbx.append("\n/* Begin PBXFrameworksBuildPhase section */")
pbx.append(f"\t\t{frameworks_build_phase_id} /* Frameworks */ = {{")
pbx.append("\t\t\tisa = PBXFrameworksBuildPhase;")
pbx.append("\t\t\tbuildActionMask = 2147483647;")
pbx.append("\t\t\tfiles = (")
pbx.append("\t\t\t);")
pbx.append("\t\t\trunOnlyForDeploymentPostprocessing = 0;")
pbx.append("\t\t};")
pbx.append("/* End PBXFrameworksBuildPhase section */")

# PBXGroup
pbx.append("\n/* Begin PBXGroup section */")
pbx.append(f"\t\t{main_group_id} = {{")
pbx.append("\t\t\tisa = PBXGroup;")
pbx.append("\t\t\tchildren = (")
for item in file_entries:
    pbx.append(f"\t\t\t\t{item['ref_id']} /* {item['filename']} */,")
pbx.append(f"\t\t\t\t{products_group_id} /* Products */,")
pbx.append("\t\t\t);")
pbx.append("\t\t\tsourceTree = \"<group>\";")
pbx.append("\t\t};")

pbx.append(f"\t\t{products_group_id} /* Products */ = {{")
pbx.append("\t\t\tisa = PBXGroup;")
pbx.append("\t\t\tchildren = (")
pbx.append(f"\t\t\t\t{product_file_id} /* {target_name}.app */,")
pbx.append("\t\t\t);")
pbx.append("\t\t\tname = Products;")
pbx.append("\t\t\tsourceTree = \"<group>\";")
pbx.append("\t\t};")
pbx.append("/* End PBXGroup section */")

# PBXNativeTarget
pbx.append("\n/* Begin PBXNativeTarget section */")
pbx.append(f"\t\t{target_id} /* {target_name} */ = {{")
pbx.append("\t\t\tisa = PBXNativeTarget;")
pbx.append(f"\t\t\tbuildConfigurationList = {target_conf_list_id} /* Build configuration list for PBXNativeTarget \"{target_name}\" */;")
pbx.append("\t\t\tbuildPhases = (")
pbx.append(f"\t\t\t\t{sources_build_phase_id} /* Sources */,")
pbx.append(f"\t\t\t\t{frameworks_build_phase_id} /* Frameworks */,")
pbx.append(f"\t\t\t\t{resources_build_phase_id} /* Resources */,")
pbx.append("\t\t\t);")
pbx.append("\t\t\tbuildRules = (")
pbx.append("\t\t\t);")
pbx.append("\t\t\tdependencies = (")
pbx.append("\t\t\t);")
pbx.append(f"\t\t\tname = {target_name};")
pbx.append(f"\t\t\tproductName = {target_name};")
pbx.append(f"\t\t\tproductReference = {product_file_id} /* {target_name}.app */;")
pbx.append("\t\t\tproductType = \"com.apple.product-type.application\";")
pbx.append("\t\t};")
pbx.append("/* End PBXNativeTarget section */")

# PBXProject
pbx.append("\n/* Begin PBXProject section */")
pbx.append(f"\t\t{proj_id} /* Project object */ = {{")
pbx.append("\t\t\tisa = PBXProject;")
pbx.append("\t\t\tattributes = {")
pbx.append("\t\t\t\tBuildIndependentTargetsInParallel = 1;")
pbx.append("\t\t\t\tLastUpgradeCheck = 1600;")
pbx.append("\t\t\t};")
pbx.append(f"\t\t\tbuildConfigurationList = {proj_conf_list_id} /* Build configuration list for PBXProject \"{project_name}\" */;")
pbx.append("\t\t\tcompatibilityVersion = \"Xcode 14.0\";")
pbx.append("\t\t\tdevelopmentRegion = de;")
pbx.append("\t\t\thasScannedForEncodings = 0;")
pbx.append("\t\t\tknownRegions = (")
pbx.append("\t\t\t\ten,")
pbx.append("\t\t\t\tBase,")
pbx.append("\t\t\t);")
pbx.append(f"\t\t\tmainGroup = {main_group_id};")
pbx.append(f"\t\t\tproductRefGroup = {products_group_id} /* Products */;")
pbx.append("\t\t\tprojectDirPath = \"\";")
pbx.append("\t\t\tprojectRoot = \"\";")
pbx.append("\t\t\ttargets = (")
pbx.append(f"\t\t\t\t{target_id} /* {target_name} */,")
pbx.append("\t\t\t);")
pbx.append("\t\t};")
pbx.append("/* End PBXProject section */")

# PBXResourcesBuildPhase
pbx.append("\n/* Begin PBXResourcesBuildPhase section */")
pbx.append(f"\t\t{resources_build_phase_id} /* Resources */ = {{")
pbx.append("\t\t\tisa = PBXResourcesBuildPhase;")
pbx.append("\t\t\tbuildActionMask = 2147483647;")
pbx.append("\t\t\tfiles = (")
for item in file_entries:
    if item["is_resource"]:
        pbx.append(f"\t\t\t\t{item['build_id']} /* {item['filename']} in Resources */,")
pbx.append("\t\t\t);")
pbx.append("\t\t\trunOnlyForDeploymentPostprocessing = 0;")
pbx.append("\t\t};")
pbx.append("/* End PBXResourcesBuildPhase section */")

# PBXSourcesBuildPhase
pbx.append("\n/* Begin PBXSourcesBuildPhase section */")
pbx.append(f"\t\t{sources_build_phase_id} /* Sources */ = {{")
pbx.append("\t\t\tisa = PBXSourcesBuildPhase;")
pbx.append("\t\t\tbuildActionMask = 2147483647;")
pbx.append("\t\t\tfiles = (")
for item in file_entries:
    if not item["is_resource"]:
        pbx.append(f"\t\t\t\t{item['build_id']} /* {item['filename']} in Sources */,")
pbx.append("\t\t\t);")
pbx.append("\t\t\trunOnlyForDeploymentPostprocessing = 0;")
pbx.append("\t\t};")
pbx.append("/* End PBXSourcesBuildPhase section */")

# XCBuildConfiguration
pbx.append("\n/* Begin XCBuildConfiguration section */")
# Project Debug
pbx.append(f"\t\t{proj_conf_debug_id} /* Debug */ = {{")
pbx.append("\t\t\tisa = XCBuildConfiguration;")
pbx.append("\t\t\tbuildSettings = {")
pbx.append("\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;")
pbx.append("\t\t\t\tCLANG_ANALYZER_NONNULL = YES;")
pbx.append("\t\t\t\tCLANG_ENABLE_MODULES = YES;")
pbx.append("\t\t\t\tDEBUG_INFORMATION_FORMAT = dwarf;")
pbx.append("\t\t\t\tENABLE_TESTABILITY = YES;")
pbx.append("\t\t\t\tGCC_DYNAMIC_NO_PIC = NO;")
pbx.append("\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;")
pbx.append("\t\t\t\tGCC_PREPROCESSOR_DEFINITIONS = (")
pbx.append("\t\t\t\t\t\"DEBUG=1\",")
pbx.append("\t\t\t\t\t\"$(inherited)\",")
pbx.append("\t\t\t\t);")
pbx.append("\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;")
pbx.append("\t\t\t\tMTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;")
pbx.append("\t\t\t\tONLY_ACTIVE_ARCH = YES;")
pbx.append("\t\t\t\tSDKROOT = iphoneos;")
pbx.append("\t\t\t\tSWIFT_ACTIVE_COMPILATION_CONDITIONS = \"DEBUG $(inherited)\";")
pbx.append("\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = \"-Onone\";")
pbx.append("\t\t\t};")
pbx.append("\t\t\tname = Debug;")
pbx.append("\t\t};")

# Project Release
pbx.append(f"\t\t{proj_conf_release_id} /* Release */ = {{")
pbx.append("\t\t\tisa = XCBuildConfiguration;")
pbx.append("\t\t\tbuildSettings = {")
pbx.append("\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;")
pbx.append("\t\t\t\tCLANG_ANALYZER_NONNULL = YES;")
pbx.append("\t\t\t\tCLANG_ENABLE_MODULES = YES;")
pbx.append("\t\t\t\tDEBUG_INFORMATION_FORMAT = \"dwarf-with-dsym\";")
pbx.append("\t\t\t\tENABLE_NS_ASSERTIONS = NO;")
pbx.append("\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;")
pbx.append("\t\t\t\tMTL_ENABLE_DEBUG_INFO = NO;")
pbx.append("\t\t\t\tSDKROOT = iphoneos;")
pbx.append("\t\t\t\tSWIFT_COMPILATION_MODE = wholemodule;")
pbx.append("\t\t\t\tVALIDATE_PRODUCT = YES;")
pbx.append("\t\t\t};")
pbx.append("\t\t\tname = Release;")
pbx.append("\t\t};")

# Target Debug
pbx.append(f"\t\t{target_conf_debug_id} /* Debug */ = {{")
pbx.append("\t\t\tisa = XCBuildConfiguration;")
pbx.append("\t\t\tbuildSettings = {")
pbx.append("\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;")
pbx.append("\t\t\t\tCLANG_ENABLE_MODULES = YES;")
pbx.append("\t\t\t\tCODE_SIGN_STYLE = Automatic;")
pbx.append("\t\t\t\tCURRENT_PROJECT_VERSION = 1;")
pbx.append("\t\t\t\tDEVELOPMENT_TEAM = \"79T386JC4J\";")
pbx.append("\t\t\t\tENABLE_PREVIEWS = YES;")
pbx.append("\t\t\t\tGENERATE_INFOPLIST_FILE = NO;")
pbx.append("\t\t\t\tINFOPLIST_FILE = Info.plist;")
pbx.append("\t\t\t\tINSTALL_PATH = \"/Applications\";")
pbx.append("\t\t\t\tSKIP_INSTALL = NO;")
pbx.append("\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;")
pbx.append("\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (")
pbx.append("\t\t\t\t\t\"$(inherited)\",")
pbx.append("\t\t\t\t\t\"@executable_path/Frameworks\",")
pbx.append("\t\t\t\t);")
pbx.append("\t\t\t\tMARKETING_VERSION = 1.0;")
pbx.append(f"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = de.amon.trainSammler;")
pbx.append(f"\t\t\t\tPRODUCT_NAME = \"$(TARGET_NAME)\";")
pbx.append("\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;")
pbx.append("\t\t\t\tSWIFT_VERSION = 5.0;")
pbx.append("\t\t\t\tTARGETED_DEVICE_FAMILY = \"1,2\";")
pbx.append("\t\t\t};")
pbx.append("\t\t\tname = Debug;")
pbx.append("\t\t};")

# Target Release
pbx.append(f"\t\t{target_conf_release_id} /* Release */ = {{")
pbx.append("\t\t\tisa = XCBuildConfiguration;")
pbx.append("\t\t\tbuildSettings = {")
pbx.append("\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;")
pbx.append("\t\t\t\tCLANG_ENABLE_MODULES = YES;")
pbx.append("\t\t\t\tCODE_SIGN_STYLE = Automatic;")
pbx.append("\t\t\t\tCURRENT_PROJECT_VERSION = 1;")
pbx.append("\t\t\t\tDEVELOPMENT_TEAM = \"79T386JC4J\";")
pbx.append("\t\t\t\tENABLE_PREVIEWS = YES;")
pbx.append("\t\t\t\tGENERATE_INFOPLIST_FILE = NO;")
pbx.append("\t\t\t\tINFOPLIST_FILE = Info.plist;")
pbx.append("\t\t\t\tINSTALL_PATH = \"/Applications\";")
pbx.append("\t\t\t\tSKIP_INSTALL = NO;")
pbx.append("\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;")
pbx.append("\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (")
pbx.append("\t\t\t\t\t\"$(inherited)\",")
pbx.append("\t\t\t\t\t\"@executable_path/Frameworks\",")
pbx.append("\t\t\t\t);")
pbx.append("\t\t\t\tMARKETING_VERSION = 1.0;")
pbx.append(f"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = de.amon.trainSammler;")
pbx.append(f"\t\t\t\tPRODUCT_NAME = \"$(TARGET_NAME)\";")
pbx.append("\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;")
pbx.append("\t\t\t\tSWIFT_VERSION = 5.0;")
pbx.append("\t\t\t\tTARGETED_DEVICE_FAMILY = \"1,2\";")
pbx.append("\t\t\t};")
pbx.append("\t\t\tname = Release;")
pbx.append("\t\t};")
pbx.append("/* End XCBuildConfiguration section */")

# XCConfigurationList
pbx.append("\n/* Begin XCConfigurationList section */")
pbx.append(f"\t\t{proj_conf_list_id} /* Build configuration list for PBXProject \"{project_name}\" */ = {{")
pbx.append("\t\t\tisa = XCConfigurationList;")
pbx.append("\t\t\tbuildConfigurations = (")
pbx.append(f"\t\t\t\t{proj_conf_debug_id} /* Debug */,")
pbx.append(f"\t\t\t\t{proj_conf_release_id} /* Release */,")
pbx.append("\t\t\t);")
pbx.append("\t\t\tdefaultConfigurationIsVisible = 0;")
pbx.append("\t\t\tdefaultConfigurationName = Release;")
pbx.append("\t\t};")

pbx.append(f"\t\t{target_conf_list_id} /* Build configuration list for PBXNativeTarget \"{target_name}\" */ = {{")
pbx.append("\t\t\tisa = XCConfigurationList;")
pbx.append("\t\t\tbuildConfigurations = (")
pbx.append(f"\t\t\t\t{target_conf_debug_id} /* Debug */,")
pbx.append(f"\t\t\t\t{target_conf_release_id} /* Release */,")
pbx.append("\t\t\t);")
pbx.append("\t\t\tdefaultConfigurationIsVisible = 0;")
pbx.append("\t\t\tdefaultConfigurationName = Release;")
pbx.append("\t\t};")
pbx.append("/* End XCConfigurationList section */")

pbx.append("\t};")
pbx.append(f"\trootObject = {proj_id} /* Project object */;")
pbx.append("}")

content = "\n".join(pbx) + "\n"

os.makedirs("trainSammler.xcodeproj", exist_ok=True)
with open("trainSammler.xcodeproj/project.pbxproj", "w") as f:
    f.write(content)

print("Generated trainSammler.xcodeproj successfully!")
