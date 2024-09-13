class Offer {
  final String uid;
  String name;
  final String category;
  final String produce;
  final String avatar;
  final String rating;
  final String location;
  final String title;
  final String description;
  final int capacity;
  final int price;

  Offer(
      {required this.uid,
      required this.name,
      required this.category,
      required this.produce,
      required this.avatar,
      required this.rating,
      required this.location,
      required this.title,
      required this.description,
      required this.capacity,
      required this.price});

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
        uid: json['uid'],
        name: json['name'],
        category: json['category'],
        produce: json['produce'],
        avatar: json['avatar'],
        rating: json['rating'],
        location: json['location'],
        title: json['title'],
        description: json['description'],
        capacity: json['capacity'],
        price: json['price']);
  }
}
