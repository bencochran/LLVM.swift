//
//  Created by Ben Cochran on 11/12/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import Foundation
import LLVM_C

public class Module {
    internal let ref: LLVMModuleRef
    
    public init(name: String, context: Context) {
        ref = LLVMModuleCreateWithNameInContext(name, context.ref)
    }

    deinit {
        LLVMDisposeModule(ref)
    }

    public var string: String? {
        let charStar = LLVMPrintModuleToString(ref)
        defer { LLVMDisposeMessage(charStar) }
        return String.fromCString(charStar)
    }
    
    public var dataLayout: String {
        get {
            return String.fromCString(LLVMGetDataLayout(ref))!
        }
        set {
            LLVMSetDataLayout(ref, dataLayout)
        }
    }
    
    public var target: String {
        get {
            return String.fromCString(LLVMGetTarget(ref))!
        }
        set {
            LLVMSetTarget(ref, target)
        }
    }
    
    // TODO: LLVMSetModuleInlineAsm
    
    public var context: Context {
        return Context(ref: LLVMGetModuleContext(ref), managed: false)
    }
    
    public func typeByName(name: String) -> TypeType? {
        let typeRef = LLVMGetTypeByName(ref, name)
        if typeRef == nil { return .None }
        return AnyType(ref: typeRef)
    }
    
    public func functionByName(name: String) -> Function? {
        let funcRef = LLVMGetNamedFunction(ref, name)
        if funcRef == nil { return .None }
        return Function(ref: funcRef)
    }
    
    // true = valid, false = invalid (opposite of LLVM’s whacky status)
    public func verify() -> Bool {
        return LLVMVerifyModule(ref, LLVMReturnStatusAction, nil) == 0
    }
    
    public var functions: AnyGenerator<Function> {
        var previousRef: LLVMValueRef?
        return anyGenerator {
            let ref: LLVMValueRef
            if let previous = previousRef {
                ref = LLVMGetNextFunction(previous)
            } else {
                ref = LLVMGetFirstFunction(self.ref)
            }
            previousRef = ref
            return ref != nil ? Function(ref: ref) : nil
        }
    }
}
