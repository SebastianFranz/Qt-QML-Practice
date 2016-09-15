import QtQuick 2.0

Canvas {
    id: myCanvas
    height: 200
    width: 3 * height * ViewModel.getRepetitions()
    antialiasing: true
    smooth: true

    property variant collidedDots:[]
    property variant dots:[]


    MouseArea {
        anchors.fill: parent
        onClicked:
        {

        }
    }




    //Checks if the Rectangle collides with a dot, adds it to the collided dots and returns a boolean
    function checkForCollision(Rectangle){
        //Distance of the Centers has to be lower than combined radiuses (with pythagoras)
        var XCenterRect = Rectangle.parent.mapToItem(myCanvas,Rectangle.x,Rectangle.y).x - Rectangle.width/2
        var YCenterRect = Rectangle.parent.mapToItem(myCanvas,Rectangle.x,Rectangle.y).y - Rectangle.width/2
        var MaximalCollisionDistance = Math.pow(Rectangle.width/2 + dots[0].radius,2)


        for (var i = 0; i < dots.length; ++i) {
            var Dot = dots[i]
            //HMPF - dont't ask me why ... but it works ... but I don't like things I don't understand ....
            var XCenter = Dot.x - Dot.radius - 11
            var YCenter = Dot.y - Dot.radius - 10



            var DistanceOfCenters = Math.pow(XCenterRect - XCenter,2) + Math.pow(YCenterRect - YCenter,2)
            //console.log("DistanceOfCenters: " + DistanceOfCenters + " MaximalCollisionDistance: " + Math.sqrt(MaximalCollisionDistance) );

            if(DistanceOfCenters < MaximalCollisionDistance){
                //console.log("Collision detected!!!!");

                if(collidedDots.length == 0 || collidedDots[collidedDots.length - 1] != Dot){
                    //console.log("Dot added. DotCount: " + collidedDots.length);

                    collidedDots.push(Dot)
                    Dot.color = "#0dff3a"
                }

                return true;
            }

            //console.log(dots.children[i].color = "#82ea12");
        }
    }

    //That's an ugly beast ... normally i would refactor it, but the focus is on learning not style
    onPaint:
    {
        var context = getContext("2d")

        context.lineWidth = ViewModel.getLineWidth()
        context.strokeStyle = "black"
        context.lineCap = "round"


        var Y1 = height
        var Y2 = 0


        var X = ViewModel.getLinearLength() * Y1
        var R = ViewModel.getRadius() * Y1
        var A0 = Math.PI/2


        var AnglePositiveRad = ViewModel.getAnglePositive() * Math.PI / 180
        var AngleNegativeRad = ViewModel.getAngleNegative() * Math.PI / 180

        //Calculating the offsets for points where a Radius tangents the line
        var OffsetRadiusPositiveX = Math.tan(AnglePositiveRad/2) * R
        var OffsetRadiusNegativeX = Math.tan(AngleNegativeRad/2) * R


        var OffsetPositive = Y1 / Math.tan(AnglePositiveRad) + OffsetRadiusPositiveX * 2
        var OffsetNegative = Y1 / Math.tan(AngleNegativeRad) + OffsetRadiusNegativeX * 2
        var TotalOffset = OffsetPositive + OffsetNegative

        var TotalLength = X * 2 + TotalOffset * ViewModel.getRepetitions()



        //Set Scale and Transformation to account for the lineWidth
        var ScaleFactor = (height - ViewModel.getLineWidth()) / height

        //ScaleFactor to compensate for the changed width ... weird, but works nicely
        var ScaleFactorWidth = myCanvas.width / ((TotalLength + ViewModel.getLineWidth()) * ScaleFactor)
        context.scale(ScaleFactorWidth, 1)
        myCanvas.width = TotalLength * ScaleFactor

        context.scale(ScaleFactor,ScaleFactor)
        context.translate(ViewModel.getLineWidth()/2,ViewModel.getLineWidth()/2)


        /*  //Flip the Y-Values and the Radius directions if it starts at the top
        var CounterClockWise = true
        if(!ViewModel.getStartsAtBottom()){
            var Y1 = 0
            var Y2 = height
            Counterclockwise = false
        }*/

        context.beginPath()
        // Move to Startpoint, if it does not start at the bottom it will be mirrored later on
        context.moveTo(0,Y1)


        //First Radius (lines will be drawn automatically)
        context.arc(X, Y1 - R, R, A0, Math.PI/2 - AnglePositiveRad, true)

        for(var i = 0; i < ViewModel.getRepetitions(); i++){
            //Top Radius
            //-PI because the Angle are facing the other direction at the top
            var StartAngleTop = 3/2 * Math.PI - AnglePositiveRad
            var EndAngleTop = 3/2 * Math.PI + AngleNegativeRad
            context.arc(X + TotalOffset * i + OffsetPositive,Y2 + R, R, StartAngleTop, EndAngleTop, false)

            //to get rid of the last radius, as it has to be special
            if(i == ViewModel.getRepetitions()-1) continue

            //Bottom Radius
            var StartAngleBottom = Math.PI/2 + AngleNegativeRad
            var EndAngleBottom =  Math.PI/2 - AnglePositiveRad
            context.arc(X + TotalOffset * (i + 1), Y1 - R, R, StartAngleBottom , EndAngleBottom , true)
        }

        //Last Radius
        context.arc(TotalLength - X, Y1 - R, R, StartAngleBottom, Math.PI/2, true)

        //Last linear bit
        context.lineTo(TotalLength,Y1)

        context.stroke()


        //Darw the Path-Dots
        //context.fillStyle = "red"
        //context.beginPath()

        //Diameter of the ellipse
        var D = ViewModel.getLineWidth()/2

        var OffsetRadiusPositiveY = (1 - Math.cos(AnglePositiveRad/2)) * R
        var OffsetRadiusNegativeY = (1 - Math.cos(AngleNegativeRad/2)) * R

        //Don't ask my why this is necessary ....
        //Makes me a bit sick ... but works perfectly - non the less WTF!!!!
        var ScaleFactorX = ScaleFactor-0.018*(2040/TotalLength)
        var DotColor = "Gold"

        for(var i = 0; i < ViewModel.getRepetitions(); i++){
            //Not sure which ones I like best, so I leave them in there
            //context.ellipse(X + TotalOffset * i + OffsetRadiusPositiveX/2 - D/2, Y1 - OffsetRadiusPositiveY / 2 + (ViewModel.getLineWidth() - D) / 2, D, -D)
            //context.ellipse(X + TotalOffset * i + OffsetPositive - OffsetRadiusNegativeX/2 - D/2, Y2 + OffsetRadiusNegativeY / 2 + (ViewModel.getLineWidth() - D) / 2, D, -D)

            /*context.ellipse(X + TotalOffset * i - D/2, Y1 + D/2, D, -D)
            context.ellipse(X + TotalOffset * i + OffsetPositive/2 - D/2, (Y1 + Y2)/2 + D/2, D, -D)
            context.ellipse(X + TotalOffset * i + OffsetPositive  - D/2, Y2 + D/2, D, -D)
            context.ellipse(X + TotalOffset * (i+1) - OffsetNegative/2 - D/2, (Y1 + Y2)/2 + D/2, D, -D)*/



            dots.push(Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "' + DotColor + '"; x: ' +(X + TotalOffset * i + D/2)*ScaleFactorX +
                                         '; y: ' + (Y1 + D/2)*ScaleFactor + '; width: ' + D*ScaleFactor + '; height: ' + D*ScaleFactor +
                                         '; radius: ' + D/2*ScaleFactor + '}',myCanvas))
            dots.push(Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "' + DotColor + '"; x: ' + (X + TotalOffset * i + OffsetPositive/2 + D/2)*ScaleFactorX +
                                         '; y: ' + ((Y1 + Y2)/2 + D/2)*ScaleFactor + '; width: ' + D*ScaleFactor + '; height: ' + D*ScaleFactor +
                                         '; radius: ' + D/2*ScaleFactor + '}',myCanvas))
            dots.push(Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "' + DotColor + '"; x: ' + (X + TotalOffset * i + OffsetPositive + D/2)*ScaleFactorX +
                                         '; y: ' + (Y2 + D/2)*ScaleFactor + '; width: ' + D*ScaleFactor + '; height: ' + D*ScaleFactor +
                                         '; radius: ' + D/2*ScaleFactor + '}',myCanvas))
            dots.push(Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "' + DotColor + '"; x: ' + (X + TotalOffset * (i+1) - OffsetNegative/2 + D/2)*ScaleFactorX +
                                         '; y: ' + ((Y1 + Y2)/2 + D/2)*ScaleFactor + '; width: ' + D*ScaleFactor + '; height: ' + D*ScaleFactor +
                                         '; radius: ' + D/2*ScaleFactor + '}',myCanvas))


        }
        // context.ellipse(X + TotalOffset * ViewModel.getRepetitions() - OffsetRadiusPositiveX/2 - D/2, Y1 - + OffsetRadiusPositiveY / 2 + (ViewModel.getLineWidth() - D) / 2, D, -D)
        // context.ellipse(X + TotalOffset * i - D/2, Y1 + D/2, D, -D)
        dots.push(Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "' + DotColor + '"; x: ' + (X + TotalOffset * i + D/2)*ScaleFactorX +
                                     '; y: ' + (Y1 + D/2)*ScaleFactor + '; width: ' + D*ScaleFactor + '; height: ' + D*ScaleFactor +
                                     '; radius: ' + D/2*ScaleFactor + '}',myCanvas))
        //context.fill()

    }
}
