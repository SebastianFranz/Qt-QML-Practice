#include "guicontroller.h"
#include <QDebug>
#include <QThread>
#include <QEventLoop>
#include <QFile>
#include <QFileInfo>


GUIController::GUIController(QObject *parent) : QObject(parent)
{
    connect(&AccessManager, SIGNAL (finished(QNetworkReply*)),
            this, SLOT (fileDownloaded(QNetworkReply*)));

    this->initializeController();

}

QString GUIController::getFileName()
{
    QString ID = "0123456789";

    return "UserSetup" + ID + ".bin";
}


void GUIController::initializeController()
{
    bool GetFileFromWeb = false;


    if (GetFileFromWeb){
        if (downloadUserSetup(this->getFileName())){
            this->ViewModel().deserialize(this->getFileName());
        }
    }
    else{
        QFile file(this->getFileName());
        if(file.exists()){
            this->ViewModel().deserialize(this->getFileName());
        }
        else {
            qDebug() << "The File" << this->getFileName() << "was not found. --> Standart setup.";
        }
    }

    QObject::connect(&_ViewModel,SIGNAL(workoutViewChanged()),this,SLOT(saveSetup()));
}




bool GUIController::downloadUserSetup(QString FileName)
{
    qDebug() << "Downloading UserSetup";
    QUrl url("https://raw.githubusercontent.com/SebastianFranz/Qt-QML-Practice/master/" + FileName);

    return this->downloadFileSynchronous(url);
}



//Well Networking is not supposed to be synchronous, but it is interesting to do it for learning purposes
bool GUIController::downloadFileSynchronous(QUrl Url)
{
    QNetworkRequest Request(Url);

    qDebug() << "Getting File" << Url;
    QNetworkReply *Reply = AccessManager.get(Request);

    //There will be some warnings that can be ignored

    QEventLoop eventLoop;
    QObject::connect(Reply, SIGNAL(finished()), &eventLoop, SLOT(quit()));
    eventLoop.exec();


    return true;
}

bool GUIController::saveFile(QNetworkReply *Reply)
{
    QFile file(QFileInfo(Reply->url().path()).fileName());

    if (!file.open(QIODevice::WriteOnly)) {
        qDebug() << "Could not open file";
        return false;
    }

    file.write(Reply->readAll());
    file.close();

    qDebug() << "Saved File successfully";

    return true;
}

void GUIController::saveSetup()
{
        qDebug() << "Saving Setup to file" << this->getFileName();
    this->ViewModel().serialize(this->getFileName());
}


void GUIController::fileDownloaded(QNetworkReply* Reply)
{

    qDebug() << "Reply received. Saving File.";

    this->saveFile(Reply);

    Reply->deleteLater();
}


WorkoutViewModel& GUIController::ViewModel()
{
    return _ViewModel;
}



