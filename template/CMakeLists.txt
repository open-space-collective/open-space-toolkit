################################################################################################################################################################

# @project        Open Space Toolkit
# @file           CMakeLists.txt
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

## Project Properties

SET (PROJECT_NAME "Library")
SET (PROJECT_DESCRIPTION "Test library.")
SET (PROJECT_PATH "Library")
SET (PROJECT_PACKAGE_NAME "library")
SET (PROJECT_LICENSE "Apache License 2.0")
SET (PROJECT_VENDOR_ID "org.open-space-collective")
SET (PROJECT_VENDOR_NAME "Open Space Collective")
SET (PROJECT_VENDOR_CONTACT "contact@open-space-collective.org")
SET (PROJECT_VENDOR_URL "open-space-collective.org")

################################################################################################################################################################

## Project Options

OPTION (BUILD_SHARED_LIBRARY "Build shared library." ON)
OPTION (BUILD_STATIC_LIBRARY "Build static library." OFF)
OPTION (BUILD_UTILITY "Build utility." OFF)
OPTION (BUILD_UNIT_TESTS "Build tests" ON)
OPTION (BUILD_PYTHON_BINDINGS "Build Python bindings." ON)
OPTION (BUILD_CODE_COVERAGE "Build code coverage" OFF)
OPTION (BUILD_DOCUMENTATION "Build documentation" OFF)

################################################################################################################################################################

## Setup

### Compatibility Check

CMAKE_MINIMUM_REQUIRED (VERSION "2.8.12" FATAL_ERROR)

### Paths

SET (CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/tools/cmake")

### Policies

CMAKE_POLICY (SET "CMP0048" NEW)

################################################################################################################################################################

## Version

INCLUDE ("GetGitRevisionDescription" OPTIONAL)

IF (COMMAND "GET_GIT_HEAD_REVISION" AND COMMAND "GIT_DESCRIBE")

    # Versioning using current git branch tag

    GET_GIT_HEAD_REVISION (GIT_REFSPEC GIT_HASH)
    GIT_DESCRIBE (GIT_TAGS "--tags")

    STRING (REPLACE "." ";" VERSION_LIST ${GIT_TAGS})

    IF (VERSION_LIST)

        LIST (GET VERSION_LIST 0 PROJECT_VERSION_MAJOR)
        LIST (GET VERSION_LIST 1 PROJECT_VERSION_MINOR)
        LIST (GET VERSION_LIST 2 PROJECT_VERSION_PATCH_TWEAK)

        STRING (REPLACE "-" ";" PROJECT_VERSION_PATCH_TWEAKS ${PROJECT_VERSION_PATCH_TWEAK})

        LIST (GET PROJECT_VERSION_PATCH_TWEAKS 0 PROJECT_VERSION_PATCH)

        LIST (LENGTH PROJECT_VERSION_PATCH_TWEAKS PROJECT_VERSION_PATCH_TWEAKS_LENGTH)

        IF (PROJECT_VERSION_PATCH_TWEAKS_LENGTH GREATER 1)

            LIST (GET PROJECT_VERSION_PATCH_TWEAKS 1 PROJECT_VERSION_TWEAK)

        ENDIF ()

        SET (PROJECT_VERSION_STRING "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")

        IF (DEFINED "PROJECT_VERSION_TWEAK")

            SET (PROJECT_VERSION_STRING "${PROJECT_VERSION_STRING}.${PROJECT_VERSION_TWEAK}")

        ENDIF ()

    ENDIF ()

ENDIF ()

IF (NOT DEFINED PROJECT_VERSION_STRING)

    # Versioning using current date / time

    STRING (TIMESTAMP CURRENT_YEAR %Y UTC)
    STRING (TIMESTAMP CURRENT_MONTH %m UTC)
    STRING (TIMESTAMP CURRENT_DAY %d UTC)
    STRING (TIMESTAMP CURRENT_DAY_OF_YEAR %j UTC)

    SET (PROJECT_VERSION_MAJOR ${CURRENT_YEAR})
    SET (PROJECT_VERSION_MINOR ${CURRENT_MONTH})
    SET (PROJECT_VERSION_PATCH ${CURRENT_DAY})

    SET (PROJECT_VERSION_STRING "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")

ENDIF ()

MESSAGE (STATUS "Version: ${PROJECT_VERSION_STRING}")

################################################################################################################################################################

## Project Configuration

PROJECT (${PROJECT_NAME} VERSION ${PROJECT_VERSION_STRING} LANGUAGES "C" "CXX")

SET (CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Limited Configs" FORCE)

IF (BUILD_CODE_COVERAGE)
    SET (CMAKE_BUILD_TYPE "Debug")
ELSEIF (NOT CMAKE_BUILD_TYPE)
    SET (CMAKE_BUILD_TYPE "Release" CACHE STRING "Build type [None|Debug|Release|RelWithDebInfo|MinSizeRel]." FORCE)
ENDIF ()

################################################################################################################################################################

## Flags

### Warnings

IF (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

    IF (CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.8)

        MESSAGE (FATAL_ERROR "GCC version must be at least 4.8")

    ENDIF ()

    SET (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wpedantic -Wshadow -Wno-deprecated -Wl,--no-undefined")

ENDIF ()

### C++ 17 support

SET (CMAKE_CXX_STANDARD 17)
SET (CMAKE_CXX_STANDARD_REQUIRED ON)
SET (CMAKE_CXX_EXTENSIONS OFF)

################################################################################################################################################################

## Debugging Options

SET (CMAKE_VERBOSE_MAKEFILE 0) # Use 1 for debugging, 0 for release

################################################################################################################################################################

## Paths

### Search Paths

LIST (APPEND CMAKE_PREFIX_PATH "${PROJECT_SOURCE_DIR}")
LIST (APPEND CMAKE_PREFIX_PATH "${PROJECT_SOURCE_DIR}/tools")
LIST (APPEND CMAKE_PREFIX_PATH "${PROJECT_SOURCE_DIR}/thirdparty")

### Output Paths

SET (EXECUTABLE_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/bin")
SET (LIBRARY_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/lib")
SET (DOCS_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/docs")

IF (WIN32)

    SET (INSTALL_ROOT ".")                              # C:\Programme\<project>
    SET (INSTALL_DATA "bin")                            # C:\Programme\<project>
    SET (INSTALL_BIN "bin")                             # C:\Programme\<project>
    SET (INSTALL_LIB "lib")                             # C:\Programme\<project>\lib
    SET (INSTALL_INCLUDE "include")                     # C:\Programme\<project>\include
    SET (INSTALL_DOC "doc")                             # C:\Programme\<project>\doc
    SET (INSTALL_SHORTCUTS ".")                         # Not available under Windows
    SET (INSTALL_ICONS ".")                             # Not available under Windows
    SET (INSTALL_INIT ".")                              # Not available under Windows

ELSE ()

    SET (INSTALL_ROOT "share/${PROJECT_PATH}")          # /usr/[local]/share/<project>
    SET (INSTALL_DATA "share/${PROJECT_PATH}")          # /usr/[local]/share/<project>
    SET (INSTALL_BIN "bin")                             # /usr/[local]/bin
    SET (INSTALL_LIB "lib")                             # /usr/[local]/lib
    SET (INSTALL_TEST "test/${PROJECT_PATH}")           # /usr/[local]/test/<project>
    SET (INSTALL_INCLUDE "include/${PROJECT_PATH}")     # /usr/[local]/include/<project>
    SET (INSTALL_DOC "share/doc/${PROJECT_PATH}")       # /usr/[local]/share/doc/<project>
    SET (INSTALL_SHORTCUTS "share/applications")        # /usr/[local]/share/applications
    SET (INSTALL_INIT "/etc/init")                      # /etc/init (upstart init scripts)

ENDIF ()

################################################################################################################################################################

## Configure Files

FILE (GLOB_RECURSE CONFIGINPUTS1 "include/*.in.hpp.cmake")
FILE (GLOB_RECURSE CONFIGINPUTS2 "include/*.hpp.in.cmake")
FILE (GLOB_RECURSE CONFIGINPUTS3 "src/*.in.hpp.cmake")
FILE (GLOB_RECURSE CONFIGINPUTS4 "src/*.hpp.in.cmake")
FILE (GLOB_RECURSE CONFIGINPUTS5 "test/*.in.hpp.cmake")
FILE (GLOB_RECURSE CONFIGINPUTS6 "test/*.hpp.in.cmake")

LIST (APPEND CONFIGINPUTS "${CONFIGINPUTS1}")
LIST (APPEND CONFIGINPUTS "${CONFIGINPUTS2}")
LIST (APPEND CONFIGINPUTS "${CONFIGINPUTS3}")
LIST (APPEND CONFIGINPUTS "${CONFIGINPUTS4}")
LIST (APPEND CONFIGINPUTS "${CONFIGINPUTS5}")
LIST (APPEND CONFIGINPUTS "${CONFIGINPUTS6}")

FOREACH (CONFIGINPUT ${CONFIGINPUTS})

    STRING (REPLACE ".in.hpp.cmake" ".h" CONFIGOUTPUT1 "${CONFIGINPUT}")
    STRING (REPLACE ".hpp.in.cmake" ".h" CONFIGOUTPUT2 "${CONFIGOUTPUT1}")

    CONFIGURE_FILE ("${CONFIGINPUT}" "${CONFIGOUTPUT2}")

ENDFOREACH ()

################################################################################################################################################################

## Dependencies

### Boost [1.69.0]

SET (Boost_USE_STATIC_LIBS ON)
SET (Boost_USE_MULTITHREADED ON)

FIND_PACKAGE ("Boost" "1.69" REQUIRED COMPONENTS "filesystem")

IF (NOT Boost_FOUND)
    MESSAGE (SEND_ERROR "[Boost] not found.")
ENDIF ()

################################################################################################################################################################

## Versioning

IF (DEFINED PROJECT_VERSION_STRING AND EXISTS "${PROJECT_SOURCE_DIR}/src/${PROJECT_PATH}/Utilities/Version.cpp.in")

    CONFIGURE_FILE ("${PROJECT_SOURCE_DIR}/src/${PROJECT_PATH}/Utilities/Version.cpp.in" "${CMAKE_CURRENT_BINARY_DIR}/src/${PROJECT_PATH}/Utilities/Version.cpp" @ONLY)

ENDIF ()

################################################################################################################################################################

## Targets

### Shared Library

IF (BUILD_SHARED_LIBRARY)

    SET (SHARED_LIBRARY_NAME "${PROJECT_PACKAGE_NAME}")
    SET (SHARED_LIBRARY_TARGET "lib${SHARED_LIBRARY_NAME}.so")

    FILE (GLOB_RECURSE SHARED_LIBRARY_HEADERS "${PROJECT_SOURCE_DIR}/include/${PROJECT_PATH}/*.hpp")
    FILE (GLOB_RECURSE SHARED_LIBRARY_SRCS "${PROJECT_SOURCE_DIR}/src/${PROJECT_PATH}/*.cpp")

    IF (APPLE)
        SET (CMAKE_MACOSX_RPATH ON)
    ENDIF (APPLE)

    ADD_LIBRARY (${SHARED_LIBRARY_TARGET} SHARED ${SHARED_LIBRARY_SRCS})

    TARGET_INCLUDE_DIRECTORIES (${SHARED_LIBRARY_TARGET} PUBLIC "${PROJECT_SOURCE_DIR}/include/")
    TARGET_INCLUDE_DIRECTORIES (${SHARED_LIBRARY_TARGET} PUBLIC "${PROJECT_SOURCE_DIR}/src/")

    TARGET_LINK_LIBRARIES (${SHARED_LIBRARY_TARGET} "stdc++")
    TARGET_LINK_LIBRARIES (${SHARED_LIBRARY_TARGET} "pthread")
    TARGET_LINK_LIBRARIES (${SHARED_LIBRARY_TARGET} "Boost::filesystem")

    SET_TARGET_PROPERTIES ( ${SHARED_LIBRARY_TARGET} PROPERTIES
                            VERSION ${PROJECT_VERSION_STRING}
                            SOVERSION ${PROJECT_VERSION_MAJOR}
                            OUTPUT_NAME ${SHARED_LIBRARY_NAME}
                            CLEAN_DIRECT_OUTPUT 1
                            INSTALL_RPATH "$ORIGIN/../lib:$ORIGIN/")

    INSTALL (DIRECTORY "${PROJECT_SOURCE_DIR}/include/${PROJECT_PATH}/" DESTINATION ${INSTALL_INCLUDE} COMPONENT "headers" FILES_MATCHING PATTERN "*.hpp")
    INSTALL (DIRECTORY "${PROJECT_SOURCE_DIR}/src/${PROJECT_PATH}/" DESTINATION ${INSTALL_INCLUDE} COMPONENT "headers" FILES_MATCHING PATTERN "*.tpp")
    INSTALL (TARGETS ${SHARED_LIBRARY_TARGET} DESTINATION ${INSTALL_LIB} COMPONENT "libraries")

ENDIF ()

### Static Library

IF (BUILD_STATIC_LIBRARY)

    SET (STATIC_LIBRARY_NAME "${PROJECT_PACKAGE_NAME}")
    SET (STATIC_LIBRARY_TARGET "lib${STATIC_LIBRARY_NAME}.a")

    FILE (GLOB_RECURSE STATIC_LIBRARY_HEADERS "${PROJECT_SOURCE_DIR}/include/${PROJECT_PATH}/*.hpp")
    FILE (GLOB_RECURSE STATIC_LIBRARY_SRCS "${PROJECT_SOURCE_DIR}/src/${PROJECT_PATH}/*.cpp")

    ADD_LIBRARY (${STATIC_LIBRARY_TARGET} STATIC ${STATIC_LIBRARY_SRCS})

    TARGET_INCLUDE_DIRECTORIES (${STATIC_LIBRARY_TARGET} PUBLIC "${PROJECT_SOURCE_DIR}/include/")

    TARGET_LINK_LIBRARIES (${STATIC_LIBRARY_TARGET} "pthread")
    TARGET_LINK_LIBRARIES (${STATIC_LIBRARY_TARGET} "Boost::date_time" "Boost::filesystem" "Boost::log")

    SET_TARGET_PROPERTIES (${STATIC_LIBRARY_TARGET} PROPERTIES VERSION ${PROJECT_VERSION_STRING} OUTPUT_NAME ${SHARED_LIBRARY_NAME} CLEAN_DIRECT_OUTPUT 1 INSTALL_RPATH "$ORIGIN/../lib:$ORIGIN/")

    INSTALL (DIRECTORY "${PROJECT_SOURCE_DIR}/include/${PROJECT_PATH}/" DESTINATION ${INSTALL_INCLUDE} COMPONENT "headers" FILES_MATCHING PATTERN "*.hpp")
    INSTALL (DIRECTORY "${PROJECT_SOURCE_DIR}/src/${PROJECT_PATH}/" DESTINATION ${INSTALL_INCLUDE} COMPONENT "headers" FILES_MATCHING PATTERN "*.tpp")
    INSTALL (TARGETS ${SHARED_LIBRARY_TARGET} DESTINATION ${INSTALL_LIB} COMPONENT "libraries")

ENDIF ()

### Utility

IF (BUILD_UTILITY)

    # ADD_SUBDIRECTORY ("${PROJECT_SOURCE_DIR}/share/CppUtility")

    SET (UTILITY_NAME "${PROJECT_PACKAGE_NAME}")
    SET (UTILITY_TARGET "${UTILITY_NAME}.exe")

    FILE (GLOB_RECURSE UTILITY_HEADERS "${PROJECT_SOURCE_DIR}/include/${PROJECT_PATH}/*.hpp")
    FILE (GLOB_RECURSE UTILITY_SRCS "${PROJECT_SOURCE_DIR}/share/util/*.cxx")

    ADD_EXECUTABLE (${UTILITY_TARGET} ${UTILITY_SRCS})

    TARGET_INCLUDE_DIRECTORIES (${UTILITY_TARGET} PUBLIC "${PROJECT_SOURCE_DIR}/include/")

    TARGET_LINK_LIBRARIES (${UTILITY_TARGET} "pthread")
    TARGET_LINK_LIBRARIES (${UTILITY_TARGET} "Boost::date_time" "Boost::filesystem" "Boost::log")
    TARGET_LINK_LIBRARIES (${UTILITY_TARGET} ${SHARED_LIBRARY_TARGET})

    SET_TARGET_PROPERTIES (${UTILITY_TARGET} PROPERTIES VERSION ${PROJECT_VERSION_STRING} OUTPUT_NAME ${SHARED_LIBRARY_NAME} CLEAN_DIRECT_OUTPUT 1 INSTALL_RPATH "$ORIGIN/../lib:$ORIGIN/")

    INSTALL (DIRECTORY "${PROJECT_SOURCE_DIR}/include/${PROJECT_PATH}/" DESTINATION ${INSTALL_INCLUDE} COMPONENT "headers" FILES_MATCHING PATTERN "*.hpp")
    INSTALL (DIRECTORY "${PROJECT_SOURCE_DIR}/src/${PROJECT_PATH}/" DESTINATION ${INSTALL_INCLUDE} COMPONENT "headers" FILES_MATCHING PATTERN "*.tpp")
    INSTALL (TARGETS ${SHARED_LIBRARY_TARGET} DESTINATION ${INSTALL_LIB} COMPONENT "libraries")

ENDIF ()

### Unit Tests

IF (BUILD_UNIT_TESTS)

    SET (UNIT_TESTS_TARGET "${PROJECT_PACKAGE_NAME}.test")

    ENABLE_TESTING ()

    FILE (GLOB_RECURSE TEST_SRCS "${PROJECT_SOURCE_DIR}/test/${PROJECT_PATH}/*.test.cpp")

    ADD_EXECUTABLE (${UNIT_TESTS_TARGET} ${TEST_SRCS})

    ADD_DEPENDENCIES (${UNIT_TESTS_TARGET} ${SHARED_LIBRARY_TARGET})

    FIND_PACKAGE ("GTest" QUIET)

    IF (NOT GTEST_FOUND)

        ADD_SUBDIRECTORY ("${PROJECT_SOURCE_DIR}/thirdparty/gtest")

        ADD_DEPENDENCIES (${UNIT_TESTS_TARGET} "googletest")

        LIST (APPEND GTEST_BOTH_LIBRARIES "${GTEST_LIBS_DIR}/libgtest.a")
        LIST (APPEND GTEST_BOTH_LIBRARIES "${GTEST_LIBS_DIR}/libgtest_main.a")

    ENDIF ()

    TARGET_INCLUDE_DIRECTORIES (${UNIT_TESTS_TARGET} PUBLIC ${GTEST_INCLUDE_DIRS})
    TARGET_INCLUDE_DIRECTORIES (${UNIT_TESTS_TARGET} PUBLIC "${PROJECT_SOURCE_DIR}/include")
    TARGET_INCLUDE_DIRECTORIES (${UNIT_TESTS_TARGET} PUBLIC "${PROJECT_SOURCE_DIR}/test")

    # TARGET_LINK_LIBRARIES (${UNIT_TESTS_TARGET} "GTest::GTest" "GTest::Main")
    TARGET_LINK_LIBRARIES (${UNIT_TESTS_TARGET} "${GTEST_BOTH_LIBRARIES}")
    TARGET_LINK_LIBRARIES (${UNIT_TESTS_TARGET} "${SHARED_LIBRARY_TARGET}")

    GTEST_DISCOVER_TESTS (${UNIT_TESTS_TARGET})

    ADD_TEST (NAME "all" COMMAND ${UNIT_TESTS_TARGET})

    SET_TARGET_PROPERTIES (${UNIT_TESTS_TARGET} PROPERTIES VERSION ${PROJECT_VERSION_STRING} OUTPUT_NAME ${UNIT_TESTS_TARGET} CLEAN_DIRECT_OUTPUT 1 INSTALL_RPATH "$ORIGIN/../lib:$ORIGIN/")

    INSTALL (TARGETS ${UNIT_TESTS_TARGET} DESTINATION ${INSTALL_TEST} COMPONENT "tests")

    #### Code Coverage

    IF (BUILD_CODE_COVERAGE)

        SET (COVERAGE_TARGET "coverage")

        INCLUDE (CodeCoverage)

        APPEND_COVERAGE_COMPILER_FLAGS ()

        SET (COVERAGE_EXCLUDES "*.test.cpp" "*/include/gtest/*" "*/c++/v1/*" "/usr/include/*" "/usr/local/*" "*/include/boost/*" "*/c++/7/*")

        SETUP_TARGET_FOR_COVERAGE (
            NAME ${COVERAGE_TARGET}
            EXECUTABLE ${UNIT_TESTS_TARGET}
            DEPENDENCIES "coverage"
        )

    ENDIF ()

ENDIF ()

### Python Bindings

IF (BUILD_PYTHON_BINDINGS)

    ADD_SUBDIRECTORY ("${PROJECT_SOURCE_DIR}/bindings/python")

ENDIF ()

### Documentation

IF (BUILD_DOCUMENTATION)

    ADD_SUBDIRECTORY ("${PROJECT_SOURCE_DIR}/docs")

ENDIF ()

### Configuration

CONFIGURE_FILE (
    "${CMAKE_MODULE_PATH}/${PROJECT_NAME}Config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    @ONLY)

CONFIGURE_FILE (
    "${CMAKE_MODULE_PATH}/${PROJECT_NAME}ConfigVersion.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    @ONLY)

INSTALL (FILES "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake" DESTINATION "${INSTALL_LIB}/${PROJECT_NAME}" COMPONENT "libraries")
INSTALL (FILES "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake" DESTINATION "${INSTALL_LIB}/${PROJECT_NAME}" COMPONENT "libraries")

### Uninstall

CONFIGURE_FILE (
    "${CMAKE_MODULE_PATH}/UninstallTarget.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/UninstallTarget.cmake"
    IMMEDIATE @ONLY)

ADD_CUSTOM_TARGET ("uninstall" COMMAND ${CMAKE_COMMAND} -P "${CMAKE_CURRENT_BINARY_DIR}/UninstallTarget.cmake")

### Misc

INSTALL (FILES "LICENSE" DESTINATION ${INSTALL_ROOT} COMPONENT "documentation")

IF (EXISTS "${PROJECT_SOURCE_DIR}/share")

    INSTALL (DIRECTORY "${PROJECT_SOURCE_DIR}/share/" DESTINATION ${INSTALL_DATA} COMPONENT "data")

ENDIF ()

################################################################################################################################################################

## Packaging

SET (CPACK_PACKAGE_NAME ${PROJECT_PACKAGE_NAME})
SET (CPACK_PACKAGE_DESCRIPTION_SUMMARY ${PROJECT_DESCRIPTION})
SET (CPACK_PACKAGE_DESCRIPTION_FILE "${PROJECT_SOURCE_DIR}/LICENSE")
SET (CPACK_PACKAGE_SUMMARY ${PROJECT_NAME})
SET (CPACK_PACKAGE_VENDOR ${PROJECT_VENDOR_NAME})
SET (CPACK_PACKAGE_CONTACT ${PROJECT_VENDOR_CONTACT})
SET (CPACK_PACKAGE_LICENSE ${PROJECT_LICENSE})
SET (CPACK_PACKAGE_VERSION ${PROJECT_VERSION_STRING})
SET (CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
SET (CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
SET (CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
SET (CPACK_PACKAGE_RELEASE 1)
SET (CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CPACK_PACKAGE_RELEASE}.${CMAKE_SYSTEM_PROCESSOR}")

SET (CPACK_RESOURCE_FILE_LICENSE "${PROJECT_SOURCE_DIR}/LICENSE")
SET (CPACK_RESOURCE_FILE_README "${PROJECT_SOURCE_DIR}/README.md")

SET (CPACK_COMPONENTS_ALL "applications" "headers" "libraries" "documentation" "tests" "data" "python")

SET (CPACK_COMPONENT_APPLICATIONS_DISPLAY_NAME "Applications")
SET (CPACK_COMPONENT_HEADERS_DISPLAY_NAME "Headers")
SET (CPACK_COMPONENT_LIBRARIES_DISPLAY_NAME "Libraries")
SET (CPACK_COMPONENT_DOCUMENTATION_DISPLAY_NAME "Documentation")
SET (CPACK_COMPONENT_TESTS_DISPLAY_NAME "Unit Tests")
SET (CPACK_COMPONENT_DATA_DISPLAY_NAME "Shared Data")
SET (CPACK_COMPONENT_PYTHON_DISPLAY_NAME "Python Bindings")

SET (CPACK_COMPONENT_APPLICATIONS_DESCRIPTION "Applications")
SET (CPACK_COMPONENT_HEADERS_DESCRIPTION "Headers")
SET (CPACK_COMPONENT_LIBRARIES_DESCRIPTION "Libraries")
SET (CPACK_COMPONENT_DOCUMENTATION_DESCRIPTION "Documentation")
SET (CPACK_COMPONENT_TESTS_DESCRIPTION "Unit Tests")
SET (CPACK_COMPONENT_DATA_DESCRIPTION "Shared Data")
SET (CPACK_COMPONENT_PYTHON_DESCRIPTION "Python Bindings")

SET (CPACK_COMPONENT_APPLICATIONS_DEPENDS "libraries")
SET (CPACK_COMPONENT_HEADERS_DEPENDS "libraries")
SET (CPACK_COMPONENT_LIBRARIES_DEPENDS "data")
SET (CPACK_COMPONENT_PYTHON_DEPENDS "libraries")

SET (CPACK_COMPONENT_APPLICATIONS_GROUP "runtime")
SET (CPACK_COMPONENT_HEADERS_GROUP "devel")
SET (CPACK_COMPONENT_LIBRARIES_GROUP "runtime")
SET (CPACK_COMPONENT_DOCUMENTATION_GROUP "devel")
SET (CPACK_COMPONENT_TESTS_GROUP "devel")
SET (CPACK_COMPONENT_DATA_GROUP "runtime")
SET (CPACK_COMPONENT_PYTHON_GROUP "python")

SET (CPACK_COMPONENT_GROUP_RUNTIME_DESCRIPTION "Runtime")
SET (CPACK_COMPONENT_GROUP_DEVEL_DESCRIPTION "Development tools")
SET (CPACK_COMPONENT_GROUP_PYTHON_DESCRIPTION "Python bindings")

SET (CPACK_PACKAGING_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})

SET (CPACK_GENERATOR "RPM")

SET (CPACK_RPM_COMPONENT_INSTALL "ON")
SET (CPACK_RPM_PACKAGE_LICENSE ${CPACK_PACKAGE_LICENSE})
SET (CPACK_RPM_PACKAGE_VENDOR ${CPACK_PACKAGE_VENDOR})
SET (CPACK_RPM_PACKAGE_DESCRIPTION ${CPACK_PACKAGE_DESCRIPTION_SUMMARY})

SET (CPACK_RPM_EXCLUDE_FROM_AUTO_FILELIST
    /usr
    /usr/bin
    /usr/include
    /usr/lib
    /usr/share
    /usr/local
    /usr/local/bin
    /usr/local/include
    /usr/local/lib
    /usr/local/share
    /usr/share/man
)

INCLUDE (CPack)

################################################################################################################################################################
