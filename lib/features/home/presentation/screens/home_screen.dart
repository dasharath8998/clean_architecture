import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../bloc/home_bloc.dart';
import 'home_tab_screen.dart';
import 'search_tab_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Widget> _pages = [
    HomeTabScreen(),
    SearchTabScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.selectedIndex,
            children: _pages,
          ),
          bottomNavigationBar: _buildBottomNavBar(context, state),
        );
      },
    );
  }

  Widget _buildBottomNavBar(BuildContext context, HomeState state) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: state.selectedIndex,
        onDestinationSelected: (index) {
          context.read<HomeBloc>().add(HomeTabChanged(index));
        },
        backgroundColor: AppColors.surface,
        elevation: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: AppStrings.homeTab,
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: AppStrings.searchTab,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: AppStrings.profileTab,
          ),
        ],
      ),
    );
  }
}