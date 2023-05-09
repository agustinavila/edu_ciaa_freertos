
if(CMAKE_HOST_WIN32)
  set(EXECUTABLE_SUFFIX .exe)
endif()

include(CMakeForceCompiler)
 set(TOOLCHAIN_PREFIX "C:/nxp/MCUXpressoIDE_11.7.0_9198/ide/tools")
if(NOT TOOLCHAIN_PREFIX)
  message(FATAL_ERROR "No TOOLCHAIN_PREFIX specified.")
endif()

# MCUXpresso version check
string(REGEX MATCH "mcuxpresso" MATCH_STR ${TOOLCHAIN_PREFIX})
if(NOT ${MATCH_STR} STREQUAL "")
  # Get version from specified path prefix
  string(REGEX MATCH "[0-9].[0-9].[0-9]" MCUXPRESSO_VERSION ${TOOLCHAIN_PREFIX})
  if(NOT ${MCUXPRESSO_VERSION} STREQUAL "")
    message(STATUS "MCUXpresso detected: v" ${MCUXPRESSO_VERSION})
    # Check if version is supported
    if(${MCUXPRESSO_VERSION} VERSION_LESS "7.6.2")
      message(FATAL_ERROR "MCUXpresso version not supported: " ${MCUXPRESSO_VERSION})
    endif()
  else()
    message(STATUS "WARNING: Could not check MCUXpresso version. Build may not work correctly.")
  endif()
endif()

set(TARGET_TRIPLET "arm-none-eabi")

set(TOOLCHAIN_BIN_DIR ${TOOLCHAIN_PREFIX}/bin)
set(TOOLCHAIN_INC_DIR ${TOOLCHAIN_PREFIX}/${TARGET_TRIPLET}/include)
set(TOOLCHAIN_LIB_DIR ${TOOLCHAIN_PREFIX}/${TARGET_TRIPLET}/lib)

set(CMAKE_SYSTEM_NAME       Generic)
set(CMAKE_SYSTEM_VERSION    1)
set(CMAKE_SYSTEM_PROCESSOR  arm)

set(CMAKE_C_COMPILER ${TOOLCHAIN_BIN_DIR}/${TARGET_TRIPLET}-gcc${EXECUTABLE_SUFFIX} CACHE INTERNAL "c compiler")
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_BIN_DIR}/${TARGET_TRIPLET}-c++${EXECUTABLE_SUFFIX} CACHE INTERNAL "cxx compiler")
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_BIN_DIR}/${TARGET_TRIPLET}-as${EXECUTABLE_SUFFIX} CACHE INTERNAL "asm compiler")

set(CMAKE_OBJCOPY ${TOOLCHAIN_BIN_DIR}/${TARGET_TRIPLET}-objcopy${EXECUTABLE_SUFFIX} CACHE INTERNAL "objcopy")
set(CMAKE_OBJDUMP ${TOOLCHAIN_BIN_DIR}/${TARGET_TRIPLET}-objdump${EXECUTABLE_SUFFIX} CACHE INTERNAL "objdump")

set(CMAKE_AR ${TOOLCHAIN_BIN_DIR}/${TARGET_TRIPLET}-ar${EXECUTABLE_SUFFIX} CACHE INTERNAL "archiver")

set(CMAKE_STRIP ${TOOLCHAIN_BIN_DIR}/${TARGET_TRIPLET}-strip${EXECUTABLE_SUFFIX} CACHE INTERNAL "strip")
set(CMAKE_SIZE ${TOOLCHAIN_BIN_DIR}/${TARGET_TRIPLET}-size${EXECUTABLE_SUFFIX} CACHE INTERNAL "size")

# Adjust the default behaviour of the FIND_XXX() commands:
# i)    Search headers and libraries in the target environment
# ii)   Search programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Compilers like arm-none-eabi-gcc that target bare metal systems don't pass
# CMake's compiler check, so fill in the results manually and mark the test
# as passed:
set(CMAKE_COMPILER_IS_GNUCC     1)
set(CMAKE_C_COMPILER_ID         GNU)
set(CMAKE_C_COMPILER_ID_RUN     TRUE)
set(CMAKE_C_COMPILER_FORCED     TRUE)
set(CMAKE_CXX_COMPILER_ID       GNU)
set(CMAKE_CXX_COMPILER_ID_RUN   TRUE)
set(CMAKE_CXX_COMPILER_FORCED   TRUE)
 
# set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)