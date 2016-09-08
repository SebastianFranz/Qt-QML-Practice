#ifndef WORKOUTVIEWMODEL_H
#define WORKOUTVIEWMODEL_H

#include <QObject>
#include <QDebug>

class WorkoutViewModel : public QObject
{
    Q_OBJECT
    Q_ENUMS(WorkoutType)

public:
    enum WorkoutType { Regular, Negativ, Adaptive, Isokinetic, Method5 };
public:
    explicit WorkoutViewModel(QObject *parent = 0);

    Q_INVOKABLE QList<QPointF> getSplinePoints();

    Q_INVOKABLE void decreaseWeightSmall();
    Q_INVOKABLE void decreaseWeightBig();
    Q_INVOKABLE void increaseWeightSmall();
    Q_INVOKABLE void increaseWeightBig();

    int getBigValue() const;
    int getBottomStart() const;
    int getRepetitions() const;
private:
    int _BigValue = 5;
    bool _BottomStart = true;
    int _Repetitions;
    QHash<WorkoutType,QList<QPointF>> _SplinePoints;
    WorkoutType _WorkoutType = Regular;
signals:

public slots:
};

#endif // WORKOUTVIEWMODEL_H
