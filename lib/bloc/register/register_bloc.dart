// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  RegisterBloc()
      : _firebaseAuth = FirebaseAuth.instance,
        _firebaseFirestore = FirebaseFirestore.instance,
        super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading()); // Emit loading state

      // Check if passwords match
      if (event.password != event.confirmPassword) {
        emit(RegisterFailure(message: 'Passwords do not match.'));
        return;
      }

      try {
        // Firebase Authentication: Create User
        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        // Set role and other information in Firestore
        await _firebaseFirestore
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'email': userCredential.user!.email,
          'uid': userCredential.user!.uid,
          'name': event.name,
          'photoUrl': userCredential.user!.photoURL,
          'createdAt': Timestamp.now(),
          'lastLoginAt': Timestamp.now(),
          'role': event.role, // Store role
        });

        // Update user's display name after account creation
        await userCredential.user?.updateDisplayName(event.name);

        // Emit success state
        emit(RegisterSuccess());
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Register Failed: ${e.message}';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Email is already registered.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email address.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'Password is too weak.';
        }
        emit(RegisterFailure(message: errorMessage));
      } catch (e) {
        emit(RegisterFailure(message: 'Unexpected error: $e'));
      }
    });
  }
}
