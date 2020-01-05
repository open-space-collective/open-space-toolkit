################################################################################################################################################################

# @project        Open Space Toolkit
# @file           docs/CMakeLists.txt
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

SET (DOCUMENTATION_TARGET "docs")

SET (DOXYFILE_IN "${PROJECT_SOURCE_DIR}/docs/doxygen/Doxyfile.in")
SET (DOXYFILE "${CMAKE_CURRENT_BINARY_DIR}/Doxyfile")

FILE (GLOB MARKDOWN_DOC "${PROJECT_SOURCE_DIR}/docs/*.md")
LIST (APPEND MARKDOWN_DOC "${PROJECT_SOURCE_DIR}/README.md")
LIST (APPEND MARKDOWN_DOC "${PROJECT_SOURCE_DIR}/CONTRIBUTING.md")

CONFIGURE_FILE (${DOXYFILE_IN} ${DOXYFILE} @ONLY)

FILE (COPY ${MARKDOWN_DOC} DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
FILE (COPY "${PROJECT_SOURCE_DIR}/docs/doxygen" DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

FIND_PACKAGE ("Doxygen" QUIET)

IF (NOT DOXYGEN_FOUND)

    ADD_SUBDIRECTORY ("${PROJECT_SOURCE_DIR}/thirdparty/doxygen")

    SET (DOXYGEN_EXECUTABLE "${CMAKE_CURRENT_BINARY_DIR}/thirdparty/doxygen/source/bin/doxygen")

    ADD_CUSTOM_TARGET (${DOCUMENTATION_TARGET} ALL
        COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYFILE}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS "doxygen" ${DOXYFILE} ${MARKDOWN_DOC}
        COMMENT "Generating API documentation with Doxygen"
        VERBATIM)

ELSE ()

    ADD_CUSTOM_TARGET (${DOCUMENTATION_TARGET} ALL
        COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYFILE}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS ${DOXYFILE} ${MARKDOWN_DOC}
        COMMENT "Generating API documentation with Doxygen"
        VERBATIM)

ENDIF ()

INSTALL (DIRECTORY "${DOCS_OUTPUT_PATH}/html/" DESTINATION ${INSTALL_DOC} COMPONENT "documentation")

################################################################################################################################################################
