class LocationModel {
  // Add the unique identifier from the backend. Nullable because it won't exist before creation.
  String? id;
  String? streetAddress;
  String? areaName;
  String? city;
  String? postalCode;
  double? latitude;
  double? longitude;
  // This is a great field for status/soft-delete
  bool? isActive;

  LocationModel({
    this.id, // Include in the constructor
    this.streetAddress,
    this.areaName,
    this.city,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.isActive = true, // Default to active when creating a new instance
  });

  // Factory method to create an instance from a JSON map (e.g., from an API or database)
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as String?, // Map the 'id' field
      streetAddress: json['street_address'] as String?,
      areaName: json['area_name'] as String?,
      city: json['city'] as String?,
      postalCode: json['postal_code'] as String?,
      // Ensure we safely cast to double, handling potential int inputs
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isActive: json['is_active'] as bool?,
    );
  }

  // Method to convert the instance to a JSON map (e.g., for sending to an API or saving to a database)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = this.id; // Include ID only if it exists (for updates/deletes)
    }
    data['street_address'] = this.streetAddress;
    data['area_name'] = this.areaName;
    data['city'] = this.city;
    data['postal_code'] = this.postalCode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['is_active'] = this.isActive;
    return data;
  }

  // Utility method for easy printing and debugging
  @override
  String toString() {
    return 'LocationModel{id: $id, city: $city, streetAddress: $streetAddress, isActive: $isActive}';
  }
}