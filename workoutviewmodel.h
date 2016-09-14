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

    enum WorkoutType { Regular, Negative, Adaptive, Isokinetic, Method5 };
    Q_INVOKABLE double getAnglePositive() const;
    Q_INVOKABLE double getAngleNegative() const;
    Q_INVOKABLE double getLinearLength() const;
    Q_INVOKABLE double getLineWidth() const;
    Q_INVOKABLE double getRadius() const;
    Q_INVOKABLE double getScale() const;

    Q_INVOKABLE int getBigValue() const;
    Q_INVOKABLE int getRepetitions() const;
    Q_INVOKABLE int getStartsAtBottom() const;

    Q_INVOKABLE void decreaseWeight(int Value);
    Q_INVOKABLE void increaseWeight(int Value);

    Q_INVOKABLE QList<QPointF> getSplinePoints();


    QList<QPointF> createPoints(double AnglePositive, double AngleNegative);
    QList<QPointF> createPointsWithRadius(double AnglePositive, double AngleNegative);
    QList<QPointF> createPointsWithTwoRadiuses(double AnglePositive, double AngleNegative);





private:
    int _BigValue = 3;
    double _LinearLength = 1;
    double _LineWidth = 50;
    int _Repetitions = 2;
    double _Radius = 0.3;
    double _Scale = 1;
    bool _StartsAtBottom = false;


    QHash<WorkoutType,QList<QPointF>> _SplinePoints;
    WorkoutType _WorkoutType = Negative;


signals:

public slots:
    void populateSeries(QAbstractSeries *series);
};

#endif // WORKOUTVIEWMODEL_H
