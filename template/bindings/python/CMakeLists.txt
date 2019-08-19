################################################################################################################################################################

# @project        Libraries
# @file           bindings/python/CMakeLists.txt
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

## Project Properties

SET (PROJECT_NAME "LibraryPy")
SET (PROJECT_DESCRIPTION "Python bindings for Library.")
SET (PROJECT_PACKAGE_NAME "LibraryPy")
SET (PROJECT_PATH "Library")
SET (PROJECT_LICENSE "Apache License 2.0")
SET (PROJECT_VENDOR_ID "com.bremond.lucas")
SET (PROJECT_VENDOR_NAME "Lucas Brémond")
SET (PROJECT_VENDOR_CONTACT "lucas.bremond@gmail.com")
SET (PROJECT_VENDOR_URL "lucas.bremond.info")

################################################################################################################################################################

## Setup

### Compatibility Check

CMAKE_MINIMUM_REQUIRED (VERSION "2.8.12" FATAL_ERROR)

### Paths

SET (CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/tools/cmake")

### Policies

CMAKE_POLICY (SET "CMP0048" NEW)

################################################################################################################################################################

## Project Configuration

PROJECT (${PROJECT_NAME} VERSION ${PROJECT_VERSION_STRING} LANGUAGES "C" "CXX")

################################################################################################################################################################

## Dependencies

### Boost [1.69.0]

UNSET (Boost_USE_STATIC_LIBS CACHE)
UNSET (Boost_USE_MULTITHREADED CACHE)

SET (BUILD_SHARED_LIBS ON)
SET (Boost_USE_STATIC_LIBS OFF)
SET (Boost_USE_MULTITHREADED ON)

FIND_PACKAGE ("Boost" "1.69" REQUIRED COMPONENTS "python37")

IF (NOT Boost_FOUND)
    MESSAGE (SEND_ERROR "[Boost] not found.")
ENDIF ()

### Python

FIND_PACKAGE ("Python3" COMPONENTS "Development")

IF (NOT Python3_FOUND)
    MESSAGE (SEND_ERROR "[Python 3] not found.")
ENDIF ()

################################################################################################################################################################

## Target

SET (LIBRARY_NAME ${PROJECT_PACKAGE_NAME})
SET (LIBRARY_TARGET "${LIBRARY_NAME}.so")

FILE (GLOB_RECURSE PROJECT_SRCS "${PROJECT_SOURCE_DIR}/src/*.cxx")

ADD_LIBRARY (${LIBRARY_TARGET} SHARED ${PROJECT_SRCS})

ADD_DEPENDENCIES (${LIBRARY_TARGET} ${SHARED_LIBRARY_TARGET})

TARGET_INCLUDE_DIRECTORIES (${LIBRARY_TARGET} PUBLIC ${PYTHON_INCLUDE_DIR})
TARGET_INCLUDE_DIRECTORIES (${LIBRARY_TARGET} PUBLIC "${CMAKE_SOURCE_DIR}/include")
TARGET_INCLUDE_DIRECTORIES (${LIBRARY_TARGET} PUBLIC "${CMAKE_SOURCE_DIR}/src")
TARGET_INCLUDE_DIRECTORIES (${LIBRARY_TARGET} PUBLIC "${PROJECT_SOURCE_DIR}/include")
TARGET_INCLUDE_DIRECTORIES (${LIBRARY_TARGET} PUBLIC "${PROJECT_SOURCE_DIR}/src")

TARGET_LINK_LIBRARIES (${LIBRARY_TARGET} "Python3::Python")
TARGET_LINK_LIBRARIES (${LIBRARY_TARGET} "Boost::python37")
TARGET_LINK_LIBRARIES (${LIBRARY_TARGET} ${SHARED_LIBRARY_TARGET})

SET_TARGET_PROPERTIES ( ${LIBRARY_TARGET} PROPERTIES
                        VERSION ${PROJECT_VERSION_STRING}
                        SOVERSION ${PROJECT_VERSION_MAJOR}
                        OUTPUT_NAME ${PROJECT_PACKAGE_NAME}
                        CLEAN_DIRECT_OUTPUT 1
                        PREFIX ""
                        BUILD_WITH_INSTALL_RPATH TRUE
                        INSTALL_RPATH "$ORIGIN/../lib:$ORIGIN/")

INSTALL (TARGETS ${LIBRARY_TARGET} DESTINATION "${INSTALL_LIB}/${PROJECT_PATH}" COMPONENT "python")
INSTALL (FILES "${PROJECT_SOURCE_DIR}/tools/python/Library/__init__.py" DESTINATION "${INSTALL_LIB}/Library" COMPONENT "python")
INSTALL (FILES "${PROJECT_SOURCE_DIR}/tools/python/${PROJECT_PATH}/__init__.py" DESTINATION "${INSTALL_LIB}/${PROJECT_PATH}" COMPONENT "python")

################################################################################################################################################################

FIND_PROGRAM (PYTHON "python3")

IF (NOT PYTHON)

    MESSAGE (FATAL_ERROR "Unable to find [python3] program.")

ENDIF (NOT PYTHON)

SET (PACKAGE_NAME ${PROJECT_PACKAGE_NAME})
SET (PACKAGE_TARGET "${PACKAGE_NAME}-python-package")

SET (SETUP_PY_IN "${CMAKE_CURRENT_SOURCE_DIR}/tools/python/setup.py.in")
SET (SETUP_PY "${CMAKE_CURRENT_BINARY_DIR}/setup.py")
SET (DEPS "${CMAKE_CURRENT_SOURCE_DIR}/tools/python/${PROJECT_PATH}/__init__.py")
SET (OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/build/timestamp")

CONFIGURE_FILE (${SETUP_PY_IN} ${SETUP_PY})

ADD_CUSTOM_COMMAND (OUTPUT ${OUTPUT}
                    COMMAND mkdir -p "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_PATH}"
                    COMMAND cp "${CMAKE_CURRENT_SOURCE_DIR}/tools/python/Library/__init__.py" "${CMAKE_CURRENT_BINARY_DIR}/Library/__init__.py"
                    COMMAND cp "${CMAKE_CURRENT_SOURCE_DIR}/tools/python/${PROJECT_PATH}/__init__.py" "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_PATH}/__init__.py"
                    COMMAND cp "/usr/local/lib/libboost_python37.so.1.69.0" "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_PATH}/libboost_python37.so.1.69.0"
                    COMMAND cp "${CMAKE_SOURCE_DIR}/lib/${SHARED_LIBRARY_TARGET}" "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_PATH}/liblibrary.so.0"
                    COMMAND cp "${CMAKE_SOURCE_DIR}/lib/${LIBRARY_TARGET}" "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_PATH}/LibraryPy.so"
                    COMMAND ${PYTHON} ${SETUP_PY} bdist_wheel
                    COMMAND ${CMAKE_COMMAND} -E touch ${OUTPUT}
                    DEPENDS ${DEPS})

ADD_CUSTOM_TARGET (${PACKAGE_TARGET} ALL DEPENDS ${OUTPUT})

ADD_DEPENDENCIES (${PACKAGE_TARGET} ${LIBRARY_TARGET})

# INSTALL (CODE "execute_process(COMMAND ${PYTHON} ${SETUP_PY} install)")

################################################################################################################################################################

ADD_CUSTOM_TARGET ("publish" COMMAND python3 -m twine upload "${CMAKE_CURRENT_BINARY_DIR}/dist/*" DEPENDS ${OUTPUT})

################################################################################################################################################################
