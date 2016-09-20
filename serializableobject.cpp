#include "serializableobject.h"
#include <QFile>
#include <QDebug>


SerializableObject::SerializableObject(QObject *parent) : QObject(parent)
{

}

/* Cant get it to work - so I omit the operator-overloading :/
QDataStream &SerializableObject::operator>>(QDataStream &ds, SerializableObject &obj)
{
    QVariant var;
    for(int i=0; i<obj.metaObject()->propertyCount(); ++i) {
        if(obj.metaObject()->property(i).isStored(&obj)) {
            ds >> var;
            obj.metaObject()->property(i).write(&obj, var);
        }
    }
    return ds;
}

QDataStream &SerializableObject::operator<<(QDataStream &ds, const SerializableObject &obj)
{
    for(int i=0; i<obj.metaObject()->propertyCount(); ++i) {
        if(obj.metaObject()->property(i).isStored(&obj)) {
            ds << obj.metaObject()->property(i).read(&obj);
        }
    }
    return ds;
}
*/

void SerializableObject::serialize(QString FileName)
{
    QFile file(FileName);
    file.open(QIODevice::WriteOnly);

    QDataStream out(&file);


    for(int i=0; i<this->metaObject()->propertyCount(); ++i) {
        if(this->metaObject()->property(i).isStored(this)) {
            out << this->metaObject()->property(i).read(this);
        }
    }


    file.close();
}






//template <class T>
//SerializableObject::T SerializableObject::deserialize(QString FileName)
void SerializableObject::deserialize(QString FileName)
{
    QFile file(FileName);
    QDataStream in(&file);

    file.open(QIODevice::ReadOnly);

    QVariant var;
    for(int i=0; i<this->metaObject()->propertyCount(); ++i) {
        if(this->metaObject()->property(i).isStored(this)) {
            in >> var;
            //qDebug() << this->metaObject()->property(i).name() << var;
            this->metaObject()->property(i).write(this, var);
        }
    }

    file.close();
}
