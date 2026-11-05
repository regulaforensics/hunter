# Copyright (c) 2015, Ruslan Baratov
# All rights reserved.

include(hunter_status_debug)
include(hunter_assert_not_empty_string)
include(hunter_unsetvar)

function(hunter_flush_cache_variables hunter_self)
  hunter_assert_not_empty_string("${hunter_self}")

  hunter_status_debug("Flushing cache")

  get_directory_property(cache_list CACHE_VARIABLES)

  # Exclude standard variables
  set(std_variables_list
    CMAKE_ADSP_ROOT
    CMAKE_BUILD_WITH_INSTALL_NAME_DIR
    CMAKE_C_CLANG_TIDY_EXPORT_FIXES_DIR
    CMAKE_CACHEFILE_DIR
    CMAKE_CXX_CLANG_TIDY_EXPORT_FIXES_DIR
    CMAKE_FIND_PACKAGE_REDIRECTS_DIR
    CMAKE_INCLUDE_CURRENT_DIR
    CMAKE_INSTALL_NAME_DIR
    CMAKE_OBJC_CLANG_TIDY_EXPORT_FIXES_DIR
    CMAKE_OBJCXX_CLANG_TIDY_EXPORT_FIXES_DIR
    CMAKE_PKG_CONFIG_SYSROOT_DIR
    CMAKE_PKG_CONFIG_TOP_BUILD_DIR
    CMAKE_ROOT
    CMAKE_VS_PLATFORM_TOOLSET_CUDA_CUSTOM_DIR
    # Internal Hunter variables
    HUNTER_ROOT
    HUNTER_CACHED_ROOT
  )

  # Exclude standard variables by pattern
  set(std_patterns_list
    LIST_DIR
    SOURCE_DIR
    BINARY_DIR
  )

  # Patterns of variables to clean up
  set(cleanup_patterns_list
    "_ROOT$"
    "_DIR$"
    "_Dir$"
    # Issue https://github.com/ruslo/hunter/issues/569
    "^Boost_.*_LIBRARY_.*$"
    "^Boost_LIBRARY_DIR_.*$"
    "^_Boost_LIBRARY_DIR_.*_LAST$"
    # From OpenCV Android
    "^OpenCV_3RDPARTY_LIB_DIR_(OPT|DBG)$"
    "^OpenCV_CONFIG_PATH$"
    # From FindOpenSSL.cmake
    "^OPENSSL_(SSL|CRYPTO)_LIBRARY$"
  )

  # Keep only variables matching cleanup patterns
  string(REPLACE ";" "|" cleanup_regex "${cleanup_patterns_list}")
  list(FILTER cache_list INCLUDE REGEX "${cleanup_regex}")

  # Drop exact standard variable names
  string(REPLACE ";" "|" std_variables_regex "${std_variables_list}")
  list(FILTER cache_list EXCLUDE REGEX "^(${std_variables_regex})$")

  # Drop standard variable suffixes
  string(REPLACE ";" "|" std_patterns_regex "${std_patterns_list}")
  list(FILTER cache_list EXCLUDE REGEX "_(${std_patterns_regex})$")

  foreach(x IN LISTS cache_list)
    hunter_status_debug("Removing variable from cache:")
    hunter_status_debug("  Name = '${x}'")
    hunter_status_debug("  Value = '${${x}}'")
    unset("${x}" CACHE)
  endforeach()

  # Read list of all projects and unset regular, cache and environment variables
  # with name '<package>_{ROOT|Dir|DIR}'
  # {
  set(directory_with_projects "${hunter_self}/cmake/projects")
  file(
      GLOB projects
      RELATIVE "${directory_with_projects}"
      "${directory_with_projects}/*"
  )

  if(NOT projects)
    message(FATAL_ERROR "No projects found")
  endif()

  set(real_projects "")
  foreach(x ${projects})
    if(IS_DIRECTORY "${directory_with_projects}/${x}")
      list(APPEND real_projects "${x}")
    endif()
  endforeach()

  if(NOT real_projects)
    message(FATAL_ERROR "No projects found")
  endif()

  foreach(x ${real_projects})
    hunter_unsetvar("${x}_ROOT")
    hunter_unsetvar("${x}_Dir")
    hunter_unsetvar("${x}_DIR")
  endforeach()
  # }
endfunction()
