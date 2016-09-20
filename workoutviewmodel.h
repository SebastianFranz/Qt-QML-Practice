#ifndef WORKOUTVIEWMODEL_H
#define WORKOUTVIEWMODEL_H

#include <QObject>
#include <QDebug>
#include <QtCharts/QAbstractSeries>
#include "serializableobject.h"

QT_CHARTS_USE_NAMESPACE

class WorkoutViewModel : public SerializableObject
{
    Q_OBJECT
    Q_ENUMS(WorkoutGoal)
    Q_ENUMS(WorkoutType)

public:
    explicit WorkoutViewModel(QObject *parent = 0);

    enum WorkoutGoal { Figure, Fitness, Weight, Athletik, Muscle};
    enum WorkoutType { Regular, Negative, Adaptive, Isokinetic, Method5};
    Q_INVOKABLE double getAnglePositive() const;
    Q_INVOKABLE double getAngleNegative() const;
    Q_INVOKABLE int getBigValue() const;
    Q_INVOKABLE double getLinearLength() const;
    Q_INVOKABLE double getLineWidth() const;
    Q_INVOKABLE double getRadius() const;
    Q_INVOKABLE int getRepetitions() const;
    Q_INVOKABLE double getScale() const;
    Q_INVOKABLE double getSecondsPerRepetition() const;
    Q_INVOKABLE int getStartsAtBottom() const;
    Q_INVOKABLE QString getWorkoutTypeGoal() const;
    Q_INVOKABLE QString getWorkoutTypeString() const;
    Q_INVOKABLE QString getUserName() const;


    Q_INVOKABLE void decreaseWeight(int Value, bool IsPositive = true);
    Q_INVOKABLE void increaseWeight(int Value, bool IsPositive = true);

    Q_INVOKABLE void logoutUser();

    Q_INVOKABLE QList<QPointF> getSplinePoints();


    //Propertys for every property to make the serialisazion work
    Q_PROPERTY(int BigValue READ getBigValue WRITE setBigValue)
    Q_PROPERTY(double LinearLength READ getLinearLength WRITE setLinearLength)
    Q_PROPERTY(QString UserName READ getUserName WRITE setUserName NOTIFY userNameChanged)
    Q_PROPERTY(QString UserID READ getUserID WRITE setUserID)
    Q_PROPERTY(bool StartsAtBottom  READ getStartsAtBottom  WRITE setStartsAtBottom )
    Q_PROPERTY(double SecondsPerRepetition READ getSecondsPerRepetition WRITE setSecondsPerRepetition)
    Q_PROPERTY(double Scale READ getScale WRITE setScale)
    Q_PROPERTY(double Radius READ getRadius WRITE setRadius)
    Q_PROPERTY(int Repetitions READ getRepetitions WRITE setRepetitions)
    Q_PROPERTY(double LineWidth READ getLineWidth WRITE setLineWidth)
    Q_PROPERTY(int WeightNegative READ getWeightNegative NOTIFY weightNegativeChanged)
    Q_PROPERTY(int WeightPositive READ getWeightPositive WRITE setWeightPositive NOTIFY weightPositiveChanged)


    QList<QPointF> createPoints(double AnglePositive, double AngleNegative);
    QList<QPointF> createPointsWithRadius(double AnglePositive, double AngleNegative);
    QList<QPointF> createPointsWithTwoRadiuses(double AnglePositive, double AngleNegative);




    QString getUserID() const;

    int getWeightNegative() const;
    int getWeightPositive() const;


    void setBigValue(int BigValue);
    void setLinearLength(double LinearLength);
    void setLineWidth(double LineWidth);
    void setRepetitions(int Repetitions);
    void setRadius(double Radius);
    void setScale(double Scale);
    void setSecondsPerRepetition(double SecondsPerRepetition);
    void setStartsAtBottom(bool StartsAtBottom);
    void setUserID(const QString &UserID);
    void setUserName(const QString &value);
    void setWeightNegative(int value);
    void setWeightPositive(int value);


private:
    int _BigValue = 5;
    double _LinearLength = 2;
    double _LineWidth = 50;
    int _Repetitions = 3;
    double _Radius = 0.3;
    double _Scale = 1;
    double _SecondsPerRepetition = 4;
    bool _StartsAtBottom = false;
    QString _UserID = "0123456789";
    QString _UserName = "Sebastian";
    int _WeightNegative = 51;
    int _WeightPositive = 34;


    //deprecated
    QHash<WorkoutType,QList<QPointF>> _SplinePoints;
    WorkoutGoal _WorkoutGoal = Athletik;
    WorkoutType _WorkoutType = Negative;


    void handleWorkoutViewChanged();


signals:
    void weightNegativeChanged();
    void weightPositiveChanged();
    void userNameChanged();
    void workoutViewChanged();
public slots:
    void populateSeries(QAbstractSeries *series);
};

#endif // WORKOUTVIEWMODEL_H
