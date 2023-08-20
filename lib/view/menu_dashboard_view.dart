import 'package:flutter/material.dart';

class MenuDashboardView extends StatefulWidget {
  const MenuDashboardView({super.key});

  @override
  State<MenuDashboardView> createState() => _MenuDashboardViewState();
}

class _MenuDashboardViewState extends State<MenuDashboardView> with TickerProviderStateMixin {
  final TextStyle menuFontStyle = const TextStyle(color: Colors.white, fontSize: 20);
  final Color backgroundColor = const Color(0xFF343442);

  late double screenHeight;
  late double screenWidth;

  bool isMenuOpen = false;

  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _scaleMenuAnimation;
  late final Animation<Offset> _menuOffsetAnimation;
  final Duration _animationDuration = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_animationController);
    _scaleMenuAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _menuOffsetAnimation = Tween(begin: const Offset(-1, 0), end: const Offset(0, 0))
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            _createMenu(context),
            _createDashboard(context),
          ],
        ),
      ),
    );
  }

  Widget _createMenu(BuildContext context) {
    return SlideTransition(
      position: _menuOffsetAnimation,
      child: ScaleTransition(
        scale: _scaleMenuAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dashboard', style: menuFontStyle),
                const SizedBox(height: 10),
                Text('Messages', style: menuFontStyle),
                const SizedBox(height: 10),
                Text('Utility Bills', style: menuFontStyle),
                const SizedBox(height: 10),
                Text('Fund Transfer', style: menuFontStyle),
                const SizedBox(height: 10),
                Text('Branches', style: menuFontStyle),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createDashboard(BuildContext context) {
    return AnimatedPositioned(
      top: 0,
      bottom: 0,
      left: isMenuOpen ? 0.40 * screenWidth : 0,
      right: isMenuOpen ? -0.40 * screenWidth : 0,
      duration: _animationDuration,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(isMenuOpen ? 40 : 0)),
          elevation: 8,
          color: backgroundColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: const Icon(Icons.menu_outlined, color: Colors.white),
                      onTap: () {
                        setState(() {
                          isMenuOpen ? _animationController.reverse() : _animationController.forward();
                          isMenuOpen = !isMenuOpen;
                        });
                      },
                    ),
                    const Text('My cards', style: TextStyle(color: Colors.white, fontSize: 24)),
                    const Icon(Icons.add_circle_outlined, color: Colors.white),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 200,
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(color: Colors.pink, width: 100, margin: const EdgeInsets.symmetric(horizontal: 12)),
                    Container(color: Colors.purple, width: 100, margin: const EdgeInsets.symmetric(horizontal: 12)),
                    Container(color: Colors.teal, width: 100, margin: const EdgeInsets.symmetric(horizontal: 12)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.person_outlined, color: Colors.white),
                      title: Text('Student $index', style: const TextStyle(color: Colors.white)),
                      trailing: const Icon(Icons.add_outlined, color: Colors.white),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(color: Colors.white);
                  },
                  itemCount: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
