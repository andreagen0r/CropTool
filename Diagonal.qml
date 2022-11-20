import QtQuick
import QtQuick.Shapes

Shape {
  id: root

  property color color: "black"

  antialiasing: true
  smooth: true
  layer.enabled: true
  layer.samples: 16

  ShapePath {
    strokeWidth: 1
    strokeStyle: ShapePath.SolidLine
    strokeColor: root.color
    fillColor: "transparent"
    startX: 0
    startY: 0
    PathLine {
      x: root.width
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
    startY: root.height
    PathLine {
      x: root.width
      y: 0
    }

    Behavior on fillColor {
      ColorAnimation {
        duration: 150
        easing.type: Easing.InOutCubic
      }
    }
  }
}
