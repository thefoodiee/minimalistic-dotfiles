import Qt.labs.folderlistmodel
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Window
import SddmComponents 2.0
import "file:///home/skibuddy/.config/quickshell" as QuickshellConfig

Rectangle {
    id: root

    readonly property real s: Screen.height / 768
    property bool isQuickshell: typeof sddm === "undefined" || sddm.hostName === undefined
    // Theme Config
    readonly property string themeMode: config.themeMode || "dark"
    readonly property bool enableWindup: config.enableWindup !== "false" && config.enableWindup !== false
    readonly property bool isLight: themeMode === "light"
    readonly property color bgColor: colors.background
    readonly property color mainText: colors.foreground
    readonly property color dimText: colors.color6
    readonly property color subColor: colors.color6
    readonly property color pillColor: colors.color0
    readonly property color pillBorder: root.isWindup ? colors.color8 : colors.color0
    readonly property color pillInnerLine: root.isWindup ? colors.foreground : colors.color8
    readonly property color sparkColor: colors.color4
    readonly property color blastColor: colors.color4
    readonly property color userItemInactive: colors.color8
    readonly property color inputWaitColor: colors.color6
    // UI State
    property int sessionIndex: (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0
    property int userIndex: (typeof userModel !== "undefined" && userModel.lastIndex >= 0) ? userModel.lastIndex : 0
    property bool userMenuOpen: false
    property bool isWindup: false
    property real uiOpacity: 0
    readonly property real marginR: 80 * s
    // Time Logic
    property int curH: new Date().getHours()
    property int curM: new Date().getMinutes()
    property int curS: new Date().getSeconds()
    property int curMS: new Date().getMilliseconds()
    readonly property real localTimeMS: (curH * 3.6e+06) + (curM * 60000) + (curS * 1000) + curMS
    // Animation Props
    property real windupOffset: 0
    property real windupProgress: windupOffset / 150000
    property real boomScale: 1
    property real boomOpacity: 0
    property real jitterX: 0
    property real jitterY: 0
    property real sparkIntensity: 0
    readonly property real smoothSecAngle: -((localTimeMS % 60000) / 60000) * 360 - windupOffset * 10
    readonly property real smoothMinAngle: -((localTimeMS % 3.6e+06) / 3.6e+06) * 360 - windupOffset * 5

    function startLoginSequence() {
        if (passInput.text.length === 0 || isWindup)
            return ;

        if (root.enableWindup) {
            isWindup = true;
            windupAnim.start();
            boomTriggerTimer.start();
        } else {
            doLogin();
        }
    }

    function doLogin() {
        var uname = (userHelper.currentItem && userHelper.currentItem.uLogin) ? userHelper.currentItem.uLogin : (typeof userModel !== "undefined" ? userModel.lastUser : "user");
        if (typeof sddm !== "undefined")
            sddm.login(uname, passInput.text, root.sessionIndex);

    }

    function capitalizeFirst(str) {
        if (!str)
            return "";

        return str.charAt(0).toUpperCase() + str.slice(1);
    }

    width: Screen.width
    height: Screen.height
    color: "transparent"
    Component.onCompleted: {
        fadeIn.start();
        keyboard.numLock = true;
    }

    // Wayland Cursor Fix
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.ArrowCursor
        z: -1
    }

    QuickshellConfig.Colors {
        id: colors
    }

    Image {
        id: bgImage

        anchors.fill: parent
        source: "file:///home/skibuddy/.cache/hyprlock/wallpaper"
        fillMode: Image.PreserveAspectCrop
        visible: false
        asynchronous: true
    }

    FastBlur {
        id: bgBlur

        anchors.fill: parent
        source: bgImage
        radius: 64
        transparentBorder: false
    }

    Rectangle {
        anchors.fill: parent
        color: root.bgColor
        opacity: 0.6
    }

    Timer {
        interval: 16
        running: true
        repeat: true
        onTriggered: {
            var d = new Date();
            root.curH = d.getHours();
            root.curM = d.getMinutes();
            root.curS = d.getSeconds();
            root.curMS = d.getMilliseconds();
        }
    }

    Timer {
        interval: 16
        running: root.isWindup
        repeat: true
        onTriggered: {
            var intensity = root.windupProgress * 32 * s;
            root.jitterX = (Math.random() - 0.5) * intensity;
            root.jitterY = (Math.random() - 0.5) * intensity;
            root.sparkIntensity = root.windupProgress > 0.2 ? (root.windupProgress - 0.2) * 2.2 : 0;
        }
    }

    NumberAnimation {
        id: windupAnim

        target: root
        property: "windupOffset"
        from: 0
        to: 150000
        duration: 1600
        easing.type: Easing.InQuint
    }

    ParallelAnimation {
        id: boomSequence

        onFinished: root.doLogin()

        NumberAnimation {
            target: root
            property: "boomScale"
            to: 35
            duration: 150
            easing.type: Easing.InQuad
        }

        NumberAnimation {
            target: root
            property: "boomOpacity"
            to: 1
            duration: 120
            easing.type: Easing.InQuad
        }

    }

    // Font Loading
    FolderListModel {
        id: fontFolder

        folder: Qt.resolvedUrl("font")
        nameFilters: ["*.ttf", "*.otf"]
    }

    FontLoader {
        id: outfitFont

        source: fontFolder.count > 0 ? "font/" + fontFolder.get(0, "fileName") : ""
    }

    TextConstants {
        id: textConstants
    }

    // Data Models
    ListView {
        id: userHelper

        width: 1
        height: 1
        opacity: 0
        currentIndex: root.userIndex
        model: typeof userModel !== "undefined" ? userModel : null

        delegate: Item {
            property string uName: model.realName || model.name || ""
            property string uLogin: model.name || ""
        }

    }

    ListView {
        id: sessionHelper

        width: 1
        height: 1
        opacity: 0
        currentIndex: root.sessionIndex
        model: typeof sessionModel !== "undefined" ? sessionModel : null

        delegate: Item {
            property string sName: model.name || ""
        }

    }

    // Input Focus
    Timer {
        interval: 300
        running: true
        onTriggered: passInput.forceActiveFocus()
    }

    NumberAnimation {
        id: fadeIn

        target: root
        property: "uiOpacity"
        to: 1
        duration: 350
        easing.type: Easing.OutCubic
    }

    // Main Layout
    Item {
        id: blastContainer

        anchors.fill: parent
        opacity: root.uiOpacity
        x: root.jitterX
        y: root.jitterY

        Item {
            id: clockContainer

            readonly property real cx: 40 * s
            readonly property real cy: height * 0.5
            readonly property real minR: 320 * s
            readonly property real secR: 480 * s

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 800 * s
            height: parent.height

            Rectangle {
                id: indicatorPill

                z: 1
                x: clockContainer.cx + 230 * s
                anchors.verticalCenter: parent.verticalCenter
                width: 330 * s
                height: 90 * s
                radius: 45 * s
                color: root.pillColor
                border.color: root.pillBorder
                border.width: 1 * s

                Rectangle {
                    x: 170 * s
                    anchors.verticalCenter: parent.verticalCenter
                    width: 1 * s
                    height: 35 * s
                    color: root.pillInnerLine
                }

            }

            Repeater {
                model: 60

                delegate: Rectangle {
                    property real randA: Math.random() * 6.28
                    property real randV: 400 * s + Math.random() * 900 * s

                    z: 50
                    x: (clockContainer.cx + 400 * s) + Math.cos(randA) * (randV * root.sparkIntensity)
                    y: (clockContainer.cy) + Math.sin(randA) * (randV * root.sparkIntensity)
                    width: (1 + Math.random() * 2) * s
                    height: (1 + 12 * root.sparkIntensity) * s
                    rotation: randA * 180 / Math.PI + 90
                    radius: width / 2
                    color: root.sparkColor
                    opacity: root.sparkIntensity * (Math.random() > 0.4 ? 1 : 0.2)
                    visible: root.sparkIntensity > 0
                }

            }

            Repeater {
                model: 60

                delegate: Item {
                    property real base: index * 6
                    property real relAngle: {
                        var a = (base + root.smoothMinAngle) % 360;
                        if (a > 180)
                            a -= 360;

                        if (a < -180)
                            a += 360;

                        return a;
                    }
                    property real spotlight: Math.max(0, 1 - Math.abs(relAngle) / 4)
                    property bool isMajor: index % 5 == 0
                    property real disp: (base + root.smoothMinAngle) * Math.PI / 180
                    property real tx: clockContainer.cx + clockContainer.minR * Math.cos(disp)
                    property real ty: clockContainer.cy + clockContainer.minR * Math.sin(disp)

                    z: 10
                    visible: tx > -600 * s && tx < 1800 * s

                    Rectangle {
                        x: parent.tx - width / 2
                        y: parent.ty - height / 2
                        width: isMajor ? 5 * s : 3 * s
                        height: isMajor ? 18 * s : 10 * s
                        radius: width / 2
                        color: Qt.rgba(root.mainText.r, root.mainText.g, root.mainText.b, isLight ? (spotlight > 0 ? 1 : (isMajor ? 0.8 : 0.6)) : (spotlight > 0 ? 1 : (isMajor ? 0.3 : 0.15)))
                        rotation: disp * 180 / Math.PI + 90
                    }

                    Text {
                        property real nRad: clockContainer.minR - 35 * s

                        visible: isMajor
                        x: clockContainer.cx + nRad * Math.cos(disp) - width / 2
                        y: clockContainer.cy + nRad * Math.sin(disp) - height / 2
                        text: String(index).padStart(2, '0')
                        font.family: outfitFont.name
                        font.pixelSize: 22 * s
                        font.weight: spotlight > 0.5 ? Font.Bold : Font.Normal
                        color: Qt.rgba(root.mainText.r, root.mainText.g, root.mainText.b, isLight ? (spotlight > 0 ? (0.6 + 0.4 * spotlight) : 0.6) : (spotlight > 0 ? (0.4 + spotlight * 0.6) : 0.25))
                        rotation: disp * 180 / Math.PI
                        transformOrigin: Item.Center
                    }

                }

            }

            Repeater {
                model: 60

                delegate: Item {
                    property real base: index * 6
                    property real relAngle: {
                        var a = (base + root.smoothSecAngle) % 360;
                        if (a > 180)
                            a -= 360;

                        if (a < -180)
                            a += 360;

                        return a;
                    }
                    property real spotlight: Math.max(0, 1 - Math.abs(relAngle) / 4)
                    property bool isMajor: index % 5 == 0
                    property real disp: (base + root.smoothSecAngle) * Math.PI / 180
                    property real tx: clockContainer.cx + clockContainer.secR * Math.cos(disp)
                    property real ty: clockContainer.cy + clockContainer.secR * Math.sin(disp)

                    z: 10
                    visible: tx > -600 * s && tx < 1800 * s

                    Rectangle {
                        x: parent.tx - width / 2
                        y: parent.ty - height / 2
                        width: isMajor ? 4 * s : 2.5 * s
                        height: isMajor ? 13 * s : 8 * s
                        radius: width / 2
                        color: Qt.rgba(root.mainText.r, root.mainText.g, root.mainText.b, isLight ? (spotlight > 0 ? 1 : (isMajor ? 0.8 : 0.6)) : (spotlight > 0 ? 1 : (isMajor ? 0.3 : 0.15)))
                        rotation: disp * 180 / Math.PI + 90
                    }

                    Text {
                        property real nRad: clockContainer.secR - 30 * s

                        visible: isMajor
                        x: clockContainer.cx + nRad * Math.cos(disp) - width / 2
                        y: clockContainer.cy + nRad * Math.sin(disp) - height / 2
                        text: String(index).padStart(2, '0')
                        font.family: outfitFont.name
                        font.pixelSize: 16 * s
                        font.weight: spotlight > 0.5 ? Font.Bold : Font.Normal
                        color: Qt.rgba(root.mainText.r, root.mainText.g, root.mainText.b, isLight ? (spotlight > 0 ? (0.6 + 0.4 * spotlight) : 0.6) : (spotlight > 0 ? (0.4 + spotlight * 0.6) : 0.25))
                        rotation: disp * 180 / Math.PI
                        transformOrigin: Item.Center
                    }

                }

            }

            Text {
                anchors.right: indicatorPill.left
                anchors.rightMargin: 40 * s
                anchors.verticalCenter: parent.verticalCenter
                text: String(root.curH % 12 || 12).padStart(2, '0')
                font.family: outfitFont.name
                font.pixelSize: 110 * s
                font.weight: Font.Black
                color: root.mainText
            }

            Column {
                anchors.left: indicatorPill.right
                anchors.leftMargin: 110 * s
                anchors.verticalCenter: parent.verticalCenter
                spacing: 5 * s

                Text {
                    text: Qt.formatDate(new Date(), "dd MMM yyyy").toUpperCase()
                    font.family: outfitFont.name
                    font.pixelSize: 13 * s
                    font.letterSpacing: 4 * s
                    color: root.subColor
                }

                Text {
                    text: Qt.formatDate(new Date(), "dddd").toUpperCase()
                    font.family: outfitFont.name
                    font.pixelSize: 18 * s
                    font.letterSpacing: 8 * s
                    font.weight: Font.Bold
                    color: root.mainText
                }

            }

        }

        transform: Scale {
            origin.x: 400 * s
            origin.y: blastContainer.height * 0.5
            xScale: root.boomScale
            yScale: root.boomScale
        }

    }

    // Flash Effect
    Rectangle {
        anchors.fill: parent
        color: root.blastColor
        opacity: root.boomOpacity
        z: 9999
    }

    // HUD Layer
    Item {
        id: hudContainer

        anchors.fill: parent
        opacity: root.uiOpacity * (root.boomOpacity > 0 ? 0 : 1)

        Row {
            anchors.right: parent.right
            anchors.rightMargin: root.marginR
            anchors.top: parent.top
            anchors.topMargin: 50 * s
            spacing: 25 * s

            CwAction {
                visible: !root.isQuickshell
                label: (sessionHelper.currentItem ? sessionHelper.currentItem.sName : "Session")
                onClicked: {
                    if (typeof sessionModel !== "undefined")
                        root.sessionIndex = (root.sessionIndex + 1) % sessionModel.rowCount();

                }
            }

            Rectangle {
                visible: !root.isQuickshell
                width: 1 * s
                height: 10 * s
                color: root.pillBorder
                anchors.verticalCenter: parent.verticalCenter
            }

            // CwAction {
            //     label: "Hibernate"
            //     onClicked: {
            //         if (typeof sddm !== "undefined")
            //             sddm.hibernate();
            //
            //     }
            // }
            //
            // Rectangle {
            //     width: 1 * s
            //     height: 10 * s
            //     color: root.pillBorder
            //     anchors.verticalCenter: parent.verticalCenter
            // }
            CwAction {
                label: "Reboot"
                onClicked: {
                    if (typeof sddm !== "undefined")
                        sddm.reboot();

                }
            }

            Rectangle {
                width: 1 * s
                height: 10 * s
                color: root.pillBorder
                anchors.verticalCenter: parent.verticalCenter
            }

            CwAction {
                label: "Shutdown"
                onClicked: {
                    if (typeof sddm !== "undefined")
                        sddm.powerOff();

                }
            }

        }

        Column {
            id: loginPanel

            anchors.right: parent.right
            anchors.rightMargin: root.marginR
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 80 * s
            width: 350 * s
            spacing: 8 * s

            Item {
                width: parent.width
                height: 32 * s
                z: 5000

                Item {
                    id: uMenuContainer

                    anchors.bottom: userNameDisp.top
                    anchors.bottomMargin: 15 * s
                    anchors.right: parent.right
                    width: 280 * s
                    height: root.userMenuOpen ? ((typeof userModel !== "undefined" ? userModel.rowCount() : 0) * 30 * s) + 20 * s : 0
                    clip: true

                    Column {
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        spacing: 6 * s

                        Repeater {
                            model: typeof userModel !== "undefined" ? userModel : null

                            delegate: Item {
                                property bool itemHover: uItemMa.containsMouse

                                width: 260 * s
                                height: 26 * s

                                Text {
                                    id: uItemTxt

                                    text: (model.realName || model.name || "").toUpperCase()
                                    font.family: outfitFont.name
                                    font.pixelSize: 13 * s
                                    font.letterSpacing: 2 * s
                                    color: (root.userIndex === index || itemHover) ? root.mainText : root.userItemInactive
                                    anchors.right: parent.right
                                    anchors.rightMargin: itemHover ? 30 * s : 10 * s
                                    anchors.verticalCenter: parent.verticalCenter

                                    Behavior on anchors.rightMargin {
                                        NumberAnimation {
                                            duration: 200
                                        }

                                    }

                                }

                                Text {
                                    text: "✦"
                                    anchors.left: uItemTxt.right
                                    anchors.leftMargin: 8 * s
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: root.mainText
                                    opacity: itemHover ? 1 : 0
                                    font.pixelSize: 10 * s

                                    Behavior on opacity {
                                        NumberAnimation {
                                            duration: 200
                                        }

                                    }

                                }

                                MouseArea {
                                    id: uItemMa

                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: {
                                        root.userIndex = index;
                                        root.userMenuOpen = false;
                                    }
                                }

                            }

                        }

                    }

                    Behavior on height {
                        NumberAnimation {
                            duration: 400
                            easing.type: Easing.OutExpo
                        }

                    }

                }

                Text {
                    id: userNameDisp

                    anchors.right: parent.right
                    anchors.rightMargin: (uMa.containsMouse || root.userMenuOpen) ? 25 * s : 0
                    text: ((userHelper.currentItem && userHelper.currentItem.uName) ? userHelper.currentItem.uName : ((typeof userModel !== "undefined" && userModel.lastUser) ? capitalizeFirst(userModel.lastUser) : "USER")).toUpperCase()
                    font.family: outfitFont.name
                    font.pixelSize: 18 * s
                    font.weight: Font.Bold
                    font.letterSpacing: 8 * s
                    color: (uMa.containsMouse || root.userMenuOpen) ? root.mainText : root.dimText

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }

                    }

                    Behavior on anchors.rightMargin {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutCubic
                        }

                    }

                }

                Text {
                    text: "✦"
                    anchors.left: userNameDisp.right
                    anchors.leftMargin: 8 * s
                    anchors.verticalCenter: userNameDisp.verticalCenter
                    color: root.mainText
                    opacity: (uMa.containsMouse || root.userMenuOpen) ? 1 : 0
                    font.pixelSize: 12 * s

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                        }

                    }

                }

                MouseArea {
                    id: uMa

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.userMenuOpen = !root.userMenuOpen;
                    }
                }

            }

            Item {
                width: parent.width
                height: 30 * s

                TextInput {
                    id: passInput

                    property bool wasClicked: false

                    anchors.fill: parent
                    echoMode: TextInput.Password
                    passwordCharacter: ""
                    color: root.dimText
                    font.family: outfitFont.name
                    font.pixelSize: 14 * s
                    font.letterSpacing: 10 * s
                    horizontalAlignment: TextInput.AlignRight
                    verticalAlignment: TextInput.AlignVCenter
                    focus: true
                    cursorVisible: false
                    Keys.onReturnPressed: startLoginSequence()

                    Text {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        text: "ENTER PASSWORD"
                        font.family: outfitFont.name
                        font.pixelSize: 10 * s
                        font.letterSpacing: 4 * s
                        color: root.inputWaitColor
                        opacity: passInput.text.length === 0 ? 0.4 : 0

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 400
                                easing.type: Easing.InOutSine
                            }

                        }

                    }

                    Rectangle {
                        id: needleCursor

                        width: 1.5 * s
                        height: 12 * s
                        color: root.mainText
                        anchors.verticalCenter: parent.verticalCenter
                        x: passInput.cursorRectangle.x
                        visible: passInput.focus && (passInput.text.length > 0 || passInput.wasClicked)

                        SequentialAnimation {
                            loops: Animation.Infinite
                            running: needleCursor.visible

                            NumberAnimation {
                                target: needleCursor
                                property: "opacity"
                                from: 1
                                to: 0.1
                                duration: 450
                            }

                            NumberAnimation {
                                target: needleCursor
                                property: "opacity"
                                from: 0.1
                                to: 1
                                duration: 450
                            }

                        }

                    }

                    cursorDelegate: Item {
                        width: 0
                        height: 0
                    }

                }

                MouseArea {
                    id: pMa_FixedFinal_Simple

                    anchors.fill: parent
                    cursorShape: Qt.ArrowCursor
                    onClicked: {
                        passInput.forceActiveFocus();
                        passInput.wasClicked = true;
                    }
                }

            }

            Item {
                width: parent.width
                height: 40 * s

                Text {
                    id: loginBtn

                    anchors.right: parent.right
                    anchors.rightMargin: btnMa.containsMouse ? 25 * s : 0
                    text: "ENTER KEY"
                    font.family: outfitFont.name
                    font.pixelSize: 11 * s
                    font.letterSpacing: 4 * s
                    font.weight: Font.Bold
                    color: passInput.text.length > 0 ? (btnMa.containsMouse ? root.mainText : root.dimText) : "transparent"
                    opacity: passInput.text.length > 0 ? 1 : 0

                    Behavior on anchors.rightMargin {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutCubic
                        }

                    }

                }

                Text {
                    text: ""
                    anchors.left: loginBtn.right
                    anchors.leftMargin: 8 * s
                    anchors.verticalCenter: loginBtn.verticalCenter
                    color: root.mainText
                    opacity: (btnMa.containsMouse && passInput.text.length > 0) ? 1 : 0
                    font.pixelSize: 10 * s

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                        }

                    }

                }

                MouseArea {
                    id: btnMa

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        startLoginSequence();
                    }
                }

            }

            Text {
                id: errText

                width: parent.width
                height: 15 * s
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignRight
                text: ""
                color: colors.color1
                font.family: outfitFont.name
                font.pixelSize: 10 * s
                font.letterSpacing: 2 * s
            }

        }

    }

    Timer {
        id: boomTriggerTimer

        interval: 1450
        onTriggered: {
            boomSequence.start();
        }
    }

    Connections {
        function onLoginSucceeded() {
        }

        function onLoginFailed() {
            isWindup = false;
            windupAnim.stop();
            boomTriggerTimer.stop();
            boomSequence.stop();
            root.windupOffset = 0;
            root.boomScale = 1;
            root.boomOpacity = 0;
            root.sparkIntensity = 0;
            errText.text = "ACCESS DENIED";
            passInput.text = "";
            passInput.forceActiveFocus();
            shake.start();
        }

        target: typeof sddm !== "undefined" ? sddm : null
    }

    SequentialAnimation {
        id: shake

        NumberAnimation {
            target: loginPanel
            property: "anchors.rightMargin"
            from: root.marginR
            to: root.marginR + 10 * s
            duration: 50
            easing.type: Easing.InOutSine
        }

        NumberAnimation {
            target: loginPanel
            property: "anchors.rightMargin"
            to: root.marginR - 10 * s
            duration: 50
            easing.type: Easing.InOutSine
        }

        NumberAnimation {
            target: loginPanel
            property: "anchors.rightMargin"
            to: root.marginR
            duration: 50
            easing.type: Easing.InOutSine
        }

    }

    component CwAction: Item {
        id: actItem

        property string label: ""

        signal clicked()

        width: actTxt.width + 20 * s
        height: 15 * s

        Text {
            id: actTxt

            anchors.right: parent.right
            anchors.rightMargin: actM.containsMouse ? 15 * s : 0
            text: label.toUpperCase()
            color: actM.containsMouse ? root.mainText : root.dimText
            font.family: outfitFont.name
            font.pixelSize: 10 * s
            font.letterSpacing: 3 * s

            Behavior on color {
                ColorAnimation {
                    duration: 200
                }

            }

            Behavior on anchors.rightMargin {
                NumberAnimation {
                    duration: 200
                }

            }

        }

        Text {
            text: "✦"
            anchors.left: actTxt.right
            anchors.leftMargin: 4 * s
            anchors.verticalCenter: actTxt.verticalCenter
            color: root.mainText
            opacity: actM.containsMouse ? 1 : 0
            font.pixelSize: 8 * s

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }

            }

        }

        MouseArea {
            id: actM

            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                actItem.clicked();
            }
            cursorShape: Qt.PointingHandCursor
        }

    }

}
