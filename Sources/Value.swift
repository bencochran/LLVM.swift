//
//  Created by Ben Cochran on 11/12/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import LLVM_C

public protocol ValueType {
    var ref: LLVMValueRef { get }
    init(ref: LLVMValueRef)
    init?(maybeRef ref: LLVMValueRef?)
    
    var name: String? { get }
    var string: String? { get }
    var isConstant: Bool { get }
    var isUndefined: Bool { get }
    var uses: AnyIterator<Use> { get }
    
    func replaceAllUsesWith(_ value: ValueType)
}

public extension ValueType {
    public init?(maybeRef ref: LLVMValueRef?) {
        guard let ref = ref else { return nil }
        self.init(ref: ref)
    }
    
    public var name: String? {
        get {
            return String(cString: LLVMGetValueName(ref))
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
        return String(cString: string!)
    }
    
    public func replaceAllUsesWith(_ value: ValueType) {
        LLVMReplaceAllUsesWith(ref, value.ref)
    }
    
    public var isConstant: Bool {
        return LLVMIsConstant(ref) != 0
    }
    
    public var isUndefined: Bool {
        return LLVMIsUndef(ref) != 0
    }
    
    public var uses: AnyIterator<Use> {
        var previousRef: LLVMValueRef?
        return AnyIterator {
            let ref: LLVMValueRef?
            if let previous = previousRef {
                ref = LLVMGetNextUse(previous)
            } else {
                ref = LLVMGetFirstUse(self.ref)
            }
            previousRef = ref
            if let ref = ref {
                return Use(ref: ref)
            }
            return nil
        }
    }
}

public struct AnyValue : ValueType {
    public var ref: LLVMValueRef
    
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
}
