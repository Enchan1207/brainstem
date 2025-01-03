//
//  BFProgramDataSource.swift
//  brainfuck_impl
//
//  Created by EnchantCode on 2025/01/01.
//

public protocol BFProgramDataSource: AnyObject {
    
    /// 指定されたアドレスに格納されている命令コードを返す
    /// - Parameter address: アドレス
    /// - Returns: アドレスに格納されている命令
    func opcode(at address: BFAddress) -> BFMachineOpcode?
    
}
