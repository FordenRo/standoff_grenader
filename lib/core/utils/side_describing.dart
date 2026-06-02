import '../models/grenade_origin.dart';

extension SideDescribing on Side {
  String describe() => switch (this) {
    .ct => 'CT',
    .t => 'T',
    .both => 'T/CT',
  };
}
