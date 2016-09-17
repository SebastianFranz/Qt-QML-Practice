import QtQuick 2.7
import QtGraphicalEffects 1.0

Rectangle  {
    id:root
    height: 25
    width: height
    color: "#00FFFFFF"


    Canvas{
        id:myCanvas
        anchors.fill: parent
        smooth: true;
        antialiasing: true;

        onPaint: {
            var ctx = getContext("2d")


            //OuterRadius = Offset
            var ro = height/2
            //InnerRadius
            var ri = ro/2
            //5 jags with 5 intermitting angles
            var a = 360/10 *(Math.PI / 180)
            ctx.translate(5,0)

            ctx.lineWidth = 0.5
            ctx.strokeStyle = "black"
            ctx.fillStyle = "gold"

            //Sharp edges
            ctx.lineJoin="miter";

            ctx.beginPath()

            var OffsetAngle = Math.PI

            for(var i=0; i<10; i++){
                //On even i take outer radius
                var r = (i % 2 == 0 ? ro : ri)
                ctx.lineTo(ro + Math.sin(i*a + OffsetAngle) * r ,ro + Math.cos(i*a + OffsetAngle) * r)
            }

            ctx.closePath()

            ctx.fill()
            ctx.stroke()
        }
        MouseArea{
            anchors.fill: parent

            onDoubleClicked: {

                var FileName = "c:/Star.png"
                if( myCanvas.save(FileName)){

                    console.log("Saved: " + FileName)
                }
                else{
                    console.log("Not saved: " + FileName)

                }            }
        }
    }
}
