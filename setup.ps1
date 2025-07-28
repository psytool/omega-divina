<#
.SYNOPSIS
    Komplettes Setup für das OmegaCore Quantum Computing Modul
#>

# 1. Verzeichnisstruktur erstellen
$projectRoot = "C:\Users\guido\omega-tempel"
$corePath = Join-Path $projectRoot "core"
$testsPath = Join-Path $projectRoot "tests"

New-Item -ItemType Directory -Path $corePath -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $testsPath -Force -ErrorAction SilentlyContinue

# 2. OmegaCore.psm1 mit korrekter Klassenhandhabung erstellen
@'
# Quantum Core Module
$script:omegaSanctum = "QuantumRealm"

# Öffentliche Funktionen
function Get-OmegaStatus {
    [CmdletBinding()]
    param()
    [PSCustomObject]@{
        Version = "0.0.1"
        Phase = "Initiation"
        User = $env:USERNAME
        SacredSpace = $script:omegaSanctum
    }
}

function Invoke-OmegaRitual {
    [CmdletBinding()]
    param([int]$Level = 1)
    Write-Host "Initiating Omega Ritual Level $Level" -ForegroundColor Cyan
}

#region ERROR HANDLING
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Log-Error {
    [CmdletBinding()]
    param([string]$message)
    "[$(Get-Date)] ERROR: $message" | Out-File "$PSScriptRoot/../divina.log" -Append
}
#endregion

#region QUANTUM OPERATIONS
function Invoke-QuantumOperation {
    [CmdletBinding()]
    param(
        [ValidateRange(1, 1024)]
        [int]$Qubits,
        
        [ValidateSet('Hadamard','PauliX','CNOT')]
        [string]$GateType
    )
    if ($Qubits -gt 256) {
        Write-Warning "High qubit count may impact performance"
        Log-Error "High qubit operation attempted ($Qubits)"
    }
    return "Applied $GateType to $Qubits qubits"
}
#endregion

#region MEMORY SAFETY
class QuantumMemoryManager {
    static [void] Clean() {
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
        Write-Verbose "Quantum memory cleaned"
    }
}

[System.GC]::AddMemoryPressure(1MB)

# Wrapper-Funktion für die Klasse
function Invoke-QuantumMemoryCleanup {
    [QuantumMemoryManager]::Clean()
}
#endregion

# Nur Funktionen exportieren (Klassen müssen anders zugänglich gemacht werden)
Export-ModuleMember -Function Get-OmegaStatus, Invoke-OmegaRitual, Invoke-QuantumOperation, Log-Error, Invoke-QuantumMemoryCleanup
'@ | Out-File "$corePath\OmegaCore.psm1" -Encoding utf8 -Force

# 3. Tests mit Wrapper-Funktion erstellen
@'
BeforeAll {
    # Modul neu laden
    Remove-Module OmegaCore -ErrorAction SilentlyContinue
    Import-Module "$PSScriptRoot/../core/OmegaCore.psm1" -Force
}

Describe "Quantum Core Tests" {
    It "Should return Omega status" {
        $status = Get-OmegaStatus
        $status.Version | Should -Be "0.0.1"
    }

    It "Should process quantum operations" {
        Invoke-QuantumOperation -Qubits 2 -GateType Hadamard | Should -Be "Applied Hadamard to 2 qubits"
    }

    It "Should clean memory successfully" {
        { Invoke-QuantumMemoryCleanup } | Should -Not -Throw
    }
}
'@ | Out-File "$testsPath\core.Tests.ps1" -Encoding utf8 -Force

# 4. Pester installieren und Tests ausführen
try {
    if (-not (Get-Module -Name Pester -ListAvailable)) {
        Install-Module Pester -Force -SkipPublisherCheck
    }
    Import-Module Pester -MinimumVersion 5.0 -Force

    # PowerShell-Sitzung neu starten, um Modulkonflikte zu vermeiden
    Write-Host "Starten Sie eine NEUE PowerShell-Sitzung und führen Sie dann folgendes aus:"
    Write-Host "cd '$projectRoot'"
    Write-Host "Import-Module Pester -Force"
    Write-Host "Invoke-Pester '$testsPath\core.Tests.ps1' -Output Detailed"
}
catch {
    Write-Error "Fehler beim Testsetup: $_"
    exit 1
}