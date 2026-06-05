import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/theme/app_pallete.dart';
import '../../../widgets/animated_screen_wrapper.dart';
import '../../controller/contacts_controller.dart';
import '../widgets/contact_card.dart';
import '../widgets/empty_state_widget.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late final ContactsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ContactsController(
      context: context,
      reloadData: () => setState(() {}),
    );
    _controller.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedScreenWrapper(
      child: Scaffold(
        backgroundColor:
        isDark ? Pallete.backgroundDark : Pallete.backgroundLight,
        appBar: AppBar(
          title: Text(
            'Contacts',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 22),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '${_controller.contacts.length}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isDark
                      ? Pallete.textSecondaryDark
                      : Pallete.textSecondaryLight,
                ),
              ),
            ),
          ],
        ),

        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              // Search Bar
              _SearchBar(controller: _controller, isDark: isDark),

              // List
              Expanded(
                child: _controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                      onRefresh: _controller.onRefresh,
                      color: Pallete.primaryColor,
                      child: _controller.contacts.isEmpty
                          ? _buildEmptyState(isDark)
                          : _buildContactList(),
                ),
              ),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: _controller.onAddContact,
          tooltip: 'Add Contact',
          child: const Icon(Icons.person_add_alt_1_rounded),
        ),
      ),
    );
  }

  Widget _buildContactList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: _controller.contacts.length,
      itemBuilder: (context, index) {
        final contact = _controller.contacts[index];
        return ContactCard(
          contact: contact,
          onTap: () => _controller.onContactTap(contact),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    final isSearching =
        _controller.searchController.text.trim().isNotEmpty;

    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        EmptyStateWidget(
          icon: isSearching
              ? Icons.search_off_rounded
              : Icons.person_outline_rounded,
          title: isSearching ? 'No Results Found' : 'No Contacts Yet',
          subtitle: isSearching
              ? 'Try a different name.'
              : 'Tap the + button below to add your first contact.',
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ContactsController controller;
  final bool isDark;

  const _SearchBar({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: TextField(
        controller: controller.searchController,
        style: GoogleFonts.inter(
          fontSize: 15,
          color: isDark ? Pallete.textPrimaryDark : Pallete.textPrimaryLight,
        ),
        decoration: InputDecoration(
          hintText: 'Search contacts...',
          hintStyle: GoogleFonts.inter(
            fontSize: 15,
            color: isDark
                ? Pallete.textSecondaryDark
                : Pallete.textSecondaryLight,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark
                ? Pallete.textSecondaryDark
                : Pallete.textSecondaryLight,
          ),
          suffixIcon: controller.searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: isDark
                  ? Pallete.textSecondaryDark
                  : Pallete.textSecondaryLight,
            ),
            onPressed: controller.clearSearch,
          )
              : null,
          filled: true,
          fillColor: isDark ? Pallete.surfaceDark : Pallete.surfaceLight,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark ? Pallete.borderDark : Pallete.borderLight,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark ? Pallete.borderDark : Pallete.borderLight,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Pallete.primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}