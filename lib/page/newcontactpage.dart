import 'package:flutter/material.dart';

class NewContactPage extends StatelessWidget {
  const NewContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "New contact",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Image Picker (placeholder box)
          Padding(
            padding: const EdgeInsets.only(left: 56),
            child: Container(
              width: 360,
              height: 160,
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text("Image Picker"),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // First Name
          _buildInputRow(
            icon: Icons.person,
            hint: "First name",
            colorScheme: colorScheme,
          ),

          const SizedBox(height: 16),

          // Last Name
          _buildInputRow(
            icon: Icons.person_outline,
            hint: "Last name",
            colorScheme: colorScheme,
          ),

          const SizedBox(height: 16),

          // Phone
          _buildInputRow(
            icon: Icons.phone,
            hint: "Phone",
            colorScheme: colorScheme,
          ),

          const SizedBox(height: 16),

          // Address
          _buildInputRow(
            icon: Icons.map,
            hint: "Address",
            colorScheme: colorScheme,
          ),

          const SizedBox(height: 16),

          // City
          _buildInputRow(
            icon: Icons.location_city,
            hint: "City",
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow({
    required IconData icon,
    required String hint,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 56,
              child: TextField(
                decoration: InputDecoration(
                  hintText: hint,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
