import QtQuick

import CropTool

import "./Misc.js" as Script

Item {
  id: root

  required property Crop roi
  property color color: "black"
  property real transparency: 0.7

  Rectangle {
    // top
    opacity: root.roi.crop.width > 0
    width: parent.width
    height: root.roi.crop.top
    color: Script.makeTransparent(root.color, root.transparency)

    Behavior on opacity {
      NumberAnimation {
        duration: 150
        easing.type: Easing.InOutCubic
      }
    }
  }

  Rectangle {
    // bottom
    opacity: root.roi.crop.width > 0
    y: root.roi.crop.bottom
    width: parent.width
    height: root.height - root.roi.crop.bottom
    color: Script.makeTransparent(root.color, root.transparency)

    Behavior on opacity {
      NumberAnimation {
        duration: 150
        easing.type: Easing.InOutCubic
      }
    }
  }

  Rectangle {
    // left
    opacity: root.roi.crop.width > 0
    y: root.roi.crop.top
    width: root.roi.crop.left
    height: root.roi.crop.height
    color: Script.makeTransparent(root.color, root.transparency)

    Behavior on opacity {
      NumberAnimation {
        duration: 150
        easing.type: Easing.InOutCubic
      }
    }
  }

  Rectangle {
    // right
    opacity: root.roi.crop.width > 0
    x: root.roi.crop.right
    y: root.roi.crop.top
    width: root.width - root.roi.crop.right
    height: root.roi.crop.height
    color: Script.makeTransparent(root.color, root.transparency)

    Behavior on opacity {
      NumberAnimation {
        duration: 150
        easing.type: Easing.InOutCubic
      }
    }
  }
}
