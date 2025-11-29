import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle, Uint8List;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:loginappv2/src/features/properties/screens/horizontal_property_list_widget.dart';
import 'package:loginappv2/src/features/properties/screens/property_list_screen.dart';
import 'package:loginappv2/src/features/properties/controllers/property_controller.dart';

class Mapspage extends StatefulWidget {
  const Mapspage({super.key});

  @override
  State<Mapspage> createState() => MapspageState();
}

class MapspageState extends State<Mapspage> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  final PropertyController propertyController = Get.put(PropertyController());
  String _mapStyle = '';
  BitmapDescriptor? _homeMarkerIcon;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.700769, 85.300140),
    zoom: 12.0,
  );

  // Sample locations data matching your image
  // Sample locations data matching your image
  final List<MapLocation> locations = [
    MapLocation(name: '1 BHK Room near Ringroad', area: 'Affordable & Clean', position: LatLng(27.7300, 85.3000)),
    MapLocation(name: '3 BHK Luxury Apartment, Maharajgunj', area: 'Spacious & Modern', position: LatLng(27.7200, 85.3300)),
    MapLocation(name: 'Ground Floor Studio in Kapan', area: 'Pet-Friendly Unit', position: LatLng(27.7100, 85.3500)),
    MapLocation(name: 'New 2 BHK House for Rent', area: 'Family Home', position: LatLng(27.6900, 85.3100)),
    MapLocation(name: 'Commercial Space near Bus Park', area: 'High Foot Traffic', position: LatLng(27.6800, 85.3200)),
    MapLocation(name: 'Short-Term Rental near Boudhanath', area: 'Tourist Stay', position: LatLng(27.7200, 85.3600)),
    MapLocation(name: 'Small Room for Bachelor', area: 'Budget Friendly', position: LatLng(27.7000, 85.3400)),
    MapLocation(name: 'Furnished Flat for Couple', area: 'Comfy Place', position: LatLng(27.7100, 85.3200)),
    MapLocation(name: 'Premium Penthouse, Kathmandu', area: 'Stunning Views', position: LatLng(27.700769, 85.300140)),
  ];

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    _createHomeMarkerIcon();
  }

  Future<void> _createHomeMarkerIcon() async {
    // Marker size increased to 120x120 for a bigger icon
    final Uint8List markerIcon = await _getBytesFromCanvas(120, 120);
    setState(() {
      _homeMarkerIcon = BitmapDescriptor.fromBytes(markerIcon);
    });
  }

  Future<Uint8List> _getBytesFromCanvas(int width, int height) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final double centerX = width / 2;
    final double centerY = height / 2;
    // Base radius for the circular part of the pin
    const double radius = 30;
    // Color matching the pin in your image
    final Color pinColor = const Color(0xFFEA4335);

    // --- Marker Pin Paint ---
    final Paint pinPaint = Paint()
      ..color = pinColor
      ..style = PaintingStyle.fill;

    // --- White House Icon Paint ---
    final Paint homePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // --- Draw Pin Shape (Circle + Triangle Tail) ---
    final Path pinPath = Path();

    // 1. Circle part
    pinPath.addOval(Rect.fromCircle(center: Offset(centerX, centerY - radius/2), radius: radius));

    // 2. Triangle/Tail part
    const double tailHeight = 35;
    pinPath.moveTo(centerX - radius/3, centerY + radius - radius/2); // Left base point
    pinPath.lineTo(centerX + radius/3, centerY + radius - radius/2); // Right base point
    pinPath.lineTo(centerX, centerY + tailHeight); // Tip of the pin
    pinPath.close();

    // Fill the pin shape
    canvas.drawPath(pinPath, pinPaint);

    // --- Draw White Home Icon inside the Pin ---

    // Center the house icon within the circular part of the pin
    const double houseSize = 24.0;
    const double roofHeight = houseSize / 2;

    // House Body (Rectangle)
    final Rect houseBody = Rect.fromCenter(
      center: Offset(centerX, centerY - radius/2 + 5),
      width: houseSize * 0.8,
      height: houseSize * 0.8,
    );
    canvas.drawRect(houseBody, homePaint);

    // House Roof (Triangle)
    final Path roofPath = Path()
      ..moveTo(centerX - houseSize * 0.8 / 2, centerY - radius/2 + 5 - houseSize * 0.8 / 2) // Left corner of body
      ..lineTo(centerX + houseSize * 0.8 / 2, centerY - radius/2 + 5 - houseSize * 0.8 / 2) // Right corner of body
      ..lineTo(centerX, centerY - radius/2 + 5 - houseSize * 0.8 / 2 - roofHeight * 0.6) // Peak
      ..close();

    canvas.drawPath(roofPath, homePaint);

    // Convert canvas to image
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ImageByteFormat.png);

    return data!.buffer.asUint8List();
  }

  Future<void> _loadMapStyles() async {
    try {
      final String style = await rootBundle.loadString('assets/map_style.json');
      setState(() {
        _mapStyle = style;
      });

      if (_controller.isCompleted) {
        final controller = await _controller.future;
        controller.setMapStyle(_mapStyle);
      }
    } catch (e) {
      print('Error loading map style: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                if (_mapStyle.isNotEmpty) {
                  controller.setMapStyle(_mapStyle);
                }
              },
              markers: _createMarkers(),
            ),

            // Top Search Bar
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Search Address',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey[300],
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.grey, size: 20),
                        onPressed: () {
                          _showLocationList(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Simple bottom sheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 220, // Fixed height
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag handle (visual only)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nearby Properties',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              // You could hide the sheet here if needed
                            },
                          ),
                        ],
                      ),
                    ),
                    // Horizontal Property List
                    Expanded(
                      child: HorizontalPropertyListWidget(
                        controller: propertyController,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Floating Action Button positioned above the sheet
            Positioned(
              right: 16,
              bottom: 240 + bottomPadding, // Position above the fixed sheet
              child: FloatingActionButton.extended(
                onPressed: () {
                  Get.to(() => PropertyListScreen());
                },
                label: const Text('List View'),
                icon: const Icon(Icons.list_alt_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return locations.map((location) {
      return Marker(
        markerId: MarkerId(location.name),
        position: location.position,
        icon: _homeMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: location.name,
          snippet: location.area,
        ),
        onTap: () {
          // Center map on tapped location
          _moveToLocation(location.position);
        },
      );
    }).toSet();
  }

  Future<void> _moveToLocation(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 14.0,
        ),
      ),
    );
  }

  void _showLocationList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              // Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Locations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Search in locations
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search locations...',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (value) {
                      // Implement search functionality
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Locations List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    final location = locations[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEA4335).withOpacity(0.1), // Changed to red
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.location_on, color: const Color(0xFFEA4335)), // Changed to red
                      ),
                      title: Text(
                        location.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        location.area,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _moveToLocation(location.position);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MapLocation {
  final String name;
  final String area;
  final LatLng position;

  MapLocation({
    required this.name,
    required this.area,
    required this.position,
  });
}