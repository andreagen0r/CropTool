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

  ColumnLayout {
    anchors.fill: parent

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
        source: "https://images.unsplash.com/photo-1668877874752-518c5315d38d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1171&q=80"
      }
    }
  }

  Component {
    id: cropComponent
    CropTool {}
  }
}
