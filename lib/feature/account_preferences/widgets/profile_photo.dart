// import 'package:flutter/material.dart';
// import 'package:jdadzok/core/const/image_path.dart';
// import 'package:jdadzok/feature/personal_view/widgets/add_profile_picture_button.dart';

// class ProfilePhoto extends StatelessWidget {
//   const ProfilePhoto({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Container(
//               margin: EdgeInsets.only(top: 100), 
//               padding: EdgeInsets.all(3), 
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: Container(
//                 padding: EdgeInsets.all(5), 
//                 decoration: BoxDecoration(
//                   color: Colors.green,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Container(
//                   padding: EdgeInsets.all(3), 
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                   ),
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundImage: AssetImage(ImagePath.activeUserImage),
//                   ),
//                 ),
//               ),
//             ),

//             AddProfilePictureButton(
//               isAddStory: true,
//               boxDecoration: BoxDecoration(
//                 color: Color(0xff2D55FF),
//                 shape: BoxShape.circle,
//               ),
//               icons: Icons.add,
//               onImagePicked: (file){
                
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
