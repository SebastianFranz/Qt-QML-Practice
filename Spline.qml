import QtQuick 2.5
import QtQuick.Window 2.2
import QtCharts 2.1

Item {
    width: 1600
    height: 600
    ChartView {
        id: root
        anchors.fill: parent

        //Might pose performance problems
        //If so dump the whole thing into a picture and import it
        antialiasing: true
        legend.visible: false
        onSeriesAdded: {
            ViewModel.populateSeries(spline)
        }
        clip: {
            spline
        }

        SplineSeries {
            id:spline
            width: 100 * ViewModel.getScale()

            pointsVisible: false


            axisX: ValueAxis{
                min: -2 * ViewModel.getScale()
                max: 5 * ViewModel.getScale()
                visible: true
                tickCount:21

                //                NumberAnimation on min {
                //                             to: 7
                //                             duration: 9000
                //                             running: true
                //                         }
                //                NumberAnimation on max {
                //                             to: 10
                //                             duration: 9000
                //                             running: true
                //                         }
            }

            axisY: ValueAxis{
                visible: true
                max: 1.2 * ViewModel.getScale()
                min: -0.2 * ViewModel.getScale()
                tickCount:21

            }
            /*  XYPoint { x: -2; y: 1 }
            XYPoint { x: 0; y: 0 }
            XYPoint { x: 0.5; y: 1 }
            XYPoint { x: 2; y: 0 }
            XYPoint { x: 2.5; y: 1 }*/





        }
    }
}
