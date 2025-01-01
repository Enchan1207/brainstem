import Testing
@testable import brainfuck_impl

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
}

@Test func testRunHelloWorld() async throws {
    class TestProgiramSource: BFProgramDataSource {
        private let program = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."
        
        func opcode(at address: BFAddress) -> BFMachineOpcode? {
            guard address < program.count else {return nil}
            let codeIndex = program.index(program.startIndex, offsetBy: address)
            return .init(program[codeIndex])
        }
    }
    let testProgramSource = TestProgiramSource()
    
    let vm = BFVirtualMachine()
    vm.dataSource = testProgramSource
    vm.run()
}
