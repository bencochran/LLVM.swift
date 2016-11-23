//
//  Created by Ben Cochran on 11/13/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import LLVM_C

public struct Function : ConstantType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }

    public init(name: String, type: FunctionType, inModule module: Module) {
        ref = LLVMAddFunction(module.ref, name, type.ref)
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
    public func addAttribute(_ attribute: LLVMAttribute) {
        LLVMAddFunctionAttr(ref, attribute)
    }
    
    public func removeAttribute(_ attribute: LLVMAttribute) {
        LLVMRemoveFunctionAttr(ref, attribute)
    }

    public var paramCount: UInt32 {
        return LLVMCountParams(ref)
    }
    
    public var params: [Argument] {
        var refs = [LLVMValueRef?](repeating: nil, count: Int(paramCount))
        refs.withUnsafeMutableBufferPointer { LLVMGetParams(ref, $0.baseAddress) }
        return refs.map { Argument(ref: $0!) }
    }

    public func paramAtIndex(_ index: UInt32) -> Argument {
        return Argument(ref: LLVMGetParam(ref, index))
    }
    
    public var basicBlockCount: UInt32 {
        return LLVMCountBasicBlocks(ref)
    }
    
    public var basicBlocks: [BasicBlock] {
        var refs = [LLVMBasicBlockRef?](repeating: nil, count: Int(basicBlockCount))
        refs.withUnsafeMutableBufferPointer { LLVMGetBasicBlocks(ref, $0.baseAddress) }
        return refs.map { BasicBlock(ref: $0!) }
    }
    
    public var entry: BasicBlock {
        return BasicBlock(ref: LLVMGetEntryBasicBlock(ref))
    }
    
    public func appendBasicBlock(_ name: String, context: Context) -> BasicBlock {
        return BasicBlock(ref: LLVMAppendBasicBlockInContext(context.ref, ref, name))
    }
    
    // true = valid, false = invalid (opposite of LLVM’s whacky status)
    public func verify() -> Bool {
        return LLVMVerifyFunction(ref, LLVMReturnStatusAction) == 0
    }
}

public struct Argument : ValueType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }

    public var attributes: LLVMAttribute {
        return LLVMGetFunctionAttr(ref)
    }
    
    // TODO: Roll add/remove into a setter on `attributes`
    public func addAttribute(_ attribute: LLVMAttribute) {
        LLVMAddFunctionAttr(ref, attribute)
    }
    
    public func removeAttribute(_ attribute: LLVMAttribute) {
        LLVMRemoveFunctionAttr(ref, attribute)
    }
}
