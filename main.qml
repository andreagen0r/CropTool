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
                if(image1.selection) {
                    image1.selection.destroy()
                }
                image1.selection = cropComponent.createObject(image1, { "anchors.fill": image1, "focus": true})
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

                anchors.fill: parent
                mipmap: true

                width: horizontal ? parent.height * aspect : parent.width
                height: horizontal ? parent.height : parent.width / aspect
            }
        }
    }

    Component {
        id: cropComponent
        CropTool {}
    }
}
