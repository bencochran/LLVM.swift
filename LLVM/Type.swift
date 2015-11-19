//
//  Created by Ben Cochran on 11/13/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

public protocol TypeType {
    var ref: LLVMValueRef { get }
    init(ref: LLVMValueRef)
    
    var kind: LLVMTypeKind { get }
    var isSized: Bool { get }
    var string: String? { get }
}

extension TypeType {
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
}

public struct AnyType : TypeType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
}

public struct IntType : TypeType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }

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

public struct RealType : TypeType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }

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


public struct FunctionType : TypeType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }

    public init(returnType: TypeType, paramTypes: [TypeType], isVarArg: Bool) {
        var paramTypeValues = paramTypes.map { $0.ref }
        ref = LLVMFunctionType(returnType.ref, &paramTypeValues, UInt32(paramTypeValues.count), isVarArg ? 1 : 0)
    }
    
    public var isVarArg: Bool {
        return LLVMIsFunctionVarArg(ref) != 0
    }
    
    public var paramTypesCount: UInt32 {
        return LLVMCountParamTypes(ref)
    }
    
    public var paramTypes: [TypeType] {
        let count = Int(paramTypesCount)
        let refs = UnsafeMutablePointer<LLVMTypeRef>.alloc(count)
        defer { refs.dealloc(count) }
        
        LLVMGetParamTypes(ref, refs)
        return UnsafeMutableBufferPointer(start: refs, count: count).map(AnyType.init)
    }
}

public protocol CompositeTypeType : TypeType { }

public struct StructType : CompositeTypeType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }

    public init(elementTypes: [TypeType], packed: Bool, inContext context: Context) {
        var elementTypeValues = elementTypes.map { $0.ref }
        ref = LLVMStructTypeInContext(context.ref, &elementTypeValues, UInt32(elementTypeValues.count), packed ? 1 : 0)
    }
    
    public init(named name: String, inContext context: Context) {
        ref = LLVMStructCreateNamed(context.ref, name)
    }
    
    public var name: String? {
        let name = LLVMGetStructName(ref)
        return .fromCString(name)
    }
    
    public var structure: ([TypeType], packed: Bool) {
        get {
            let count = Int(LLVMCountStructElementTypes(ref))
            let refs = UnsafeMutablePointer<LLVMTypeRef>.alloc(count)
            defer { refs.dealloc(count) }
            
            LLVMGetParamTypes(ref, refs)
            let types = UnsafeMutableBufferPointer(start: refs, count: count).map({ AnyType(ref: $0) as TypeType })
            
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

public protocol SequentialTypeType : CompositeTypeType {
    var type: TypeType { get }
}

public extension SequentialTypeType {
    var type: TypeType {
        return AnyType(ref: LLVMGetElementType(ref))
    }
}

public struct ArrayType : SequentialTypeType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }

    public init(type: TypeType, count: UInt32) {
        ref = LLVMArrayType(type.ref, count)
    }
    
    public var length: UInt32 {
        return LLVMGetArrayLength(ref)
    }
}

public struct PointerType : SequentialTypeType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }

    public init(type: TypeType, addressSpace: UInt32) {
        ref = LLVMPointerType(type.ref, addressSpace)
    }
    
    public var addressSpace: UInt32 {
        return LLVMGetPointerAddressSpace(ref)
    }
}

public struct VectorType : SequentialTypeType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }

    public init(type: TypeType, count: UInt32) {
        ref = LLVMVectorType(type.ref, count)
    }
    
    public var size: UInt32 {
        return LLVMGetVectorSize(ref)
    }
}

public struct VoidType : TypeType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }

    public init(inContext context: Context) {
        ref = LLVMVoidTypeInContext(context.ref)
    }
}

public struct LabelType : TypeType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }

    public init(inContext context: Context) {
        ref = LLVMLabelTypeInContext(context.ref)
    }
}

public struct X86MMXType : TypeType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }

    public init(inContext context: Context) {
        ref = LLVMX86MMXTypeInContext(context.ref)
    }
}

public struct MetadataType : TypeType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }

    public init(inContext context: Context) {
        ref = LLVMX86MMXTypeInContext(context.ref)
    }
}
