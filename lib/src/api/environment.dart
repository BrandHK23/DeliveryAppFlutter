import 'package:iris_delivery_app_stable/src/models/mercado_pago_credentials.dart';

class Environment {
  static const String API_DELIVERY = "192.168.0.20:3000";
  static const String API_KEY_MAPS = "AIzaSyCfAwKKKEK6zWWde6ShxRtCX__Kt0Q8xPU";

  static MercadoPagoCredentials mercadoPagoCredentials = MercadoPagoCredentials(
      publicKey: 'TEST-156698ac-702f-4fd8-a019-da1cf53d0fa0',
      accessToken:
          'TEST-8913120874816489-122022-85a7f701d3a7eb5d8482b064952a053d-517315294');
}
