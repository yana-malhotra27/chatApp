import 'package:flutter/material.dart';

class NewContactPage extends StatelessWidget {
  const NewContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            // Top row: back button + title (no AppBar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "New contact",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Image Picker section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: 360,
                height: 160,
                decoration: BoxDecoration(
                  color: colorScheme.inversePrimary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: colorScheme.primary.withOpacity(0.15),
                    child: Icon(
                      Icons.image,
                      color: colorScheme.onSurface,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Input fields
            _buildInputRow(
              icon: Icons.person_outlined,
              hint: "First name",
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 16),
            _buildInputRow(
              hint: "Last name",
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 16),
            _buildInputRow(
              icon: Icons.phone_outlined,
              hint: "Phone",
              colorScheme: colorScheme,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildInputRow(
              icon: Icons.place_outlined,
              hint: "Address",
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 16),
            _buildInputRow(
              hint: "City",
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow({
    IconData? icon,
    required String hint,
    required ColorScheme colorScheme,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 60,
              child: TextField(
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: colorScheme.inversePrimary),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide(color: colorScheme.tertiary)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(color: colorScheme.tertiary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(color: colorScheme.tertiary),
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
