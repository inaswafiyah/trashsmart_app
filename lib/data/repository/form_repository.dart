class FormRepository {
  Future<List<dynamic>> getFormList() async {
    // Contoh: ambil data dari API atau database
    return [];
  }

  Future<String> submitForm(Map<String, dynamic> data) async {
    // Contoh: kirim data ke API
    return 'Form submitted successfully';
  }

  Future<String> updateFormStatus(int id, String status, String? pickupConfirmedAt) async {
    // Contoh: update status di API
    return 'Status updated';
  }

  Future<String> deleteForm(int id) async {
    // Contoh: delete form di API
    return 'Form deleted';
  }
}
