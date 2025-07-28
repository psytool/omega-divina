BeforeAll {
    Import-Module ./core/OmegaCore.psm1 -Force
}

Describe "Quantum Core Stability" {
    Context "Quantum Operations" {
        It "Should reject invalid qubit counts" {
            { Invoke-QuantumOperation -Qubits 0 -GateType Hadamard } | Should -Throw
        }

        It "Should reject invalid gate types" {
            { Invoke-QuantumOperation -Qubits 2 -GateType Invalid } | Should -Throw
        }

        It "Should process valid operations" {
            Invoke-QuantumOperation -Qubits 2 -GateType Hadamard | Should -Be "Applied Hadamard to 2 qubits"
        }
    }

    Context "Omega Status" {
        It "Should return proper status structure" {
            $status = Get-OmegaStatus
            $status.Version | Should -Be "0.0.1"
            $status.Phase | Should -Be "Initiation"
            $status.User | Should -Be $env:USERNAME
            $status.SacredSpace | Should -Be "QuantumRealm"
        }
    }

    Context "Error Handling" {
        It "Should enforce strict mode" {
            { Get-Variable nonExistentVar -ValueOnly } | Should -Throw
        }
    }

    Context "Memory Management" {
        It "Should clean quantum memory" {
            { [QuantumMemoryManager]::Clean() } | Should -Not -Throw
        }
    }
}
