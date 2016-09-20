#ifndef GUICONTROLLER_H
#define GUICONTROLLER_H

#include <QObject>
#include "workoutviewmodel.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>


class GUIController : public QObject
{
    Q_OBJECT

private:
    bool downloadUserSetup(QString ID);

    WorkoutViewModel _ViewModel;
    QNetworkAccessManager AccessManager;
    bool _IsDownloading;
public:
    explicit GUIController(QObject *parent = 0);
    QString getFileName();
    void initializeController();

    WorkoutViewModel& ViewModel();


    bool downloadFileSynchronous(QUrl Url);
    bool saveFile(QNetworkReply *DownloadedData);

signals:

public slots:
    void saveSetup();
  void fileDownloaded(QNetworkReply* Reply);


};

#endif // GUICONTROLLER_H
