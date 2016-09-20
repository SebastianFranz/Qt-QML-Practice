//Whith quite lot of help from here: http://stackoverflow.com/questions/13835197/serializing-my-custom-class-in-qt

#ifndef SERIALIZABLEOBJECT_H
#define SERIALIZABLEOBJECT_H

#include <QObject>
#include <QDataStream>
#include <QMetaProperty>

class SerializableObject : public QObject
{
    Q_OBJECT
public:
    explicit SerializableObject(QObject *parent = 0);

    //  template <typename T>
    // static T deserialize(QString FileName);
    void deserialize(QString FileName);

    void serialize (QString FileName);

private:

    //Cant get it to work ...
    //friend QDataStream &operator<<(QDataStream &ds, const SerializableObject &obj);
    //friend QDataStream &operator>>(QDataStream &ds, SerializableObject &obj) ;

signals:

public slots:
};




#endif // SERIALIZABLEOBJECT_H

