//
//  Created by Ben Cochran on 11/12/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import LLVM_C

public class Builder {
    internal let ref: LLVMBuilderRef
    
    public init(inContext context: Context) {
        ref = LLVMCreateBuilderInContext(context.ref)
    }
    
    deinit {
        LLVMDisposeBuilder(ref)
    }
    
    public func position(block: BasicBlock, instruction: InstructionType) {
        LLVMPositionBuilder(ref, block.ref, instruction.ref)
    }
    
    public func positionBefore(instruction: InstructionType) {
        LLVMPositionBuilderBefore(ref, instruction.ref)
    }
    
    public func positionAtEnd(block: BasicBlock) {
        LLVMPositionBuilderAtEnd(ref, block.ref)
    }
    
    public var insertBlock: BasicBlock {
        return BasicBlock(ref: LLVMGetInsertBlock(ref))
    }
    
    public func clearInsertionPosition() {
        LLVMClearInsertionPosition(ref)
    }
    
    public func insert(instruction: InstructionType, name: String? = nil) {
        if let name = name {
            LLVMInsertIntoBuilderWithName(ref, instruction.ref, name)
        } else {
            LLVMInsertIntoBuilder(ref, instruction.ref)
        }
    }
    
    public func buildReturnVoid() -> ReturnInstruction {
        return ReturnInstruction(ref: LLVMBuildRetVoid(ref))
    }
    
    public func buildReturn(value: ValueType) -> ReturnInstruction {
        return ReturnInstruction(ref: LLVMBuildRet(ref, value.ref))
    }
    
    public func buildBranch(destination: BasicBlock) -> BranchInstruction {
        return BranchInstruction(ref: LLVMBuildBr(ref, destination.ref))
    }
    
    public func buildConditionalBranch(condition: ValueType, thenBlock: BasicBlock, elseBlock: BasicBlock) -> BranchInstruction {
        return BranchInstruction(ref: LLVMBuildCondBr(ref, condition.ref, thenBlock.ref, elseBlock.ref))
    }
    
    public func buildSwitch(value: ValueType, elseBlock: BasicBlock, numCases: UInt32) -> SwitchInstruction {
        return SwitchInstruction(ref: LLVMBuildSwitch(ref, value.ref, elseBlock.ref, numCases))
    }
    
    public func buildIndirectBranch(address: ValueType, destinationHint: UInt32) -> IndirectBranchInstruction {
        return IndirectBranchInstruction(ref: LLVMBuildIndirectBr(ref, address.ref, destinationHint))
    }
    
    public func buildInvoke(_ function: Function, args: [Argument], thenBlock: BasicBlock, catchBlock: BasicBlock, name: String) -> InvokeInstruction {
        var argValues = args.map { Optional.some($0.ref) }
        return InvokeInstruction(ref: LLVMBuildInvoke(ref, function.ref, &argValues, UInt32(argValues.count), thenBlock.ref, catchBlock.ref, name))
    }
    
    // TODO: buildLandingPad
    // TODO: buildResume
    // TODO: addClause
    // TODO: setCleanup
    
    public func buildUnreachable() -> UnreachableInstruction {
        return UnreachableInstruction(ref: LLVMBuildUnreachable(ref))
    }
    
    // MARK: Arithmetic
    
    public func buildAdd(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildAdd(ref, left.ref, right.ref, name))
    }
    
    public func buildNSWAdd(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildNSWAdd(ref, left.ref, right.ref, name))
    }
    
    public func buildNUWAdd(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildNUWAdd(ref, left.ref, right.ref, name))
    }
    
    public func buildFAdd(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildFAdd(ref, left.ref, right.ref, name))
    }
    
    public func buildSub(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildSub(ref, left.ref, right.ref, name))
    }
    
    public func buildNSWSub(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildNSWSub(ref, left.ref, right.ref, name))
    }
    
    public func buildNUWSub(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildNUWSub(ref, left.ref, right.ref, name))
    }
    
    public func buildFSub(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildFSub(ref, left.ref, right.ref, name))
    }
    
    public func buildMul(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildMul(ref, left.ref, right.ref, name))
    }
    
    public func buildNSWMul(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildNSWMul(ref, left.ref, right.ref, name))
    }
    
    public func buildNUWMul(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildNUWMul(ref, left.ref, right.ref, name))
    }
    
    public func buildFMul(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildFMul(ref, left.ref, right.ref, name))
    }
    
    public func buildUDiv(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildUDiv(ref, left.ref, right.ref, name))
    }
    
    public func buildSDiv(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildSDiv(ref, left.ref, right.ref, name))
    }
    
    public func buildExactSDiv(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildExactSDiv(ref, left.ref, right.ref, name))
    }
    
    public func buildFDiv(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildFDiv(ref, left.ref, right.ref, name))
    }
    
    public func buildURem(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildURem(ref, left.ref, right.ref, name))
    }
    
    public func buildSRem(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildSRem(ref, left.ref, right.ref, name))
    }
    
    public func buildFRem(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildFRem(ref, left.ref, right.ref, name))
    }
    
    public func buildShl(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildShl(ref, left.ref, right.ref, name))
    }
    
    public func buildLShr(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildLShr(ref, left.ref, right.ref, name))
    }
    
    public func buildAShr(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildAShr(ref, left.ref, right.ref, name))
    }
    
    public func buildAnd(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildAnd(ref, left.ref, right.ref, name))
    }
    
    public func buildOr(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildOr(ref, left.ref, right.ref, name))
    }
    
    public func buildXor(left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildXor(ref, left.ref, right.ref, name))
    }
    
    public func buildBinOp(_ op: LLVMOpcode, left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildBinOp(ref, op, left.ref, right.ref, name))
    }
    
    public func buildNeg(_ value: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildNeg(ref, value.ref, name))
    }
    
    public func buildNSWNeg(_ value: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildNSWNeg(ref, value.ref, name))
    }
    
    public func buildNUWNeg(_ value: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildNUWNeg(ref, value.ref, name))
    }
    
    public func buildFNeg(_ value: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildFNeg(ref, value.ref, name))
    }
    
    public func buildNot(_ value: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildNot(ref, value.ref, name))
    }

    // MARK: Memory
    
    public func buildMalloc(type: TypeType, name: String) -> InstructionType {
        return AnyInstruction(ref: LLVMBuildMalloc(ref, type.ref, name))
    }
    
    public func buildArrayMalloc(type: TypeType, value: ValueType, name: String) -> InstructionType {
        return AnyInstruction(ref: LLVMBuildArrayMalloc(ref, type.ref, value.ref, name))
    }
    
    public func buildAlloca(type: TypeType, name: String) -> AllocaInstruction {
        return AllocaInstruction(ref: LLVMBuildAlloca(ref, type.ref, name))
    }
    
    public func buildArrayAlloca(type: TypeType, value: ValueType, name: String) -> AllocaInstruction {
        return AllocaInstruction(ref: LLVMBuildArrayAlloca(ref, type.ref, value.ref, name))
    }
    
    public func buildFree(_ pointer: ValueType) -> CallInstruction {
        return CallInstruction(ref: LLVMBuildFree(ref, pointer.ref))
    }
    
    public func buildLoad(_ pointer: ValueType, name: String) -> LoadInstruction {
        return LoadInstruction(ref: LLVMBuildLoad(ref, pointer.ref, name))
    }
    
    public func buildGEP(_ pointer: ValueType, indices: [ValueType], name: String) -> ValueType {
        var indexRefs = indices.map { Optional.some($0.ref) }
        return AnyValue(ref: LLVMBuildGEP(ref, pointer.ref, &indexRefs, UInt32(indexRefs.count), name))
    }
    
    public func buildInBoundsGEP(_ pointer: ValueType, indices: [ValueType], name: String) -> ValueType {
        var indexRefs = indices.map { Optional.some($0.ref) }
        return AnyValue(ref: LLVMBuildInBoundsGEP(ref, pointer.ref, &indexRefs, UInt32(indexRefs.count), name))
    }
    
    public func buildStructGEP(_ pointer: ValueType, index: UInt32, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildStructGEP(ref, pointer.ref, index, name))
    }
    
    public func buildGlobalString(_ string: String, name: String) -> GlobalVariableType {
        return AnyGlobalVariable(ref: LLVMBuildGlobalString(ref, string, name))
    }
    
    public func buildGlobalStringPointer(_ string: String, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildGlobalStringPtr(ref, string, name))
    }
    
    // TODO: volatile get/set
    
    public func buildTrunc(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildTrunc(ref, value.ref, type.ref, name))
    }
    
    public func buildZExt(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildZExt(ref, value.ref, type.ref, name))
    }
    
    public func buildSExt(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildSExt(ref, value.ref, type.ref, name))
    }
    
    public func buildFPToUI(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildFPToUI(ref, value.ref, type.ref, name))
    }
    
    public func buildFPToSI(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildFPToSI(ref, value.ref, type.ref, name))
    }

    public func buildUIToFP(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildUIToFP(ref, value.ref, type.ref, name))
    }
    
    public func buildSIToFP(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildSIToFP(ref, value.ref, type.ref, name))
    }
    
    public func buildFPTrunc(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildFPTrunc(ref, value.ref, type.ref, name))
    }
    
    public func buildFPExt(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildFPExt(ref, value.ref, type.ref, name))
    }
    
    public func buildIntToPointer(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildIntToPtr(ref, value.ref, type.ref, name))
    }
    
    public func buildBitCast(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildBitCast(ref, value.ref, type.ref, name))
    }
    
    public func buildAddressSpaceCast(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildAddrSpaceCast(ref, value.ref, type.ref, name))
    }
    
    public func buildZExtOrBitCast(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildZExtOrBitCast(ref, value.ref, type.ref, name))
    }
    
    public func buildSExtOrBitCast(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildSExtOrBitCast(ref, value.ref, type.ref, name))
    }
    
    public func buildTrucOrBitCast(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildTruncOrBitCast(ref, value.ref, type.ref, name))
    }
    
    public func buildCast(_ op: LLVMOpcode, value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildCast(ref, op, value.ref, type.ref, name))
    }
    
    public func buildPointerCast(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildPointerCast(ref, value.ref, type.ref, name))
    }
    
    public func buildIntCast(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildIntCast(ref, value.ref, type.ref, name))
    }
    
    public func buildFPCast(_ value: ValueType, destinationType type: TypeType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildFPCast(ref, value.ref, type.ref, name))
    }
    
    public func buildICmp(_ op: LLVMIntPredicate, left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildICmp(ref, op, left.ref, right.ref, name))
    }
    
    public func buildFCmp(_ op: LLVMRealPredicate, left: ValueType, right: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildFCmp(ref, op, left.ref, right.ref, name))
    }
    
    public func buildPhi(_ type: TypeType, name: String) -> PHINode {
        return PHINode(ref: LLVMBuildPhi(ref, type.ref, name))
    }
    
    public func buildCall(_ function: Function, args: [ValueType], name: String) -> CallInstruction {
        var argRefs = args.map { Optional.some($0.ref) }
        return CallInstruction(ref: LLVMBuildCall(ref, function.ref, &argRefs, UInt32(argRefs.count), name))
    }
    
    public func buildSelect(_ condition: ValueType, trueValue: ValueType, falseValue: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildSelect(ref, condition.ref, trueValue.ref, falseValue.ref, name))
    }
    
    public func buildVAArg(_ list: ValueType, type: TypeType, name: String) -> VAArgInstruction {
        return VAArgInstruction(ref: LLVMBuildVAArg(ref, list.ref, type.ref, name))
    }
    
    public func buildExtractElement(_ vec: ValueType, index: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildExtractElement(ref, vec.ref, index.ref, name))
    }
    
    public func buildInsertElement(_ vec: ValueType, value: ValueType, index: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildInsertElement(ref, value.ref, vec.ref, index.ref, name))
    }
    
    public func buildShuffleVector(_ vec1: ValueType, vec2: ValueType, mask: ValueType, name: String) -> ValueType {
        return AnyValue(ref: LLVMBuildShuffleVector(ref, vec1.ref, vec2.ref, mask.ref, name))
    }
}
