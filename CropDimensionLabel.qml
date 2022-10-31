import QtQuick
import QtQuick.Controls

Control {
    id: root

    property color color: "white"
    property color backgroundColor: "black"
    property color borderColor: "white"

    property string text: ""

    implicitWidth: Math.max( implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding )
    implicitHeight: Math.max( implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding )

    padding: 12

    contentItem: Label{
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: root.text
        color: root.color
        font.bold: true
        font.pointSize: 12
    }

    background: Rectangle {
        implicitWidth: implicitContentWidth
        implicitHeight: implicitContentHeight
        color: root.backgroundColor
        radius: 3
        border.width: 1
        border.color: root.borderColor
        anchors.margins: 12
    }
}
