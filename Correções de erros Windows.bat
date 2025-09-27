@echo off
chcp 65001
mode con: cols=90 lines=25
:: Comando que ativa o padrão ANSI de cor no computador do usuário.
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>nul
:: Loop que captura o caractere ESC.
for /f "tokens=1 delims=#" %%a in ('"prompt #$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%a"
:: Parte que valida se o arquivo foi aberto como administrador
choice /c 0 /n /m  "Digite Zero [0]: "

if %errorlevel% == 0 goto opcao0
cls

:opcao0
cls
:: Verifica se o script está rodando como Administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo %ESC%[47;30mSolicitando privilégios de administrador...%ESC%[0m
    :: Comando para solicitar o administrador do usuário
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit
    cls
)

:: Criação do menu interativo para o usuário
:menu
echo %ESC%[36m======================================%ESC%[0m
echo %ESC%[47;30mEscolha qual correção deseja realizar:%ESC%[0m
echo %ESC%[36m======================================%ESC%[0m

echo %ESC%[34m[0]%ESC%[0m - Encerrar Programa
echo %ESC%[34m[1]%ESC%[0m - Corrigir problemas de rede internet
echo %ESC%[34m[2]%ESC%[0m - Corrigir problemas de arquvios do Sistema
echo %ESC%[34m[3]%ESC%[0m - Corrigir Problemas com Windows-Defender
echo %ESC%[34m[4]%ESC%[0m - Remover Pesquisa Bing no menu iniciar
echo %ESC%[34m[5]%ESC%[0m - Desativar função vincular celular
choice /c 123450 /n /m "Digite uma opção: "

if %errorlevel% == 0 goto opcao0
if %errorlevel% == 1 goto opcao1
if %errorlevel% == 2 goto opcao2
if %errorlevel% == 3 goto opcao3
if %errorlevel% == 4 goto opcao4
if %errorlevel% == 5 goto opcao5

:opcao0
cls
echo programa encerrado
exit

:opcao1
cls
echo Correcao de problemas de rede internet
echo ﾠ
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
cls
echo %ESC%[32m"Correções de erros da Rede concluida. :)"%ESC%[0m 
pause
cls
goto menu

:opcao2
cls
echo Correção de problemas do Windows 10-11
echo ﾠ
echo Verificando e restaurando a integridade do Windows...
echo ﾠ
echo Executando DISM /CheckHealth...
Dism /Online /Cleanup-Image /CheckHealth
echo ﾠ
echo Executando DISM /ScanHealth...
Dism /Online /Cleanup-Image /ScanHealth
echo ﾠ
echo Executando DISM /RestoreHealth...
Dism /Online /Cleanup-Image /RestoreHealth
echo ﾠ
echo Executando SFC /Scannow...
sfc /scannow
cls
echo %ESC%[32m"Correções de erros do Sistema concluida com Sucesso. :)%ESC%[0m
pause
cls
goto menu

:opcao3
cls
echo Correções do Problemas com Windows-Defender
echo ﾠ
echo Reiniciando O Windows-Defender
winmgmt /verifyrepository
net stop winmgmt
echo Precione [S] para confirmar que deseja reinicar o Windows-Defender
winmgmt /resetrepository
cls
echo %ESC%[32mPronto, agora basta reiniciar o computador que o Windows Defender já estará funcionando.%ESC%[0m
pause
cls
goto menu

:opcao4
cls
echo Removendo a pesquisa do Bing!
echo
REG ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /V BingSearchEnabled /T REG_DWORD /D 0 /F
cls
echo %ESC%[32m"Pesquisa Removida com Sucesso! :)"%ESC%[0m
pause
cls
goto menu

:opcao5
cls
echo Desativando função vincular celular
echo
powershell -command "Get-AppxPackage *Microsoft.YourPhone* | Remove-AppxPackage"
cls
echo %ESC%[32m"Vincular Celular desativado com sucesso. :)"%ESC%[0m
pause
cls
goto menu