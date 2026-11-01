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
    name: 'Indomie Goreng',
    price: 3500,
    sku: '899100',
    quantity: 2,
  ),
  Product(
    name: 'Aqua 600 ml',
    price: 4000,
    sku: '899200',
    quantity: 1,
  ),
  Product(
    name: 'Gula Pasir 1 kg',
    price: 17000,
    sku: '899300',
    quantity: 1,
  ),
];

String formatRupiah(int value) => 'Rp${value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match.group(1)}.',
    )}';
