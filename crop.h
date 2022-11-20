#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QRectF>

class Crop : public QObject {

    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY( QRectF crop READ crop WRITE setCrop NOTIFY cropChanged )
    Q_PROPERTY( QSizeF boundaries READ boundaries WRITE setBoundaries NOTIFY boundariesChanged )
    Q_PROPERTY( bool startDraw READ startDraw WRITE setStartDraw NOTIFY startDrawChanged )
    Q_PROPERTY( int stepSize READ stepSize WRITE setStepSize NOTIFY stepSizeChanged )

public:
    Crop( QObject* parent = nullptr );

    enum class CompositionType { RuleOfThirds, Diagonal, GoldenRatio };

    Q_ENUM( CompositionType )

    const QRectF& crop() const;
    const QSizeF& boundaries() const;
    bool startDraw() const;
    int stepSize() const;

public Q_SLOTS:
    void reset();

    void setCrop( const QRectF& newCrop );
    void setBoundaries( const QSizeF& newboundaries );
    void setStartDraw( bool newStartDraw );
    void setStartPoint( QPointF newStartPoint );
    void setStepSize( int newStepSize );

    void makeRect( qreal mouseX, qreal mouseY );

    void setX( qreal newX );
    void setY( qreal newY );
    void setTopLeft( QPointF newTopLeft );
    void setTopRight( QPointF newTopRight );
    void setBottomLeft( QPointF newBottomLeft );
    void setBottomRight( QPointF newBottomRight );
    void setLeft( qreal newLeft );
    void setRight( qreal newRight );
    void setTop( qreal newTop );
    void setBottom( qreal newBottom );

    void increaseX();
    void increaseY();
    void decreaseX();
    void decreaseY();

Q_SIGNALS:
    void cropChanged();
    void boundariesChanged();
    void startDrawChanged();
    void stepSizeChanged();

private:
    QRectF m_crop;
    QSizeF m_boundaries;
    QPointF m_startPoint;
    bool m_startDraw;
    int m_stepSize;
};

Q_DECLARE_METATYPE( Crop::CompositionType )
