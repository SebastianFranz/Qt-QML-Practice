import QtQuick 2.0

Item {
    id: root
    height: 480
    width: 800


    DrawnCurve {
        id: curve
        anchors.bottom: parent.bottom

        NumberAnimation on x {
            id:animation
            to: - curve.width + ViewModel.getLineWidth()
            duration: 10000
            running: false

            onStopped:
            {
                //curve.collidedDots - curve.
            }

        }
    }


    AnimatedImage  {
        id: pacman
        source: "Pacman.gif"
        x: 120
        height: 30
        width: 30


        anchors.bottom: parent.bottom
    }

    Timer{
        id: timer
        interval: 50
        repeat: true
        onTriggered:
        {
            curve.checkForCollision(pacman)
        }

    }



    MouseArea {
        anchors.fill: parent
        onClicked:
        {
            animation.running = !animation.running
            timer.running = !timer.running
        }
    }
}
