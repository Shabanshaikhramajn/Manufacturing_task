enum MachineType {
  cncTurningCenter(1, 'CNC Turning Center'),
  vmc(2, 'VMC'),
  hmc(3, 'HMC'),
  hbm(4, 'HBM'),
  vtl(5, 'VTL'),
  fiveAxisMachiningCenter(6, '5-Axis Machining Center');

  final int code;
  final String label;
  const MachineType(this.code, this.label);

  static MachineType fromCode(int code) {
    return MachineType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => MachineType.cncTurningCenter,
    );
  }
}
