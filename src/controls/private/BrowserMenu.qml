import QtQuick 2.15
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui
import org.kde.kirigami 2.6 as Kirigami

Maui.ContextualMenu
{
    id: control
    MenuItem
    {
        icon.name: "bookmark-new"
        text: i18n("Bookmark")
        onTriggered: bookmarkFolder([currentPath])
//         enabled: _optionsButton.enabled
    }

    MenuItem
    {
        icon.name: "document-new"
        text: i18n("New item")
//         enabled: _optionsButton.enabled

        onTriggered: newItem()        
    }

    MenuSeparator {}

    MenuItem
    {
        text: i18n("Paste")
//         enabled: _optionsButton.enabled

        icon.name: "edit-paste"
        // 		enabled: control.clipboardItems.length > 0
        onTriggered: paste()
    }

    MenuSeparator {}

    MenuItem
    {
        text: i18n("Select all")
        icon.name: "edit-select-all"
        onTriggered: selectAll()
    }

    /**
      *
      */
    function show(parent = control, x, y)
    {
          control.open(x, y, parent)
    }
}

