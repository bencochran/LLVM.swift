//
//  Created by Ben Cochran on 11/13/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

public class BasicBlock {
    public let ref: LLVMBasicBlockRef
    
    internal init(ref: LLVMBasicBlockRef) {
        self.ref = ref
    }
    
    public var parent: Function? {
        return Function(maybeRef: LLVMGetBasicBlockParent(ref))
    }
    
    public var terminator: TerminatorInstructionType? {
        return AnyTerminatorInstruction(maybeRef: LLVMGetBasicBlockTerminator(ref))
    }
    
    public func insertInContext(context: Context, name: String) -> BasicBlock {
        return BasicBlock(ref: LLVMInsertBasicBlockInContext(context.ref, ref, name))
    }
    
    public func delete() {
        LLVMDeleteBasicBlock(ref)
        // TODO: We have a dangling ref now … 😕
    }
    
    public func removeFromParent() {
        LLVMRemoveBasicBlockFromParent(ref)
    }
    
    public func moveBefore(block: BasicBlock) {
        LLVMMoveBasicBlockBefore(ref, block.ref)
    }
    
    public func moveAfter(block: BasicBlock) {
        LLVMMoveBasicBlockAfter(ref, block.ref)
    }
    
    public var firstInstruction: InstructionType? {
        return AnyInstruction(maybeRef: LLVMGetFirstInstruction(ref))
    }
    
    public var lastInstruction: InstructionType? {
        return AnyInstruction(maybeRef: LLVMGetLastInstruction(ref))
    }
}
