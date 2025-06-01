class FormRepository {
  Future<List<dynamic>> getFormList() async {
    return [];
  }

  Future<String> submitForm(Map<String, dynamic> data) async {
    return 'Form submitted successfully';
  }

  Future<String> updateFormStatus(
    int id,
    String status,
    String? pickupConfirmedAt,
  ) async {
    return 'Status updated';
  }

  Future<String> deleteForm(int id) async {
    return 'Form deleted';
  }
}
