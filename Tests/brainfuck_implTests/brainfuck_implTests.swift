import Testing
@testable import brainfuck_impl


@Test func testRunHelloWorld() async throws {
    class TestProgiramSource: BFProgramDataSource {
        private let program = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."
        
        func opcode(at address: BFAddress) -> BFMachineOpcode? {
            guard address < program.count else {return nil}
            let codeIndex = program.index(program.startIndex, offsetBy: .init(address))
            return .init(rawValue: program[codeIndex])
        }
    }
    let testProgramSource = TestProgiramSource()
    
    let vm = BFVirtualMachine()
    vm.dataSource = testProgramSource
    vm.run()
}
