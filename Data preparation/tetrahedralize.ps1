# --- Configurazione Percorsi ---
$TetExe = "C:/dev/fTetWild/build/Release/FloatTetwild_bin.exe"
$InDir  = "C:/Users/franc/Desktop/SHAPEMI_project/dataset/atlas/hippocampus/"
$OutDir = "C:/Users/franc/Desktop/SHAPEMI_project/dataset/atlas/hippocampus/"
#$InDir  = "C:/Users/franc/Desktop/SHAPEMI_project/dataset/atlas/PTBP/BRAIN/"
#$OutDir = "C:/Users/franc/Desktop/SHAPEMI_project/dataset/atlas/PTBP/BRAIN/"




# Crea la cartella di output se non esiste
if (!(Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir }

# --- Inizializzazione CSV ---
"MeshName,RealTime,ExitStatus" | Out-File -FilePath "tetrahedralize.csv" -Encoding utf8

# --- Ciclo di Processamento ---
$files = Get-ChildItem -Path $InDir -Filter *.obj

foreach ($file in $files) {
    Write-Host "Tetrahedralization of $($file.Name)... " -NoNewline
    
    # Misura il tempo di esecuzione
    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    
    # Esecuzione fTetWild
    # -i: input, -o: output
    # Parametri extra: --no-binary, --skip-simplify, -l 0.01, -e 1e-3
    & $TetExe -i $file.FullName -o "$OutDir$($file.BaseName).mesh" --no-binary --skip-simplify -l 0.02 | Out-Null
    
    $timer.Stop()
    
    # Stato di uscita (0 se ok)
    $exitStatus = $LASTEXITCODE
    
    # Scrittura log nel CSV
    "$($file.BaseName),$($timer.Elapsed.TotalSeconds),$exitStatus" | Out-File -FilePath "tetrahedralize.csv" -Append -Encoding utf8
    
    Write-Host "Done ($($timer.Elapsed.TotalSeconds)s)."
}