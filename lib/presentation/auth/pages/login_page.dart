// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:trashsmart/core/core.dart';
// import 'package:trashsmart/data/datasource/auth_local_datasource.dart';
// import 'package:trashsmart/presentation/auth/bloc/login/login_bloc.dart';
// import 'package:trashsmart/widget/bottom.dart';

// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final emailController = TextEditingController();
//     final passwordController = TextEditingController();

//     return Scaffold(
//       body: Stack(
//         children: [
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: SingleChildScrollView(
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20.0),
//                 ),
//                 child: ColoredBox(
//                   color: Colors.white,
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 28.0,
//                       vertical: 44.0,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomTextField(
//                           controller: emailController,
//                           label: 'Email Address',
//                           isOutlineBorder: false,
//                         ),
//                         const SpaceHeight(30.0),
//                         CustomTextField(
//                           controller: passwordController,
//                           obscureText: true,
//                           label: 'Password',
//                         ),
//                         const SpaceHeight(120.0),
//                         BlocListener<LoginBloc, LoginState>(
//                           listener: (context, state) {
//                             state.maybeWhen(
//                               orElse: () {},
//                               success: (data) async {
//                                 await AuthLocalDatasource().saveAuthData(data);
//                                 context.pushReplacement(const Bottom());
//                               },
//                               error: (error) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(error),
//                                     backgroundColor: Colors.red,
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                           child: BlocBuilder<LoginBloc, LoginState>(
//                             builder: (context, state) {
//                               return state.maybeWhen(
//                                 orElse: () {
//                                   return Button.filled(
//                                     onPressed: () {
//                                       context.read<LoginBloc>().add(
//                                         LoginEvent.login(
//                                           email: emailController.text,
//                                           password: passwordController.text,
//                                         ),
//                                       );
//                                       context.pushReplacement(const Bottom());
//                                     },
//                                     label: 'login',
//                                   );
//                                 },
//                                 loading: () {
//                                   return const Center(
//                                     child: CircularProgressIndicator(),
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
