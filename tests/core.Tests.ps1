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
