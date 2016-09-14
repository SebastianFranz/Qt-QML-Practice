import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: root
    height: 480
    width: 800

    Text{
        id: result
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: false
    }



    DrawnCurve {
        id: curve
        anchors.bottom: parent.bottom
        anchors.margins: 10
        x: pacman.x - pacman.width/2

        NumberAnimation on x {
            id:animation
            to: - curve.width + ViewModel.getLineWidth() + ViewModel.getLinearLength() * curve.height/2
            duration: 10000
            running: false

            onStopped:
            {
                var RatioDotsEaten = curve.collidedDots.length / curve.dots.length
                result.text = "Your Result: " + (Math.round(RatioDotsEaten*100) + "% = " +
                                                 curve.collidedDots.length + " of " +
                                                 curve.dots.length)
                result.visible = true
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


    Slider{
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        orientation: Qt.Vertical
        height: curve.height


        minimumValue: curve.y
        maximumValue: curve.y + curve.height - pacman.height
        value: curve.y + curve.height - 1.5* pacman.height
        onValueChanged: {
            pacman.y = value
            //console.log(value)
        }
    }



    AnimatedImage  {
        id: pacman
        source: "Pacman.gif"
        x: 120
        height: 30
        width: 30
        transitions: Transition {
            NumberAnimation {
                properties: "rotation";
                easing.type: Easing.Linear
                duration: 1000
            }
        }

        property real lastX: 0
        property real lastY: 0

        onYChanged: {
            var NewX = parent.mapFromItem(curve,x,y).x
            var NewY = parent.mapFromItem(curve,x,y).y
            //console.log("NewX: " + NewX + " NewY: " + NewY)


            var ChangeX = NewX - lastX
            var ChangeY = NewY - lastY

            //To make it more smooth
            if(Math.pow(ChangeX,2) + Math.pow(ChangeY,2) < 500){
                return
            }
            // console.log("ChangeX: " + ChangeX + " ChangeY: " + ChangeY)

            var NewRotation = Math.atan(-ChangeY / ChangeX) * 180 / Math.PI

            //console.log("NewRotation: " + NewRotation)

            if(!animation.running) {
                rotation: 0
            }
            else{
                rotation = NewRotation
            }


            lastX = NewX
            lastY = NewY

        }

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
}


