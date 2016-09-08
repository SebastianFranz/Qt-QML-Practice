#include <QtMath>
#include "workoutviewmodel.h"

int WorkoutViewModel::getBottomStart() const
{
    return _BottomStart;
}

WorkoutViewModel::WorkoutViewModel(QObject *parent) : QObject(parent)
{
    
}


/**
 * @brief WorkoutViewModel::getSplinePoints
 * @return
 */
QList<QPointF> WorkoutViewModel::getSplinePoints()
{

    //Not really neccisary to buffer it, rather for training purposes
    if(_SplinePoints.contains(_WorkoutType)) return _SplinePoints.value(_WorkoutType);

    QList<QPointF> Temp;

    //Angles in relation to the X-Axis for the inclining and declining stretch of the spline
    double AnglePositive;
    double AngleNegative;
    
    switch (_WorkoutType) {
    case Adaptive:
    case Regular:
        AnglePositive = 45;
        AngleNegative = 45;

        break;
    case Isokinetic:
    case Method5:
        //TODO Special Interface
        return Temp;

        break;
    case Negativ:
        AnglePositive = 66;
        AngleNegative = 33;

        break;
    }


    //1 is the heigth
    double OffsetPositive = 1 /  qTan(qDegreesToRadians(AnglePositive));
    double OffsetNegative = 1 /  qTan(qDegreesToRadians(AngleNegative));
    double TotalOffset = OffsetPositive + OffsetNegative;


    //Linear Startstretch
    Temp.append(QPointF(-3,0));
    Temp.append(QPointF(0,0));

    //Loop for the
    for(int i = 1; i = getRepetitions(); i++){
        Temp.append(QPointF(i * TotalOffset + OffsetPositive,0));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive + OffsetNegative,1));
    }


    //If it starts at Top mirror it
    if(!getBottomStart()){
        foreach (auto Point, Temp) {
            //As values are only between 0 and 1
            Point.setY(Point.y() + 1);
            if(Point.y() > 1 ) Point.setY(Point.y() - 1);
        }
    }
    
    return Temp;
}

void WorkoutViewModel::decreaseWeightSmall()
{
    qDebug() << "Decrease Weight Small";
}

void WorkoutViewModel::decreaseWeightBig()
{
    qDebug() << "Decrease Weight Big";
}

int WorkoutViewModel::getBigValue() const
{
    return _BigValue;
}

int WorkoutViewModel::getRepetitions() const
{
    return _Repetitions;
}

void WorkoutViewModel::increaseWeightSmall()
{
    qDebug() << "Increase Weight Small";
}

void WorkoutViewModel::increaseWeightBig()
{
    qDebug() << "Increase Weight Big";
}

