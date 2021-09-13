import 'package:cass_branch/api/car_api.dart';
import 'package:cass_branch/model/customer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCustomer extends Mock implements Customer {}

void main() {
  test('Get cars from API', () async {
    // ARRANGE
    final mockCustomer = MockCustomer();
    when(mockCustomer.id).thenAnswer((realInvocation) => 1);

    // ACT
    final response = await CarAPI.fetchByCustomer(mockCustomer);
    final cars = response.data;

    // ASSERT
    expect(cars.length, 2);
  });

  test('Get car brands from API', () async {
    // ACT
    final response = await CarAPI.fetchBrands();
    final carbrands = response.data;

    // ASSERT
    expect(carbrands.length, 50);
  });

  test('Get car models from API', () async {
    // ACT
    final response = await CarAPI.fetchModels();
    final carmodels = response.data;

    // ASSERT
    expect(carmodels.length, 370);
  });
}
