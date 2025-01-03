//
//  BFVirtualMachineError.swift
//  brainfuck_impl
//
//  Created by EnchantCode on 2025/01/02.
//

/// Brainfuck VMのエラー
public enum BFVirtualMachineError: Error {
    
    /// 命令フェッチ失敗
    case InstructionFetchError(address: BFAddress)
    
    /// 不正なループ終端 (`]`)
    case InvalidLoopEndError(address: BFAddress)
    
    /// メモリアドレス範囲外アクセス
    case MemoryAddressIndexOutOfBoundsError
    
}
