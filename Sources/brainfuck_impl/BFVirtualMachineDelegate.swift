//
//  BFVirtualMachineDelegate.swift
//  brainfuck_impl
//
//  Created by EnchantCode on 2025/01/02.
//

public protocol BFVirtualMachineDelegate: AnyObject {
    
    /// 仮想マシンが命令を実行した
    /// - Parameters:
    ///   - vm: 仮想マシン
    ///   - result: 命令とその実行結果
    func bfVirtualMachine(_ vm: BFVirtualMachine, didExecuteOpcode result: Result<BFMachineOpcode, BFVirtualMachineError>)
    
    /// 仮想マシンの実行が完了した
    /// - Parameter vm: 仮想マシン
    func bfVirtualMachineDidFinishExecution(_ vm: BFVirtualMachine)
    
}
