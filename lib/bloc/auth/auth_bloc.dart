import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    // Handling the Signup event
    on<AuthSignUpEvent>((event, emit) async {
      emit(AuthLoadingState()); // Tampilkan loading saat signup

      try {
        await _firebaseAuth.createUserWithEmailAndPassword(
            email: event.email, password: event.password);
        emit(AuthSuccessState(successMessage: 'Akun berhasil dibuat!'));
      } on FirebaseAuthException catch (e) {
        emit(AuthErrorState(errorMessage: _handleError(e)));
      } catch (e) {
        emit(AuthErrorState(errorMessage: 'Terjadi kesalahan, coba lagi.'));
      }
    });

    // Handling the SignIn event
    on<AuthSignInEvent>((event, emit) async {
      emit(AuthLoadingState()); // Tampilkan loading saat login

      try {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: event.email, password: event.password);

        if (userCredential.user != null) {
          emit(AuthSignedInState()); // Login berhasil, emit success state
        } else {
          emit(AuthErrorState(errorMessage: 'Pengguna tidak ditemukan.'));
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthErrorState(errorMessage: _handleError(e))); // Tangani error
      } catch (e) {
        emit(AuthErrorState(errorMessage: 'Terjadi kesalahan, coba lagi.'));
      }
    });

    // Handling the SignOut event
    on<AuthSignOutEvent>((event, emit) async {
      emit(AuthLoadingState()); // Tampilkan loading saat logout

      try {
        await _firebaseAuth.signOut();
        emit(AuthSignedOutState()); // Emit signed out state setelah logout
      } catch (e) {
        emit(AuthErrorState(errorMessage: 'Gagal keluar. Coba lagi.'));
      }
    });
  }

  // Function to handle Firebase errors with Indonesian messages
  String _handleError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password terlalu lemah. Pilih password yang lebih kuat.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Gunakan email lain.';
      case 'invalid-email':
        return 'Alamat email tidak valid. Periksa kembali email yang Anda masukkan.';
      case 'user-not-found':
        return 'Pengguna tidak ditemukan dengan email ini.';
      case 'wrong-password':
        return 'Password salah. Coba lagi.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan masuk. Coba lagi setelah beberapa saat.';
      case 'network-request-failed':
        return 'Koneksi jaringan gagal. Periksa koneksi internet Anda.';
      default:
        return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }
}
