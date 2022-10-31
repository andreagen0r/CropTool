import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

import CropTool

FocusScope {
    id: root
    objectName: "Crop_Tool"

    opacity: 0

    property color color: "#CB9B5E"
    property color colorHighlight: "orange"
    property color borderColor: "#CB9B5E"
    property color backgroundColor: "#35CB9B5E"

    property color labelColor: "white"
    property color labelBackgroundColor: "#66000000"

    property real handleSize: 18
    property bool labelsVisible: true

    signal roiChanged(rect _roi)

    onWidthChanged: backend.windowSize = Qt.size(width, height)
    onHeightChanged: backend.windowSize = Qt.size(width, height)

    Keys.onPressed: (event)=> {
                        let speed = 1
                        if (event.modifiers === Qt.ShiftModifier ) {
                            speed = 10
                        }

                        switch (event.key) {
                            case Qt.Key_Left: {
                                backend.crop.x -= backend.crop.x < 0 ? 0 : speed
                                backend.topLeft.x -= backend.crop.x < 0 ? 0 : speed
                                backend.bottomRight.x -= backend.crop.x < 0 ? 0 : speed
                                event.accepted = true;

                                break
                            }
                            case Qt.Key_Right: {
                                const mRight = width - backend.crop.width
                                const limitX = mRight - backend.crop.x + 1
                                backend.crop.x += backend.crop.x > mRight ? limitX : speed
                                backend.topLeft.x += backend.crop.x > mRight ? limitX : speed
                                backend.bottomRight.x += backend.crop.x > mRight ? limitX : speed
                                event.accepted = true;
                                break
                            }
                            case Qt.Key_Up: {
                                backend.crop.y -= backend.crop.y < 0 ? 0 : speed
                                backend.topLeft.y -= backend.crop.y < 0 ? 0 : speed
                                backend.bottomRight.y -= backend.crop.y < 0 ? 0 : speed
                                event.accepted = true;
                                break
                            }
                            case Qt.Key_Down: {
                                const mDown = height - backend.crop.height
                                const limitY = mDown - backend.crop.y - 1
                                console.log(backend.crop.y, mDown, limitY)
                                backend.crop.y += backend.crop.y > mDown ? limitY : speed
                                backend.topLeft.y += backend.crop.y > mDown ? limitY : speed
                                backend.bottomRight.y += backend.crop.y > mDown ? limitY : speed
                                event.accepted = true;
                                break
                            }
                        }

                        updateDraw()
                    }

    QtObject {
        id: internal
        readonly property real handleMultiplier: 1.5
        readonly property real handleVisibleSpace: (root.handleSize * 3) * 3
        readonly property bool isHorizontalVisible: backend.crop.height > ( handleVisibleSpace )
        readonly property bool isVerticalVisible: backend.crop.width > ( handleVisibleSpace )
    }

    MouseArea {
        anchors.fill: root

        onReleased: backend.startDraw = false

        onPressed: {
            backend.startDraw = true
            backend.reset()
            backend.startPoint = Qt.point(mouseX, mouseY)
        }

        onPositionChanged:  {
            if (root.opacity < 1) {
                root.opacity = 1
            }

            backend.currentPoint = Qt.point(mouseX, mouseY)
            backend.makeRect(mouseX, mouseY)
        }
    }

    Crop {
        id: backend

        onCropChanged: root.roiChanged(crop)

        onStartPointChanged: {
            handleTopLeft.x = backend.startPoint.x
            handleTopLeft.y = backend.startPoint.y
        }

        onCurrentPointChanged: {
            handleTopLeft.x = crop.left
            handleTopLeft.y = crop.top

            handleBottomRight.x =  crop.right
            handleBottomRight.y = crop.bottom

            handleLeft.x = crop.left
            handleRight.x = crop.right
            handleTop.y = crop.top
            handleBottom.y = crop.bottom

            handleTopRight.x = crop.right
            handleTopRight.y = crop.top

            handleBottomLeft.x = crop.left
            handleBottomLeft.y = crop.bottom

            updateDraw()
        }

        onTopLeftChanged: {
            handleTopLeft.x = topLeft.x
            handleTopLeft.y = topLeft.y

            handleLeft.x = topLeft.x
            handleTop.y = topLeft.y

            handleTopRight.y = topLeft.y

            handleBottomLeft.x = topLeft.x
        }

        onBottomRightChanged: {
            handleBottomRight.x = bottomRight.x
            handleBottomRight.y = bottomRight.y

            handleRight.x = bottomRight.x
            handleBottom.y = bottomRight.y

            handleTopRight.x = bottomRight.x

            handleBottomLeft.y = bottomRight.y
        }
    }

    Shape {
        id: background
        width: backend.crop.width
        height: backend.crop.height
        x: backend.crop.x
        y: backend.crop.y
        antialiasing: true
        smooth: true

        ShapePath {
            strokeWidth: 1
            strokeStyle: ShapePath.DashLine
            dashPattern: [1, 3]
            strokeColor: root.borderColor
            fillColor: root.backgroundColor
            joinStyle: ShapePath.RoundJoin
            startX: 0; startY: 0
            PathLine { x: background.width; y: 0 }
            PathLine { x: background.width; y: background.height }
            PathLine { x: 0; y: background.height }
            PathLine { x: 0; y: 0 }

            Behavior on fillColor { ColorAnimation { duration: 150; easing.type: Easing.InOutCubic } }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: containsMouse ? Qt.OpenHandCursor : Qt.ArrowCursor
            drag {
                target: background
                minimumX: 0
                minimumY: 0
                maximumX: root.width - parent.width
                maximumY: root.height - parent.height
            }

            onPressed: cursorShape = Qt.ClosedHandCursor
            onReleased: cursorShape = Qt.binding(function(){return containsMouse ? Qt.OpenHandCursor : Qt.ArrowCursor})

            onPositionChanged: {
                backend.topLeft = Qt.point( parent.x, parent.y )
                backend.bottomRight = Qt.point( parent.x + parent.width, parent.y + parent.height )

                handleTopLeft.x = backend.topLeft.x
                handleTopLeft.y = backend.topLeft.y
                handleBottomRight.x = backend.bottomRight.x
                handleBottomRight.y = backend.bottomRight.y

                handleLeft.x = backend.topLeft.x
                handleRight.x = backend.bottomRight.x

                handleTop.y = backend.topLeft.y
                handleBottom.y = backend.bottomRight.y
                updateDraw()
            }
        }
    }

    CropDimensionLabel {
        id: widthLabel
        visible: root.labelsVisible
        anchors.horizontalCenter: background.horizontalCenter
        anchors.margins: 12
        color: root.labelColor
        backgroundColor: root.labelBackgroundColor
        borderColor: root.borderColor
        opacity: ( state === "Inside" ) ? internal.isHorizontalVisible ? 1 : 0 : 1
        Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutCubic } }

        text: `${Math.round(backend.crop.width)} px`

        state: backend.crop.y < widthLabel.height + anchors.margins ? "Inside" : "Outside"
        states: [
            State {
                name: "Inside"
                AnchorChanges { target: widthLabel; anchors.bottom: undefined; anchors.top: background.top }
            },
            State {
                name: "Outside"
                AnchorChanges { target: widthLabel; anchors.top: undefined; anchors.bottom: background.top }
            }
        ]
    }

    CropDimensionLabel {
        id: heightLabel
        visible: root.labelsVisible
        anchors.verticalCenter: background.verticalCenter
        anchors.margins: 12
        color: root.labelColor
        backgroundColor: root.labelBackgroundColor
        borderColor: root.borderColor
        opacity: ( state === "Inside" ) ? internal.isVerticalVisible ? 1 : 0 : 1
        Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutCubic } }

        text: `${Math.round(backend.crop.height)} px`

        state: backend.crop.x < widthLabel.width + anchors.margins ? "Inside" : "Outside"
        states: [
            State {
                name: "Inside"
                AnchorChanges { target: heightLabel; anchors.left: background.left }
            },
            State {
                name: "Outside"
                AnchorChanges { target: heightLabel; anchors.right: background.left }
            }
        ]
    }

    Item {
        id: handleLeft
        width: root.handleSize
        height: backend.crop.height
        anchors.verticalCenter: background.verticalCenter
        opacity: internal.isHorizontalVisible ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutCubic } }

        Rectangle {
            width: root.handleSize / 3
            height: root.handleSize * 3
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -( parent.width / 2)
            radius: width / 2
            opacity: backend.startDraw ? 0 : 1
            color: handleLeftMouse.pressed ? root.colorHighlight : root.color
            Behavior on color { ColorAnimation { duration: 150; easing.type: Easing.InOutCubic } }

            MouseArea {
                id: handleLeftMouse
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: backend.crop.width < internal.handleVisibleSpace ? -(width / 2) : 0
                width: root.handleSize
                height: backend.crop.height
                preventStealing: true
                hoverEnabled: true
                cursorShape: pressed || containsMouse ? Qt.SizeHorCursor : Qt.ArrowCursor
                drag{
                    target: handleLeft
                    axis: Drag.XAxis
                    minimumX: 0
                    maximumX: handleBottomRight.x - 1
                }

                onPositionChanged: {
                    backend.topLeft = Qt.point(handleLeft.x, handleTopLeft.y)
                    updateDraw()
                }
            }
        }
    }

    Item {
        id: handleRight
        width: root.handleSize
        height: backend.crop.height
        anchors.verticalCenter: background.verticalCenter
        opacity: internal.isHorizontalVisible ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutCubic } }

        Rectangle {
            width: root.handleSize / 3
            height: root.handleSize * 3
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -( parent.width / 2)
            radius: width / 2
            opacity: backend.startDraw ? 0 : 1
            color: handleRightMouse.pressed ? root.colorHighlight : root.color
            Behavior on color { ColorAnimation { duration: 150; easing.type: Easing.InOutCubic } }

            MouseArea {
                id: handleRightMouse
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: backend.crop.width < internal.handleVisibleSpace ? width / 2 : 0
                width: root.handleSize
                height: backend.crop.height
                preventStealing: true
                hoverEnabled: true
                cursorShape: pressed || containsMouse ? Qt.SizeHorCursor : Qt.ArrowCursor
                drag{
                    target: handleRight
                    axis: Drag.XAxis
                    minimumX: handleLeft.x + 1
                    maximumX: root.width
                }

                onPositionChanged: {
                    backend.bottomRight = Qt.point(handleRight.x, handleBottomRight.y)
                    updateDraw()
                }
            }
        }
    }

    Item {
        id: handleTop
        width: backend.crop.width
        height: root.handleSize * 0.6
        anchors.horizontalCenter: background.horizontalCenter
        opacity: internal.isVerticalVisible ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutCubic } }

        Rectangle {
            width: root.handleSize * 3
            height: root.handleSize / 3
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -(parent.height / 2)
            radius: height / 2
            opacity: backend.startDraw ? 0 : 1
            color: handleTopMouse.pressed ? root.colorHighlight : root.color
            Behavior on color { ColorAnimation { duration: 150; easing.type: Easing.InOutCubic } }
            MouseArea {
                id: handleTopMouse
                anchors.centerIn: parent
                anchors.verticalCenterOffset: backend.crop.height < internal.handleVisibleSpace ? -(height / 2) : 0
                width: backend.crop.width
                height: root.handleSize
                preventStealing: true
                hoverEnabled: true
                cursorShape: pressed || containsMouse ? Qt.SizeVerCursor : Qt.ArrowCursor
                drag{
                    target: handleTop
                    axis: Drag.YAxis
                    minimumY: 0
                    maximumY: handleBottomRight.y - 1
                }
                onPositionChanged: {
                    backend.topLeft = Qt.point(handleTopLeft.x, handleTop.y)
                    updateDraw()
                }
            }
        }
    }

    Item {
        id: handleBottom
        width: backend.crop.width
        height: root.handleSize * 0.6
        anchors.horizontalCenter: background.horizontalCenter
        opacity: internal.isVerticalVisible ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutCubic } }

        Rectangle {
            width: root.handleSize * 3
            height: root.handleSize / 3
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -(parent.height / 2)
            radius: height / 2
            opacity: backend.startDraw ? 0 : 1
            color: handleBottomMouse.pressed ? root.colorHighlight : root.color
            Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.InOutCubic } }
            Behavior on color { ColorAnimation { duration: 150; easing.type: Easing.InOutCubic } }
            MouseArea {
                id: handleBottomMouse
                anchors.centerIn: parent
                anchors.verticalCenterOffset: backend.crop.height < internal.handleVisibleSpace ? height / 2 : 0
                width: backend.crop.width
                height: root.handleSize
                preventStealing: true
                hoverEnabled: true
                cursorShape: pressed || containsMouse ? Qt.SizeVerCursor : Qt.ArrowCursor
                drag{
                    target: handleBottom
                    axis: Drag.YAxis
                    minimumY: handleTop.y + 1
                    maximumY: root.height
                }
                onPositionChanged: {
                    backend.bottomRight = Qt.point(handleBottomRight.x, handleBottom.y)
                    updateDraw()
                }
            }
        }
    }

    // ************************************************************
    // Corners
    // ************************************************************

    Item {
        id: handleTopLeft
        width: root.handleSize * internal.handleMultiplier
        height: width
        opacity: (internal.isVerticalVisible && internal.isHorizontalVisible) ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutCubic } }

        Shape {
            width: parent.width
            height: parent.height
            antialiasing: true
            smooth: true
            opacity: backend.startDraw ? 0 : 1
            ShapePath {
                strokeWidth: 2
                strokeColor: handleTopLeftMouse.pressed ? root.colorHighlight : Qt.lighter(root.color, 1.4)
                fillColor: "transparent"
                startX: 0; startY: handleTopLeft.height
                PathLine { x: 0; y: 0 }
                PathLine { x: handleTopLeft.height; y: 0 }

                Behavior on fillColor { ColorAnimation { duration: 150; easing.type: Easing.InOutCubic } }
            }

            MouseArea {
                id: handleTopLeftMouse
                readonly property bool doOffset: backend.crop.width < internal.handleVisibleSpace || backend.crop.height < internal.handleVisibleSpace
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: doOffset ? -(width / 2) : 0
                anchors.verticalCenterOffset: doOffset ? -(height / 2) : 0
                width: root.handleSize * 2
                height: width
                preventStealing: true
                hoverEnabled: true
                cursorShape: pressed || containsMouse ? Qt.SizeFDiagCursor : Qt.ArrowCursor
                drag{
                    target: handleTopLeft
                    axis: Drag.XAndYAxis
                    minimumX: 0
                    minimumY: 0
                    maximumX: handleBottomRight.x - 1
                    maximumY: handleBottomRight.y - 1
                }
                onPositionChanged: {
                    backend.topLeft = Qt.point(handleTopLeft.x, handleTopLeft.y)
                    updateDraw()
                }
            }
        }
    }

    Item {
        id: handleTopRight
        width: root.handleSize * internal.handleMultiplier
        height: width
        opacity: (internal.isVerticalVisible && internal.isHorizontalVisible) ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutCubic } }

        Shape {
            width: parent.width
            height: parent.height
            x: - ( parent.height )
            antialiasing: true
            smooth: true
            opacity: backend.startDraw ? 0 : 1
            ShapePath {
                strokeWidth: 2
                strokeColor: handleTopRightMouse.pressed ? root.colorHighlight : Qt.lighter(root.color, 1.4)
                fillColor: "transparent"
                startX: 0; startY: 0
                PathLine { x: handleTopRight.width; y: 0 }
                PathLine { x: handleTopRight.width; y: handleTopRight.height }

                Behavior on fillColor { ColorAnimation { duration: 150; easing.type: Easing.InOutCubic } }
            }

            MouseArea {
                id: handleTopRightMouse
                readonly property bool doOffset: backend.crop.width < internal.handleVisibleSpace || backend.crop.height < internal.handleVisibleSpace
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: doOffset ? (width / 2) : 0
                anchors.verticalCenterOffset: doOffset ? -(height / 2) : 0
                width: root.handleSize * 2
                height: width
                preventStealing: true
                hoverEnabled: true
                cursorShape: pressed || containsMouse ? Qt.SizeBDiagCursor : Qt.ArrowCursor
                drag{
                    target: handleTopRight
                    axis: Drag.XAndYAxis
                    minimumX: handleTopLeft.x + 1
                    minimumY: 0
                    maximumX: root.width
                    maximumY: handleBottomRight.y
                }
                onPositionChanged: {
                    backend.topLeft = Qt.point(handleTopLeft.x, handleTopRight.y)
                    backend.bottomRight = Qt.point(handleTopRight.x, handleBottomRight.y)
                    updateDraw()
                }
            }
        }
    }

    Item {
        id: handleBottomLeft
        width: root.handleSize * internal.handleMultiplier
        height: width
        opacity: (internal.isVerticalVisible && internal.isHorizontalVisible) ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutCubic } }

        Shape {
            width: parent.width
            height: parent.height
            y: - ( parent.height )
            antialiasing: true
            smooth: true
            opacity: backend.startDraw ? 0 : 1
            ShapePath {
                strokeWidth: 2
                strokeColor: handleBottomLeftMouse.pressed ? root.colorHighlight : Qt.lighter(root.color, 1.4)
                fillColor: "transparent"
                startX: 0; startY: 0
                PathLine { x: 0; y: handleBottomLeft.height }
                PathLine { x: handleBottomLeft.width; y: handleBottomLeft.height }

                Behavior on fillColor { ColorAnimation { duration: 150; easing.type: Easing.InOutCubic } }
            }

            MouseArea {
                id: handleBottomLeftMouse
                readonly property bool doOffset: backend.crop.width < internal.handleVisibleSpace || backend.crop.height < internal.handleVisibleSpace
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: doOffset ? -(width / 2) : 0
                anchors.verticalCenterOffset: doOffset ? (height / 2) : 0
                width: root.handleSize * 2
                height: width
                preventStealing: true
                hoverEnabled: true
                cursorShape: pressed || containsMouse ? Qt.SizeBDiagCursor : Qt.ArrowCursor
                drag{
                    target: handleBottomLeft
                    axis: Drag.XAndYAxis
                    minimumX: 0
                    minimumY: handleTopLeft.y + 1
                    maximumX: handleBottomRight.x - 1
                    maximumY: root.height
                }
                onPositionChanged: {
                    backend.topLeft = Qt.point(handleBottomLeft.x, handleTopRight.y)
                    backend.bottomRight = Qt.point(handleTopRight.x, handleBottomLeft.y)
                    updateDraw()
                }
            }
        }
    }

    Item {
        id: handleBottomRight
        width: root.handleSize * internal.handleMultiplier
        height: width
        opacity: (internal.isVerticalVisible && internal.isHorizontalVisible) ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutCubic } }

        Shape {
            width: parent.width
            height: parent.height
            x: - ( parent.width )
            y: - ( parent.height )
            antialiasing: true
            smooth: true
            opacity: backend.startDraw ? 0 : 1
            ShapePath {
                strokeWidth: 2
                strokeColor: handleBottomRightMouse.pressed ? root.colorHighlight : Qt.lighter(root.color, 1.4)
                fillColor: "transparent"
                startX: handleBottomRight.width; startY: 0
                PathLine { x: handleBottomRight.width; y: handleBottomRight.height }
                PathLine { x: 0; y: handleBottomRight.height }

                Behavior on fillColor { ColorAnimation { duration: 150; easing.type: Easing.InOutCubic } }
            }

            MouseArea {
                id: handleBottomRightMouse
                readonly property bool doOffset: backend.crop.width < internal.handleVisibleSpace || backend.crop.height < internal.handleVisibleSpace
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: doOffset ? (width / 2) : 0
                anchors.verticalCenterOffset: doOffset ? (height / 2) : 0
                width: root.handleSize * 2
                height: width
                preventStealing: true
                hoverEnabled: true
                cursorShape: pressed || containsMouse ? Qt.SizeFDiagCursor : Qt.ArrowCursor
                drag{
                    target: handleBottomRight
                    axis: Drag.XAndYAxis
                    minimumX: handleTopLeft.x + 1
                    minimumY: handleTopLeft.y + 1
                    maximumX: root.width
                    maximumY: root.height
                }
                onPositionChanged: {
                    backend.bottomRight = Qt.point(handleBottomRight.x, handleBottomRight.y)
                    updateDraw()
                }
            }
        }
    }

    function updateDraw() {
        backend.crop = Qt.rect(handleTopLeft.x, handleTopLeft.y, handleBottomRight.x - handleTopLeft.x, handleBottomRight.y - handleTopLeft.y)
    }
}
