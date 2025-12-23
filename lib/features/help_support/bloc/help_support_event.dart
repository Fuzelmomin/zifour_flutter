part of 'help_support_bloc.dart';

abstract class HelpSupportEvent {
  const HelpSupportEvent();
}

class HelpSupportRequested extends HelpSupportEvent {
  const HelpSupportRequested();
}
