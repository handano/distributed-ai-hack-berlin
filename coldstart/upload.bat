@echo off
REM Upload coldstart template to hackathon server

echo ================================================
echo Uploading Coldstart Template - Team04
echo ================================================
echo.
echo Server: team04@129.212.178.168:32605
echo Password: Et;;%%oiWS)IT^<Ot0uY0CTrG07YiHZbSQ
echo.
echo This will upload the coldstart directory to ~/coldstart
echo.

cd "C:\Users\handa\Documents\AI revolution\Coding AI agents\distributed-ai-hack-berlin"

scp -P 32605 -r coldstart team04@129.212.178.168:~/

if %errorlevel% equ 0 (
    echo.
    echo ================================================
    echo Upload successful!
    echo ================================================
    echo.
    echo Next steps:
    echo 1. SSH into server: ssh team04@129.212.178.168 -p 32605
    echo 2. cd ~/coldstart
    echo 3. source ~/hackathon-venv/bin/activate
    echo 4. pip install -e .
    echo 5. ./submit-job.sh "flwr run . cluster --stream" --gpu --name test
    echo.
) else (
    echo.
    echo Upload failed! Try again.
    echo Connection might have timed out - retry 2-3 times.
    echo.
)

pause
