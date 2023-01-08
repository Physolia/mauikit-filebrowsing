import QtQuick 2.14
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.14

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.3 as FB

/**
 * NewTagDialog
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
Maui.Dialog
{
    id: control

    property alias currentColor : _colorsRow.currentColor
    readonly property var defaultColors : ["#4DD0E1", "#9575CD", "#F06292", "#DCE775", "#FFD54F", "#FF8A65", "#90A4AE"]

    
    title: i18nd("mauikitfilebrowsing", "New tags")
    message: i18nd("mauikitfilebrowsing", "Create new tags to organize your files. You can create multiple tags separated by a comma.")

    closeButtonVisible: false
    
    acceptButton.text: i18nd("mauikitfilebrowsing", "Add")
    rejectButton.text: i18nd("mauikitfilebrowsing", "Cancel")

    onAccepted: done()
    onRejected:
    {
        control.close()
    }

    property alias textEntry: _textEntry
    
    TextField
    {
        id: _textEntry
        Layout.fillWidth: true
    }
    
    Maui.ColorsRow
    {
        id: _colorsRow
                Layout.fillWidth: true

        colors: control.defaultColors
        onColorPicked: currentColor = color
    }
    
    Flow
    {
        visible: control.textEntry.text.length
        Layout.fillWidth: true
//         implicitHeight: Math.min(200, contentHeight) + Maui.Style.space.big
//         implicitHeight: Maui.Style.toolBarHeight * 1.2
//         orientation: ListView.Horizontal
        spacing: Maui.Style.space.medium
        
//         horizontalScrollBarPolicy: ScrollBar.AlwaysOff
        //snapMode: ListView.SnapOneItem
//         verticalScrollBarPolicy: ScrollBar.AlwaysOff        
        
        Repeater
        {
            model: textEntry.text.split(",")
            
            delegate: Maui.Chip
            {
                label.text: modelData
                showCloseButton: false
                color: control.currentColor
                iconSource: "tag"
            }
        }       
    }
    
    onClosed:
    {
        control.clear()
    }

    function clear()
    {
        control.currentColor = ""
        textEntry.clear()
    }
    
    function done()
    {
        for(var tag of textEntry.text.split(","))
        {
             FB.Tagging.tag(tag, control.currentColor, "")
        }
        
        control.close()
        //control.alert(i18nd("mauikitfilebrowsing", "Tag could not be created. Check all fields are correct"))
    }
}
