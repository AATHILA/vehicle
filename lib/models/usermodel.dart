class UserModel {
  String name;
  double mileage; // Dropdown options like "10 kmpl", "15 kmpl"
  int year;
  String imageData; // Stores selected image path

  UserModel({
    required this.name,
    required this.mileage,
    required this.year,
    required this.imageData,
  });

  // Convert to Map for storing in database or JSON
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mileage': mileage,
      'year': year,
      'imageData': imageData,
    };
  }

  // Create an object from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      mileage: map['mileage'],
      year: map['year'] ,
      imageData: map['imageData'],
    );
  }
}