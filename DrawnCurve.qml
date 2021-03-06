import QtQuick 2.0

Canvas {
    id: myCanvas
    height: 200
    width: 3 * height * ViewModel.getRepetitions()
    antialiasing: true
    smooth: true

    property color pathColor: "black"
    property color dotColor: "gold"
    property color collidedDotColor: Qt.darker("#0dff3a")
    property int dotDiameter: 0

    property int collidedDotsCount: 0
    property variant passedDots:[]
    property variant dots:[]

    property real progress: 0
    property int completedRepetitions: 0
    property bool isOnPositvePath: true

    property real firstX: 0
    property real totalDistance: 0

    function reset(){
        x = 0
        collidedDotsCount = 0
        progress = 0
        completedRepetitions = 0
        isOnPositvePath = true
        firstX = 0
        totalDistance = 0

        //Reset the color and shift them back to the dots
        while (passedDots.length != 0) {
            var passedDot = passedDots.pop()
            passedDot.color = dotColor
            passedDot.height = dotDiameter
            passedDot.width = dotDiameter
            passedDot.border.width = 0
            dots.unshift(passedDot)

        }
    }


    //Checks if the Rectangle collides with a dot, adds it to the collided dots and returns a boolean
    function checkForCollision(Rectangle){
        //Set first X and totalDistance on first Execution, to calculate the progress
        if(firstX == 0){
            firstX = dots[0].x
            totalDistance = dots[dots.length-1].x - firstX + dots[0].radius;
        }

        //Distance of the Centers has to be lower than combined radiuses (with pythagoras)
        var XCenterRect = Rectangle.parent.mapToItem(myCanvas,Rectangle.x,Rectangle.y).x - Rectangle.width/2
        var YCenterRect = Rectangle.parent.mapToItem(myCanvas,Rectangle.x,Rectangle.y).y - Rectangle.width/2

        //Set progress
        progress =  (XCenterRect - firstX) / totalDistance;


        if(dots.length == 0) return;
        var MaximalCollisionDistance = Math.pow(Rectangle.width/2 + dots[0].radius,2)


        for (var i = 0; i < dots.length; ++i) {
            var Dot = dots[i]
            //HMPF - dont't ask me why ... but it works ... but I don't like things I don't understand ....
            var XCenter = Dot.x - Dot.radius - 11
            var YCenter = Dot.y - Dot.radius - 10

            //check if the dot was allready passed, if so remove it and insert it at the passedDots
            if(XCenterRect - Rectangle.width/2 - XCenter - Dot.radius > 0){
                //console.log("Dot passed collidedDotsCount: " + collidedDotsCount);
                passedDots.push(Dot);
                dots.splice(i,1);
                i--;
                continue;
            }


            //check if dot is reachable, if not exit
            if(XCenterRect + Rectangle.width/2 < XCenter - Dot.radius){
                //console.log("Dot not in range collidedDotsCount: " + collidedDotsCount);
                return false;
            }

            //Set repetitions. As we did not exit, the point is within reach and can be mentally added
            //(as the first dot has to be substracted anyway it won't show)
            completedRepetitions = Math.floor(passedDots.length / 4)


            //Set isOnPositvePath - again the next dot is within reach, but not yet past, so mentally add it
            isOnPositvePath = passedDots.length % 4 < 2


            var DistanceOfCenters = Math.pow(XCenterRect - XCenter,2) + Math.pow(YCenterRect - YCenter,2)
            //console.log("DistanceOfCenters: " + DistanceOfCenters + " MaximalCollisionDistance: " + Math.sqrt(MaximalCollisionDistance) );

            if(DistanceOfCenters < MaximalCollisionDistance){
                //console.log("Collision detected!!!!");

                collidedDotsCount ++
                //console.log("Dot collided. collidedDotsCount: " + collidedDotsCount);
                passedDots.push(Dot)
                dots.splice(i,1);
                eatenDotFirst.target=Dot
                eatenDot.restart()


                return true;
            }
        }
    }


    SequentialAnimation{
        property QtObject target:myCanvas

        id: eatenDot

        ParallelAnimation{
            NumberAnimation{
                id: eatenDotFirst
                //myCanvas is only a placeholder to get rid of an Error on initialisation
                target: myCanvas
                properties: "width,height"
                to:1
                duration: 200
            }
            NumberAnimation{
                target: eatenDotFirst.target
                properties: "y"
                from: target.y
                to:target.y+target.height/2
                duration: eatenDotFirst.duration
            }
        }
        ParallelAnimation{
            NumberAnimation{
               id: eatendotSecond
                target: eatenDotFirst.target
                properties: "width,height"
                to:dotDiameter
                duration: 100
                easing:OutBack
            }
            NumberAnimation{
                target: eatenDotFirst.target
                properties: "y"
                to:target.y
                duration: eatendotSecond.duration
            }

            ColorAnimation {
                target: eatenDotFirst.target
                properties: "color"
                to: collidedDotColor
                duration: eatendotSecond.duration
            }

            NumberAnimation{
                target: eatenDotFirst.target
                properties: "border.width"
                to:3
                duration: eatendotSecond.duration
            }

            ColorAnimation {
                target: eatenDotFirst.target
                properties: "border.color"
                from: target.color
                to: Qt.lighter(collidedDotColor)
                duration: eatendotSecond.duration
            }
        }
    }

    //That's an ugly beast ... normally i would refactor it, but the focus is on learning not style
    onPaint:
    {
        var context = getContext("2d")

        context.lineWidth = ViewModel.getLineWidth()
        context.strokeStyle = pathColor
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


            //Bottom Radius
            var StartAngleBottom = Math.PI/2 + AngleNegativeRad
            var EndAngleBottom =  Math.PI/2 - AnglePositiveRad


            //to get rid of the last radius, as it has to be special
            if(i == ViewModel.getRepetitions()-1) continue
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
        dotDiameter = D*ScaleFactor


        var OffsetRadiusPositiveY = (1 - Math.cos(AnglePositiveRad/2)) * R
        var OffsetRadiusNegativeY = (1 - Math.cos(AngleNegativeRad/2)) * R

        //Don't ask my why this is necessary ....
        //Makes me a bit sick ... but works perfectly - non the less WTF!!!!
        var ScaleFactorX = ScaleFactor-0.018*(2040/TotalLength)

        for(var i = 0; i < ViewModel.getRepetitions(); i++){
            //Not sure which ones I like best, so I leave them in there
            //context.ellipse(X + TotalOffset * i + OffsetRadiusPositiveX/2 - D/2, Y1 - OffsetRadiusPositiveY / 2 + (ViewModel.getLineWidth() - D) / 2, D, -D)
            //context.ellipse(X + TotalOffset * i + OffsetPositive - OffsetRadiusNegativeX/2 - D/2, Y2 + OffsetRadiusNegativeY / 2 + (ViewModel.getLineWidth() - D) / 2, D, -D)

            /*context.ellipse(X + TotalOffset * i - D/2, Y1 + D/2, D, -D)
            context.ellipse(X + TotalOffset * i + OffsetPositive/2 - D/2, (Y1 + Y2)/2 + D/2, D, -D)
            context.ellipse(X + TotalOffset * i + OffsetPositive  - D/2, Y2 + D/2, D, -D)
            context.ellipse(X + TotalOffset * (i+1) - OffsetNegative/2 - D/2, (Y1 + Y2)/2 + D/2, D, -D)*/



            dots.push(Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "' + dotColor + '"; x: ' +(X + TotalOffset * i + D/2)*ScaleFactorX +
                                         '; y: ' + (Y1 + D/2)*ScaleFactor + '; width: ' + D*ScaleFactor + '; height: ' + D*ScaleFactor +
                                         '; radius: ' + D/2*ScaleFactor + '}',myCanvas))

            dots.push(Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "' + dotColor + '"; x: ' + (X + TotalOffset * i + OffsetPositive/2 + D/2)*ScaleFactorX +
                                         '; y: ' + ((Y1 + Y2)/2 + D/2)*ScaleFactor + '; width: ' + D*ScaleFactor + '; height: ' + D*ScaleFactor +
                                         '; radius: ' + D/2*ScaleFactor + '}',myCanvas))

            dots.push(Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "' + dotColor + '"; x: ' + (X + TotalOffset * i + OffsetPositive + D/2)*ScaleFactorX +
                                         '; y: ' + (Y2 + D/2)*ScaleFactor + '; width: ' + D*ScaleFactor + '; height: ' + D*ScaleFactor +
                                         '; radius: ' + D/2*ScaleFactor + '}',myCanvas))

            dots.push(Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "' + dotColor + '"; x: ' + (X + TotalOffset * (i+1) - OffsetNegative/2 + D/2)*ScaleFactorX +
                                         '; y: ' + ((Y1 + Y2)/2 + D/2)*ScaleFactor + '; width: ' + D*ScaleFactor + '; height: ' + D*ScaleFactor +
                                         '; radius: ' + D/2*ScaleFactor + '}',myCanvas))


        }
        // context.ellipse(X + TotalOffset * ViewModel.getRepetitions() - OffsetRadiusPositiveX/2 - D/2, Y1 - + OffsetRadiusPositiveY / 2 + (ViewModel.getLineWidth() - D) / 2, D, -D)
        // context.ellipse(X + TotalOffset * i - D/2, Y1 + D/2, D, -D)
        dots.push(Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "' + dotColor + '"; x: ' + (X + TotalOffset * i + D/2)*ScaleFactorX +
                                     '; y: ' + (Y1 + D/2)*ScaleFactor + '; width: ' + D*ScaleFactor + '; height: ' + D*ScaleFactor +
                                     '; radius: ' + D/2*ScaleFactor + '}',myCanvas))
        //context.fill()

    }
}
