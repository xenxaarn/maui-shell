import QtQuick
import QtQuick.Controls
import QtMultimedia

import org.mauikit.controls as Maui

import org.maui.cask as Cask

Item
{

    id: control

    property bool running : false

    Rectangle
    {
        id: _color
        visible: _animation.running
        anchors.fill: parent
        color: Maui.Theme.textColor
        opacity: 0.4

        ParallelAnimation
        {
            id: _animation

            OpacityAnimator
            {
                target: _color
                from: 0.4
                to:0
            }
            SequentialAnimation
            {

                SequentialAnimation
                {
                    ScaleAnimator
                    {
                        target: _color
                        from: 1
                        to: 0.95
                        duration: 50

                        easing.type :Easing.OutQuad
                    }

                    ScaleAnimator
                    {
                        target: _color
                        from: 0.95
                        to: 1
                        duration: 50
                        easing.type :Easing.InOutQuad
                    }
                }

            }

            onFinished:
            {
                _color.opacity = 0.4
                control.running = false
            }
        }
    }

    SoundEffect
    {
        id: playSound
        source: "qrc:/sounds/camera-shutter.wav"
    }

    Connections
    {
        target: Cask.Server.screenshot
        function onTakeScreenshot(type, id)
        {
            console.log("GRAB SCREEN FROM THE SERVER REQUEDTED", id, type)
            switch(type)
            {
            case Cask.CaskScreenshot.CurrentScreen: control.grabCurrentScreen(id); return;
            case Cask.CaskScreenshot.AllScreens: control.grabAllScreens(id); return;
            case Cask.CaskScreenshot.CurrentWindow: control.grabCurrentWindow(id); return;
            }
        }
    }

    function animate()
    {
        _animation.start()
        playSound.play()
    }

    function screenshotPath()
    {
        const stamp = new Date().toLocaleTimeString().replace(/[^0-9A-Za-z.-]/g, "-")
        return `${Cask.Server.screenshot.saveDir}/screenshot-${stamp}.png`
    }

    function saveGrab(result, id: string)
    {
        const where = screenshotPath()

        if(!result || !result.saveToFile(where))
        {
            console.log("SCREENSHOT FAILED", where)
            Cask.Server.screenshot.setScreenshotReady("", id)
        }else
        {
            console.log("SCREENSHOT RESULT", result.url, where)
            Cask.Server.screenshot.setScreenshotReady(where, id)
        }

        control.animate()
    }

    function grabItem(item, id: string)
    {
        if(!item)
        {
            console.log("No item to grab screenshot from")
            Cask.Server.screenshot.setScreenshotReady("", id)
            return
        }

        control.running = true
        item.grabToImage(function(result) {
            control.saveGrab(result, id)
        })
    }

    function grabCurrentScreen(id : string)
    {
        // The window content item contains the whole compositor output.
        grabItem(Shell.win ? Shell.win.contentItem : null, id)
    }

    function grabAllScreens(id: string)
    {
        // This shell currently creates one CaskScreen output, so the all-screens
        // request is served by the single compositor window.
        grabCurrentScreen(id)
    }

    function grabCurrentWindow(id : string)
    {
        const window = Shell.zpaces ? Shell.zpaces.allSurfaces.activeWindow : null

        if(window == null)
        {
            console.log("No window to grab screenshot")
            Cask.Server.screenshot.setScreenshotReady("", id)
            return
        }

        if(!window.chrome)
        {
            console.log("Window has no chrome yet")
            Cask.Server.screenshot.setScreenshotReady("", id)
            return
        }

        grabItem(window.chrome, id)
    }

    function grabCustomArea(rect, id: string)
    {

    }
}
