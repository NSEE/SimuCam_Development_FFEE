@ECHO off
PUSHD "%~dp0"
REM Executa os batch files responsaveis pelo update de cada módulo o Hw Project
START cmd /c "..\FPGA_Developments\COM_Module_v2\Development\UpdateComm200Hw.bat"
START cmd /c "..\FPGA_Developments\FTDI_USB3\Development\UpdateFtdiUsb3Hw.bat"
START cmd /c "..\FPGA_Developments\RMAP_Echoing\Development\UpdateRmpe100Hw.bat
START cmd /c "..\FPGA_Developments\RMAP_Memory_FFEE_DEB_Area\Development\UpdateFDRM100Hw.bat
START cmd /c "..\FPGA_Developments\RMAP_Memory_FFEE_AEB_Area\Development\UpdateFARM100Hw.bat
START cmd /c "..\FPGA_Developments\SpaceWire_Channel\Development\UpdateSpwc100Hw.bat
START cmd /c "..\FPGA_Developments\SpaceWire_Glutton\Development\UpdateSpwGluttonHw.bat
START cmd /c "..\FPGA_Developments\SpaceWire_Demux\Development\UpdateSpwd100Hw.bat
START cmd /c "..\FPGA_Developments\Sync\Development\UpdateSyncHw.bat"
START cmd /c "..\FPGA_Developments\Memory_Filler\Development\UpdateMfilHw.bat"
START cmd /c "..\FPGA_Developments\RST_Controller\Development\UpdateRstControllerHw.bat"
REM Adicionar novos Hw sempre que forem criados
REM PAUSE
