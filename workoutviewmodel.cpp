#include <QtMath>
#include <QtCharts/QXYSeries>
#include "workoutviewmodel.h"

QT_CHARTS_USE_NAMESPACE

Q_DECLARE_METATYPE(QAbstractSeries *)
Q_DECLARE_METATYPE(QXYSeries *)

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


    Temp = createPoints(AnglePositive,AngleNegative);

    //TODO scale

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

QList<QPointF> WorkoutViewModel::createPoints(double AnglePositive,double AngleNegative)
{
    QList<QPointF> Temp;

    //Scale is the heigth
    double OffsetPositive = getScale() /  qTan(qDegreesToRadians(AnglePositive));
    double OffsetNegative = getScale() /  qTan(qDegreesToRadians(AngleNegative));
    double TotalOffset = OffsetPositive + OffsetNegative;

    //Beginning
    Temp.append(QPointF(-OffsetNegative,getScale()));
    Temp.append(QPointF(0,0));

    //Loop for the
    for(int i = 0; i < getRepetitions(); i++){
        //those have no real effect, I leave it in there to play arround
        //Temp.append(QPointF(i * TotalOffset + OffsetPositive / 2 , getScale()/2));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive , getScale()));
        //Temp.append(QPointF(i * TotalOffset + OffsetPositive + OffsetNegative/2 , getScale()/2));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive + OffsetNegative , 0));
    }

    Temp.append(QPointF(getRepetitions() * TotalOffset + OffsetPositive , getScale()));

    return Temp;
}


/**
 * @brief Did not help resolve the issue of the dip in the curve as it goes to the linear part
 * @param AnglePositive
 * @param AngleNegative
 * @return
 */
QList<QPointF> WorkoutViewModel::createPointsWithRadius(double AnglePositive,double AngleNegative)
{
    QList<QPointF> Temp;

    //Scale is the heigth
    double OffsetPositive = getScale() /  qTan(qDegreesToRadians(AnglePositive));
    double OffsetNegative = getScale() /  qTan(qDegreesToRadians(AngleNegative));
    double TotalOffset = OffsetPositive + OffsetNegative;


    //Calculating the offsets for points where a Radius tangents the line
    double OffsetRadiusPositiveX = getScale() * qSin(qDegreesToRadians(AnglePositive)*getRadius());
    double OffsetRadiusPositiveY = getScale() * (1-qCos(qDegreesToRadians(AnglePositive)))*getRadius();
    double OffsetRadiusNegativeX = getScale() * qSin(qDegreesToRadians(AngleNegative)*getRadius());
    double OffsetRadiusNegativeY = getScale() * (1-qCos(qDegreesToRadians(AngleNegative)))*getRadius();


    //Linear Startstretch
    Temp.append(QPointF(-getScale(),0));
    Temp.append(QPointF(0,0));

    //Loop for the
    for(int i = 0; i < getRepetitions(); i++){
        Temp.append(QPointF(i * TotalOffset + OffsetRadiusPositiveX , OffsetRadiusPositiveY));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive/2 , getScale()/2));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive - OffsetRadiusPositiveX , getScale() - OffsetRadiusPositiveY));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive , getScale()));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive + OffsetRadiusNegativeX , getScale() - OffsetRadiusNegativeY));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive + OffsetNegative/2 , getScale()/2));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive + OffsetNegative - OffsetRadiusNegativeX ,OffsetRadiusNegativeY));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive + OffsetNegative , 0));
    }

    Temp.append(QPointF(getRepetitions() * TotalOffset + getScale(),0));

    return Temp;
}

/**
 * @brief Did not help resolve the issue of the dip in the curve as it goes to the linear part
 * @param AnglePositive
 * @param AngleNegative
 * @return
 */
QList<QPointF> WorkoutViewModel::createPointsWithTwoRadiuses(double AnglePositive,double AngleNegative)
{
    QList<QPointF> Temp;

    //Scale is the heigth
    double OffsetPositive = getScale() /  qTan(qDegreesToRadians(AnglePositive));
    double OffsetNegative = getScale() /  qTan(qDegreesToRadians(AngleNegative));
    double TotalOffset = OffsetPositive + OffsetNegative;


    //Calculating the offsets for points where a Radius tangents the line
    double OffsetRadiusPositiveX = getScale() * qSin(qDegreesToRadians(AnglePositive)*getRadius());
    double OffsetRadiusPositiveY = getScale() * (1-qCos(qDegreesToRadians(AnglePositive)))*getRadius();
    double OffsetRadiusNegativeX = getScale() * qSin(qDegreesToRadians(AngleNegative)*getRadius());
    double OffsetRadiusNegativeY = getScale() * (1-qCos(qDegreesToRadians(AngleNegative)))*getRadius();

    //Calculating inbetween points to make the spline smoother
    double OffsetRadiusPositiveX2 = getScale() * qSin(qDegreesToRadians(AnglePositive/2)*getRadius());
    double OffsetRadiusPositiveY2 = getScale() * (1-qCos(qDegreesToRadians(AnglePositive/2)))*getRadius();
    double OffsetRadiusNegativeX2 = getScale() * qSin(qDegreesToRadians(AngleNegative/2)*getRadius());
    double OffsetRadiusNegativeY2 = getScale() * (1-qCos(qDegreesToRadians(AngleNegative/2)))*getRadius();

    //Linear Startstretch
    Temp.append(QPointF(-getScale(),0));
    Temp.append(QPointF(0,0));

    //Loop for the
    for(int i = 0; i < getRepetitions(); i++){
        Temp.append(QPointF(i * TotalOffset + OffsetRadiusPositiveX2 , OffsetRadiusPositiveY2));
        Temp.append(QPointF(i * TotalOffset + OffsetRadiusPositiveX , OffsetRadiusPositiveY));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive / 2 , getScale()/2));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive - OffsetRadiusPositiveX , getScale() - OffsetRadiusPositiveY));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive - OffsetRadiusPositiveX2 , getScale() - OffsetRadiusPositiveY2));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive , getScale()));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive + OffsetRadiusNegativeX2 , getScale() - OffsetRadiusNegativeY2));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive + OffsetRadiusNegativeX , getScale() - OffsetRadiusNegativeY));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive + OffsetNegative/2 , getScale()/2));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive + OffsetNegative - OffsetRadiusNegativeX ,OffsetRadiusNegativeY));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive + OffsetNegative - OffsetRadiusNegativeX2 ,OffsetRadiusNegativeY2));
        Temp.append(QPointF(i * TotalOffset + OffsetPositive + OffsetNegative , 0));
    }

    Temp.append(QPointF(getRepetitions() * TotalOffset + getScale(),0));

    return Temp;
}

double WorkoutViewModel::getScale() const
{
    return _Scale;
}

double WorkoutViewModel::getRadius() const
{
    return _Radius;
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

void WorkoutViewModel::populateSeries(QAbstractSeries *series)
{
    if (!series) return;
    QXYSeries *xySeries = static_cast<QXYSeries *>(series);

    xySeries->clear();
    foreach (auto Point, getSplinePoints()) {
        xySeries->append(Point);
    }
}

void WorkoutViewModel::increaseWeightSmall()
{
    qDebug() << "Increase Weight Small";
}

void WorkoutViewModel::increaseWeightBig()
{
    qDebug() << "Increase Weight Big";
}

