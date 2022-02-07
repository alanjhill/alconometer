import 'package:alconometer/providers/top_level_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService?>(
  (ref) {
    final auth = ref.watch(authStateChangesProvider);
    final firebaseAuth = ref.watch(firebaseAuthProvider);

    final user = auth.asData!.value;
    if (user?.uid != null) {
      String userId = user!.uid;
      String? idToken =
          'eyJhbGciOiJSUzI1NiIsImtpZCI6IjJlMzZhMWNiZDBiMjE2NjYxOTViZGIxZGZhMDFiNGNkYjAwNzg3OWQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vYWxjb25vbWV0ZXIiLCJhdWQiOiJhbGNvbm9tZXRlciIsImF1dGhfdGltZSI6MTYzNzQzNjM0MiwidXNlcl9pZCI6IkR3QUx3Zm1VaVhZVTJ5NmFCbEFwN0hoR2NnVzIiLCJzdWIiOiJEd0FMd2ZtVWlYWVUyeTZhQmxBcDdIaEdjZ1cyIiwiaWF0IjoxNjM3NDM2MzQyLCJleHAiOjE2Mzc0Mzk5NDIsImVtYWlsIjoiYWxhbmpoaWxsQGhvdG1haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImFsYW5qaGlsbEBob3RtYWlsLmNvbSJdfSwic2lnbl9pbl9wcm92aWRlciI6InBhc3N3b3JkIn19.PB5Jod3_6MzMUbBpRL04cs33X6gmvbTPI83AcE3ADQHeBvzuRJaPV9_yx70AxmLtfr3EASJCRkyv3pTsEiCssFCT8CMn7FQeapmZ2_8G4hzD2vqjTsBaFpUesEw62k1vnVfh6fkQycD7aPIL_m80CBU1-qymG-F3eq3IWzVpKjd2Y2TVoo-g1KVcd5sMs9dvD2unMyTv3tNAuVQDOKllg6OsECP_Wwh0BPQct-aLF8yPQGDQ4JW8TmVLs4E6e47Y1pTmlexUCODJmxCH443iMYOcINv6hvS5Xe-rNHyUjQWyw2n8SGnnP_8BLiF6VHRHbi855MNwe1Ak4mLFC2jlzQ';
      firebaseAuth.currentUser!.getIdToken().then((value) {
        //idToken = value;
      });
      debugPrint('idToken: $idToken');
      return ApiService(userId, idToken);
    }
    throw UnimplementedError();
  },
);

class ApiService {
  final String _userId;
  final String _idToken;

  ApiService(this._userId, this._idToken);

  String get userId => _userId;

  String get idToken => _idToken;
}
