//
//  Created by Ben Cochran on 11/12/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

public class Value {
    internal var ref: LLVMValueRef
    
    internal init(ref: LLVMValueRef) {
        guard ref != nil else { fatalError("unexpected nil value") }
        self.ref = ref
    }
    
    internal init?(maybeRef ref: LLVMValueRef) {
        self.ref = ref
        if ref == nil { return nil }
    }
    
    public var name: String? {
        get {
            return .fromCString(LLVMGetValueName(ref))
        }
        set {
            // Swift can’t do its type magic with `String?` or `name ?? nil`
            if let name = name {
                LLVMSetValueName(ref, name)
            } else {
                LLVMSetValueName(ref, nil)
            }
        }
    }
    
    public var string: String? {
        let string = LLVMPrintValueToString(ref)
        defer { LLVMDisposeMessage(string) }
        return .fromCString(string)
    }
    
    public func replaceAllUsesWith(value: Value) {
        LLVMReplaceAllUsesWith(ref, value.ref)
    }
    
    public var isConstant: Bool {
        return LLVMIsConstant(ref) != 0
    }
    
    public var isUndefined: Bool {
        return LLVMIsUndef(ref) != 0
    }
    
    public var uses: AnyGenerator<Use> {
        var previousRef: LLVMValueRef?
        return anyGenerator {
            let ref: LLVMValueRef
            if let previous = previousRef {
                ref = LLVMGetNextUse(previous)
            } else {
                ref = LLVMGetFirstUse(self.ref)
            }
            previousRef = ref
            return ref != nil ? Use(ref: ref) : nil
        }
    }
    
}
