import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values
    _usernameController.text = 'Sayub Shakya';
    _emailController.text = 'sayub.shakya123@gmail.com';
    _phoneController.text = '9828807288';
    _locationController.text = 'Patan';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C0B4D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C0B4D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2C0B4D),
              Color(0xFF2C0B4D),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Profile Picture Section
              _buildProfilePictureSection(),
              const SizedBox(height: 28),

              // Form Fields
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: _buildFormSection(),
              ),
              const SizedBox(height: 28),

              // Update Button
              _buildUpdateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Profile Picture
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF2C0B4D), Color(0xFF2C0B4D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            // Change Picture Button
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4285F4),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  onPressed: _changeProfilePicture,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _changeProfilePicture,
          child: const Text(
            'Change Picture',
            style: TextStyle(
              color: Color(0xFFB3A4FF),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Username Section
        _buildSectionHeader('Username'),
        _buildTextField(
          controller: _usernameController,
          hintText: 'Enter your username',
        ),
        const SizedBox(height: 24),
        
        // Email Address Section
        _buildSectionHeader('Email Address'),
        _buildTextField(
          controller: _emailController,
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        
        // Phone Number Section
        _buildSectionHeader('Phone Number'),
        _buildTextField(
          controller: _phoneController,
          hintText: 'Enter your phone number',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 24),
        
        // Location Section
        _buildSectionHeader('Location'),
        _buildTextField(
          controller: _locationController,
          hintText: 'Enter your location',
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4285F4),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          'Update',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _changeProfilePicture() {
    // Implement profile picture change logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Profile Picture'),
        content: const Text('Choose an option to update your profile picture'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement camera functionality
            },
            child: const Text('Take Photo'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement gallery functionality
            },
            child: const Text('Choose from Gallery'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _updateProfile() {
    // Implement update profile logic
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final location = _locationController.text.trim();

    if (username.isEmpty || email.isEmpty || phone.isEmpty || location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Here you would typically send the data to your backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back or show success message
    Navigator.pop(context);
  }
}