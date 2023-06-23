class OrderProductModel {
  String id = '';
  String number = '';
  String name = '';
  String invoiceNumber = '';
  String invoiceName = '';
  int price = 0;
  String unit = '';
  String image = '';
  int requestQuantity = 0;
  int deliveryQuantity = 0;

  OrderProductModel.fromMap(Map map) {
    id = map['id'] ?? '';
    number = map['number'] ?? '';
    name = map['name'] ?? '';
    invoiceNumber = map['invoiceNumber'] ?? '';
    invoiceName = map['invoiceName'] ?? '';
    price = map['price'] ?? 0;
    unit = map['unit'] ?? '';
    image = map['image'] ?? '';
    requestQuantity = map['requestQuantity'] ?? 0;
    deliveryQuantity = map['deliveryQuantity'] ?? 0;
  }

  Map toMap() => {
        'id': id,
        'number': number,
        'name': name,
        'invoiceNumber': invoiceNumber,
        'invoiceName': invoiceName,
        'price': price,
        'unit': unit,
        'image': image,
        'requestQuantity': requestQuantity,
        'deliveryQuantity': deliveryQuantity,
      };
}
