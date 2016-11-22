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
        return String(cString: charStar!)
    }
    
    public var dataLayout: String {
        get {
            return String(cString: LLVMGetDataLayout(ref))
        }
        set {
            LLVMSetDataLayout(ref, dataLayout)
        }
    }
    
    public var target: String {
        get {
            return String(cString: LLVMGetTarget(ref))
        }
        set {
            LLVMSetTarget(ref, target)
        }
    }
    
    // TODO: LLVMSetModuleInlineAsm
    
    public var context: Context {
        return Context(ref: LLVMGetModuleContext(ref), managed: false)
    }
    
    public func typeByName(_ name: String) -> TypeType? {
        let typeRef = LLVMGetTypeByName(ref, name)
        if typeRef == nil { return .none }
        return AnyType(ref: typeRef!)
    }
    
    public func functionByName(_ name: String) -> Function? {
        let funcRef = LLVMGetNamedFunction(ref, name)
        if funcRef == nil { return .none }
        return Function(ref: funcRef!)
    }
    
    // true = valid, false = invalid (opposite of LLVM’s whacky status)
    public func verify() -> Bool {
        return LLVMVerifyModule(ref, LLVMReturnStatusAction, nil) == 0
    }
    
    public var functions: AnyIterator<Function> {
        var previousRef: LLVMValueRef?
        return AnyIterator {
            let ref: LLVMValueRef?
            if let previous = previousRef {
                ref = LLVMGetNextFunction(previous)
            } else {
                ref = LLVMGetFirstFunction(self.ref)
            }
            previousRef = ref
            if let ref = ref {
                return Function(ref: ref)
            }
            return nil
        }
    }
}
