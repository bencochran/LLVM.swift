//
//  Created by Ben Cochran on 11/13/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

public class Instruction : User {
    public var parent: BasicBlock {
        return BasicBlock(ref: LLVMGetInstructionParent(ref))
    }
    
    public var nextInstruction: Instruction? {
        return Instruction(maybeRef: LLVMGetNextInstruction(ref))
    }
    
    public var previousInstruction: Instruction? {
        return Instruction(maybeRef: LLVMGetPreviousInstruction(ref))
    }
    
    public var opCode: LLVMOpcode {
        return LLVMGetInstructionOpcode(ref)
    }
}

public class TerminatorInstruction : Instruction {
    
}

public class ReturnInstruction : TerminatorInstruction {
    
}

public class BranchInstruction : TerminatorInstruction {
    
}

public class SwitchInstruction : TerminatorInstruction {
    func addCase(on: Constant, destination: BasicBlock) {
        LLVMAddCase(ref, on.ref, destination.ref)
    }
}

public class IndirectBranchInstruction : TerminatorInstruction {
    public func addDestination(destination: BasicBlock) {
        LLVMAddDestination(ref, destination.ref)
    }
}

public class ResumeInstruction : TerminatorInstruction {
    
}

public class InvokeInstruction : TerminatorInstruction {
    
}

public class UnreachableInstruction : TerminatorInstruction {
    
}

public class CallInstruction : Instruction {
    
}

public class UnaryInstruction : Instruction {
    
}

public class AllocaInstruction : UnaryInstruction {
    
}

public class LoadInstruction : UnaryInstruction {
    
}

public class VAArgInstruction : UnaryInstruction {
    
}

public class PHINode : Instruction {
    
}

