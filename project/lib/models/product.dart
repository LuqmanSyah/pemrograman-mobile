class Product {
  const Product({
    required this.name,
    required this.price,
    required this.sku,
    required this.quantity,
  });

  final String name;
  final int price;
  final String sku;
  final int quantity;

  int get total => price * quantity;
}

const products = [
  Product(
    name: 'Kopi Susu Gula Aren',
    price: 15000,
    sku: 'A01',
    quantity: 2,
  ),
  Product(
    name: 'Nasi Goreng Spesial',
    price: 28000,
    sku: 'B02',
    quantity: 1,
  ),
  Product(
    name: 'Es Teh Lemon',
    price: 12000,
    sku: 'C03',
    quantity: 2,
  ),
];

String formatRupiah(int value) => 'Rp${value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match.group(1)}.',
    )}';
