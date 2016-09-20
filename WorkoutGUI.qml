import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Particles 2.0
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0

Rectangle {
    id: root
    height: 600
    width: 800
    color: backgroundColor

    property color backgroundColor: "#8d7d81"
    property color backgroundColorGraph: "#9f9295"
    property color colorButtons: "#474547" //3c3b3c
    property color colorLoginButton: "#ceccce" //c4c3c5
    property color colorText: "#8d7d81"
    property color colorState: "#bd6c32" //(Training)
    property color colorProgress: "#dba14d"  //5d595c
    property color colorDotsInGraph: "#e0de8f"
    property color colorSeperator: "#e8e064"
    property color colorStar: "#e9d86c"

    property string fontFamily: "Calibri"
    property color fontColor: "white"

    property real progress: 0





    Item{
        id:header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        height: 95

        Text{
            id:workoutGoal
            font.pixelSize: 65
            font.family: fontFamily
            color: fontColor
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenterOffset: -10
            text:  "<i>" + ViewModel.getWorkoutTypeGoal() + "</i>"
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                verticalOffset: -1
                radius: 1
            }
        }
        Button{
            id:buttonLogout
            style: buttonStyle
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 10
            text: "Abmelden"
            height: 45
            width: 150
            property int pixelSize: 19
            property color textColor: "black"
            property color backgroundColor: "#cccccc"
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                verticalOffset: 1
                horizontalOffset: 1
                radius: 1
            }
            onClicked: ViewModel.logoutUser()
        }
        Text{
            id:userName
            font.family: fontFamily
            color: fontColor
            anchors.verticalCenter: buttonLogout.verticalCenter
            anchors.right: buttonLogout.left
            anchors.margins: 10
            text: "<i>" + ViewModel.UserName + "</i>"
            font.pixelSize: 25
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                verticalOffset: -1
                radius: 1
            }
        }
        Image{
            id:userImage
            anchors.verticalCenter: buttonLogout.verticalCenter
            anchors.right: userName.left
            anchors.margins: 5
            source: "Star.png"
            height: 25
            width: 25
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                verticalOffset: -1
                radius: 1
            }
        }
    }

    Rectangle{
        id:separatingElement
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 45
        // color: backgroundColorGraph

        gradient: Gradient {
            GradientStop {
                position: 0
                color: "lightgrey"
            }

            GradientStop {
                position: 0.05
                color: backgroundColorGraph
            }
        }
        Text{
            id:workoutType
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left

            anchors.margins: 10
            text: "<b>" + "Du trainierst: " + ViewModel.getWorkoutTypeString() + "</b>"
            font.family: fontFamily
            color: fontColor
            font.pixelSize: 20
        }
        Rectangle{
            id:separator
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 3
            color: colorSeperator
        }

    }
    RowLayout{
        id:centralDisplay
        anchors.top: separatingElement.bottom
        anchors.margins: 10
        anchors.right: parent.right
        anchors.left: parent.left
        spacing: 30
        height: 320

        Slider{
            id: slider
            orientation: Qt.Vertical
            height: curve.height

            //all those - invert the behavior
            maximumValue: - (curve.y - pacman.height/3)
            minimumValue: -( curve.y + curve.height - pacman.height)
            value: -(curve.y + curve.height - 1.5* pacman.height)

            onValueChanged: {
                pacman.y = -value
            }
            style:
                SliderStyle{
                groove: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 5
                    color: colorLoginButton
                    radius: 5

                    layer.enabled: true
                    layer.effect: DropShadow{
                        transparentBorder: true
                        verticalOffset: 1
                        horizontalOffset: 1
                    }
                }
                handle: Rectangle {
                    anchors.centerIn: parent
                    color: control.pressed ? backgroundColorGraph : colorButtons
                    border.color: control.pressed ? colorButtons : "gray"
                    border.width: 2
                    implicitWidth: 25
                    implicitHeight: 25
                    radius: 10
                    layer.enabled: true
                    layer.effect: DropShadow{
                        transparentBorder: true
                        verticalOffset: 1
                        horizontalOffset: 1
                    }
                }
            }

        }


        Rectangle{
            id:curveBorder
            border.color: "black"
            border.width: 1
            color: backgroundColorGraph
            radius: 10
            anchors.left: slider.right
            anchors.right: weightAdjustments.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 55
            anchors.bottomMargin: 55
            anchors.rightMargin: 50
            anchors.leftMargin: 20
            clip: true

            DrawnCurve {
                id: curve
                anchors.bottom: parent.bottom

                onCompletedRepetitionsChanged: {repetitionsText.text = "<b>" + curve.completedRepetitions + "</b> / " + ViewModel.getRepetitions()}
                onProgressChanged: progressBar.setValue(curve.progress)
                onIsOnPositvePathChanged: {(curve.isOnPositvePath ? weightAdjustments.state = "positive" : weightAdjustments.state = "negative")}

                NumberAnimation on x {
                    id:animation
                    to: - curve.width + ViewModel.getLineWidth() + ViewModel.getLinearLength() * curve.height/2
                    duration: ViewModel.getSecondsPerRepetition() *1000 * ViewModel.getRepetitions()
                    running: false

                    onStopped: {
                        root.state = "Result"
                    }
                }
            }



            AnimatedImage  {
                id: pacman
                source: "Pacman.gif"
                x: 0
                y: -200
                height: 30
                width: 30
                NumberAnimation on x {
                    to: 120
                    duration: 2000
                    running: true

                    easing.type: Easing.OutElastic //OutBounce
                    easing.amplitude: 1.0
                    easing.period: 0.2

                }
                /* NumberAnimation on y {
                    to: 180 //curve.y + curve.height - 1.5*height
                    duration: 2000
                    running: true
                        easing.type: Easing.InBounce;
                                            easing.amplitude: 10.0;
                                            easing.period: 50.5
                }*/

                ParticleSystem { id: bubbles; running: visible }
                ImageParticle {
                    id: sweat
                    system: bubbles
                    //Source styles Excample
                    source: "bubble.png"
                    opacity: 1
                }
                Emitter {
                    system: bubbles
                    anchors.top: parent.top
                    anchors.margins: 4
                    anchors.leftMargin: -1
                    anchors.topMargin: 5
                    anchors.left: parent.left
                    anchors.right: parent.right
                    size: 3
                    sizeVariation: 2
                    acceleration: PointDirection { y: +6; xVariation: 1 }
                    emitRate: 1
                    lifeSpan: 3000
                }


                property real lastX
                property real lastY

                //Sets the rotation of the image to head towards the direction of movement
                function setRotation(){
                    if(!animation.running) {
                        //console.log("Not running")
                        pacman.rotation = 0
                        return;
                    }

                    var NewX = parent.mapFromItem(curve,pacman.x,pacman.y).x
                    var NewY = parent.mapFromItem(curve,pacman.x,pacman.y).y
                    //console.log("NewX: " + NewX + " NewY: " + NewY)


                    var ChangeX = NewX - lastX
                    var ChangeY = NewY - lastY

                    //To make it more smooth
                    if(Math.pow(ChangeX,2) + Math.pow(ChangeY,2) < 200){
                        return
                    }
                    // console.log("ChangeX: " + ChangeX + " ChangeY: " + ChangeY)

                    var NewRotation = Math.atan(-ChangeY / ChangeX) * 180 / Math.PI


                    //Removes an upwards dip at the start, removable with initialisation, but looks very ugly
                    if (lastX != 0){
                        //console.log("NewRotation: " + NewRotation)
                        pacman.rotation = NewRotation
                    }


                    lastX = NewX
                    lastY = NewY

                }

                Timer{
                    id: timerCollision
                    interval: 25
                    repeat: true

                    onTriggered:
                    {
                        curve.checkForCollision(pacman)
                        pacman.setRotation()
                    }
                }
            }

        }


        Column{
            id: weightAdjustments
            spacing: 5
            property int contentWidth: 140
            property int contentHeigth: 45
            anchors.right: parent.right
            anchors.rightMargin: 40

            state: "positive"
            states: [
                State {
                    name: "positive"
                    PropertyChanges {target: rectangleWeightPositive; border.width: 2}
                    PropertyChanges {target: textWeightPositive; font.bold: true}
                    PropertyChanges {target: rectangleWeightNegative; border.width: 0}
                    PropertyChanges {target: textWeightNegative; font.bold: false}
                },
                State {
                    name: "negative"
                    PropertyChanges {target: rectangleWeightPositive; border.width: 0}
                    PropertyChanges {target: textWeightPositive; font.bold: false}
                    PropertyChanges {target: rectangleWeightNegative; border.width: 2}
                    PropertyChanges {target: textWeightNegative; font.bold: true}
                }
            ]

            Button{
                style: buttonStyle
                text: "<b>+</b>  " + ViewModel.getBigValue()
                height:  parent.contentHeigth
                width: parent.contentWidth
                onClicked: ViewModel.increaseWeight(ViewModel.getBigValue())
                property int pixelSize: height*0.75
            }
            Button{
                style: buttonStyle
                text: "<b>+"
                height:  parent.contentHeigth
                width: parent.contentWidth
                onClicked: ViewModel.increaseWeight(1)
                property int pixelSize: height*0.75
            }
            Rectangle{
                id: rectangleWeightPositive
                border.color: backgroundColorGraph
                border.width: 2
                radius: height/5
                height:  parent.contentHeigth
                width: parent.contentWidth
                anchors.horizontalCenter: parent.horizontalCenter
                color: backgroundColor

                Text{
                    id: textWeightPositive
                    anchors.centerIn: parent
                    text: ViewModel.WeightPositive
                    font.family: fontFamily
                    color: fontColor
                    font.pixelSize: 20
                }
            }

            Rectangle{
                id: rectangleWeightNegative
                border.color: backgroundColorGraph
                border.width: 1
                radius: height/5
                height:  parent.contentHeigth
                width: parent.contentWidth
                color: backgroundColor

                Text{
                    id: textWeightNegative
                    anchors.centerIn: parent
                    text: ViewModel.WeightNegative
                    font.family: fontFamily
                    color: fontColor
                    font.pixelSize: 20
                }
            }
            Button{
                style: buttonStyle
                text: "<b>-</b>"
                height:  parent.contentHeigth
                width: parent.contentWidth
                onClicked: ViewModel.decreaseWeight(1)
                property int pixelSize: height*0.75
            }
            Button{
                style: buttonStyle
                text: "<b>-</b>   " + ViewModel.getBigValue()
                height:  parent.contentHeigth
                width: parent.contentWidth
                onClicked: ViewModel.decreaseWeight(ViewModel.getBigValue())
                property int pixelSize: height*0.75
            }
        }
    }
    Rectangle{
        id:statusElement
        anchors.top: centralDisplay.bottom
        color: colorButtons
        height: 40
        anchors.right: parent.right
        anchors.left: parent.left
        Rectangle{
            id: state
            color: colorState
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            width: 150
            Text{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
                font.family: fontFamily
                color: fontColor
                text: "Training"
                font.pixelSize: parent.height * 0.6
            }
        }
        ProgressBar{
            id: progressBar
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.left: state.right
            anchors.right: repetitions.left
            anchors.leftMargin: 3

            style:
                ProgressBarStyle {
                background: Rectangle {
                    color:colorButtons
                }
                progress: Rectangle {
                    id:progress
                    color:  colorProgress
                }

            }
            Text {
                id: progressElapsedText
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                }
                font.family: fontFamily
                color: fontColor
                text: "<b>" + Math.round(progressBar.value * 100) + "</b> %"
                font.pixelSize: parent.height * 0.6
            }
        }
        Rectangle{
            id: repetitions
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.right: parent.right
            width: 100
            color: backgroundColor
            Text{
                id: repetitionsText
                anchors.centerIn: parent
                font.family: fontFamily
                color: fontColor
                font.pixelSize: parent.height * 0.6
                text: "<b>0</b>/" + ViewModel.getRepetitions()
            }
        }
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            verticalOffset: 3
            radius: 5
        }
    }

    Rectangle{
        id:result
        anchors.top: separatingElement.bottom
        anchors.centerIn: parent
        radius: 20
        height: 200
        width: 400
        Text{
            id: resultText
            color: "black"
            textFormat: Text.RichText
            anchors.centerIn: parent
            font.family: fontFamily
        }
    }


    Button{
        id: startButton
        anchors.top: statusElement.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 5
        property int pixelSize: 20
        height: 70
        width: 350

        text: (!animation.running ? "Übung beginnen" : "Übung beenden")
        style: buttonStyle
        onClicked:
        {
            if(animation.running || root.state == "Result"){
                animation.stop()
                curve.reset()
            }
            else{
                animation.running = true
            }
            root.state = "Workout"
            timerCollision.running = animation.running
        }
    }


    state: "Workout"
    states: [
        State {
            name: "Workout"
            PropertyChanges {
                target: workoutGoal
                text:  "<i>" + ViewModel.getWorkoutTypeGoal() + "</i>"
            }
            PropertyChanges {
                target: workoutType
                text: "<b>" + "Du trainierst: " + ViewModel.getWorkoutTypeString() + "</b>"
            }
            PropertyChanges {
                target: centralDisplay
                visible: true
            }
            PropertyChanges {
                target: statusElement
                visible: true
            }
            PropertyChanges {
                target: result
                visible: false
            }
            PropertyChanges {
                target: startButton
                text: (!animation.running ? "Übung beginnen" : "Übung beenden")
            }
            PropertyChanges {
                target: slider
                value: -(curve.y + curve.height - 1.5* pacman.height)
            }
        },
        State {
            name: "Result"
            PropertyChanges {
                target: workoutGoal
                text:  "<i>Fertig!</i>"
            }
            PropertyChanges {
                target: workoutType
                text: "<b>Ergebnis</b>"
            }
            PropertyChanges {
                target: centralDisplay
                visible: false
            }
            PropertyChanges {
                target: statusElement
                visible: false
            }
            PropertyChanges {
                target: result
                visible: true
            }
            PropertyChanges {
                target: resultText
                text: {
                    var Result = Math.round(curve.collidedDotsCount / curve.passedDots.length*100)
                    var Text = "Geht so ..."
                    if (Result > 50){
                        Text = "Net schlecht."
                    }
                    if (Result > 70){
                        Text = "Sauber!"
                    }
                    if (Result > 70){
                        Text = "Bist a Viech!!!!!"
                    }


                    "<h3>Deine Ausbeute</h3></br><p style='text-align:center'><b><font size='3000'>" +
                      Result + "%</font></b></p>" +
                      "</br><p style='text-align:center'>" + Text + "</p>"
                }
            }
            PropertyChanges {
                target: startButton
                text: "Übung wiederholen"
            }
        }
    ]

    //
    //

    Component{
        id: buttonStyle
        ButtonStyle {
            //Thanks to:
            //http://stackoverflow.com/questions/25462162/creating-a-scalable-glossy-shiny-button-with-qt-quick

            property color backgroundColor: (control.hasOwnProperty("backgroundColor") ? control.backgroundColor: colorButtons)
            property color textColor: (control.hasOwnProperty("textColor") ? control.textColor :"white")
            property color textColorHover: "#ddd" //was "white"
            readonly property real radius: control.height / 5

            background: Item {
                Canvas {
                    opacity: !control.pressed ? 1 : 0.75
                    anchors.fill: parent

                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.reset();

                        ctx.beginPath();
                        ctx.lineWidth = height * 0.1;
                        ctx.roundedRect(ctx.lineWidth / 2, ctx.lineWidth / 2,
                                        width - ctx.lineWidth, height - ctx.lineWidth, radius, radius);
                        ctx.strokeStyle = "grey";
                        ctx.stroke();
                        ctx.fillStyle = backgroundColor;
                        ctx.fill();
                    }
                }

                Label {
                    text: control.text
                    color: control.hovered && !control.pressed ? textColorHover : textColor
                    textFormat: Text.RichText
                    font.pixelSize: (control.hasOwnProperty("pixelSize") ? control.pixelSize :  control.height / 2)
                    anchors.centerIn: parent
                }

                Canvas {
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.reset();

                        ctx.beginPath();
                        ctx.lineWidth = height * 0.1;
                        ctx.roundedRect(ctx.lineWidth / 2, ctx.lineWidth / 2,
                                        width - ctx.lineWidth, height - ctx.lineWidth, radius, radius);
                        ctx.moveTo(0, height * 0.4);
                        ctx.bezierCurveTo(width * 0.25, height * 0.6, width * 0.75, height * 0.6, width, height * 0.4);
                        ctx.lineTo(width, height);
                        ctx.lineTo(0, height);
                        ctx.lineTo(0, height * 0.4);
                        ctx.clip();

                        ctx.beginPath();
                        ctx.roundedRect(ctx.lineWidth / 2, ctx.lineWidth / 2,
                                        width - ctx.lineWidth, height - ctx.lineWidth,
                                        radius, radius);
                        var gradient = ctx.createLinearGradient(0, 0, 0, height);
                        gradient.addColorStop(0, "#bbffffff");
                        gradient.addColorStop(0.6, "#00ffffff");
                        ctx.fillStyle = gradient;
                        ctx.fill();
                    }
                }
            }

            label: null
        }
    }
}





