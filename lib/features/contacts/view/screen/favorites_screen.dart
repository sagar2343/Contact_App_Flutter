import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/theme/app_pallete.dart';
import '../../../widgets/animated_screen_wrapper.dart';
import '../../controller/favorites_controller.dart';
import '../widgets/contact_card.dart';
import '../widgets/empty_state_widget.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FavoritesController(
      context: context,
      reloadData: () => setState(() {}),
    );
    _controller.init();
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
            'Favourites',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 22),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '${_controller.favorites.length}',
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

        body: _controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
              onRefresh: _controller.onRefresh,
              color: Pallete.primaryColor,
              child: _controller.favorites.isEmpty
                  ? _buildEmptyState()
                  : _buildFavoritesList(),
        ),
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: _controller.favorites.length,
      itemBuilder: (context, index) {
        final contact = _controller.favorites[index];
        return ContactCard(
          contact: contact,
          onTap: () => _controller.onContactTap(contact),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.22),
        const EmptyStateWidget(
          icon: Icons.star_border_rounded,
          title: 'No Favourites Yet',
          subtitle:
          'Open a contact and tap the star icon to add them here.',
        ),
      ],
    );
  }
}
