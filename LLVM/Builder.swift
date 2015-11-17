//
//  Created by Ben Cochran on 11/12/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

public class Builder {
    internal let ref: LLVMBuilderRef
    
    public init(inContext context: Context) {
        ref = LLVMCreateBuilderInContext(context.ref)
    }
    
    deinit {
        LLVMDisposeBuilder(ref)
    }
    
    public func position(block block: BasicBlock, instruction: Instruction) {
        LLVMPositionBuilder(ref, block.ref, instruction.ref)
    }
    
    public func positionBefore(instruction instruction: Instruction) {
        LLVMPositionBuilderBefore(ref, instruction.ref)
    }
    
    public func positionAtEnd(block block: BasicBlock) {
        LLVMPositionBuilderAtEnd(ref, block.ref)
    }
    
    public var insertBlock: BasicBlock {
        return BasicBlock(ref: LLVMGetInsertBlock(ref))
    }
    
    public func clearInsertionPosition() {
        LLVMClearInsertionPosition(ref)
    }
    
    public func insert(instruction instruction: Instruction, name: String? = nil) {
        if let name = name {
            LLVMInsertIntoBuilderWithName(ref, instruction.ref, name)
        } else {
            LLVMInsertIntoBuilder(ref, instruction.ref)
        }
    }
    
    public func buildReturnVoid() -> ReturnInstruction {
        return ReturnInstruction(ref: LLVMBuildRetVoid(ref))
    }
    
    public func buildReturn(value value: Value) -> ReturnInstruction {
        return ReturnInstruction(ref: LLVMBuildRet(ref, value.ref))
    }
    
    public func buildBranch(destination destination: BasicBlock) -> BranchInstruction {
        return BranchInstruction(ref: LLVMBuildBr(ref, destination.ref))
    }
    
    public func buildConditionalBranch(condition condition: Value, thenBlock: BasicBlock, elseBlock: BasicBlock) -> BranchInstruction {
        return BranchInstruction(ref: LLVMBuildCondBr(ref, condition.ref, thenBlock.ref, elseBlock.ref))
    }
    
    public func buildSwitch(value value: Value, elseBlock: BasicBlock, numCases: UInt32) -> SwitchInstruction {
        return SwitchInstruction(ref: LLVMBuildSwitch(ref, value.ref, elseBlock.ref, numCases))
    }
    
    public func buildIndirectBranch(address address: Value, destinationHint: UInt32) -> IndirectBranchInstruction {
        return IndirectBranchInstruction(ref: LLVMBuildIndirectBr(ref, address.ref, destinationHint))
    }
    
    public func buildInvoke(function: Function, args: [Argument], thenBlock: BasicBlock, catchBlock: BasicBlock, name: String) -> InvokeInstruction {
        var argValues = args.map { $0.ref }
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
    
    public func buildAdd(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildAdd(ref, left.ref, right.ref, name))
    }
    
    public func buildNSWAdd(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildNSWAdd(ref, left.ref, right.ref, name))
    }
    
    public func buildNUWAdd(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildNUWAdd(ref, left.ref, right.ref, name))
    }
    
    public func buildFAdd(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildFAdd(ref, left.ref, right.ref, name))
    }
    
    public func buildSub(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildSub(ref, left.ref, right.ref, name))
    }
    
    public func buildNSWSub(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildNSWSub(ref, left.ref, right.ref, name))
    }
    
    public func buildNUWSub(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildNUWSub(ref, left.ref, right.ref, name))
    }
    
    public func buildFSub(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildFSub(ref, left.ref, right.ref, name))
    }
    
    public func buildMul(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildMul(ref, left.ref, right.ref, name))
    }
    
    public func buildNSWMul(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildNSWMul(ref, left.ref, right.ref, name))
    }
    
    public func buildNUWMul(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildNUWMul(ref, left.ref, right.ref, name))
    }
    
    public func buildFMul(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildFMul(ref, left.ref, right.ref, name))
    }
    
    public func buildUDiv(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildUDiv(ref, left.ref, right.ref, name))
    }
    
    public func buildSDiv(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildSDiv(ref, left.ref, right.ref, name))
    }
    
    public func buildExactSDiv(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildExactSDiv(ref, left.ref, right.ref, name))
    }
    
    public func buildFDiv(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildFDiv(ref, left.ref, right.ref, name))
    }
    
    public func buildURem(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildURem(ref, left.ref, right.ref, name))
    }
    
    public func buildSRem(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildSRem(ref, left.ref, right.ref, name))
    }
    
    public func buildFRem(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildFRem(ref, left.ref, right.ref, name))
    }
    
    public func buildShl(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildShl(ref, left.ref, right.ref, name))
    }
    
    public func buildLShr(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildLShr(ref, left.ref, right.ref, name))
    }
    
    public func buildAShr(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildAShr(ref, left.ref, right.ref, name))
    }
    
    public func buildAnd(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildAnd(ref, left.ref, right.ref, name))
    }
    
    public func buildOr(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildOr(ref, left.ref, right.ref, name))
    }
    
    public func buildXor(left left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildXor(ref, left.ref, right.ref, name))
    }
    
    public func buildBinOp(op: LLVMOpcode, left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildBinOp(ref, op, left.ref, right.ref, name))
    }
    
    public func buildNeg(value: Value, name: String) -> Value {
        return Value(ref: LLVMBuildNeg(ref, value.ref, name))
    }
    
    public func buildNSWNeg(value: Value, name: String) -> Value {
        return Value(ref: LLVMBuildNSWNeg(ref, value.ref, name))
    }
    
    public func buildNUWNeg(value: Value, name: String) -> Value {
        return Value(ref: LLVMBuildNUWNeg(ref, value.ref, name))
    }
    
    public func buildFNeg(value: Value, name: String) -> Value {
        return Value(ref: LLVMBuildFNeg(ref, value.ref, name))
    }
    
    public func buildNot(value: Value, name: String) -> Value {
        return Value(ref: LLVMBuildNot(ref, value.ref, name))
    }

    // MARK: Memory
    
    public func buildMalloc(type type: Type, name: String) -> Instruction {
        return Instruction(ref: LLVMBuildMalloc(ref, type.ref, name))
    }
    
    public func buildArrayMalloc(type type: Type, value: Value, name: String) -> Instruction {
        return Instruction(ref: LLVMBuildArrayMalloc(ref, type.ref, value.ref, name))
    }
    
    public func buildAlloca(type type: Type, name: String) -> AllocaInstruction {
        return AllocaInstruction(ref: LLVMBuildAlloca(ref, type.ref, name))
    }
    
    public func buildArrayAlloca(type type: Type, value: Value, name: String) -> AllocaInstruction {
        return AllocaInstruction(ref: LLVMBuildArrayAlloca(ref, type.ref, value.ref, name))
    }
    
    public func buildFree(pointer: Value) -> CallInstruction {
        return CallInstruction(ref: LLVMBuildFree(ref, pointer.ref))
    }
    
    public func buildLoad(pointer: Value, name: String) -> LoadInstruction {
        return LoadInstruction(ref: LLVMBuildLoad(ref, pointer.ref, name))
    }
    
    public func buildGEP(pointer: Value, indices: [Value], name: String) -> Value {
        var indexRefs = indices.map { $0.ref }
        return Value(ref: LLVMBuildGEP(ref, pointer.ref, &indexRefs, UInt32(indexRefs.count), name))
    }
    
    public func buildInBoundsGEP(pointer: Value, indices: [Value], name: String) -> Value {
        var indexRefs = indices.map { $0.ref }
        return Value(ref: LLVMBuildInBoundsGEP(ref, pointer.ref, &indexRefs, UInt32(indexRefs.count), name))
    }
    
    public func buildStructGEP(pointer: Value, index: UInt32, name: String) -> Value {
        return Value(ref: LLVMBuildStructGEP(ref, pointer.ref, index, name))
    }
    
    public func buildGlobalString(string: String, name: String) -> GlobalVariable {
        return GlobalVariable(ref: LLVMBuildGlobalString(ref, string, name))
    }
    
    public func buildGlobalStringPointer(string: String, name: String) -> Value {
        return Value(ref: LLVMBuildGlobalStringPtr(ref, string, name))
    }
    
    // TODO: volatile get/set
    
    public func buildTrunc(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildTrunc(ref, value.ref, type.ref, name))
    }
    
    public func buildZExt(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildZExt(ref, value.ref, type.ref, name))
    }
    
    public func buildSExt(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildSExt(ref, value.ref, type.ref, name))
    }
    
    public func buildFPToUI(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildFPToUI(ref, value.ref, type.ref, name))
    }
    
    public func buildFPToSI(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildFPToSI(ref, value.ref, type.ref, name))
    }

    public func buildUIToFP(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildUIToFP(ref, value.ref, type.ref, name))
    }
    
    public func buildSIToFP(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildSIToFP(ref, value.ref, type.ref, name))
    }
    
    public func buildFPTrunc(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildFPTrunc(ref, value.ref, type.ref, name))
    }
    
    public func buildFPExt(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildFPExt(ref, value.ref, type.ref, name))
    }
    
    public func buildIntToPointer(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildIntToPtr(ref, value.ref, type.ref, name))
    }
    
    public func buildBitCast(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildBitCast(ref, value.ref, type.ref, name))
    }
    
    public func buildAddressSpaceCast(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildAddrSpaceCast(ref, value.ref, type.ref, name))
    }
    
    public func buildZExtOrBitCast(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildZExtOrBitCast(ref, value.ref, type.ref, name))
    }
    
    public func buildSExtOrBitCast(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildSExtOrBitCast(ref, value.ref, type.ref, name))
    }
    
    public func buildTrucOrBitCast(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildTruncOrBitCast(ref, value.ref, type.ref, name))
    }
    
    public func buildCast(op: LLVMOpcode, value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildCast(ref, op, value.ref, type.ref, name))
    }
    
    public func buildPointerCast(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildPointerCast(ref, value.ref, type.ref, name))
    }
    
    public func buildIntCast(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildIntCast(ref, value.ref, type.ref, name))
    }
    
    public func buildFPCast(value: Value, destinationType type: Type, name: String) -> Value {
        return Value(ref: LLVMBuildFPCast(ref, value.ref, type.ref, name))
    }
    
    public func buildICmp(op: LLVMIntPredicate, left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildICmp(ref, op, left.ref, right.ref, name))
    }
    
    public func buildFCmp(op: LLVMRealPredicate, left: Value, right: Value, name: String) -> Value {
        return Value(ref: LLVMBuildFCmp(ref, op, left.ref, right.ref, name))
    }
    
    public func buildPhi(type: Type, name: String) -> PHINode {
        return PHINode(ref: LLVMBuildPhi(ref, type.ref, name))
    }
    
    public func buildCall(function: Function, args: [Value], name: String) -> CallInstruction {
        var argRefs = args.map { $0.ref }
        return CallInstruction(ref: LLVMBuildCall(ref, function.ref, &argRefs, UInt32(argRefs.count), name))
    }
    
    public func buildSelect(condition: Value, trueValue: Value, falseValue: Value, name: String) -> Value {
        return Value(ref: LLVMBuildSelect(ref, condition.ref, trueValue.ref, falseValue.ref, name))
    }
    
    public func buildVAArg(list: Value, type: Type, name: String) -> VAArgInstruction {
        return VAArgInstruction(ref: LLVMBuildVAArg(ref, list.ref, type.ref, name))
    }
    
    public func buildExtractElement(vec: Value, index: Value, name: String) -> Value {
        return Value(ref: LLVMBuildExtractElement(ref, vec.ref, index.ref, name))
    }
    
    public func buildInsertElement(vec: Value, value: Value, index: Value, name: String) -> Value {
        return Value(ref: LLVMBuildInsertElement(ref, value.ref, vec.ref, index.ref, name))
    }
    
    public func buildShuffleVector(vec1: Value, vec2: Value, mask: Value, name: String) -> Value {
        return Value(ref: LLVMBuildShuffleVector(ref, vec1.ref, vec2.ref, mask.ref, name))
    }
}