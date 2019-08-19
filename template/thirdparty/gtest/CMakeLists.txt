CMAKE_MINIMUM_REQUIRED(VERSION "2.8.8")

CMAKE_POLICY (SET "CMP0048" NEW)

PROJECT ("gtest_builder" VERSION "" LANGUAGES "C" "CXX")

INCLUDE (ExternalProject)

SET (GTEST_FORCE_SHARED_CRT ON)
SET (GTEST_DISABLE_PTHREADS OFF)

IF (MINGW)
    SET (GTEST_DISABLE_PTHREADS ON)
ENDIF ()

EXTERNALPROJECT_ADD ("googletest"
    GIT_REPOSITORY "https://github.com/google/googletest.git"
    CMAKE_ARGS 
    #-DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG:PATH=DebugLibs
    #-DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE:PATH=ReleaseLibs
    -DCMAKE_CXX_FLAGS=${MSVC_COMPILER_DEFS}
    -Dgtest_force_shared_crt=${GTEST_FORCE_SHARED_CRT}
    -Dgtest_disable_pthreads=${GTEST_DISABLE_PTHREADS}
    -DBUILD_GTEST=ON
    UPDATE_DISCONNECTED 1
    PREFIX "${CMAKE_CURRENT_BINARY_DIR}"
    # Disable install step
    INSTALL_COMMAND ""
    )

# Specify include dir

EXTERNALPROJECT_GET_PROPERTY ("googletest" source_dir)
SET (GTEST_INCLUDE_DIRS "${source_dir}/googletest/include" PARENT_SCOPE)

# Specify MainTest's link libraries

EXTERNALPROJECT_GET_PROPERTY ("googletest" binary_dir)
SET (GTEST_LIBS_DIR "${binary_dir}/googlemock/gtest" PARENT_SCOPE)