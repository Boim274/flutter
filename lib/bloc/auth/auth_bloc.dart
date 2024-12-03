import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateInitial()) {
    // Initialize FirebaseAuth and Firestore
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    // Listen for login event
    on<AuthEventLogin>((event, emit) async {
      try {
        emit(AuthStateLoading()); // Show loading indicator

        // Perform Firebase Authentication sign-in
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        // Check if the user exists in Firestore
        DocumentSnapshot userDoc = await users.doc(userCredential.user!.uid).get();

        // If user doesn't exist, create a new user document
        if (!userDoc.exists) {
          await users.doc(userCredential.user!.uid).set({
            'email': userCredential.user!.email,
            'uid': userCredential.user!.uid,
            'name': userCredential.user!.displayName,
            'photoUrl': userCredential.user!.photoURL,
            'createAt': Timestamp.now(),
            'lastLoginAt': Timestamp.now(),
          });
        } else {
          // Update the last login timestamp if the user exists
          await users.doc(userCredential.user!.uid).set({
            'lastLoginAt': Timestamp.now(),
          }, SetOptions(merge: true));
        }

        emit(AuthStateLoaded()); // Successfully logged in
      } on FirebaseAuthException catch (e) {
        // Handle different Firebase Auth exceptions
        if (e.code == 'user-not-found') {
          emit(AuthStateError(message: 'No user found with that email.'));
        } else if (e.code == 'wrong-password') {
          emit(AuthStateError(message: 'Incorrect password.'));
        } else {
          emit(AuthStateError(message: 'Login failed: ${e.message}'));
        }
      } catch (e) {
        emit(AuthStateError(message: 'An unknown error occurred: $e'));
      }
    });
  }
}
