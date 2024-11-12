// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 3;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      productId: fields[10] as String,
      name: fields[0] as String,
      category: fields[1] as String,
      description: fields[2] as String,
      unit: fields[3] as String,
      rate: fields[4] as double,
      price: fields[5] as double,
      minlimit: fields[6] as double,
      maxlimit: fields[7] as double,
      stock: fields[8] as double,
      userId: fields[9] as String,
      productImage: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.rate)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.minlimit)
      ..writeByte(7)
      ..write(obj.maxlimit)
      ..writeByte(8)
      ..write(obj.stock)
      ..writeByte(9)
      ..write(obj.userId)
      ..writeByte(10)
      ..write(obj.productId)
      ..writeByte(11)
      ..write(obj.productImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
