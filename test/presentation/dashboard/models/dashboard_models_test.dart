import 'package:banzeiro_tour/presentation/dashboard/models/dashboard_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exposes the labels used by tourist experience filters', () {
    expect(ExperienceCategory.boats.label, 'Barcos Fluviais');
    expect(ExperienceCategory.food.label, 'Culinária');
  });

  test('keeps progress within valid boundaries', () {
    expect(DashboardMath.progress(-1, 10), 0);
    expect(DashboardMath.progress(4, 0), 0);
    expect(DashboardMath.progress(24, 20), 1);
  });
}
