// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchaseModelAdapter extends TypeAdapter<PurchaseModel> {
  @override
  final int typeId = 4;

  @override
  PurchaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchaseModel(
      id: fields[0] as String,
      purchaseNumber: fields[1] as String,
      purchaseProducts: (fields[2] as List).cast<PurchaseProduct>(),
      userId: fields[3] as String,
      GrandTotal: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PurchaseModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.purchaseNumber)
      ..writeByte(2)
      ..write(obj.purchaseProducts)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.GrandTotal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PurchaseProductAdapter extends TypeAdapter<PurchaseProduct> {
  @override
  final int typeId = 5;

  @override
  PurchaseProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchaseProduct(
      product: fields[0] as ProductModel,
      quantity: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PurchaseProduct obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.product)
      ..writeByte(1)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
