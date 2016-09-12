import QtQuick 2.7
import QtGraphicalEffects 1.0

Rectangle  {
    id:root
    height: 30
    width: height
    color: "#00FFFFFF"


    Canvas{
        id:myCanvas
        anchors.fill: parent
        smooth: true;
        antialiasing: true;


        property real angleDegreeStart: 30
        property real angleDegree: angleDegreeStart
        property bool decreasing: true
        property real increment: 1.0
        property real intervall: 10.0

        onPaint: {
            var ctx = getContext("2d")

            //Clean the Canvas
            //context.clearRect (0, 0, width, height);
            ctx.reset()

            //20 looked nice on 500 height
            ctx.lineWidth = 20 * (height / 500)

            //Translates and scales to account for the LineWidth
            var Spacing = ctx.lineWidth/2
            ctx.translate(Spacing,Spacing)
            var ScaleFactor = (height-2*Spacing)/height
            ctx.scale(ScaleFactor,ScaleFactor)


            var Angle = myCanvas.angleDegree * Math.PI / 180
            var Radius = height/2

            //Offsets for the Startposition of the Arc
            var x = (1 + Math.cos(Angle)) * Radius;
            var y = (1+Math.sin(Angle)) * Radius;

            ctx.strokeStyle = "black"

            //Rounded edges
            ctx.lineJoin="round";

            //Move to Startposition of the Arc
            ctx.moveTo(x, y);

            //Draw the Arc
            ctx.arc(Radius,Radius,Radius,Angle,-Angle,false)

            //Line to Center
            ctx.lineTo(Radius,Radius)

            //Close the lines
            ctx.closePath()


            ctx.stroke()

            //Constrict everything to the drawn outline
            ctx.clip()

            //30 loooked good at height 500
            var GradientOffset = 30 * (height / 500)
            //Add a Radial Gradient with a little offset to the upper right, to get a 3D-Effect
            var gradient=ctx.createRadialGradient(Radius,Radius,0,Radius + GradientOffset,Radius - GradientOffset,Radius);
            gradient.addColorStop(0.0,"#fcfc00");
            gradient.addColorStop(0.9,"#c4c400");
            gradient.addColorStop(1,"#676700");
            ctx.fillStyle = gradient
            ctx.fill()


            //Draw the eye
            ctx.beginPath()
            ctx.ellipse(Radius,Radius/4,Radius/4,Radius/4)
            ctx.fillStyle = "black"
            ctx.fill()



        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                myTimer.running = !myTimer.running
            }
        }

        Timer{
            id: myTimer
            interval: myCanvas.intervall
            repeat: true

            onTriggered: {
                myCanvas.angleDegree += (myCanvas.decreasing ? -1 : 1) * myCanvas.increment


                // console.log("Angle: " + myCanvas.angleDegree)
                if(myCanvas.angleDegree <= 1.0){
                    myCanvas.decreasing = false
                }
                else if(myCanvas.angleDegree >= myCanvas.angleDegreeStart){
                    myCanvas.decreasing=true
                }
                myCanvas.requestPaint()


                //Save the current canvas to a png to create a gif from it
                //Created an animated Gif at http://gifmaker.me/
                //Made the Background transparent on the same webpage
                var Index =  (myCanvas.decreasing ?  myCanvas.angleDegree : myCanvas.angleDegreeStart - myCanvas.angleDegree)
                Index = (Index < 10 ? "0":"") + Index
                var FileName = "c:/Pacman" + (myCanvas.decreasing ? 0 : 1) + Index + ".png"
                if( myCanvas.save(FileName)){

                    console.log("Saved Angle: " + FileName)
                }
                else{
                    console.log("Not saved Angle: " + myCanvas.angleDegree)

                }
            }
        }
    }
}
