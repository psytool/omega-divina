BeforeDiscovery {
    Import-Module "$PSScriptRoot/../core/OmegaCore.psm1" -Force
}

Describe "Quantum Core Stability" {
    It "Should reject invalid qubit counts" {
        { Invoke-QuantumOperation -Qubits 1025 -GateType Hadamard } | 
        Should -Throw -Because "Qubit count exceeds maximum"
    }

    It "Should reject invalid gate types" {
        { Invoke-QuantumOperation -Qubits 2 -GateType 'Invalid' } | 
        Should -Throw -Because "Invalid gate type"
    }

    It "Should process valid operations" {
        $result = Invoke-QuantumOperation -Qubits 2 -GateType Hadamard
        $result | Should -Be "Applied Hadamard to 2 qubits" -Because "Valid operation should return expected output"
    }
}
