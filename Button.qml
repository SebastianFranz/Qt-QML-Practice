import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import QtQuick.Layouts 1.3

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

    ColumnLayout{

        Button {
            id: buttonID
            Layout.preferredWidth: 150
            Layout.preferredHeight: 50
            anchors.centerIn: parent
            text: "Button"
            style: buttonStyle

            readonly property real radius: height / 5


        }

        Component{
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
}
