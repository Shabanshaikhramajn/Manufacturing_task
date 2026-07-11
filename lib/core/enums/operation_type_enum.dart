enum OperationType {
  turning(1, 'Turning'),
  milling(2, 'Milling'),
  drilling(3, 'Drilling'),
  chamfering(4, 'Chamfering'),
  tapping(5, 'Tapping'),
  threading(6, 'Threading'),
  boring(7, 'Boring'),
  knurling(8, 'Knurling'),
  honing(9, 'Honing'),
  buffing(10, 'Buffing');

  final int code;
  final String label;
  const OperationType(this.code, this.label);

  static OperationType fromCode(int code) {
    return OperationType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => OperationType.turning,
    );
  }
}
