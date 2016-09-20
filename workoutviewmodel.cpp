#include <QtMath>
#include <QtCharts/QXYSeries>
#include <QInputDialog>
#include "workoutviewmodel.h"

QT_CHARTS_USE_NAMESPACE

Q_DECLARE_METATYPE(QAbstractSeries *)
Q_DECLARE_METATYPE(QXYSeries *)


WorkoutViewModel::WorkoutViewModel(QObject *parent) : SerializableObject(parent)
{
    connect(this,&WorkoutViewModel::weightNegativeChanged,this,&WorkoutViewModel::handleWorkoutViewChanged);
    connect(this,&WorkoutViewModel::weightPositiveChanged,this,&WorkoutViewModel::handleWorkoutViewChanged);
    connect(this,&WorkoutViewModel::userNameChanged,this,&WorkoutViewModel::handleWorkoutViewChanged);
}

//TODO Special Interface for Isokinetic and Method5

/**
 * @brief Defines if the curve starts at the bottom or at the top.
 * @return
 */
int WorkoutViewModel::getStartsAtBottom() const
{
    return _StartsAtBottom;
}


double WorkoutViewModel::getAnglePositive() const
{
    switch (_WorkoutType) {
    case Method5:
    case Negative:
        return 66;
    default:
        return 45;
    }
}

double WorkoutViewModel::getAngleNegative() const
{
    switch (_WorkoutType) {
    case Negative:
        return 40;
    default:
        return 45;
    }
}



/**
 * @brief deprecated
 * @return
 */
QList<QPointF> WorkoutViewModel::getSplinePoints()
{

    //Not really neccisary to buffer it, rather for training purposes
    if(_SplinePoints.contains(_WorkoutType)) return _SplinePoints.value(_WorkoutType);

    QList<QPointF> Temp;

    //Angles in relation to the X-Axis for the inclining and declining stretch of the spline
    double AnglePositive = getAnglePositive();
    double AngleNegative = getAngleNegative();
    



    Temp = createPoints(AnglePositive,AngleNegative);

    //TODO scale

    //If it starts at Top mirror it
    if(!getStartsAtBottom()){
        foreach (auto Point, Temp) {
            //As values are only between 0 and 1
            Point.setY(Point.y() + 1);
            if(Point.y() > 1 ) Point.setY(Point.y() - 1);
        }
    }
    
    return Temp;
}


/**
 * @brief deprecated
 * @param AnglePositive
 * @param AngleNegative
 * @return
 */
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
 * @brief deprecated
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
 * @brief deprecated
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

int WorkoutViewModel::getWeightNegative() const
{
     return _WeightNegative;
}

QString WorkoutViewModel::getUserName() const
{
    return _UserName;
}

void WorkoutViewModel::setUserName(const QString &value)
{
    _UserName = value;
    emit userNameChanged();
}

void WorkoutViewModel::setWeightNegative(int value)
{
    _WeightPositive = value;
    emit weightPositiveChanged();
}

void WorkoutViewModel::setWeightPositive(int value)
{
    _WeightPositive = value;
    emit weightPositiveChanged();
}

void WorkoutViewModel::handleWorkoutViewChanged()
{
    emit workoutViewChanged();
}

void WorkoutViewModel::setBigValue(int BigValue)
{
    _BigValue = BigValue;
}

void WorkoutViewModel::setLinearLength(double LinearLength)
{
    _LinearLength = LinearLength;
}

void WorkoutViewModel::setLineWidth(double LineWidth)
{
    _LineWidth = LineWidth;
}

void WorkoutViewModel::setRepetitions(int Repetitions)
{
    _Repetitions = Repetitions;
}

void WorkoutViewModel::setRadius(double Radius)
{
    _Radius = Radius;
}

void WorkoutViewModel::setScale(double Scale)
{
    _Scale = Scale;
}

void WorkoutViewModel::setSecondsPerRepetition(double SecondsPerRepetition)
{
    _SecondsPerRepetition = SecondsPerRepetition;
}

void WorkoutViewModel::setStartsAtBottom(bool StartsAtBottom)
{
    _StartsAtBottom = StartsAtBottom;
}

void WorkoutViewModel::setUserID(const QString &UserID)
{
    _UserID = UserID;
}

QString WorkoutViewModel::getUserID() const
{
    return _UserID;
}

double WorkoutViewModel::getSecondsPerRepetition() const
{
    return _SecondsPerRepetition;
}

int WorkoutViewModel::getWeightPositive() const
{
    return _WeightPositive;
}

double WorkoutViewModel::getLineWidth() const
{
    return _LineWidth;
}

double WorkoutViewModel::getLinearLength() const
{
    return _LinearLength;
}

double WorkoutViewModel::getScale() const
{
    return _Scale;
}

QString WorkoutViewModel::getWorkoutTypeGoal() const
{

    switch (_WorkoutGoal) {
    case Figure:
        return "Figur";

    case Fitness:
        return "Fitness";

    case Weight:
        return "Gewichtsreduktion";

    case Athletik:
        return "Athletik";

    case Muscle:
        return "Muskelaufbau";
    }

    return "0";
}


QString WorkoutViewModel::getWorkoutTypeString() const
{
    switch (_WorkoutType) {
    case Regular:
        return "Regulär";

    case Negative:
        return "Negativ";

    case Adaptive:
        return "Adaptiv";

    case Isokinetic:
        return "Isokinetisch";

    case Method5:
        return "Methode 5";
    }

    return "0";
}

double WorkoutViewModel::getRadius() const
{
    return _Radius;
}


void WorkoutViewModel::decreaseWeight(int Value, bool IsPositive)
{
    qDebug() << "Decrease" << (IsPositive ? "Positive" : "Negative") << "Weight by" << Value;

    if(IsPositive){
        setWeightPositive(getWeightPositive() - Value);
    }
    else{
        setWeightNegative(getWeightPositive() - Value);
    }
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

void WorkoutViewModel::increaseWeight(int Value, bool IsPositive)
{
    qDebug() << "Increase" << (IsPositive ? "Positive" : "Negative") <<  "Weight by" << Value;

    if(IsPositive){
        setWeightPositive(getWeightPositive() + Value);
    }
    else{
        setWeightNegative(getWeightPositive() + Value);
    }
}

void WorkoutViewModel::logoutUser()
{
    bool ok;
    QString text = QInputDialog::getText(NULL,"Benutzername","Bitte neuen Benutzername eingeben.",QLineEdit::Normal,"",&ok);
            //this, tr("QInputDialog::getText()"),tr("User name:"), QLineEdit::Normal,, &ok)

    if (ok && !text.isEmpty())
        qDebug() << "New Username:" << text;
       this->setUserName(text);
}

