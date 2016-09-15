import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Particles 2.0
import QtQuick.Controls.Styles 1.2

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

    property int competedRepetitions: 0
    property real progress: 0




    Text{
        id: result
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: false
    }



  /*  Column{
        spacing: 10
        anchors.fill: parent*/

        Item{
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            height: 95

            Text{
                id:workoutGoal
                font.pixelSize: 70
                font.family: fontFamily
                color: fontColor
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenterOffset: 5
                text: "<i>" + "Athletik_" + "</i>"
            }
            Button{
                id:buttonLogout
                style: buttonStyle
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 10
                text: "Abmelden"
                height: 50
                width: 150
            }
            Text{
                id:userName
                font.family: fontFamily
                color: fontColor
                anchors.verticalCenter: buttonLogout.verticalCenter
                anchors.right: buttonLogout.left
                anchors.margins: 10
                text: "<i>" + "Toni_" + "</i>"
                font.pixelSize: 25
            }
            Image{
                id:userImage
                anchors.verticalCenter: buttonLogout.verticalCenter
                anchors.right: userName.left
                anchors.margins: 10
                height: userName.height
                width: height
            }
        }

        Rectangle{
            id:separatingElement
            anchors.left: parent.left
            anchors.right: parent.right
            height: 45
            color: backgroundColorGraph

            Text{
                id:workoutType
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left

                anchors.margins: 10
                text: "<b>" + "Du trainierst: " + "Negativ_" + "</b>"
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
            anchors.margins: 10
            anchors.right: parent.right
            anchors.left: parent.left
            spacing: 30
            height: 320

            Slider{
                id: slider
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
                anchors.rightMargin: 40
                anchors.leftMargin: 20
                clip: true

                DrawnCurve {
                    id: curve
                    anchors.bottom: parent.bottom


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
                }



                AnimatedImage  {
                    id: pacman
                    source: "Pacman.gif"
                    x: 20
                    height: 30
                    width: 30
                    NumberAnimation on x {
                        to: 120
                        duration: 2000
                        running: true
                    }

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


            Column{
                id: weightAdjustments
                spacing: 5
                property int contentWidth: 140
                property int contentHeigth: 40
                anchors.right: parent.right
                anchors.rightMargin: 40

                Button{
                    style: buttonStyle
                    text: "<b>+ " + ViewModel.getBigValue() + "</b>"
                    height:  parent.contentHeigth
                    width: parent.contentWidth
                    onClicked: ViewModel.increaseWeight(ViewModel.getBigValue())
                }
                Button{
                    style: buttonStyle
                    text: "<b>+"
                    height:  parent.contentHeigth
                    width: parent.contentWidth
                    onClicked: ViewModel.increaseWeight(1)
                }
                Rectangle{
                    border.color: backgroundColorGraph
                    border.width: 2
                    radius: height/5
                    height:  parent.contentHeigth
                    width: parent.contentWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: backgroundColor

                    Text{
                        id: textWeight1
                        anchors.centerIn: parent
                        text: "34 kg_"
                        font.bold:  true
                        font.family: fontFamily
                        color: fontColor
                        font.pixelSize: 20
                    }
                }

                Rectangle{
                    border.color: backgroundColorGraph
                    border.width: 1
                    radius: height/5
                    height:  parent.contentHeigth
                    width: parent.contentWidth
                    color: backgroundColor

                    Text{
                        id: textWeight2
                        anchors.centerIn: parent
                        text: "51 kg_"
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
                }
                Button{
                    style: buttonStyle
                    text: "<b>- " + ViewModel.getBigValue() + "</b>"
                    height:  parent.contentHeigth
                    width: parent.contentWidth
                    onClicked: ViewModel.decreaseWeight(ViewModel.getBigValue())
                }
            }
        }
        Rectangle{
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
                value: 0.6

                style:
                    ProgressBarStyle {
                    background: Rectangle {
                        color:colorButtons
                    }
                    progress: Rectangle {
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
                width: 80
                color: backgroundColor
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    font.family: fontFamily
                    color: fontColor
                    font.pixelSize: parent.height * 0.6
                    text: "<b>" + competedRepetitions + "</b> / " + ViewModel.getRepetitions()
                }
            }
        }


            Button{
                anchors.horizontalCenter: parent.horizontalCenter
                height: 60
                width: root.width/3

                text: (!animation.running ? "Übung beginnen" : "Übung beenden")
                style: buttonStyle
                onClicked:
                {
                    animation.running = !animation.running
                    timerCollision.running = !timerCollision.running


            }
        }


        Component{
            id: buttonStyle
            ButtonStyle {
                //Thanks to:
                //http://stackoverflow.com/questions/25462162/creating-a-scalable-glossy-shiny-button-with-qt-quick

                property color backgroundColor: colorButtons
                property color textColor: "white"
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
                        font.pixelSize: control.height * 0.5
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
//}




