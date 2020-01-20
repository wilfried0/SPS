

import 'package:services/marketplace/lib/models/ServiceConfig.dart';

class Config {
  static ServiceConfig rule(int id) {
    if (id == 1)
      return new ServiceConfig(
          amountRequired: true, serviceRequired: true, canPayByOther: true);
    else if (id == 2)
      return new ServiceConfig(
          amountRequired: true, serviceRequired: true, billRequired: true);
    else if (id == 3 || id == 4)
      return new ServiceConfig(billRequired: true);
    else if (id >= 5 && id <= 9)
      return new ServiceConfig(amountRequired: true, phoneRequired: true);
    else
      return new ServiceConfig(amountRequired: true, canPayByOther: true);
  }
}
