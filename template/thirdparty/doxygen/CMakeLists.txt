CMAKE_MINIMUM_REQUIRED (VERSION "2.8.8")

CMAKE_POLICY (SET "CMP0048" NEW)

PROJECT ("doxygen_builder" VERSION "")

INCLUDE (ExternalProject)

## ==============================================================================
##
##  Package information
##
## ==============================================================================

set (DOXYGEN_VERSION        "1.8.2" )
set (DOXYGEN_SOURCE_ARCHIVE "doxygen-${DOXYGEN_VERSION}.src.tar.gz" )
set (DOXYGEN_URL            "ftp://ftp.stack.nl/pub/users/dimitri/${DOXYGEN_SOURCE_ARCHIVE}" )
set (DOXYGEN_SVN            "https://doxygen.svn.sourceforge.net/svnroot/doxygen/trunk" )
set (DOXYGEN_GIT            "https://github.com/doxygen/doxygen.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (DOXYGEN_FORCE_BUILD    "Force build and installation of package?" NO )
option (DOXYGEN_FROM_REPOS     "Install package from repository?"         YES )

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

## Check if Doxygen is available

if (NOT DOXYGEN_EXECUTABLE)
  find_package ("Doxygen" QUIET)
endif (NOT DOXYGEN_EXECUTABLE)

## Check if Doxygen is available in a recent enough version

## Extract Doxygen version number - this is not done by the standard module
if (DOXYGEN_EXECUTABLE)

  message (STATUS "Checking whether Doxygen version is ok")

  execute_process(
    COMMAND ${DOXYGEN_EXECUTABLE} --version
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    RESULT_VARIABLE DOXYGEN_RESULT_VARIABLE
    OUTPUT_VARIABLE DOXYGEN_VERSION
    ERROR_VARIABLE DOXYGEN_ERROR_VARIABLE
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )

  if (DOXYGEN_VERSION)
    ## Convert string to list of numbers
    string (REGEX REPLACE "\\." ";" DOXYGEN_VERSION_LIST ${DOXYGEN_VERSION})
    ## Retrieve individual elements in the list
    list(GET DOXYGEN_VERSION_LIST 0 DOXYGEN_VERSION_MAJOR)
    list(GET DOXYGEN_VERSION_LIST 1 DOXYGEN_VERSION_MINOR)
    list(GET DOXYGEN_VERSION_LIST 2 DOXYGEN_VERSION_PATCH)
  endif (DOXYGEN_VERSION)

  math (EXPR DOXYGEN_VERSION_MAJOR "${DOXYGEN_VERSION_MAJOR}*100")
  math (EXPR DOXYGEN_VERSION_MINOR "${DOXYGEN_VERSION_MINOR}*100")
  math (EXPR DOXYGEN_VERSION_PATCH "${DOXYGEN_VERSION_PATCH}*100")

  set (DOXYGEN_VERSION_STRING "${DOXYGEN_VERSION_MAJOR}${DOXYGEN_VERSION_MINOR}${DOXYGEN_VERSION_PATCH}")

  if (${DOXYGEN_VERSION_STRING} LESS ${REQUIRED_VERSION_DOXYGEN})
    set (DOXYGEN_FOUND FALSE)
    message (STATUS "Checking whether Doxygen version is ok - no")
  else ()
    message (STATUS "Checking whether Doxygen version is ok - yes")
  endif()

endif (DOXYGEN_EXECUTABLE)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (DOXYGEN_FROM_REPOS)
  set (DOXYGEN_FORCE_BUILD TRUE)
endif (DOXYGEN_FROM_REPOS)

if (NOT DOXYGEN_FOUND OR DOXYGEN_FORCE_BUILD)

  ## Locate source file to build from

  find_file (DOXYGEN_SOURCE ${DOXYGEN_SOURCE_ARCHIVE}
    PATHS ${CMAKE_CURRENT_SOURCE_DIR}
    )

  if (NOT DOXYGEN_SOURCE)
    set (DOXYGEN_SOURCE ${DOXYGEN_URL})
  endif (NOT DOXYGEN_SOURCE)

  ## Build package from source

  if (DOXYGEN_FROM_REPOS)

    ExternalProject_Add (doxygen
      GIT_REPOSITORY ${DOXYGEN_GIT}
      PREFIX ${CMAKE_CURRENT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      CMAKE_ARGS
      BUILD_IN_SOURCE 1
      INSTALL_COMMAND ""
      )

  else (DOXYGEN_FROM_REPOS)

    ExternalProject_Add (doxygen
      PREFIX ${CMAKE_CURRENT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${DOXYGEN_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${CMAKE_CURRENT_BINARY_DIR}/source/configure --prefix ${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )

  endif (DOXYGEN_FROM_REPOS)

  ## Update top-level project configuration
  # ExternalProject_Add_Step (doxygen update_configuration
  #   COMMAND ${CMAKE_COMMAND} -E remove CMakeCache.txt
  #   COMMAND ${CMAKE_COMMAND} ..
  #   COMMENT "Updating top-level configuration ..."
  #   DEPENDEES install
  #   WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  # )

else (NOT DOXYGEN_FOUND OR DOXYGEN_FORCE_BUILD)

  add_custom_target (doxygen
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "[doxygen] Found system-wide installation; skipping rebuild!"
    )

endif (NOT DOXYGEN_FOUND OR DOXYGEN_FORCE_BUILD)