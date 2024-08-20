import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(LoginError('Email and Password cannot be empty.'));
      return;
    }

    emit(LoginLoading());

    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        // If no user is logged in, create a new user
        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        user = userCredential.user;
        emit(LoginSuccess(userCredential.user!.uid));
      } else {
        // Sign in the user
        UserCredential userCredential =
            await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        emit(LoginSuccess(userCredential.user!.uid));
      }

      ///         emit(LoginSuccess(userCredential.user!.uid));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Create a new user if not exists
        try {
          UserCredential userCredential =
              await _firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          emit(LoginSuccess(userCredential.user!.uid));
        } catch (e) {
          emit(LoginError('Failed to create user'));
        }
      } else {
        emit(LoginError('Login failed: ${e.message}'));
      }
    } catch (e) {
      emit(LoginError('An unexpected error occurred'));
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    emit(LoginInitial());
  }
}
