import QtQuick 2.0

Canvas {
    id: myCanvas
    height: 200
    width: 3 * height * ViewModel.getRepetitions()
    antialiasing: true


    onPaint:
    {
        var context = getContext("2d")

        context.lineWidth = 5
        context.strokeStyle = "black"
        context.fillStyle = "steelblue"

        var ScaleFactor = (height - context.lineWidth) / height
        context.scale(ScaleFactor,ScaleFactor)
        context.translate(0,context.lineWidth/2)

        var Y = height
        var X = ViewModel.getLinearLength() * height
        var R = ViewModel.getRadius() * height
        var A0 = Math.PI/2

        var AnglePositiveRad = ViewModel.getAnglePositive() * Math.PI / 180
        var AngleNegativeRad = ViewModel.getAngleNegative() * Math.PI / 180

        //Calculating the offsets for points where a Radius tangents the line
        var OffsetRadiusPositiveX = Math.tan(AnglePositiveRad/2) * R * 2
        var OffsetRadiusNegativeX = Math.tan(AngleNegativeRad/2) * R * 2


        var OffsetPositive = Y / Math.tan(AnglePositiveRad) + OffsetRadiusPositiveX
        var OffsetNegative = Y / Math.tan(AngleNegativeRad) + OffsetRadiusNegativeX
        var TotalOffset = OffsetPositive + OffsetNegative



        context.beginPath()
        // Move to Startpoint, if it does not start at the bottom it will be mirrored later on
        context.moveTo(0,Y)


        //First Radius
        context.arc(X, Y - R, R, A0, Math.PI/2 - AnglePositiveRad, true)

        for(var i = 0; i < ViewModel.getRepetitions(); i++){
            //-PI because the Angle are facing the other direction at the top
            var StartAngleTop = 3/2 * Math.PI - AnglePositiveRad
            var EndAngleTop = 3/2 * Math.PI + AngleNegativeRad
            context.arc(X + TotalOffset * i + OffsetPositive, R, R, StartAngleTop, EndAngleTop, false)

            //to get rid of the last radius, as it has to be special
            if(i == ViewModel.getRepetitions()-1) continue


            var StartAngleBottom = Math.PI/2 + AngleNegativeRad
            var EndAngleBottom =  Math.PI/2 - AnglePositiveRad
            context.arc(X + TotalOffset * (i + 1), Y - R, R, StartAngleBottom , EndAngleBottom , true)
        }

        var TotalLength = X + TotalOffset * ViewModel.getRepetitions()
        context.arc(TotalLength , Y - R, R, StartAngleBottom, Math.PI/2, true)

        TotalLength += ViewModel.getLinearLength() * height
        context.lineTo(TotalLength,Y)
        //myCanvas.width = TotalLength

        context.stroke()
    }
}
