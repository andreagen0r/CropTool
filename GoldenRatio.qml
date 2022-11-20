import QtQuick

import QtQuick.Shapes

Shape {
  id: root

  property color color: "black"

  antialiasing: true
  smooth: true

  QtObject {
    id: internal

    readonly property real valueX1: (root.width - (root.width * 0.618))
    readonly property real valueX2: valueX1 + root.width - (2 * valueX1)
    readonly property real valueY1: (root.height - (root.height * 0.618))
    readonly property real valueY2: valueY1 + root.height - (2 * valueY1)
  }

  ShapePath {
    strokeWidth: 1
    strokeStyle: ShapePath.SolidLine
    strokeColor: root.color
    fillColor: "transparent"
    startX: internal.valueX1
    startY: 0
    PathLine {
      x: internal.valueX1
      y: root.height
    }

    Behavior on fillColor {
      ColorAnimation {
        duration: 150
        easing.type: Easing.InOutCubic
      }
    }
  }

  ShapePath {
    strokeWidth: 1
    strokeStyle: ShapePath.SolidLine
    strokeColor: root.color
    fillColor: "transparent"
    startX: internal.valueX2
    startY: 0
    PathLine {
      x: internal.valueX2
      y: root.height
    }

    Behavior on fillColor {
      ColorAnimation {
        duration: 150
        easing.type: Easing.InOutCubic
      }
    }
  }

  ShapePath {
    strokeWidth: 1
    strokeStyle: ShapePath.SolidLine
    strokeColor: root.color
    fillColor: "transparent"
    startX: 0
    startY: internal.valueY1
    PathLine {
      x: root.width
      y: internal.valueY1
    }

    Behavior on fillColor {
      ColorAnimation {
        duration: 150
        easing.type: Easing.InOutCubic
      }
    }
  }

  ShapePath {
    strokeWidth: 1
    strokeStyle: ShapePath.SolidLine
    strokeColor: root.color
    fillColor: "transparent"
    startX: 0
    startY: internal.valueY2
    PathLine {
      x: root.width
      y: internal.valueY2
    }

    Behavior on fillColor {
      ColorAnimation {
        duration: 150
        easing.type: Easing.InOutCubic
      }
    }
  }
}
