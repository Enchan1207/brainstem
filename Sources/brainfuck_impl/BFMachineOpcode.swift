//
//  BFMachineOpcode.swift
//  brainfuck_impl
//
//  Created by EnchantCode on 2025/01/01.
//

/// 仮想マシンが実行する命令
public enum BFMachineOpcode: RawRepresentable {
    public typealias RawValue = Character
    
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
    
    public init?(rawValue: Character){
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
    
    public var rawValue: Character {
        switch self {
        case .IncrementAddress:
            return ">"
        case .DecrementAddress:
            return "<"
        case .IncrementMemory:
            return "+"
        case .DecrementMemory:
            return "-"
        case .Write:
            return "."
        case .Read:
            return ","
        case .BeginLoop:
            return "["
        case .EndLoop:
            return "]"
        }
    }
}
