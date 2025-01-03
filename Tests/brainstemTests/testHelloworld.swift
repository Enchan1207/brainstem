import XCTest
@testable import brainstem

final class testError: XCTestCase {
    
    func testRunHelloWorld() throws {
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
    
}
