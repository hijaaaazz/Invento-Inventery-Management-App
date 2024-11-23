// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesModelAdapter extends TypeAdapter<SalesModel> {
  @override
  final int typeId = 6;

  @override
  SalesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesModel(
      id: fields[0] as String,
      saleNumber: fields[1] as String,
      saleProducts: (fields[2] as List).cast<SaleProduct>(),
      userId: fields[3] as String,
      customerName: fields[4] as String,
      grandTotal: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SalesModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.saleNumber)
      ..writeByte(2)
      ..write(obj.saleProducts)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.customerName)
      ..writeByte(5)
      ..write(obj.grandTotal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SaleProductAdapter extends TypeAdapter<SaleProduct> {
  @override
  final int typeId = 7;

  @override
  SaleProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleProduct(
      product: fields[0] as ProductModel,
      quantity: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SaleProduct obj) {
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
      other is SaleProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
