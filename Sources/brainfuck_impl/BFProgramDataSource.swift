//
//  BFProgramDataSource.swift
//  brainfuck_impl
//
//  Created by EnchantCode on 2025/01/01.
//

public protocol BFProgramDataSource {
    
    func opcode(at address: BFAddress) -> BFMachineOpcode?
    
}
