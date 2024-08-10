// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:test/core/utility/config.dart';
// import 'package:test/core/utility/constants.dart';

// class NewsDetailsScreen extends StatelessWidget {
//   const NewsDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: appColorWhite,
//         leading: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: const Icon(Icons.arrow_back),
//         ),
//       ),
//       body: SafeArea(
//           child: SizedBox(
//         height: deviceHeight(context),
//         width: deviceWidth(context),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 Text(
//                   "How to protect your environment",
//                   style: fontStyle.copyWith(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 8.h,
//                 ),
//                 Image.asset('assets/images/nature.png'),
//                 Text(
//                   "Lorem ipsum dolor sit amet sit amet \nconsectetur sit. Diam ultrigshcies \n viverra",
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                   ),
//                 ),
//                 const Row(
//                   children: [
//                     TextContainer(
//                       text: 'Environment',
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     TextContainer(
//                       text: 'Trees',
//                     ),
//                   ],
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.only(top: 25, left: 28),
//                   child: Text(
//                     "Lorem ipsum dolor sit amet consectetur. Metus nibh ornare sollicitudin tincidunt velit vulputate amet. Viverra arcu mauris id nunc vel id bibendum viverra. Nisi ut proin sit elit. Tellus nulla volutpat faucibus faucibus egestas. Amet morbi mauris nulla volutpat amet aliquam odio. In mi interdum amet senectus viverra urna fermentum phasellus. Nulla mi in sed amet amet ut tellus bibendum suscipit. Quisque volutpat purus in quam tortor sollicitudin venenatis dui.In mi interdum amet senectus viverra urna fermentum phasellus. Nulla mi in sed amet amet ut tellus bibendum suscipit. Quisque volutpat purus in quam tortor sollicitudin venenatis dui. Nulla mi in sed amet amet ut tellus bibendum suscipit. Quisque volutpat purus in quam tortor sollicitudin venenatis dui. In mi interdum amet senectus viverra urna fermentum phasellus. Nulla mi in sed amet amet ut tellus bibendum suscipit. Quisque volutpat purus in quam tortor sollicitudin venenatis dui.",
//                     style: TextStyle(fontSize: 15),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       )),
//     );
//   }
// }

// class TextContainer extends StatelessWidget {
//   const TextContainer({
//     super.key,
//     required this.text,
//   });

//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: deviceHeight(context) * 0.05,
//       child: ElevatedButton(
//         onPressed: () {},
//         style: ElevatedButton.styleFrom(
//           backgroundColor: appColorBlack.withOpacity(0.9),
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(30)),
//           ),
//         ),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Text(
//               text,
//               style: const TextStyle(color: appColorWhite, fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
