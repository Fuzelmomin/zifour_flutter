abstract class ModuleOrderEvent {
  const ModuleOrderEvent();
}

class SubmitModuleOrder extends ModuleOrderEvent {
  final String stuId;
  final String mdlId;
  final String name;
  final String mobile;
  final String pincode;
  final String address;

  const SubmitModuleOrder({
    required this.stuId,
    required this.mdlId,
    required this.name,
    required this.mobile,
    required this.pincode,
    required this.address,
  });
}
