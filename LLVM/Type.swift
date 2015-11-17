//
//  Created by Ben Cochran on 11/13/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

public class Type {
    internal var ref: LLVMTypeRef
    private init(ref: LLVMTypeRef) {
        self.ref = ref
    }
    
    public var kind: LLVMTypeKind {
        return LLVMGetTypeKind(ref)
    }
    
    public var isSized: Bool {
        return LLVMTypeIsSized(ref) != 0
    }
    
    public var string: String? {
        let string = LLVMPrintTypeToString(ref)
        defer { LLVMDisposeMessage(string) }
        return .fromCString(string)
    }
    
    public static func foo(ref: LLVMTypeRef) -> Type? {
        let kind = LLVMGetTypeKind(ref)
        switch kind {
        case LLVMVoidTypeKind: return VoidType(ref: ref)
        case LLVMHalfTypeKind: return RealType(ref: ref)
        case LLVMFloatTypeKind: return RealType(ref: ref)
        case LLVMDoubleTypeKind: return RealType(ref: ref)
        case LLVMX86_FP80TypeKind: return RealType(ref: ref)
        case LLVMPPC_FP128TypeKind: return RealType(ref: ref)
        case LLVMLabelTypeKind: return LabelType(ref: ref)
        case LLVMIntegerTypeKind: return IntType(ref: ref)
        case LLVMFunctionTypeKind: return FunctionType(ref: ref)
        case LLVMStructTypeKind: return StructType(ref: ref)
        case LLVMArrayTypeKind: return ArrayType(ref: ref)
        case LLVMPointerTypeKind: return PointerType(ref: ref)
        case LLVMVectorTypeKind: return VectorType(ref: ref)
        case LLVMMetadataTypeKind: return MetadataType(ref: ref)
        case LLVMX86_MMXTypeKind: return X86MMXType(ref: ref)
        default: return Type(ref: ref)
        }
    }
    
}

public class IntType : Type {
    public static func int1(inContext context: Context) -> IntType {
        return IntType(ref: LLVMInt1TypeInContext(context.ref))
    }
    
    public static func int8(inContext context: Context) -> IntType {
        return IntType(ref: LLVMInt8TypeInContext(context.ref))
    }
    
    public static func int16(inContext context: Context) -> IntType {
        return IntType(ref: LLVMInt16TypeInContext(context.ref))
    }
    
    public static func int32(inContext context: Context) -> IntType {
        return IntType(ref: LLVMInt32TypeInContext(context.ref))
    }
    
    public static func int64(inContext context: Context) -> IntType {
        return IntType(ref: LLVMInt64TypeInContext(context.ref))
    }
    
    public static func int(inContext context: Context, numBits: UInt32) -> IntType {
        return IntType(ref: LLVMIntTypeInContext(context.ref, numBits))
    }
    
    public var width: UInt32 {
        return LLVMGetIntTypeWidth(ref)
    }
}

public class RealType : Type {
    public static func half(inContext context: Context) -> RealType {
        return RealType(ref: LLVMHalfTypeInContext(context.ref))
    }
    
    public static func float(inContext context: Context) -> RealType {
        return RealType(ref: LLVMFloatTypeInContext(context.ref))
    }
    
    public static func double(inContext context: Context) -> RealType {
        return RealType(ref: LLVMDoubleTypeInContext(context.ref))
    }
    
    public static func x86fp80(inContext context: Context) -> RealType {
        return RealType(ref: LLVMX86FP80TypeInContext(context.ref))
    }
    
    public static func fp128(inContext context: Context) -> RealType {
        return RealType(ref: LLVMFP128TypeInContext(context.ref))
    }
    
    public static func ppcfp128(inContext context: Context) -> RealType {
        return RealType(ref: LLVMPPCFP128TypeInContext(context.ref))
    }
}


public class FunctionType : Type {
    public convenience init(returnType: Type, paramTypes: [Type], isVarArg: Bool) {
        var paramTypeValues = paramTypes.map { $0.ref }
        let ref = LLVMFunctionType(returnType.ref, &paramTypeValues, UInt32(paramTypeValues.count), isVarArg ? 1 : 0)
        self.init(ref: ref)
    }
    
    public var isVarArg: Bool {
        return LLVMIsFunctionVarArg(ref) != 0
    }
    
    public var paramTypesCount: UInt32 {
        return LLVMCountParamTypes(ref)
    }
    
    public var paramTypes: [Type] {
        let count = Int(paramTypesCount)
        let refs = UnsafeMutablePointer<LLVMTypeRef>.alloc(count)
        defer { refs.dealloc(count) }
        
        LLVMGetParamTypes(ref, refs)
        return UnsafeMutableBufferPointer(start: refs, count: count).map(Type.init)
    }
}

public class CompositeType : Type {
    
}

public class StructType : CompositeType {
    public convenience init(elementTypes: [Type], packed: Bool, inContext context: Context) {
        var elementTypeValues = elementTypes.map { $0.ref }
        let ref = LLVMStructTypeInContext(context.ref, &elementTypeValues, UInt32(elementTypeValues.count), packed ? 1 : 0)
        self.init(ref: ref)
    }
    
    public convenience init(named name: String, inContext context: Context) {
        let ref = LLVMStructCreateNamed(context.ref, name)
        self.init(ref: ref)
    }
    
    public var name: String? {
        let name = LLVMGetStructName(ref)
        return .fromCString(name)
    }
    
    public var structure: ([Type], packed: Bool) {
        get {
            let count = Int(LLVMCountStructElementTypes(ref))
            let refs = UnsafeMutablePointer<LLVMTypeRef>.alloc(count)
            defer { refs.dealloc(count) }
            
            LLVMGetParamTypes(ref, refs)
            let types = UnsafeMutableBufferPointer(start: refs, count: count).map(Type.init)
            
            let packed = LLVMIsPackedStruct(ref) != 0
            return (types, packed)
        }
        set {
            var elementTypeValues = structure.0.map { $0.ref }
            LLVMStructSetBody(ref, &elementTypeValues, UInt32(elementTypeValues.count), structure.packed ? 1 : 0)
        }
    }
    
    public var isOpaque: Bool {
        return LLVMIsOpaqueStruct(ref) != 0
    }
}

public class SequentialType : CompositeType {
    public var type: Type {
        return Type(ref: LLVMGetElementType(ref))
    }
}

public class ArrayType : SequentialType {
    public convenience init(type: Type, count: UInt32) {
        let ref = LLVMArrayType(type.ref, count)
        self.init(ref: ref)
    }
    
    public var length: UInt32 {
        return LLVMGetArrayLength(ref)
    }
}

public class PointerType : SequentialType {
    public convenience init(type: Type, addressSpace: UInt32) {
        self.init(ref: LLVMPointerType(type.ref, addressSpace))
    }
    
    public var addressSpace: UInt32 {
        return LLVMGetPointerAddressSpace(ref)
    }
}

public class VectorType : SequentialType {
    public convenience init(type: Type, count: UInt32) {
        self.init(ref: LLVMVectorType(type.ref, count))
    }
    
    public var size: UInt32 {
        return LLVMGetVectorSize(ref)
    }
}

public class VoidType : Type {
    public convenience init(inContext context: Context) {
        self.init(ref: LLVMVoidTypeInContext(context.ref))
    }
}

public class LabelType : Type {
    public convenience init(inContext context: Context) {
        self.init(ref: LLVMLabelTypeInContext(context.ref))
    }
}

public class X86MMXType : Type {
    public convenience init(inContext context: Context) {
        self.init(ref: LLVMX86MMXTypeInContext(context.ref))
    }
}

public class MetadataType : Type {
    public convenience init(inContext context: Context) {
        self.init(ref: LLVMX86MMXTypeInContext(context.ref))
    }
}
