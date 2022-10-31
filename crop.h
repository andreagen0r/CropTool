#pragma once

#include <QObject>
#include <QPointF>
#include <QQmlEngine>
#include <QRectF>
#include <QSizeF>

class Crop : public QObject {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY( QPointF startPoint READ startPoint WRITE setStartPoint NOTIFY startPointChanged )
    Q_PROPERTY( QPointF currentPoint READ currentPoint WRITE setCurrentPoint NOTIFY currentPointChanged )
    Q_PROPERTY( QSizeF windowSize READ windowSize WRITE setWindowSize NOTIFY windowSizeChanged )
    Q_PROPERTY( QRectF crop READ crop WRITE setCrop NOTIFY cropChanged )

    Q_PROPERTY( bool startDraw READ startDraw WRITE setStartDraw NOTIFY startDrawChanged )

    Q_PROPERTY( QPointF topLeft READ topLeft WRITE setTopLeft NOTIFY topLeftChanged )
    Q_PROPERTY( QPointF bottomRight READ bottomRight WRITE setBottomRight NOTIFY bottomRightChanged )
public:
    Crop( QObject* parent = nullptr );

    Q_INVOKABLE const QRectF& crop() const;
    Q_INVOKABLE void setCrop( const QRectF& newCrop );

    QPointF startPoint() const;
    void setStartPoint( QPointF newStartPoint );

    Q_INVOKABLE void reset();
    Q_INVOKABLE void makeRect( qreal mouseX, qreal mouseY );

    const QSizeF& windowSize() const;
    void setWindowSize( const QSizeF& newWindowSize );

    QPointF currentPoint() const;
    void setCurrentPoint( QPointF newCurrentPoint );

    bool startDraw() const;
    void setStartDraw( bool newStartDraw );

    QPointF topLeft() const;
    void setTopLeft( QPointF newTopLeft );

    QPointF bottomRight() const;
    void setBottomRight( QPointF newBottomRight );

Q_SIGNALS:
    void cropChanged();
    void startPointChanged();
    void windowSizeChanged();

    void currentPointChanged();

    void startDrawChanged();

    void topLeftChanged();

    void bottomRightChanged();

private:
    QRectF m_crop;
    QPointF m_startPoint;
    QSizeF m_windowSize;
    QPointF m_currentPoint;
    bool m_startDraw;
    QPointF m_topLeft;
    QPointF m_bottomRight;
};
