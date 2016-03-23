project(smartcontrol)
cmake_minimum_required(VERSION 2.8.12)

include(GNUInstallDirs)

set(SMARTCONTROL_VERSION "0.0.0" CACHE STRING "Version")
configure_file(smartcontrol/Version.py.in Version.py @ONLY)

find_package(PythonInterp 3.4.0 REQUIRED)

install(DIRECTORY resources DESTINATION ${CMAKE_INSTALL_DATADIR}/smartcontrol)
install(FILES SmartControlLauncher.py DESTINATION ${CMAKE_INSTALL_BINDIR} PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
if(NOT APPLE AND NOT WIN32)
    install(DIRECTORY smartcontrol DESTINATION lib/python${PYTHON_VERSION_MAJOR}/dist-packages FILES_MATCHING PATTERN *.py)
    install(FILES ${CMAKE_BINARY_DIR}/Version.py DESTINATION lib/python${PYTHON_VERSION_MAJOR}/dist-packages/smartcontrol)
else()
    install(DIRECTORY smartcontrol DESTINATION lib/python${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}/site-packages FILES_MATCHING PATTERN *.py)
    install(FILES ${CMAKE_BINARY_DIR}/Version.py DESTINATION lib/python${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}/site-packages/smartcontrol)
endif()

#include(CPackConfig.cmake)
