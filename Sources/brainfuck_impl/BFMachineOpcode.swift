//
//  BFMachineOpcode.swift
//  brainfuck_impl
//
//  Created by EnchantCode on 2025/01/01.
//

/// 仮想マシンが実行する命令
public enum BFMachineOpcode {
    /// アドレス加算
    case IncrementAddress
    
    /// アドレス減算
    case DecrementAddress
    
    /// メモリ値加算
    case IncrementMemory
    
    /// メモリ値減算
    case DecrementMemory
    
    /// 出力
    case Write
    
    /// 入力
    case Read
    
    /// ループ開始
    case BeginLoop
    
    /// ループ終了
    case EndLoop
    
    init?(_ rawValue: Character){
        switch rawValue {
        case ">":
            self = .IncrementAddress
        
        case "<":
            self = .DecrementAddress
            
        case "+":
            self = .IncrementMemory
        
        case "-":
            self = .DecrementMemory
        
        case ".":
            self = .Write
            
        case ",":
            self = .Read
        
        case "[":
            self = .BeginLoop
            
        case "]":
            self = .EndLoop
            
        default:
            return nil
        }
    }
}
