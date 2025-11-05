// import 'package:flutter/material.dart';

// class _WallpaperSidebarWrapper extends StatefulWidget {
//   const _WallpaperSidebarWrapper({super.key});

//   @override
//   State<_WallpaperSidebarWrapper> createState() => _WallpaperSidebarWrapperState();
// }

// class _WallpaperSidebarWrapperState extends State<_WallpaperSidebarWrapper>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _slide;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _slide = Tween(begin: const Offset(1, 0), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // 🔹 Blur Layer
//         Positioned.fill(
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//             child: const SizedBox(),
//           ),
//         ),

//         // 🔹 Sidebar
//         Align(
//           alignment: Alignment.centerRight,
//           child: SlideTransition(
//             position: _slide,
//             child: Container(
//               width: 656,
//               height: double.infinity,
//               color: Colors.white,
//               padding: const EdgeInsets.all(32),
//               child: const WallpaperSetupPanel(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
