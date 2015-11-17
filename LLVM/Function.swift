//
//  Created by Ben Cochran on 11/13/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

public class Function : Constant {
    public convenience init(name: String, type: FunctionType, inModule module: Module) {
        self.init(ref: LLVMAddFunction(module.ref, name, type.ref))
    }
    
    public var intrinsicID: UInt32 {
        return LLVMGetIntrinsicID(ref)
    }
    
    public var callConv: LLVMCallConv {
        get {
            return LLVMCallConv(rawValue: LLVMGetFunctionCallConv(ref))
        }
        set {
            LLVMSetFunctionCallConv(ref, callConv.rawValue)
        }
    }
    
    public var attributes: LLVMAttribute {
        return LLVMGetFunctionAttr(ref)
    }
    
    // TODO: Roll add/remove into a setter on `attributes`
    public func addAttribute(attribute: LLVMAttribute) {
        LLVMAddFunctionAttr(ref, attribute)
    }
    
    public func removeAttribute(attribute: LLVMAttribute) {
        LLVMRemoveFunctionAttr(ref, attribute)
    }

    public var paramCount: UInt32 {
        return LLVMCountParams(ref)
    }
    
    public var params: [Argument] {
        let count = Int(paramCount)
        let refs = UnsafeMutablePointer<LLVMValueRef>.alloc(count)
        defer { refs.dealloc(count) }
        
        LLVMGetParams(ref, refs)
        return UnsafeMutableBufferPointer(start: refs, count: count).map(Argument.init)
    }

    public func paramAtIndex(index: UInt32) -> Argument {
        return Argument(ref: LLVMGetParam(ref, index))
    }
    
    public var basicBlockCount: UInt32 {
        return LLVMCountBasicBlocks(ref)
    }
    
    public var basicBlocks: [BasicBlock] {
        let count = Int(paramCount)
        let refs = UnsafeMutablePointer<LLVMBasicBlockRef>.alloc(count)
        defer { refs.dealloc(count) }
        
        LLVMGetBasicBlocks(ref, refs)
        return UnsafeMutableBufferPointer(start: refs, count: count).map(BasicBlock.init)
    }
    
    public var entry: BasicBlock {
        return BasicBlock(ref: LLVMGetEntryBasicBlock(ref))
    }
    
    public func appendBasicBlock(name: String, context: Context) -> BasicBlock {
        return BasicBlock(ref: LLVMAppendBasicBlockInContext(context.ref, ref, name))
    }
    
    // true = valid, false = invalid (opposite of LLVM’s whacky status)
    public func verify() -> Bool {
        return LLVMVerifyFunction(ref, LLVMReturnStatusAction) == 0
    }
}

public class Argument : Value {
    public var attributes: LLVMAttribute {
        return LLVMGetFunctionAttr(ref)
    }
    
    // TODO: Roll add/remove into a setter on `attributes`
    public func addAttribute(attribute: LLVMAttribute) {
        LLVMAddFunctionAttr(ref, attribute)
    }
    
    public func removeAttribute(attribute: LLVMAttribute) {
        LLVMRemoveFunctionAttr(ref, attribute)
    }
}
