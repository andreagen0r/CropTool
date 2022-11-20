import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

import CropTool

FocusScope {
  id: root
  objectName: "Crop_Tool"

  property color color: "#CB9B5E"
  property color colorHighlight: "orange"
  property color borderColor: "#CB9B5E"
  property color backgroundColor: "#35CB9B5E"

  property color labelColor: "white"
  property color labelBackgroundColor: "#66000000"

  property real handleSize: 18
  property bool labelsVisible: true

  readonly property rect crop: backend.crop

  property int compositeGuideType: backend.Diagonal

  Binding {
    target: backend
    property: "boundaries"
    value: Qt.size(width, height)
  }

  Keys.onPressed: event => {
                    let speed = 1
                    backend.stepSize = 1
                    if (event.modifiers === Qt.ShiftModifier) {
                      speed = 10
                      backend.stepSize = 10
                    }

                    switch (event.key) {
                      case Qt.Key_Left:
                      {
                        backend.decreaseX()
                        event.accepted = true
                        break
                      }
                      case Qt.Key_Right:
                      {
                        backend.increaseX()
                        event.accepted = true
                        break
                      }
                      case Qt.Key_Up:
                      {
                        backend.decreaseY()
                        event.accepted = true
                        break
                      }
                      case Qt.Key_Down:
                      {
                        backend.increaseY()
                        event.accepted = true
                        break
                      }
                    }
                  }

  QtObject {
    id: internal
    readonly property real handleMultiplier: 1.5
    readonly property real handleVisibleSpace: (root.handleSize * 3) * 3
    readonly property bool isHorizontalVisible: backend.crop.height > (handleVisibleSpace)
    readonly property bool isVerticalVisible: backend.crop.width > (handleVisibleSpace)
  }

  MouseArea {
    id: mainMouse
    anchors.fill: root

    onReleased: {
      backend.startDraw = false
    }

    onPressed: {
      backend.startDraw = true
      backend.reset()
      backend.setStartPoint(Qt.point(mouseX, mouseY))
    }

    onPositionChanged: backend.makeRect(mouseX, mouseY)
  }

  Crop {
    id: backend
  }

  CropOverlay {
    anchors.fill: parent
    roi: backend
  }

  Shape {
    id: background

    x: handleLeft.x
    y: handleTop.y
    width: handleRight.x - handleLeft.x
    height: handleBottom.y - handleTop.y
    antialiasing: true
    smooth: true

    ShapePath {
      strokeWidth: 1
      strokeStyle: ShapePath.DashLine
      dashPattern: [1, 3]
      strokeColor: root.borderColor
      fillColor: "transparent" //root.backgroundColor
      joinStyle: ShapePath.RoundJoin
      startX: 0
      startY: 0
      PathLine {
        x: background.width
        y: 0
      }
      PathLine {
        x: background.width
        y: background.height
      }
      PathLine {
        x: 0
        y: background.height
      }
      PathLine {
        x: 0
        y: 0
      }

      Behavior on fillColor {
        ColorAnimation {
          duration: 150
          easing.type: Easing.InOutCubic
        }
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: containsMouse ? Qt.OpenHandCursor : Qt.ArrowCursor
      drag {
        target: background
        minimumX: 0
        minimumY: 0
        maximumX: backend.boundaries.width - background.width
        maximumY: backend.boundaries.height - background.height
      }

      onPressed: cursorShape = Qt.ClosedHandCursor
      onReleased: cursorShape = Qt.binding(function () {
        return containsMouse ? Qt.OpenHandCursor : Qt.ArrowCursor
      })

      onPositionChanged: {
        backend.crop.x = background.x
        backend.crop.y = background.y
      }
    }
  }

  RuleOfThird {
    id: composite_ruleOfThirds
    x: handleLeft.x
    y: handleTop.y
    width: handleRight.x - handleLeft.x
    height: handleBottom.y - handleTop.y
    visible: root.compositeGuideType === backend.RuleOfThirds
    color: root.color
  }

  Diagonal {
    id: composite_diagonal
    x: handleLeft.x
    y: handleTop.y
    width: handleRight.x - handleLeft.x
    height: handleBottom.y - handleTop.y
    visible: root.compositeGuideType === backend.Diagonal
    color: root.color
  }

  GoldenRatio {
    id: composite_goldenRatioGrid
    x: handleLeft.x
    y: handleTop.y
    width: handleRight.x - handleLeft.x
    height: handleBottom.y - handleTop.y
    visible: root.compositeGuideType === backend.GoldenRatio
    color: root.color
  }

  Item {
    id: handleLeft
    x: backend.crop.left
    width: root.handleSize
    height: backend.crop.height
    anchors.verticalCenter: background.verticalCenter
    opacity: internal.isHorizontalVisible ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 250
        easing.type: Easing.InOutCubic
      }
    }

    Rectangle {
      width: root.handleSize / 3
      height: root.handleSize * 3
      anchors.centerIn: parent
      anchors.horizontalCenterOffset: -(parent.width / 2)
      radius: width / 2
      opacity: backend.startDraw ? 0 : 1
      color: handleLeftMouse.pressed ? root.colorHighlight : root.color
      Behavior on color {
        ColorAnimation {
          duration: 150
          easing.type: Easing.InOutCubic
        }
      }

      MouseArea {
        id: handleLeftMouse
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: backend.crop.width < internal.handleVisibleSpace ? -(width / 2) : 0
        width: root.handleSize
        height: backend.crop.height
        preventStealing: true
        hoverEnabled: true
        cursorShape: pressed || containsMouse ? Qt.SizeHorCursor : Qt.ArrowCursor
        drag {
          target: handleLeft
          axis: Drag.XAxis
          minimumX: 0
          maximumX: handleBottomRight.x - 1
        }

        onPositionChanged: backend.setLeft(handleLeft.x)
      }
    }
  }

  Item {
    id: handleRight
    x: backend.crop.right
    width: root.handleSize
    height: backend.crop.height
    anchors.verticalCenter: background.verticalCenter
    opacity: internal.isHorizontalVisible ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 250
        easing.type: Easing.InOutCubic
      }
    }

    Rectangle {
      width: root.handleSize / 3
      height: root.handleSize * 3
      anchors.centerIn: parent
      anchors.horizontalCenterOffset: -(parent.width / 2)
      radius: width / 2
      opacity: backend.startDraw ? 0 : 1
      color: handleRightMouse.pressed ? root.colorHighlight : root.color
      Behavior on color {
        ColorAnimation {
          duration: 150
          easing.type: Easing.InOutCubic
        }
      }

      MouseArea {
        id: handleRightMouse
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: backend.crop.width < internal.handleVisibleSpace ? width / 2 : 0
        width: root.handleSize
        height: backend.crop.height
        hoverEnabled: true
        cursorShape: pressed || containsMouse ? Qt.SizeHorCursor : Qt.ArrowCursor
        drag {
          target: handleRight
          axis: Drag.XAxis
          minimumX: handleLeft.x + 1
          maximumX: root.width
        }

        onPositionChanged: backend.setRight(handleRight.x)
      }
    }
  }

  Item {
    id: handleTop
    y: backend.crop.top
    width: backend.crop.width
    height: root.handleSize * 0.6
    anchors.horizontalCenter: background.horizontalCenter
    opacity: internal.isVerticalVisible ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 250
        easing.type: Easing.InOutCubic
      }
    }

    Rectangle {
      width: root.handleSize * 3
      height: root.handleSize / 3
      anchors.centerIn: parent
      anchors.verticalCenterOffset: -(parent.height / 2)
      radius: height / 2
      opacity: backend.startDraw ? 0 : 1
      color: handleTopMouse.pressed ? root.colorHighlight : root.color
      Behavior on color {
        ColorAnimation {
          duration: 150
          easing.type: Easing.InOutCubic
        }
      }
      MouseArea {
        id: handleTopMouse
        anchors.centerIn: parent
        anchors.verticalCenterOffset: backend.crop.height < internal.handleVisibleSpace ? -(height / 2) : 0
        width: backend.crop.width
        height: root.handleSize
        preventStealing: true
        hoverEnabled: true
        cursorShape: pressed || containsMouse ? Qt.SizeVerCursor : Qt.ArrowCursor
        drag {
          target: handleTop
          axis: Drag.YAxis
          minimumY: 0
          maximumY: handleBottomRight.y - 1
        }
        onPositionChanged: backend.setTop(handleTop.y)
      }
    }
  }

  Item {
    id: handleBottom
    width: backend.crop.width
    height: root.handleSize * 0.6
    y: backend.crop.bottom
    anchors.horizontalCenter: background.horizontalCenter
    opacity: internal.isVerticalVisible ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 250
        easing.type: Easing.InOutCubic
      }
    }

    Rectangle {
      width: root.handleSize * 3
      height: root.handleSize / 3
      anchors.centerIn: parent
      anchors.verticalCenterOffset: -(parent.height / 2)
      radius: height / 2
      opacity: backend.startDraw ? 0 : 1
      color: handleBottomMouse.pressed ? root.colorHighlight : root.color
      Behavior on opacity {
        NumberAnimation {
          duration: 150
          easing.type: Easing.InOutCubic
        }
      }
      Behavior on color {
        ColorAnimation {
          duration: 150
          easing.type: Easing.InOutCubic
        }
      }
      MouseArea {
        id: handleBottomMouse
        anchors.centerIn: parent
        anchors.verticalCenterOffset: backend.crop.height < internal.handleVisibleSpace ? height / 2 : 0
        width: backend.crop.width
        height: root.handleSize
        preventStealing: true
        hoverEnabled: true
        cursorShape: pressed || containsMouse ? Qt.SizeVerCursor : Qt.ArrowCursor
        drag {
          target: handleBottom
          axis: Drag.YAxis
          minimumY: handleTop.y + 1
          maximumY: root.height
        }
        onPositionChanged: backend.setBottom(handleBottom.y)
      }
    }
  }

  // ************************************************************
  // Corners
  // ************************************************************
  Item {
    id: handleTopLeft
    x: backend.crop.left
    y: backend.crop.top
    width: root.handleSize * internal.handleMultiplier
    height: width
    opacity: (internal.isVerticalVisible && internal.isHorizontalVisible) ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 250
        easing.type: Easing.InOutCubic
      }
    }

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
        startX: 0
        startY: handleTopLeft.height
        PathLine {
          x: 0
          y: 0
        }
        PathLine {
          x: handleTopLeft.height
          y: 0
        }

        Behavior on fillColor {
          ColorAnimation {
            duration: 150
            easing.type: Easing.InOutCubic
          }
        }
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
        drag {
          target: handleTopLeft
          axis: Drag.XAndYAxis
          minimumX: 0
          minimumY: 0
          maximumX: handleBottomRight.x - 1
          maximumY: handleBottomRight.y - 1
        }
        onPositionChanged: backend.setTopLeft(Qt.point(handleTopLeft.x, handleTopLeft.y))
      }
    }
  }

  Item {
    id: handleTopRight
    x: backend.crop.right
    y: backend.crop.top
    width: root.handleSize * internal.handleMultiplier
    height: width
    opacity: (internal.isVerticalVisible && internal.isHorizontalVisible) ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 250
        easing.type: Easing.InOutCubic
      }
    }

    Shape {
      width: parent.width
      height: parent.height
      x: -(parent.height)
      antialiasing: true
      smooth: true
      opacity: backend.startDraw ? 0 : 1
      ShapePath {
        strokeWidth: 2
        strokeColor: handleTopRightMouse.pressed ? root.colorHighlight : Qt.lighter(root.color, 1.4)
        fillColor: "transparent"
        startX: 0
        startY: 0
        PathLine {
          x: handleTopRight.width
          y: 0
        }
        PathLine {
          x: handleTopRight.width
          y: handleTopRight.height
        }

        Behavior on fillColor {
          ColorAnimation {
            duration: 150
            easing.type: Easing.InOutCubic
          }
        }
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
        drag {
          target: handleTopRight
          axis: Drag.XAndYAxis
          minimumX: handleTopLeft.x + 1
          minimumY: 0
          maximumX: root.width
          maximumY: handleBottomRight.y
        }
        onPositionChanged: backend.setTopRight(Qt.point(handleTopRight.x, handleTopRight.y))
      }
    }
  }

  Item {
    id: handleBottomLeft
    x: backend.crop.left
    y: backend.crop.bottom
    width: root.handleSize * internal.handleMultiplier
    height: width
    opacity: (internal.isVerticalVisible && internal.isHorizontalVisible) ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 250
        easing.type: Easing.InOutCubic
      }
    }

    Shape {
      width: parent.width
      height: parent.height
      y: -(parent.height)
      antialiasing: true
      smooth: true
      opacity: backend.startDraw ? 0 : 1
      ShapePath {
        strokeWidth: 2
        strokeColor: handleBottomLeftMouse.pressed ? root.colorHighlight : Qt.lighter(root.color, 1.4)
        fillColor: "transparent"
        startX: 0
        startY: 0
        PathLine {
          x: 0
          y: handleBottomLeft.height
        }
        PathLine {
          x: handleBottomLeft.width
          y: handleBottomLeft.height
        }

        Behavior on fillColor {
          ColorAnimation {
            duration: 150
            easing.type: Easing.InOutCubic
          }
        }
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
        drag {
          target: handleBottomLeft
          axis: Drag.XAndYAxis
          minimumX: 0
          minimumY: handleTopLeft.y + 1
          maximumX: handleBottomRight.x - 1
          maximumY: root.height
        }
        onPositionChanged: backend.setBottomLeft(Qt.point(handleBottomLeft.x, handleBottomLeft.y))
      }
    }
  }

  Item {
    id: handleBottomRight
    x: backend.crop.right
    y: backend.crop.bottom
    width: root.handleSize * internal.handleMultiplier
    height: width
    opacity: (internal.isVerticalVisible && internal.isHorizontalVisible) ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 250
        easing.type: Easing.InOutCubic
      }
    }

    Shape {
      width: parent.width
      height: parent.height
      x: -(parent.width)
      y: -(parent.height)
      antialiasing: true
      smooth: true
      opacity: backend.startDraw ? 0 : 1
      ShapePath {
        strokeWidth: 2
        strokeColor: handleBottomRightMouse.pressed ? root.colorHighlight : Qt.lighter(root.color, 1.4)
        fillColor: "transparent"
        startX: handleBottomRight.width
        startY: 0
        PathLine {
          x: handleBottomRight.width
          y: handleBottomRight.height
        }
        PathLine {
          x: 0
          y: handleBottomRight.height
        }

        Behavior on fillColor {
          ColorAnimation {
            duration: 150
            easing.type: Easing.InOutCubic
          }
        }
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
        drag {
          target: handleBottomRight
          axis: Drag.XAndYAxis
          minimumX: handleTopLeft.x + 1
          minimumY: handleTopLeft.y + 1
          maximumX: root.width
          maximumY: root.height
        }
        onPositionChanged: backend.setBottomRight(Qt.point(handleBottomRight.x, handleBottomRight.y))
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
    opacity: (state === "Inside") ? internal.isHorizontalVisible ? 1 : 0 : 1
    Behavior on opacity {
      NumberAnimation {
        duration: 250
        easing.type: Easing.InOutCubic
      }
    }

    text: `${Math.round(backend.crop.width)} px`

    state: backend.crop.y < widthLabel.height + anchors.margins ? "Inside" : "Outside"
    states: [
      State {
        name: "Inside"
        AnchorChanges {
          target: widthLabel
          anchors.bottom: undefined
          anchors.top: background.top
        }
      },
      State {
        name: "Outside"
        AnchorChanges {
          target: widthLabel
          anchors.top: undefined
          anchors.bottom: background.top
        }
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
    opacity: (state === "Inside") ? internal.isVerticalVisible ? 1 : 0 : 1
    Behavior on opacity {
      NumberAnimation {
        duration: 250
        easing.type: Easing.InOutCubic
      }
    }

    text: `${Math.round(backend.crop.height)} px`

    state: backend.crop.x < widthLabel.width + anchors.margins ? "Inside" : "Outside"
    states: [
      State {
        name: "Inside"
        AnchorChanges {
          target: heightLabel
          anchors.left: background.left
        }
      },
      State {
        name: "Outside"
        AnchorChanges {
          target: heightLabel
          anchors.right: background.left
        }
      }
    ]
  }
}
