/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 2020  camilo <chiguitar@unal.edu.co>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.2 as Maui
import org.mauikit.filebrowsing 1.3 as FB


/**
 * OpenWithDialog
 * A dialog with a list of services associated to the list of URLs.
 *
 * The services listed can open the file type of the file URLs.
 *
 *
 *
 *
 */
Maui.Dialog
{
    id: control

    /**
      * urls : var
      * List of file URLs to look for associated services.
      */
    property alias urls : _openWithList.urls

    widthHint: 0.9
    page.padding: 0
    maxHeight: Math.min(_list.contentHeight + (page.padding * 2.5) + headBar.height + Maui.Style.space.huge, 500)
    maxWidth: 350
    persistent: false

    defaultButtons: false

    page.title: i18nd("mauikitfilebrowsing", "Open with")
    headBar.visible: true
    
    stack: Maui.ListBrowser
    {
        id: _list
        Layout.fillWidth: true
        Layout.fillHeight: true
        
        model: Maui.BaseModel
        {
            id: _appsModel
            list: FB.OpenWithModel
            {
                id: _openWithList
            }
        }
        
        delegate: Maui.ListBrowserDelegate
        {
            width: ListView.view.width
            //height: Maui.Style.rowHeight * 2
            hoverEnabled: true
            
            label1.text: model.label
                label2.text: model.comment
                iconSource: model.icon
                iconSizeHint: Maui.Style.iconSizes.big

            onClicked:
            {
                _list.currentIndex = index
                triggerService(index)
            }
        }
    }  

    /**
      *
      */
    function triggerService(index)
    {
        _openWithList.openWith(index)
        close()
    }
}
