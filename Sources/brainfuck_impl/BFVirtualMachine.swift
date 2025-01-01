//
//  BFVirtualMachine.swift
//  brainfuck_impl
//
//  Created by EnchantCode on 2025/01/01.
//

public typealias BFAddress = Int


/// Brainfuck仮想マシン
public final class BFVirtualMachine {
    
    /// 仮想マシン実行状態
    private enum BFMachineState {
        /// 通常通り (REPL)
        case Default
        
        /// 対応するループ終端まで飛ぶ
        case SkipToLoopEnd(depth: UInt)
    }
    
    private var state: BFMachineState = .Default
    
    /// ループ戻り値スタック
    private var returnAddressStack: [BFAddress] = []
    
    /// 内部メモリ
    private var memory: [BFAddress: Int] = [:]
    
    /// 内部メモリポインタ
    private var memoryPointer: BFAddress = 0
    
    /// 現在のmemoryPointerが指す値
    private var memoryValue: Int? {
        get {
            return memory[memoryPointer]
        }
        
        set {
            memory[memoryPointer] = newValue
        }
    }
    
    /// プログラムカウンタ
    private var programCounter: BFAddress = 0
    
    public var dataSource: BFProgramDataSource? {
        willSet {
            reset()
        }
    }
    
    /// Brainfuckコードを実行する
    public func run(){
        while let opcode = fetchOpcode() {
            handle(opcode)
        }
    }
    
    /// 単一のBrainfuckコードを処理する
    /// - Parameter opcode: 実行する命令
    private func handle(_ opcode: BFMachineOpcode){
        if case let .SkipToLoopEnd(depth) = state {
            switch opcode {
            
            case .BeginLoop:
                // メモリの状態は気にせず、とりあえず戻りアドレススタックに積んでいく
                returnAddressStack.append(programCounter)
            
            case .EndLoop:
                // 目的の深さまで戻ってきたらステートを戻す
                if returnAddressStack.count == depth {
                    state = .Default
                }
                
                // アドレススタックを取り出して捨てる
                _ = returnAddressStack.popLast()
                
            default:
                // ループ終端に達するまではオペコードを読み捨てる
                break
            }

            return
        }
        
        switch opcode {
        case .BeginLoop:
            returnAddressStack.append(programCounter - 1)
            if memoryValue == 0 {
                state = .SkipToLoopEnd(depth: .init(returnAddressStack.count))
                break
            }
            
        case .EndLoop:
            guard let returnAddress = returnAddressStack.popLast() else {
                // TODO: エラー処理
                print("Invalid end of loop")
                break
            }
            
            if memoryValue != 0 {
                programCounter = returnAddress
            }
            
        case .IncrementAddress:
            memoryPointer += 1
            
        case .DecrementAddress:
            memoryPointer -= 1
            
        case .IncrementMemory:
            memoryValue = (memoryValue ?? 0) + 1
            
        case .DecrementMemory:
            memoryValue = (memoryValue ?? 0) - 1
            
        case .Write:
            guard let unicodeScalar = UnicodeScalar(memoryValue ?? 0) else {break}
            let character = Character(unicodeScalar)
            print(character, terminator: "")
            
        case .Read:
            // TODO: read
            break
        }
    }
    
    /// 現在のプログラムカウンタから命令を読み出し、カウンタをインクリメントして返す
    /// - Returns: 読み出した命令
    private func fetchOpcode() -> BFMachineOpcode? {
        guard let code = dataSource?.opcode(at: programCounter) else {return nil}
        programCounter += 1
        return code
    }
    
    /// 仮想マシンをリセットする
    public func reset(){
        returnAddressStack.removeAll()
        memory.removeAll()
        programCounter = 0
        state = .Default
    }
    
}
