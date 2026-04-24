import 'package:flutter_test/flutter_test.dart';
import 'package:ricky_morty_list_char/main.dart';
import 'package:ricky_morty_list_char/modules/home/presenter/home/home_page.dart';
import 'package:ricky_morty_list_char/core/di/injection.dart';
import 'package:ricky_morty_list_char/modules/home/presenter/home/home_controller.dart';

import 'mocks.mocks.dart';

void main() {
  late MockLoadEpisodeUsecase mockLoadEpisodeUsecase;
  late MockLoadCharactersUsecase mockLoadCharactersUsecase;

  setUp(() async {
    await getIt.reset();
    mockLoadEpisodeUsecase = MockLoadEpisodeUsecase();
    mockLoadCharactersUsecase = MockLoadCharactersUsecase();

    getIt.registerFactory<HomeController>(
      () => HomeController(mockLoadEpisodeUsecase, mockLoadCharactersUsecase),
    );
  });

  testWidgets('Navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that we are on the HomePage
    expect(find.byType(HomePage), findsOneWidget);
    // The text in HomePage is 'Personagens de Rick and Morty' based on previous read
    expect(find.text('Personagens de Rick and Morty'), findsOneWidget);
  });
}
