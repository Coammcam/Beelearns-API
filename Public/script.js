function showTable(functionName) {
    const content = document.getElementById('content');
    const tabs = document.querySelectorAll('.sidebar .nav-link');
    tabs.forEach(tab => tab.classList.remove('active'));
    document.getElementById(`tab-${functionName}`).classList.add('active');

  function editRow(id) {
    const editor = document.getElementById('editor');
    editor.value = `Bạn đang chỉnh sửa dòng có ID: ${id}`;
  }

  function saveChanges() {
    alert("Nội dung đã được lưu!");
  }

}