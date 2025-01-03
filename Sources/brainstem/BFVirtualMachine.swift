//
//  BFVirtualMachine.swift
//  brainfuck_impl
//
//  Created by EnchantCode on 2025/01/01.
//

public typealias BFAddress = UInt


/// Brainfuck仮想マシン
public final class BFVirtualMachine {
    
    // MARK: - Private properties
    
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
    
    // MARK: - Public properties
    
    /// プログラムカウンタ
    private(set) public var programCounter: BFAddress = 0
    
    public weak var dataSource: BFProgramDataSource? {
        willSet {
            reset()
        }
    }
    
    public weak var delegate: BFVirtualMachineDelegate?
    
    // MARK: - Private methods
    
    /// 現在のプログラムカウンタから命令を読み出し、カウンタをインクリメントして返す
    /// - Returns: 読み出した命令
    private func fetchOpcode() -> Result<BFMachineOpcode, BFVirtualMachineError> {
        guard let code = dataSource?.opcode(at: programCounter) else {return .failure(.InstructionFetchError(address: programCounter))}
        programCounter += 1
        return .success(code)
    }
    
    /// 単一のBrainfuckコードを処理する
    /// - Parameter opcode: 実行する命令
    private func exec(_ opcode: BFMachineOpcode) -> Result<BFMachineOpcode, BFVirtualMachineError> {
        switch (state, opcode) {
            
        case (.Default, .BeginLoop):
            returnAddressStack.append(programCounter - 1)
            if memoryValue == 0 {
                state = .SkipToLoopEnd(depth: .init(returnAddressStack.count))
            }
            
        case (.Default, .EndLoop):
            guard let returnAddress = returnAddressStack.popLast() else {return .failure(.InvalidLoopEndError(address: programCounter - 1))}
            
            if memoryValue != 0 {
                programCounter = returnAddress
            }
            
        case (.Default, .IncrementAddress):
            memoryPointer += 1
            
        case (.Default, .DecrementAddress):
            guard memoryPointer > 0 else {return .failure(.MemoryAddressIndexOutOfBoundsError)}
            memoryPointer -= 1
            
        case (.Default, .IncrementMemory):
            memoryValue = (memoryValue ?? 0) + 1
            
        case (.Default, .DecrementMemory):
            memoryValue = (memoryValue ?? 0) - 1
            
        case (.Default, .Write):
            guard let unicodeScalar = UnicodeScalar(memoryValue ?? 0) else {break}
            let character = Character(unicodeScalar)
            // TODO: I/Oを逃がす
            print(character, terminator: "")
            
        case (.Default, .Read):
            // TODO: I/Oを逃がす
            break
        
        case (.SkipToLoopEnd(_), .BeginLoop):
            // メモリの状態は気にせず、とりあえず戻りアドレススタックに積んでいく
            returnAddressStack.append(programCounter)
        
        case (.SkipToLoopEnd(let depth), .EndLoop):
            // 目的の深さまで戻ってきたらステートを戻す
            if returnAddressStack.count == depth {
                state = .Default
            }
            // アドレススタックを取り出して捨てる
            _ = returnAddressStack.popLast()
        
        default:
            break
        }
        
        return .success(opcode)
    }
    
    // MARK: - Public methods
    
    /// 仮想マシンを実行する
    public func run() {
        while true {
            let result = step()
            switch result {
            case .success(_):
                continue
            case .failure(let error):
                if case .InstructionFetchError(_) = error {
                    delegate?.bfVirtualMachineDidFinishExecution(self)
                }
            }
            break
        }
    }
    
    /// 仮想マシンをステップ実行する
    /// - Returns: 実行が完了した命令またはエラー
    public func step() -> Result<BFMachineOpcode, BFVirtualMachineError> {
        let result = fetchOpcode().flatMap(exec)
        self.delegate?.bfVirtualMachine(self, didExecuteOpcode: result)
        return result
    }
    
    /// 仮想マシンをリセットする
    public func reset(){
        returnAddressStack.removeAll()
        memory.removeAll()
        programCounter = 0
        state = .Default
    }
    
}
