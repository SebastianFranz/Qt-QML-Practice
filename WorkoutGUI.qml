import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Particles 2.0
import QtQuick.Controls.Styles 1.2

Item {
    id: root
    height: 480
    width: 800

    Button{
        id:buttonLogout2
        style: buttonStyle22
        anchors.right: parent.right
        text: "Logout"
        Layout.preferredHeight: 200
        Layout.preferredWidth: 500
        height: 200
        width: 500
}

    Component{
        id: buttonStyle22
        ButtonStyle {
            property color backgroundColor: "black"  //was "#00c0f5"
            property color textColor: "gold" //was "#ddd"
            property color textColorHover: "#ddd" //was "white"

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
                                        width - ctx.lineWidth, height - ctx.lineWidth, control.radius, control.radius);
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
                                        width - ctx.lineWidth, height - ctx.lineWidth, control.radius, control.radius);
                        ctx.moveTo(0, height * 0.4);
                        ctx.bezierCurveTo(width * 0.25, height * 0.6, width * 0.75, height * 0.6, width, height * 0.4);
                        ctx.lineTo(width, height);
                        ctx.lineTo(0, height);
                        ctx.lineTo(0, height * 0.4);
                        ctx.clip();

                        ctx.beginPath();
                        ctx.roundedRect(ctx.lineWidth / 2, ctx.lineWidth / 2,
                                        width - ctx.lineWidth, height - ctx.lineWidth,
                                        control.radius, control.radius);
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


    Text{
        id: result
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: false
    }



        Column{
            visible:  false

            anchors.fill: parent
        Item{
            anchors.left: parent.left
            anchors.right: parent.right
            height: 50

            Text{
                id:workoutGoal
                font.family: "Ubuntu"
                font.pixelSize: 28
                color: "#303030"
                anchors.verticalCenter: parent.verticalCenter
                text: "WorkoutGoal"
            }
            Button{
                id:buttonLogout
                style: buttonStyle
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                text: "Logout"
                Layout.preferredHeight: 20
                Layout.preferredWidth: 50
                height: 20
                width: 50

            }
            Text{
                id:userName
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: buttonLogout.left
                anchors.margins: 10
                text: "Name"
            }
            Image{
                id:userImage
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: userName.left
                anchors.margins: 10
            }
        }
        Text{
            id:workoutType
            text: "WorkoutType"
           // Layout.topMargin: 50
        }
        Rectangle{
            id:seperator
            anchors.left: parent.left
            anchors.right: parent.right
            height: 2
            color: "black"
        }

        RowLayout{
            id:centralDisplay
            anchors.margins: 10
            anchors.right: parent.right
            anchors.left: parent.left
            spacing: 30

            Slider{
                // anchors.bottom: parent.bottom
                // anchors.left: parent.left
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
                border.width: 2
                radius: 10
                Layout.fillWidth: true
                //width: 300
                //anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
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


            ColumnLayout{
                id: weightAdjustments
                //anchors.right: parent.right
                width: 200
                spacing: 20



                Button{
                    text: "+ " + ViewModel.getBigValue()
                    onClicked: ViewModel.increaseWeight(ViewModel.getBigValue())
                }
                Button{
                    text: "+"

                    onClicked: ViewModel.increaseWeight(1)
                }
                Text{
                    id: textWeight1
                    text: "Weight 1"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text{
                    id: textWeight2
                    text: "Weight 2"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Button{
                    text: "-"
                    onClicked: ViewModel.decreaseWeight(1)
                }
                Button{
                    text: "- " + ViewModel.getBigValue()
                    onClicked: ViewModel.decreaseWeight(ViewModel.getBigValue())
                }
            }
        }
        RowLayout{
            Text{
                text: "State"
            }
            ProgressBar{
                Layout.fillWidth: true
            }
            Text{
                text: "Repetition Progression"
            }
        }

        RowLayout{

            height: 100
            Button{

                height: 100
                anchors.fill: parent
                //anchors.horizontalCenter: parent.horizontalCenter
                text:  "Start / Stop"
                style: buttonStyle
                onClicked:
                {
                    animation.running = !animation.running
                    timerCollision.running = !timerCollision.running
                }
            }

        }

        Component {
            id: buttonStyle3
            ButtonStyle {

                background: Rectangle {
                    implicitHeight: 220
                    implicitWidth: window.width / columnFactor
                    color: control.pressed ? "darkGray" : control.activeFocus ? "#cdd" : "#ccc"
                    antialiasing: true
                    border.color: "gray"
                    radius: height/2
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1
                        color: "transparent"
                        antialiasing: true
                        visible: !control.pressed
                        border.color: "#aaffffff"
                        radius: height/2
                    }
                }
            }
        }
        Component {
            id: buttonStyle1
            ButtonStyle {
                background: Item {
                    Canvas {
                        anchors.fill: parent

                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.reset();

                            ctx.beginPath();
                            ctx.lineWidth = height * 0.1;
                            ctx.roundedRect(ctx.lineWidth / 2, ctx.lineWidth / 2,
                                            width - ctx.lineWidth, height - ctx.lineWidth, control.radius, control.radius);
                            ctx.strokeStyle = "grey";
                            ctx.stroke();
                            ctx.fillStyle = "#00c0f5";
                            ctx.fill();
                        }
                    }

                    Label {
                        text: control.text
                        color: "#ddd"
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
                                            width - ctx.lineWidth, height - ctx.lineWidth, control.radius, control.radius);
                            ctx.moveTo(0, height * 0.4);
                            ctx.bezierCurveTo(width * 0.25, height * 0.6, width * 0.75, height * 0.6, width, height * 0.4);
                            ctx.lineTo(width, height);
                            ctx.lineTo(0, height);
                            ctx.lineTo(0, height * 0.4);
                            ctx.clip();

                            ctx.beginPath();
                            ctx.roundedRect(ctx.lineWidth / 2, ctx.lineWidth / 2,
                                            width - ctx.lineWidth, height - ctx.lineWidth,
                                            control.radius, control.radius);
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


        Component {
            id: buttonStyle2
            ButtonStyle {

                background:
                    Rectangle {
                    id: button12
                    anchors.centerIn: parent
                    signal clicked
                    property alias text: btnText.text

                    // height: 500
                    //radius: 10
                    //border.color:"#6a6363"
                    smooth: true
                    border.color: "#22FFFFFF"

                    gradient: off

                    Gradient {
                        id:off
                        /*  GradientStop { position: 0.0; color: "lightsteelblue" }
                                   GradientStop { position: 0.5; color: "lightsteelblue" }
                                   GradientStop { position: 0.5; color: "black" }
                                   GradientStop { position: 1.0; color: "black" }*/


                        GradientStop { position: 0;    color: "#88FFFF" }
                        GradientStop { position: .1;   color: "#55FFFF" }
                        GradientStop { position: .5;   color: "#33FFFF" }
                        GradientStop { position: .501; color: "#110000" }
                        GradientStop { position: .8;   color: "#11FFFF" }
                        GradientStop { position: 1;    color: "#55FFFF" }
                    }


                    Gradient {
                        id:onn
                        GradientStop { position: 0.0; color: "steelblue" }
                        GradientStop { position: 0.5; color: "steelblue" }
                        GradientStop { position: 0.5; color: "black" }
                        GradientStop { position: 1.0; color: "black" }
                    }

                    Text {
                        id:btnText
                        anchors.centerIn:parent
                        color:"white"
                        //text: "text"
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked:  {
                            button.clicked();

                            console.log("clicked")
                        }

                        onEntered:{
                            button.gradient=onn
                            border.color= "steelblue"
                            console.log("entered")
                        }

                        onCanceled:{
                            border.color= "#6a6363"
                            button.gradient=off
                        }

                        onExited: {
                            border.color= "#6a6363"
                            button.gradient=off
                        }

                    }
                }
                /*Rectangle {
                height: 500
                width : 500
                color: "green"
                radius: 10 // '0' to square and 'width/2' to round
                smooth: true
                border.color: "#22000000"
                border.width: 6
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width - parent.border.width
                    height: parent.height - parent.border.width
                    radius:parent.radius - parent.border.width/2
                    smooth: true

                    border.width: parent.border.width/2
                    border.color: "#22FFFFFF"

                    gradient: Gradient {
                        GradientStop { position: 0;    color: "#88FFFFFF" }
                        GradientStop { position: .1;   color: "#55FFFFFF" }
                        GradientStop { position: .5;   color: "#33FFFFFF" }
                        GradientStop { position: .501; color: "#11000000" }
                        GradientStop { position: .8;   color: "#11FFFFFF" }
                        GradientStop { position: 1;    color: "#55FFFFFF" }
                    }
                }
            }*/

                /*     Rectangle {
                id: button12
                signal clicked
                property alias text: btnText.text

                height: 50
                //radius: 10
                border.color:"#6a6363"

                gradient: off

                Gradient {
                    id:off
                    GradientStop { position: 0.0; color: "lightsteelblue" }
                    GradientStop { position: 0.5; color: "lightsteelblue" }
                    GradientStop { position: 0.5; color: "black" }
                    GradientStop { position: 1.0; color: "black" }
                }

                Gradient {
                    id:onn
                    GradientStop { position: 0.0; color: "steelblue" }
                    GradientStop { position: 0.5; color: "steelblue" }
                    GradientStop { position: 0.5; color: "black" }
                    GradientStop { position: 1.0; color: "black" }
                }

                Text {
                    id:btnText
                    anchors.centerIn:parent
                    color:"white"
                    text: "text"
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked:  {
                        button.clicked();
                    }

                    onEntered:{
                        button.gradient=onn
                        border.color= "steelblue"
                    }

                    onCanceled:{
                        border.color= "#6a6363"
                        button.gradient=off
                    }

                    onExited: {
                        border.color= "#6a6363"
                        button.gradient=off
                    }

                }

            }*/
            }
        }
    }




    Component{
        //Thanks to:
        //http://stackoverflow.com/questions/25462162/creating-a-scalable-glossy-shiny-button-with-qt-quick

        id: buttonStyle
        ButtonStyle {
            property color backgroundColor: "black"  //was "#00c0f5"
            property color textColor: "gold" //was "#ddd"
            property color textColorHover: "#ddd" //was "white"

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
                                        width - ctx.lineWidth, height - ctx.lineWidth, control.radius, control.radius);
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
                                        width - ctx.lineWidth, height - ctx.lineWidth, control.radius, control.radius);
                        ctx.moveTo(0, height * 0.4);
                        ctx.bezierCurveTo(width * 0.25, height * 0.6, width * 0.75, height * 0.6, width, height * 0.4);
                        ctx.lineTo(width, height);
                        ctx.lineTo(0, height);
                        ctx.lineTo(0, height * 0.4);
                        ctx.clip();

                        ctx.beginPath();
                        ctx.roundedRect(ctx.lineWidth / 2, ctx.lineWidth / 2,
                                        width - ctx.lineWidth, height - ctx.lineWidth,
                                        control.radius, control.radius);
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



