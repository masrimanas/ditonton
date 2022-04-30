import 'package:http/http.dart' as http;
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class SslPinning {
  static http.Client get client => _instance;

  static http.Client get _instance => Secured.getClient(_fingerprints);

  static Future<void> init() async {
    await _instance;
  }
}

// class SslPinning {
//   static Future<http.Client> get _instance async =>
//       _clientInstance ??= await Secured.getClient(_fingerprints);

//   static http.Client? _clientInstance;
//   static http.Client get client => _clientInstance!;

//   static Future<void> init() async {
//     _clientInstance = await _instance;
//   }
// }

class Secured {
  static SecureHttpClient getClient(List<String> allowedSHAFingerprints) {
    final secureClient = SecureHttpClient.build(allowedSHAFingerprints);
    return secureClient;
  }
}

const _fingerprints = [
  '54:9E:69:39:A3:01:44:A6:1B:1B:F5:5D:A5:B0:CD:E7:F8:1B:39:4D:8B:7D:B1:97:C0:B7:50:1E:FC:15:A2:85'
];


// class SslPinning {
//   static Future<http.Client> get _instance async =>
//       _clientInstance ??= await Shared.createLEClient();

//   static http.Client? _clientInstance;
//   static http.Client get client => _clientInstance ?? http.Client();

//   static Future<void> init() async {
//     _clientInstance = await _instance;
//   }
// }

// class SslPinning {
//   static Future<http.Client> get _instance async =>
//       _clientInstance ??= await Secured.getSecured();

//   static http.Client? _clientInstance;
//   static http.Client get client => _clientInstance!;

//   static Future<void> init() async {
//     _clientInstance = await _instance;
//   }
// }

// class Secured {
//   static Future<SecurityContext> get globalContext async {
//     final sslCert = await rootBundle.load('assets/cert/certificate.pem');
//     SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
//     securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
//     return securityContext;
//   }

//   static Future<http.Client> getSecured() async {
//     HttpClient client = HttpClient(context: await globalContext);
//     client.badCertificateCallback =
//         (X509Certificate cert, String host, int port) => false;
//     IOClient ioClient = IOClient(client);
//     return ioClient;
//   }
// }

// class Shared {
//   static Future<HttpClient> createHttpClient({bool isTestMode = false}) async {
//     final securityContext = SecurityContext(withTrustedRoots: false);

//     try {
//       List<int> certFileBytes = [];

//       if (isTestMode) {
//         certFileBytes = utf8.encode(_certificatiInString);
//       } else {
//         try {
//           certFileBytes = (await rootBundle.load('assets/cert/certificate.pem'))
//               .buffer
//               .asInt8List();
//           log('Successfully access and load certificate.pem file!');
//         } catch (e) {
//           certFileBytes = utf8.encode(_certificatiInString);
//           log('Error access and load certificate.pem file.\n${e.toString()}');
//         }
//       }

//       securityContext.setTrustedCertificatesBytes(certFileBytes);
//     } on TlsException catch (e) {
//       if (e.osError?.message != null &&
//           e.osError!.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
//         log('createHttpClient() - cert already trusted! Skipping.');
//       } else {
//         log('createHttpClient().setTrustedCertificateBytes EXCEPTION: $e');
//         rethrow;
//       }
//     } catch (e) {
//       log('unexpected error $e');
//       rethrow;
//     }

//     final httpClient = HttpClient(context: securityContext);
//     httpClient.badCertificateCallback =
//         (X509Certificate cert, String host, int port) => false;

//     return httpClient;
//   }

//   static Future<http.Client> createLEClient({bool isTestMode = false}) async {
//     IOClient client =
//         IOClient(await Shared.createHttpClient(isTestMode: isTestMode));
//     return client;
//   }
// }

// const _certificatiInString = """-----BEGIN CERTIFICATE-----
// MIIF5zCCBM+gAwIBAgIQAdKnBRs48TrGZbcfFRKNgDANBgkqhkiG9w0BAQsFADBG
// MQswCQYDVQQGEwJVUzEPMA0GA1UEChMGQW1hem9uMRUwEwYDVQQLEwxTZXJ2ZXIg
// Q0EgMUIxDzANBgNVBAMTBkFtYXpvbjAeFw0yMTEwMjEwMDAwMDBaFw0yMjExMTgy
// MzU5NTlaMBsxGTAXBgNVBAMMECoudGhlbW92aWVkYi5vcmcwggEiMA0GCSqGSIb3
// DQEBAQUAA4IBDwAwggEKAoIBAQC8Ec+A4PYy8acf0O0ebSymr7jvuwlpv9AE4hHi
// 0/zpeHn+oRQcQ950dPPkiFTyxGQ1ZaaWpujOOMhXEj7Y9qX7Q6hYGv3Y2XQbErba
// WG0dYZOT5LVxd6Fedj/TcyICVDU2suK6vqndug1XUqTRsfMTY994gHWf6QL2+VL0
// wFIfUcbpxzRhYLOIEmPlIxPpdzDvrh3cX73U0VvDIycbmxUgI/DkdqFyE93QJafK
// bD2qa+szpXicUHAGf3u+wLdEuXHwZ1hAjsheOW5+IciMKYCybSM0pm5Ik90et75B
// ye8vY9sQukK6uGY5Bm9upYJhco3cTbYJTadKTZ+ukVMqRfz3AgMBAAGjggL6MIIC
// 9jAfBgNVHSMEGDAWgBRZpGYGUqB7lZI8o5QHJ5Z0W/k90DAdBgNVHQ4EFgQUbBJ2
// pTVTIhbl/i1hSGCoJQJTUaAwKwYDVR0RBCQwIoIQKi50aGVtb3ZpZWRiLm9yZ4IO
// dGhlbW92aWVkYi5vcmcwDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUF
// BwMBBggrBgEFBQcDAjA9BgNVHR8ENjA0MDKgMKAuhixodHRwOi8vY3JsLnNjYTFi
// LmFtYXpvbnRydXN0LmNvbS9zY2ExYi0xLmNybDATBgNVHSAEDDAKMAgGBmeBDAEC
// ATB1BggrBgEFBQcBAQRpMGcwLQYIKwYBBQUHMAGGIWh0dHA6Ly9vY3NwLnNjYTFi
// LmFtYXpvbnRydXN0LmNvbTA2BggrBgEFBQcwAoYqaHR0cDovL2NydC5zY2ExYi5h
// bWF6b250cnVzdC5jb20vc2NhMWIuY3J0MAwGA1UdEwEB/wQCMAAwggF9BgorBgEE
// AdZ5AgQCBIIBbQSCAWkBZwB1ACl5vvCeOTkh8FZzn2Old+W+V32cYAr4+U1dJlwl
// XceEAAABfKGE524AAAQDAEYwRAIgUuAFRBhoFIqgzBGJg12YDv26moS9xRx0UmYe
// VOi3YVECIGigEG/HSrh+Jhw+pj8GrPji5zLZev/NhFbgAI9Z+JigAHUAQcjKsd8i
// RkoQxqE6CUKHXk4xixsD6+tLx2jwkGKWBvYAAAF8oYTnXwAABAMARjBEAiBnWphw
// CrLg7u6jOnaxRRQ0A7ESan6hbsDiPg+tUmoo5QIgOKufQRsQDiw8COBmdDKjQxcJ
// Cwj0RnnE+JWKBKjD8tgAdwDfpV6raIJPH2yt7rhfTj5a6s2iEqRqXo47EsAgRFwq
// cwAAAXyhhOeyAAAEAwBIMEYCIQClg2eAirkVpLAsrz7a97zxraww48oc1AnCx/07
// 4YD0jAIhANtSG6mNHQ3Qk85GEfyl4dI1sAJ8gjOAI4kG+ZbR5iFYMA0GCSqGSIb3
// DQEBCwUAA4IBAQA+0VPryDt08DgXGPiQc/LVh2aqx0Si0wylNF7zgVtBh2nzdPV7
// 18Qex5uK+Z4VjnBFzLQ7wUkLh8MNi2uJmxyX0tdhATJ2sdGieHuGdcJnjZYHMXqP
// AAHoVgjJSWWhy+t66cPauipX2dR0b4Ul0cz42aRlmpExJwRqm7jCtpaJU3nuxOwN
// jia+Kff2MpLspB3nHmHOZ2gvwU05oiZQvnranwshboDhCDV3ucFX4IKPr74+1P8l
// DUpiVEdsyxDA9Sbkc2QS57dWiD0Ju55Sxhhd1uSHi4aqKaFpAA4XZr4edUwWFE4c
// 4JJi1ufB/lOcf+G5uV2HrO27/FScF/8dZyzy
// -----END CERTIFICATE-----""";
