#QT += core gui
QT += quick charts
#QT += widgets


TARGET = eGymTest
TEMPLATE = app

INCLUDEPATH += $$_PRO_FILE_PWD_


SOURCES += *.cpp
OTHER_FILES += *.qml
RESOURCES += *.qrc \
    images.qrc
HEADERS += *.h

DISTFILES += \
    Pacman.qml \
    DrawnCurve.qml \
    WorkoutGUI.qml \
    Glossy.qml
