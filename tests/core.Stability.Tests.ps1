Describe "Quantum Core Stability" {
    It "Should reject invalid qubit counts" {
        { Invoke-QuantumOperation -Qubits 0 -GateType Hadamard } | Should -Throw
    }

    It "Should reject invalid gate types" {
        { Invoke-QuantumOperation -Qubits 2 -GateType Invalid } | Should -Throw
    }

    It "Should process valid operations" {
        Invoke-QuantumOperation -Qubits 2 -GateType Hadamard | Should -Be "Applied Hadamard to 2 qubits"
    }

    It "Should log high qubit operations" {
        $logFile = "$PSScriptRoot/../divina.log"
        Remove-Item $logFile -ErrorAction SilentlyContinue
        Invoke-QuantumOperation -Qubits 300 -GateType PauliX
        Get-Content $logFile | Should -Match "High qubit operation attempted"
    }

    It "Should return Omega status" {
        $status = Get-OmegaStatus
        $status.Version | Should -Be "0.0.1"
        $status.User | Should -Be $env:USERNAME
    }

    It "Should perform ritual invocation" {
        { Invoke-OmegaRitual -Level 1 } | Should -Not -Throw
    }
}
