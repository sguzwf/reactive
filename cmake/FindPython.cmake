set(Python_ADDITIONAL_VERSIONS 3.6)
find_package(PythonLibs 3.6)
if(NOT ${PYTHONLIBS_FOUND})
    set(SEARCH_PYTHON_LIBS_SUFFIX "")
    if(IS_PY_DEBUG)
        set(SEARCH_PYTHON_LIBS_SUFFIX "'dm.so', 'dm.a'")
    else()
        set(SEARCH_PYTHON_LIBS_SUFFIX "'.a', '.so', 'm.a', 'm.so'")
    endif()
    message(STATUS "Python alternative search")
    execute_process(COMMAND python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc(), end='')" OUTPUT_VARIABLE PYTHON_INCLUDE_DIRS)
    execute_process(COMMAND python3 -c "from platform import python_version\nimport distutils.sysconfig as sysconfig\nimport os.path\nimport sys\nlibDir = sysconfig.get_config_var('LIBDIR')\nversion = python_version()[:3]\nfor suffix in [${SEARCH_PYTHON_LIBS_SUFFIX}]:\n\tlibname = os.sep.join([libDir, 'libpython' + version + suffix])\n\tif(os.path.isfile(libname)):\n\t\tprint(libname, end='')\n\t\tsys.exit()" OUTPUT_VARIABLE PYTHON_LIBRARIES)
    execute_process(COMMAND python3 -c "from platform import python_version; print(python_version(), end='');" OUTPUT_VARIABLE PYTHONLIBS_VERSION_STRING)

    set(PYTHONLIBS_VERSION_STRING ${PYTHONLIBS_VERSION_STRING} CACHE STRING "" FORCE)
    set(PYTHON_LIBRARIES ${PYTHON_LIBRARIES} CACHE STRING "" FORCE)
    set(PYTHON_INCLUDE_DIRS ${PYTHON_INCLUDE_DIRS} CACHE STRING "" FORCE)
    set(PYTHONLIBS_FOUND True CACHE BOOL "" FORCE)
endif()
if(${PYTHONLIBS_FOUND})
    message(STATUS "Python version ${PYTHONLIBS_VERSION_STRING} found")
    message(STATUS "Python library dir ${PYTHON_LIBRARIES}")
    message(STATUS "Python include dir ${PYTHON_INCLUDE_DIRS}")
    if(NOT ${PYTHONLIBS_VERSION_STRING} MATCHES "^(3)")
        message(FATAL_ERROR "Python version 3.x is requred, found - ${PYTHONLIBS_VERSION_STRING}")
    endif()
endif()

