#include "crop.h"
#include <QDebug>
Crop::Crop( QObject* parent )
    : QObject( parent )
    , m_crop( QRectF( 0.0, 0.0, 0.0, 0.0 ) )
    , m_startDraw( true ) { }

const QRectF& Crop::crop() const {
    return m_crop;
}

void Crop::setCrop( const QRectF& newCrop ) {
    if ( m_crop == newCrop ) {
        return;
    }

    m_crop = newCrop;
    emit cropChanged();
}

QPointF Crop::startPoint() const {
    return m_startPoint;
}

void Crop::setStartPoint( QPointF newStartPoint ) {
    if ( m_startPoint == newStartPoint )
        return;

    m_startPoint = newStartPoint;
    emit startPointChanged();
}

QPointF Crop::currentPoint() const {
    return m_currentPoint;
}

void Crop::setCurrentPoint( QPointF newCurrentPoint ) {
    if ( m_currentPoint == newCurrentPoint )
        return;

    m_currentPoint = newCurrentPoint;
    emit currentPointChanged();
}

void Crop::reset() {
    m_crop = QRectF( 0.0, 0.0, 0.0, 0.0 );
    emit cropChanged();
}

void Crop::makeRect( qreal mouseX, qreal mouseY ) {

    const auto mx = std::clamp( mouseX, 0.0, m_windowSize.width() );
    const auto my = std::clamp( mouseY, 0.0, m_windowSize.height() );

    if ( mouseX <= m_startPoint.x() ) { // Left

        m_crop.setX( mx );
        m_crop.setWidth( m_startPoint.x() - mx );

        if ( mouseY <= m_startPoint.y() ) { // Top
            m_crop.setY( my );
            m_crop.setHeight( m_startPoint.y() - my );

        } else { // Bottom
            m_crop.setY( m_startPoint.y() );
            m_crop.setHeight( my - m_startPoint.y() );
        }

    } else { // Right

        m_crop.setX( m_startPoint.x() );
        m_crop.setWidth( mx - m_startPoint.x() );

        if ( mouseY <= m_startPoint.y() ) { // Top

            m_crop.setY( my );
            m_crop.setHeight( m_startPoint.y() - my );

        } else { // Bottom
            m_crop.setY( m_startPoint.y() );
            m_crop.setHeight( my - m_startPoint.y() );
        }
    }

    m_topLeft = m_crop.topLeft();
    m_bottomRight = m_crop.bottomRight();
    emit cropChanged();
}

const QSizeF& Crop::windowSize() const {
    return m_windowSize;
}

void Crop::setWindowSize( const QSizeF& newWindowSize ) {
    if ( m_windowSize == newWindowSize )
        return;
    m_windowSize = newWindowSize;
    emit windowSizeChanged();
}

bool Crop::startDraw() const {
    return m_startDraw;
}

void Crop::setStartDraw( bool newStartDraw ) {
    if ( m_startDraw == newStartDraw )
        return;
    m_startDraw = newStartDraw;
    emit startDrawChanged();
}

QPointF Crop::topLeft() const {
    return m_topLeft;
}

void Crop::setTopLeft( QPointF newTopLeft ) {
    if ( m_topLeft == newTopLeft )
        return;
    m_topLeft = newTopLeft;
    emit topLeftChanged();
}

QPointF Crop::bottomRight() const {
    return m_bottomRight;
}

void Crop::setBottomRight( QPointF newBottomRight ) {
    if ( m_bottomRight == newBottomRight )
        return;
    m_bottomRight = newBottomRight;
    emit bottomRightChanged();
}
