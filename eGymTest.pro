#QT += gui
QT += quick charts
QT += core
QT += network
#QT += widgets


TARGET = eGymTest
TEMPLATE = app

INCLUDEPATH += $$_PRO_FILE_PWD_


SOURCES += *.cpp \
    serializableobject.cpp \
    guicontroller.cpp
OTHER_FILES += *.qml
RESOURCES += *.qrc \
    images.qrc
HEADERS += *.h \
    serializableobject.h \
    guicontroller.h

DISTFILES += \
    Pacman.qml \
    DrawnCurve.qml \
    WorkoutGUI.qml \
    Star.qml
