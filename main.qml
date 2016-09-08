import QtQuick 2.5
import QtQuick.Window 2.2
import QtCharts 2.1

Item {
    width: 800
    height: 600
    ChartView {
        id: root
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        height: 400

        //Might pose performance problems
        antialiasing: true
        legend.visible: false

        SplineSeries {
            id:chart
            width: 50
            axisX: CategoryAxis{
                min: -10
                max: 20
                visible: false

                NumberAnimation on min {
                             to: 0
                             duration: 3000
                             running: true
                         }
                NumberAnimation on max {
                             to: 30
                             duration: 3000
                             running: true
                         }
            }

            axisY: CategoryAxis{
                visible: false
                max: 12
                min: -3
            }
            XYPoint { x: -20; y: 10 }
            XYPoint { x: 0; y: 0 }
            XYPoint { x: 5; y: 10 }
            XYPoint { x: 20; y: 0 }
            XYPoint { x: 25; y: 10 }
//onPressed: {
    //ViewModel.decreaseWeightSmall()
//}


        }
    }
}
