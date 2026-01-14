@echo off
setlocal enabledelayedexpansion

REM Script per configurare e avviare n8n con Docker Compose
REM Uso: setup-n8n.cmd <cartella_dati>

if "%~1"=="" (
    echo Errore: specificare una cartella di destinazione
    echo Uso: %~nx0 ^<cartella_dati^>
    exit /b 1
)

set "DATA_FOLDER=%~1"

REM Crea la cartella se non esiste
if not exist "%DATA_FOLDER%" (
    echo Creazione cartella: %DATA_FOLDER%
    mkdir "%DATA_FOLDER%"
    if errorlevel 1 (
        echo Errore nella creazione della cartella
        exit /b 1
    )
)

REM Scarica il docker-compose.yml
echo Scaricamento docker-compose.yml...
set "COMPOSE_URL=https://raw.githubusercontent.com/leorm2002/n8n-local-dockerfile/main/docker-compose.yml"
set "COMPOSE_FILE=%DATA_FOLDER%\docker-compose.yml"

curl -sL "%COMPOSE_URL%" -o "%COMPOSE_FILE%"
if errorlevel 1 (
    echo Errore nel download del file docker-compose.yml
    exit /b 1
)

if not exist "%COMPOSE_FILE%" (
    echo Errore: file docker-compose.yml non scaricato
    exit /b 1
)

echo File scaricato in: %COMPOSE_FILE%

REM Avvia docker compose
echo.
echo Avvio container con Docker Compose...
cd /d "%DATA_FOLDER%"
docker compose up -d

if errorlevel 1 (
    echo Errore nell'avvio del container
    exit /b 1
)

echo.
echo ========================================
echo Container avviato con successo!
echo ========================================
echo.
echo Per avviare nuovamente il container in futuro, esegui:
echo.
echo     cd /d "%DATA_FOLDER%" ^&^& docker compose up -d
echo.
echo Per fermare il container:
echo.
echo     cd /d "%DATA_FOLDER%" ^&^& docker compose down
echo.

endlocal
