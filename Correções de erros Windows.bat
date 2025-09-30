@echo off
chcp 65001
mode con: cols=90 lines=25
:: Comando que ativa o padrão ANSI de cor no computador do usuário.
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>nul
:: Loop que captura o caractere ESC.
for /f "tokens=1 delims=#" %%a in ('"prompt #$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%a"

:: Verifica se o arquivo foi aberto como ADM
net session >nul 2>&1
if %errorlevel% neq 0 (goto AbrirADM) else ( goto menu )

:: Pergunta se quer abrir o arquivo como ADM
:AbrirADM
echo %ESC%[32m O programa precisa abrir como administrador %ESC%[0m
set /p  ADM="Abrir como Administrador?  SIM[1] | NÃO [0]: "
cls
if %ADM% == 1 goto ExecutarADM
if %ADM% == 0 goto opcao0

:: Executa o arquivo como ADM
:ExecutarADM
if %errorlevel% neq 0 (
    echo %ESC%[47;30mSolicitando privilégios de administrador...%ESC%[0m
    :: Comando para solicitar o administrador do usuário
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit
    cls
)

:: Criação do menu interativo para o usuário
:menu
cls
echo %ESC%[32m Olá usuário %USERNAME% %ESC%[0m
echo %ESC%[36m======================================%ESC%[0m
echo %ESC%[47;30mEscolha qual correção deseja realizar:%ESC%[0m
echo %ESC%[36m======================================%ESC%[0m
echo %ESC%[34m[0]%ESC%[0m - Encerrar Programa
echo %ESC%[34m[1]%ESC%[0m - Corrigir problemas de rede internet
echo %ESC%[34m[2]%ESC%[0m - Corrigir problemas de arquvios do Sistema
echo %ESC%[34m[3]%ESC%[0m - Corrigir Problemas com Windows-Defender
echo %ESC%[34m[4]%ESC%[0m - Remover Pesquisa Bing no menu iniciar
echo %ESC%[34m[5]%ESC%[0m - Desativar função vincular celular
echo %ESC%[34m[6]%ESC%[0m - Timpar arquivos temporários
echo %ESC%[34m[7]%ESC%[0m - Reparar Windows update
echo %ESC%[34m[8]%ESC%[0m - Reparar Windows Store
echo %ESC%[34m[9]%ESC%[0m - Reparar Conexão com impressora
echo %ESC%[34m[10]%ESC%[0m - Remover programas inúteis
echo %ESC%[34m[11]%ESC%[0m - Remover Animações do sistema
echo %ESC%[34m[12]%ESC%[0m - Ativar/Desativar modo Hibernar
echo %ESC%[34m[13]%ESC%[0m - Desativar SMB1 (vulnerável)
echo %ESC%[34m[14]%ESC%[0m - Ativar GodMode (Modo Deus)
echo %ESC%[34m[15]%ESC%[0m - Repara Icones corrompidos
echo %ESC%[34m[16]%ESC%[0m - Desativar/Ativar Widgtes
echo %ESC%[32m[D]"- Próximo Menu ->"%ESC%[0m

set /p opcao="Digite uma opção: "

:: Redirecionamento para a opção selecionada
if %opcao% == 0 goto opcao0
if %opcao% == 1 goto opcao1
if %opcao% == 2 goto opcao2
if %opcao% == 3 goto opcao3
if %opcao% == 4 goto opcao4
if %opcao% == 5 goto opcao5
if %opcao% == 6 goto opcao6
if %opcao% == 7 goto opcao7
if %opcao% == 8 goto opcao8
if %opcao% == 9 goto opcao9
if %opcao% == 10 goto opcao10
if %opcao% == 11 goto opcao11
if %opcao% == 12 goto opcao12
if %opcao% == 13 goto opcao13
if %opcao% == 14 goto opcao14
if %opcao% == 15 goto opcao15
if %opcao% == 16 goto opcao16
if %opcao% == D goto Menu02
if %opcao% == d goto Menu02

echo %ESC%[47;31mOpcao invalida! Tente novamente.%ESC%[0m
timeout /t 2 > nul
cls
goto menu

:: função Reinicar Computador
:ReniciarPC
echo É necessário Reinicar.
set /p Reniciar="Deseja Reinicar agora? SIM[1] | NÃO[0]"
if %Reniciar% == 0 goto menu
if %Reniciar% == 1 shutdown -r
echo %ESC%[47;30m Seu computador ira reiniciar %ESC%[0m
exit

:opcao0
cls
echo programa encerrado
timeout /t 1 > nul
exit

:opcao1
cls
echo %ESC%[47;30mCorrecao de problemas de rede internet%ESC%[0m
ipconfig /release
ipconfig /renew
ipconfig /flushdns 
Netsh winsock reset
net localgroup administradores localservice /add
fsutil resource setautoreset true C:\
netsh int ip reset resetlog.txt
netsh winsock reset all
netsh int 6to4 reset all
Netsh int ip reset all
netsh int ipv4 reset all 
netsh int ipv6 reset all
netsh int httpstunnel reset all
netsh int isatap reset all
netsh int portproxy reset all
netsh int tcp reset all
netsh int teredo reset all
Netsh int ip reset
Netsh winsock reset
:: Melhoria no TCP/IP
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global chimney=enabled
netsh int tcp set global dca=enabled
netsh int tcp set global netdma=enabled
netsh int tcp set global ecncapability=enabled
netsh int tcp set global timestamps=disabled
netsh int tcp set heuristics disabled
:: Resetar configurações de proxy
netsh winhttp reset proxy
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /f
cls
echo %ESC%[32m"Correções de erros da Rede concluida! :) "%ESC%[0m
pause
goto ReniciarPC


:opcao2
cls
echo %ESC%[47;30mCorreção de problemas do Windows 10-11%ESC%[0m 
echo %ESC%[0mVerificando e restaurando a integridade do Windows...%ESC%[0m 
echo Executando DISM /CheckHealth...
Dism /Online /Cleanup-Image /CheckHealth
echo Executando DISM /ScanHealth...
Dism /Online /Cleanup-Image /ScanHealth
echo
echo Executando DISM /RestoreHealth...
Dism /Online /Cleanup-Image /RestoreHealth
echo Executando SFC /Scannow...
sfc /scannow
cls
echo %ESC%[32m "Correções de erros do Sistema concluida com Sucesso! :) " %ESC%[0m
pause
cls
goto ReniciarPC

:opcao3
cls
echo %ESC%[47;30mCorreções do Problemas com Windows-Defender%ESC%[0m
echo %ESC%[47;30mReiniciando O Windows-Defender%ESC%[0m
winmgmt /verifyrepository
net stop winmgmt
echo Precione [S] para confirmar que deseja reinicar o Windows-Defender
winmgmt /resetrepository
cls
echo %ESC%[32mPronto, agora basta reiniciar o computador que o Windows Defender já estará funcionando.%ESC%[0m
pause
cls
goto ReniciarPC

:opcao4
cls
echo %ESC%[47;30mRemovendo a pesquisa do Bing!%ESC%[0m
REG ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /V BingSearchEnabled /T REG_DWORD /D 0 /F
cls
echo %ESC%[32m"Pesquisa Removida com Sucesso! :) "%ESC%[0m
pause
cls
goto menu

:opcao5
cls
echo %ESC%[47;30mDesativando função vincular celular%ESC%[0m
powershell -command "Get-AppxPackage *Microsoft.YourPhone* | Remove-AppxPackage"
cls
echo %ESC%[32m"Vincular Celular desativado com sucesso! :) "%ESC%[0m
pause
cls
goto menu


:opcao6
cls
echo %ESC%[47;30mLimpando arquivos temporários%ESC%[0m
del /q/f/s %TEMP%\*
del /q/f/s C:\Windows\Temp\*
del /q/f/s C:\Windows\Prefetch\*
cleanmgr /sagerun:1
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255
cls
echo %ESC%[32m"Arquivos temporários deletados com sucesso! :) "%ESC%[0m
pause
cls
goto menu

:opcao7
cls
echo %ESC%[47;30mReparando Windows update%ESC%[0m
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 catroot2.old
net start wuauserv
net start cryptSvc
net start bits
net start msiserver
cls
echo %ESC%[32m"Windows Update Reparado com sucesso! :) "%ESC%[0m
pause
cls
goto ReniciarPC

:opcao8
cls
echo %ESC%[47;30mReparando a Microsoft Store%ESC%[0m
wsreset.exe
powershell -Command "Get-AppXPackage *WindowsStore* -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register \"$($_.InstallLocation)\AppXManifest.xml\"}"
cls
echo %ESC%[32m"MS Store Reparada com Sucesso! :) "%ESC%[0m
pause
cls
goto menu

:opcao9
cls
echo %ESC%[47;30m"Reparando Improssora"%ESC%[0m
net stop spooler
del /q /f /s "%systemroot%\System32\spool\PRINTERS\*.*"
net start spooler
cls
echo %ESC%[32m"impressora raparada com Sucesso! :) "%ESC%[0m
pause
cls
goto menu

:opcao10
cls
echo %ESC%[47;30m"Removendo Programas Desnecessários"%ESC%[0m
echo %ESC%[47;30m"Removendo o 3DBuilder"%ESC%[0m
powershell -Command "Get-AppxPackage *3DBuilder* | Remove-AppxPackage"
echo %ESC%[47;30m"Removendo o Candy Crush"%ESC%[0m
powershell -Command "Get-AppxPackage *Candy* | Remove-AppxPackage"
echo %ESC%[47;30m"Removendo o GetHelp(Suporte da Microsoft)"%ESC%[0m
powershell -Command "Get-AppxPackage *GetHelp* | Remove-AppxPackage"
echo %ESC%[47;30m"Removendo o Getstarted(Tutorial De Ínicio do Windows 11)"%ESC%[0m
powershell -Command "Get-AppxPackage *Getstarted* | Remove-AppxPackage"
echo %ESC%[47;30m"Removendo o Messaging"%ESC%[0m
powershell -Command "Get-AppxPackage *Messaging* | Remove-AppxPackage"
echo %ESC%[47;30m"Removendo o paint 3D"%ESC%[0m
powershell -Command "Get-AppxPackage *Microsoft3DViewer* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *Print3D* | Remove-AppxPackage"
echo %ESC%[47;30m"Removendo MicrosoftSolitaire(Jogos básicos do Windows)"%ESC%[0m
powershell -Command "Get-AppxPackage *MicrosoftSolitaire* | Remove-AppxPackage"
echo %ESC%[47;30m"Removendo MixedReality(Realidade Virtual do Windows)"%ESC%[0m
powershell -Command "Get-AppxPackage *MixedReality* | Remove-AppxPackage"
echo %ESC%[47;30m"Removendo OneNote(Um caderno digital que vem com o pacote office)"%ESC%[0m
powershell -Command "Get-AppxPackage *OneNote* | Remove-AppxPackage"
echo %ESC%[47;30m"Removendo WindowsAlarms,WindowsMaps e WindowsFeedback"%ESC%[0m
powershell -Command "Get-AppxPackage *WindowsAlarms* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *WindowsMaps* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *WindowsFeedback* | Remove-AppxPackage"
cls
echo %ESC%[32m"Todos os programas foram removidos! :) "%ESC%[0m
pause
cls
goto menu

:opcao11
cls
echo %ESC%[47;30m"Removendo animações do sistema"%ESC%[0m 
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f
cls
echo %ESC%[32m"Animações removidas com Sucesso! :) "%ESC%[0m
pause
cls
goto menu

:opcao12
cls
set /p OnOff="Ativar[1] | Desativar [0]: "
if %OnOff% == 1 goto ativarHibernar
if %OnOff% == 0 goto desativarHibernar

echo %ESC%[47;31mOpcao invalida! Tente novamente.%ESC%[0m
timeout /t 2 > nul
cls
goto opcao12

:ativarHibernar
echo %ESC%[47;30m"Ativando modo Hibernar"%ESC%[0m 
powercfg.exe /hibernate on
cls
echo %ESC%[32m"Modo hibernar ativado com Sucesso! :) "%ESC%[0m
pause
cls
goto menu
:desativarHibernar
echo %ESC%[47;30m"Desativando modo Hibernar"%ESC%[0m 
echo
powercfg.exe /hibernate off
cls
echo %ESC%[32m"Modo hibernar Desativado com Sucesso! :) "%ESC%[0m
pause
cls
goto menu

:opcao13
cls
echo %ESC%[47;30m"Desativando SMB1 (vulnerável)"%ESC%[0m 
sc config lanmanworkstation depend= bowser/mrxsmb20/nsi
sc config mrxsmb10 start= disabled
dism /online /norestart /disable-feature /featurename:SMB1Protocol
cls
echo %ESC%[32m"Vulnerabilidade de segurança SMB1 corrigida! :) "%ESC%[0m
pause
cls
goto ReniciarPC

:opcao14
cls
echo %ESC%[47;30m"Ativando GodMode(modo Deus)"%ESC%[0m
set pastaDesk01="%userprofile%\OneDrive\Área de Trabalho\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
set pastaDesk02="%userprofile%\OneDrive\Área de Trabalho\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
if EXIST "%pastaDesk01%\NUL"(
mkdir "%userprofile%\OneDrive\Área de Trabalho\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
) else (mkdir "%userprofile%\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}")
cls
echo %ESC%[32m GodMode(modo Deus) ativado você pode acessar a pasta na area de trabalho %ESC%[0m
echo %ESC%[32m para Desativar basta excluir a pasta criada na area de trabalho  %ESC%[0m
pause
cls
goto menu

:opcao15
cls
echo %ESC%[47;30m"Reparando os icones corrompidos"%ESC%[0m
taskkill /f /im explorer.exe
cd /d %userprofile%\AppData\Local
attrib –h IconCache.db
del IconCache.db
start explorer.exe
cls
echo %ESC%[32m "Icones reparados com Sucesso! :) " %ESC%[0m
pause
cls
goto menu

:opcao16
cls
echo %ESC%[47;30m Widgets do windows %ESC%[0m
set /p OnOffWidgets="Ativar[1] | Desativar [0]: "
if %OnOffWidgets% == 1 goto AtivarWidgets
if %OnOffWidgets% == 0 goto DesativarWidgets

:DesativarWidgets
cls
echo %ESC%[47;30m"Removendo os widgets do Windows"%ESC%[0m
:: Desativar Widgets na barra de tarefas
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f
:: Desativar serviço de Widgets
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f
:: Reiniciar Explorer
taskkill /f /i
cls
echo %ESC%[32m "Widgets desativados com Sucesso! :) " %ESC%[0m
pause
cls
goto menu

:AtivarWidgets
cls
:: Ativar Widgets na barra de tarefas
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 1 /f
:: Ativar serviço de Widgets
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 1 /f
:: Reiniciar Explorer
taskkill /f /im explorer.exe
explorer.exe
cls
echo %ESC%[32m "Widgets Ativados com Sucesso! :) " %ESC%[0m
pause
cls
goto menu

:: Segundo menu interativo
:Menu02
cls
echo %ESC%[32m Olá usuário %USERNAME% %ESC%[0m
echo %ESC%[36m======================================%ESC%[0m
echo %ESC%[47;30m Escolha qual correção deseja realizar:%ESC%[0m
echo %ESC%[36m======================================%ESC%[0m
echo %ESC%[34m[0]%ESC%[0m - Encerrar Programa
echo %ESC%[34m[17]%ESC%[0m - Ativar Controle do Brilho do monitor
echo %ESC%[34m[18]%ESC%[0m - Teste de latencia da rede
echo %ESC%[34m[19]%ESC%[0m - Desativar OneDrive
echo %ESC%[34m[20]%ESC%[0m - Desativar Copilot do Windows/Edge
echo %ESC%[34m[21]%ESC%[0m - Ativar/Desativar HPET (High Precision Event Timer)
echo %ESC%[32m[A] "<- Menu Anterior" -  %ESC%[0m

set /p opcao="Digite uma opção: "

:: Redirecionamento para a opção selecionada
if %opcao% == 0 goto opcao0
if %opcao% == 17 goto opcao17
if %opcao% == 18 goto opcao18
if %opcao% == 19 goto opcao19
if %opcao% == 20 goto opcao20
if %opcao% == 21 goto opcao21
if %opcao% == A goto Menu
if %opcao% == a goto Menu

echo %ESC%[47;31mOpcao invalida! Tente novamente.%ESC%[0m
timeout /t 2 > nul
cls
goto menu02

:opcao17
cls
echo %ESC%[47;30m"Baixando o Twinkle Tray"%ESC%[0m
winget --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Winget nao encontrado. Abrindo Microsoft Store...
    start ms-windows-store://pdp/?ProductId=9PLJWWSV01LK
) else (
    echo Instalando Twinkle Tray via winget...
    winget install --id=xanderfrangos.twinkletray -e
)
cls
echo %ESC%[32m "Agora você pode controlar o brilho do monitor" %ESC%[0m
echo %ESC%[32m "diretamente no Windows" %ESC%[0m
pause
cls
goto menu2

:opcao18
cls %ESC%[47;30m"Baixando o Twinkle Tray"%ESC%[0m
echo 
@echo off
echo ========================================
echo     TESTE DE LATENCIA - PING
echo ========================================
echo.
cls
echo Testando Google DNS (8.8.8.8)...
ping 8.8.8.8 -n 4
echo.
cls
echo Testando Cloudflare DNS (1.1.1.1)...
ping 1.1.1.1 -n 4
echo.
cls
echo Testando Google.com...
ping www.google.com -n 4
echo.
cls
echo Testando seu Gateway padrao...
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"Gateway Padr" /c:"Default Gateway"') do (
    set gateway=%%a
    set gateway=!gateway:~1!
    ping !gateway! -n 4
)
echo.
cls
echo ========================================
echo Teste de latencia continuo (Ctrl+C para parar)
echo ========================================
ping 8.8.8.8 -t
echo %ESC%[32m "Teste De latencia Realizado com Sucesso! :)" %ESC%[0m
pause
goto menu02

:opcao19
cls
echo %ESC%[47;30m"Desativando o OneDrive"%ESC%[0m

taskkill /f /im OneDrive.exe
%SystemRoot%\System32\OneDriveSetup.exe /uninstall
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
reg delete "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
reg delete "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f
rd "%UserProfile%\OneDrive" /Q /S
rd "%LocalAppData%\Microsoft\OneDrive" /Q /S
rd "%ProgramData%\Microsoft OneDrive" /Q /S
rd "C:\OneDriveTemp" /Q /S
cls

echo %ESC%[32m "OneDrive Desativado com Sucesso! :)" %ESC%[0m
pause
cls
goto menu02

:opcao20
cls
echo %ESC%[47;30m"Desativando o Copilot no Windows"%ESC%[0m

:: Desativar Copilot no Windows 11
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowCopilotButton /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe
start explorer.exe
cls
set /p OffEdge="Deseja desativa o Copilot no Edge? SIM [1] | NÃO [0] "

if %OffEdge% == 1 goto DesativarCopilotEdge
if %OffEdge% == 0 goto menu02

:DesativarCopilotEdge
cls
:: Desativar Copilot no Microsoft Edge
echo %ESC%[47;30m"A desativação do copilot no Edge pode não funcionar dependendo da sua versão do Navegador"%ESC%[0m
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v HubsSidebarEnabled /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v CopilotEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Policies\Microsoft\Edge" /v HubsSidebarEnabled /t REG_DWORD /d 0 /f
cls
echo %ESC%[32m "Copilot Desativado com sucesso! :)" %ESC%[0m
pause
cls
goto menu02

:opcao21
cls
set /p OnOffHPET="Deseja Ativar ou Desativar o HPET? ATIVAR [1] | DESATIVAR [0] "

if %OnOffHPET% == 1 goto AtivarHPET
if %OnOffHPET% == 0 goto DesativarHPET

:DesativarHPET
cls
echo %ESC%[47;30m"Desativando a função HPET (High Precision Event Timer)"%ESC%[0m
:: Desativar HPET no Windows
bcdedit /deletevalue useplatformclock
bcdedit /set disabledynamictick yes
:: Desativar HPET no dispositivo
reg add "HKLM\SYSTEM\CurrentControlSet\Services\HPET" /v Start /t REG_DWORD /d 4 /f
echo %ESC%[32m "HPET Desativado com sucesso! :)" %ESC%[0m
pause
goto ReniciarPC

:AtivarHPET
cls
echo %ESC%[47;30m"Ativando a função HPET (High Precision Event Timer)"%ESC%[0m
:: Ativar HPET no Windows
bcdedit /set useplatformclock true
bcdedit /set disabledynamictick no
:: Ativar HPET no dispositivo
reg add "HKLM\SYSTEM\CurrentControlSet\Services\HPET" /v Start /t REG_DWORD /d 2 /f
echo %ESC%[32m "HPET Ativado com sucesso! :)" %ESC%[0m
pause
goto ReniciarPC
