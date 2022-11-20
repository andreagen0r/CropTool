#include "crop.h"
#include <QDebug>
Crop::Crop( QObject* parent )
    : QObject( parent )
    , m_crop( QRectF( 0.0, 0.0, 0.0, 0.0 ) )
    , m_boundaries { QSizeF( 0, 0 ) }
    , m_startPoint { QPointF( 0, 0 ) }
    , m_startDraw( true )
    , m_stepSize { 1 } { }

const QRectF& Crop::crop() const {
    return m_crop;
}

void Crop::setCrop( const QRectF& newCrop ) {
    if ( m_crop == newCrop ) {
        return;
    }

    m_crop = newCrop;
    Q_EMIT cropChanged();
}

void Crop::setStartPoint( QPointF newStartPoint ) {
    if ( m_startPoint == newStartPoint ) {
        return;
    }
    m_startPoint = newStartPoint;
}

void Crop::reset() {
    m_crop = QRectF( 0.0, 0.0, 0.0, 0.0 );
    Q_EMIT cropChanged();
}

void Crop::makeRect( qreal mouseX, qreal mouseY ) {

    const auto mx = std::clamp( mouseX, 0.0, m_boundaries.width() );
    const auto my = std::clamp( mouseY, 0.0, m_boundaries.height() );

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

    Q_EMIT cropChanged();
}

const QSizeF& Crop::boundaries() const {
    return m_boundaries;
}

void Crop::setBoundaries( const QSizeF& newBoundaries ) {
    if ( m_boundaries == newBoundaries )
        return;
    m_boundaries = newBoundaries;
    Q_EMIT boundariesChanged();
}

bool Crop::startDraw() const {
    return m_startDraw;
}

void Crop::setStartDraw( bool newStartDraw ) {
    if ( m_startDraw == newStartDraw )
        return;
    m_startDraw = newStartDraw;
    Q_EMIT startDrawChanged();
}

void Crop::setX( qreal newX ) {
    if ( qFuzzyCompare( m_crop.x(), newX ) ) {
        return;
    }
    m_crop.setX( newX );
    Q_EMIT cropChanged();
}

void Crop::setY( qreal newY ) {
    if ( qFuzzyCompare( m_crop.y(), newY ) ) {
        return;
    }
    m_crop.setY( newY );
    Q_EMIT cropChanged();
}


void Crop::setTopLeft( QPointF newTopLeft ) {
    if ( m_crop.topLeft() == newTopLeft )
        return;
    m_crop.setTopLeft( newTopLeft );
    Q_EMIT cropChanged();
}

void Crop::setTopRight( QPointF newTopRight ) {
    if ( m_crop.topRight() == newTopRight ) {
        return;
    }
    m_crop.setTopRight( newTopRight );
    Q_EMIT cropChanged();
}

void Crop::setBottomLeft( QPointF newBottomLeft ) {
    if ( m_crop.bottomLeft() == newBottomLeft ) {
        return;
    }
    m_crop.setBottomLeft( newBottomLeft );
    Q_EMIT cropChanged();
}


void Crop::setBottomRight( QPointF newBottomRight ) {
    if ( m_crop.bottomRight() == newBottomRight )
        return;
    m_crop.setBottomRight( newBottomRight );
    Q_EMIT cropChanged();
}

void Crop::setLeft( qreal newLeft ) {
    if ( qFuzzyCompare( m_crop.left(), newLeft ) ) {
        return;
    }
    m_crop.setLeft( newLeft );
    Q_EMIT cropChanged();
}

void Crop::setRight( qreal newRight ) {
    if ( qFuzzyCompare( m_crop.right(), newRight ) ) {
        return;
    }
    m_crop.setRight( newRight );
    Q_EMIT cropChanged();
}

void Crop::setTop( qreal newTop ) {
    if ( qFuzzyCompare( m_crop.top(), newTop ) ) {
        return;
    }
    m_crop.setTop( newTop );
    Q_EMIT cropChanged();
}

void Crop::setBottom( qreal newBottom ) {
    if ( qFuzzyCompare( m_crop.bottom(), newBottom ) ) {
        return;
    }
    m_crop.setBottom( newBottom );
    Q_EMIT cropChanged();
}

void Crop::increaseX() {
    m_crop.moveLeft( std::clamp( m_crop.x() + m_stepSize, 0.0, static_cast<qreal>( m_boundaries.width() - m_crop.width() ) ) );
    Q_EMIT cropChanged();
}

void Crop::increaseY() {
    m_crop.moveTop( std::clamp( m_crop.y() + m_stepSize, 0.0, static_cast<qreal>( m_boundaries.height() - m_crop.height() ) ) );
    Q_EMIT cropChanged();
}

void Crop::decreaseX() {
    m_crop.moveLeft( std::clamp( m_crop.x() - m_stepSize, 0.0, static_cast<qreal>( m_boundaries.width() ) ) );
    Q_EMIT cropChanged();
}

void Crop::decreaseY() {
    m_crop.moveTop( std::clamp( m_crop.y() - m_stepSize, 0.0, static_cast<qreal>( m_boundaries.height() ) ) );
    Q_EMIT cropChanged();
}

int Crop::stepSize() const {
    return m_stepSize;
}

void Crop::setStepSize( int newStepSize ) {
    if ( m_stepSize == newStepSize ) {
        return;
    }
    m_stepSize = newStepSize;
    Q_EMIT stepSizeChanged();
}
