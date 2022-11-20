import QtQuick
import QtQuick.Shapes

Shape {
  id: root

  property color color: "black"

  antialiasing: true
  smooth: true

  ShapePath {
    strokeWidth: 1
    strokeStyle: ShapePath.SolidLine
    strokeColor: root.color
    fillColor: "transparent"
    startX: root.width / 3
    startY: 0
    PathLine {
      x: root.width / 3
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
    startX: 2 * (root.width / 3)
    startY: 0
    PathLine {
      x: 2 * (root.width / 3)
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
    startY: root.height / 3
    PathLine {
      x: root.width
      y: root.height / 3
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
    startY: 2 * (root.height / 3)
    PathLine {
      x: root.width
      y: 2 * (root.height / 3)
    }

    Behavior on fillColor {
      ColorAnimation {
        duration: 150
        easing.type: Easing.InOutCubic
      }
    }
  }
}
