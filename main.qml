import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import CropTool

ApplicationWindow {
  id: root
  title: qsTr("Crop Tool")
  width: 1920
  height: 1080
  visible: true

  Material.theme: Material.Dark
  Material.accent: Material.Orange

  ColumnLayout {
    anchors.fill: parent

    RowLayout {
      Layout.fillWidth: true

      ToolButton {
        text: "Crop"
        checkable: true
        onCheckedChanged: {
          if (image1.selection) {
            image1.selection.destroy()
          }
          image1.selection = cropComponent.createObject(image1, {
                                                          "anchors.fill": image1,
                                                          "focus": true
                                                        })
        }
      }
      ComboBox {
        id: combo
        Layout.preferredWidth: 150
        textRole: "text"
        valueRole: "value"
        model: ListModel {
          id: model
          ListElement {
            text: "Rule of Third"
            value: 0
          }
          ListElement {
            text: "Diagonal"
            value: 1
          }
          ListElement {
            text: "Golden Ratio"
            value: 2
          }
        }
      }
    }

    Item {
      Layout.fillWidth: true
      Layout.fillHeight: true

      Image {
        id: image1
        property var selection: undefined

        property real windowAspect: parent.width / parent.height
        property real aspect: sourceSize.width / sourceSize.height
        property bool horizontal: windowAspect >= aspect

        anchors.centerIn: parent
        mipmap: true

        width: horizontal ? parent.height * aspect : parent.width
        height: horizontal ? parent.height : parent.width / aspect
        source: "https://images.unsplash.com/photo-1457301353672-324d6d14f471?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80"
      }
    }
  }

  Component {
    id: cropComponent
    CropTool {
      focus: true
      compositeGuideType: combo.currentValue
    }
  }
}
