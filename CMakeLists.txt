cmake_minimum_required(VERSION 3.16)

project(CropTool VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

qt_add_executable(appCropTool
    main.cpp
)

qt_add_qml_module(appCropTool
    URI CropTool
    VERSION 1.0
    QML_FILES main.qml CropTool.qml CropDimensionLabel.qml
    SOURCES crop.h crop.cpp
    RESOURCES assets/chevron--mini.svg
)

set_target_properties(appCropTool PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appCropTool
    PRIVATE Qt6::Quick)

install(TARGETS appCropTool
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
