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
      productId: fields[9] as String,
      name: fields[0] as String,
      category: fields[1] as String,
      description: fields[2] as String,
      unit: fields[3] as String,
      price: fields[4] as double,
      minlimit: fields[5] as double,
      maxlimit: fields[6] as double,
      rate: fields[11] as double,
      stock: fields[7] as double,
      productImage: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.minlimit)
      ..writeByte(6)
      ..write(obj.maxlimit)
      ..writeByte(7)
      ..write(obj.stock)
      ..writeByte(9)
      ..write(obj.productId)
      ..writeByte(10)
      ..write(obj.productImage)
      ..writeByte(11)
      ..write(obj.rate);
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
