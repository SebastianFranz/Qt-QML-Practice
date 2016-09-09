#ifndef WORKOUTVIEWMODEL_H
#define WORKOUTVIEWMODEL_H

#include <QObject>
#include <QDebug>
#include <QtCharts/QAbstractSeries>

QT_CHARTS_USE_NAMESPACE

class WorkoutViewModel : public QObject
{
    Q_OBJECT
    Q_ENUMS(WorkoutType)

public:
    explicit WorkoutViewModel(QObject *parent = 0);

    enum WorkoutType { Regular, Negativ, Adaptive, Isokinetic, Method5 };

    Q_INVOKABLE QList<QPointF> getSplinePoints();
    Q_INVOKABLE void decreaseWeightSmall();
    Q_INVOKABLE void decreaseWeightBig();
    Q_INVOKABLE double getScale() const;
    Q_INVOKABLE void increaseWeightSmall();
    Q_INVOKABLE void increaseWeightBig();

    QList<QPointF> createPoints(double AnglePositive, double AngleNegative);
    QList<QPointF> createPointsWithRadius(double AnglePositive, double AngleNegative);
    QList<QPointF> createPointsWithTwoRadiuses(double AnglePositive, double AngleNegative);

    int getBigValue() const;
    int getBottomStart() const;
    double getRadius() const;
    int getRepetitions() const;


private:
    int _BigValue = 5;
    bool _BottomStart = true;
    int _Repetitions = 2;
    double _Radius = 0.1;
    double _Scale = 1;


    QHash<WorkoutType,QList<QPointF>> _SplinePoints;
    WorkoutType _WorkoutType = Negativ;


signals:

public slots:
       void populateSeries(QAbstractSeries *series);
};

#endif // WORKOUTVIEWMODEL_H
