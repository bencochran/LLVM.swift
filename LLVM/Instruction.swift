//
//  Created by Ben Cochran on 11/13/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

public protocol InstructionType : UserType {
    var parent: BasicBlock { get }
    var nextInstruction: InstructionType? { get }
    var previousInstruction: InstructionType? { get }
    var opCode: LLVMOpcode { get }
}



public extension InstructionType {
    public var parent: BasicBlock {
        return BasicBlock(ref: LLVMGetInstructionParent(ref))
    }
    
    public var nextInstruction: InstructionType? {
        return AnyInstruction(maybeRef: LLVMGetNextInstruction(ref))
    }
    
    public var previousInstruction: InstructionType? {
        return AnyInstruction(maybeRef: LLVMGetPreviousInstruction(ref))
    }
    
    public var opCode: LLVMOpcode {
        return LLVMGetInstructionOpcode(ref)
    }
}

public struct AnyInstruction : InstructionType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
}

public protocol TerminatorInstructionType : InstructionType { }

public struct AnyTerminatorInstruction : TerminatorInstructionType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
}

public struct ReturnInstruction : TerminatorInstructionType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
}

public struct BranchInstruction : TerminatorInstructionType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
}

public struct SwitchInstruction : TerminatorInstructionType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
    func addCase(on: ConstantType, destination: BasicBlock) {
        LLVMAddCase(ref, on.ref, destination.ref)
    }
}

public struct IndirectBranchInstruction : TerminatorInstructionType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
    public func addDestination(destination: BasicBlock) {
        LLVMAddDestination(ref, destination.ref)
    }
}

public struct ResumeInstruction : TerminatorInstructionType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
    
}

public struct InvokeInstruction : TerminatorInstructionType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
    
}

public struct UnreachableInstruction : TerminatorInstructionType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
    
}

public struct CallInstruction : InstructionType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
    
}

public protocol UnaryInstructionType : InstructionType { }

public struct AllocaInstruction : UnaryInstructionType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
    
}

public struct LoadInstruction : UnaryInstructionType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
    
}

public struct VAArgInstruction : UnaryInstructionType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
    
}

public struct PHINode : InstructionType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
    
}

