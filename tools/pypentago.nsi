; How to build
; ------------
; Set SRC_PATH to a directory which contains the src\ directory which can be
; found in the repository of the pypentago
; repository.
; Put the setup files of Python, PyQt, Twisted an pywin32 in the inst\
; sub-directory of the directory where this script is in.
; If the versions of the dependencies have changed, adjust PYTHON_INSTALLER,
; PYQT_INSTALLER, TWISTED_INSTALLER or PYWIN_INSTALLER respectively.
; If you are building for another version of Python, also adjust PYTHON_VERSION.
; Then use NSIS to create your installer.

; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "pypentago"
!define PRODUCT_VERSION "0.1.0"
!define PRODUCT_PUBLISHER "Florian Mayer et al."
!define PRODUCT_WEB_SITE "http://bitbucket.org/segfaulthunter/pypentago-mainline/"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"


!define SRC_PATH "src\"
!define PYTHON_VERSION "2.6"
!define PYTHON_INSTALLER "python-2.6.1.msi"
!define PYQT_INSTALLER "PyQt-Py2.6-gpl-4.4.4-2.exe"
!define TWISTED_INSTALLER "Twisted_NoDocs-8.2.0.win32-py2.6.exe"
!define PYWIN_INSTALLER "pywin32-212.win32-py2.6.exe"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\win-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\win-uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "gpl.txt"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "pypentago-${PRODUCT_VERSION}-py${PYTHON_VERSION}.exe"
InstallDir "$PROGRAMFILES\pypentago"
InstallDirRegKey HKLM "Software\pypentago" "Install_Dir"
ShowInstDetails show
ShowUnInstDetails show

Section "Python" SEC01
  ReadRegStr $0 HKLM "SOFTWARE\Python\PythonCore\${PYTHON_VERSION}\InstallPath" ''
  StrCmp $0 "" install end
  install:
    SetOutPath "$TEMP"
    File "inst\${PYTHON_INSTALLER}"
    ExecWait 'msiexec /i "$TEMP\${PYTHON_INSTALLER}"'
  end:
SectionEnd

Section "PyQt" SEC02
  ReadRegStr $0 HKLM "SOFTWARE\Python\PythonCore\${PYTHON_VERSION}\InstallPath" ''
  IfFileExists "$0\Lib\site-packages\PyQt4\__init__.py" end
     SetOutPath "$TEMP"
     File "inst\${PYQT_INSTALLER}"
     ExecWait "$TEMP\${PYQT_INSTALLER}"
  end:
SectionEnd

Section "Twisted" SEC03
  ReadRegStr $0 HKLM "SOFTWARE\Python\PythonCore\${PYTHON_VERSION}\InstallPath" ''
  IfFileExists "$0\Lib\site-packages\twisted\__init__.py" end
    SetOutPath "$TEMP"
    File "inst\${TWISTED_INSTALLER}"
    ExecWait "$TEMP\${TWISTED_INSTALLER}"
end:
SectionEnd

Section "pywin32" SEC04
  ReadRegStr $0 HKLM "SOFTWARE\Python\PythonCore\${PYTHON_VERSION}\InstallPath" ''
  IfFileExists "$0\Lib\site-packages\win32com\__init__.py" end
    SetOutPath "$TEMP"
    File "inst\${PYWIN_INSTALLER}"
    ExecWait "$TEMP\${PYWIN_INSTALLER}"
end:
SectionEnd

Section "pypentago" SEC05
  SetOutPath "$INSTDIR"
  SetOverwrite try

  File /r "${SRC_PATH}"
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateDirectory "$SMPROGRAMS\pypentago"
  CreateShortCut "$SMPROGRAMS\pypentago\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\pypentago\Uninstall.lnk" "$INSTDIR\uninst.exe"
  CreateShortCut "$DESKTOP\pypentago.lnk" "$INSTDIR\pypentago\client\main.py"
  CreateShortCut "$SMPROGRAMS\pypentago\pypentago.lnk" "$INSTDIR\pypentago\client\main.py"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Section Uninstall
  RMDir /r "$SMPROGRAMS\pypentago"
  RMDir /r "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true
SectionEnd