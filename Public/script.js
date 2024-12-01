const apiBaseUrl = "http://127.0.0.1:8080";

async function deleteItem(id) {
  console.log("Deleting item with ID:", id);

  if (confirm("Are you sure you want to delete this item?")) {
    try {
      const response = await fetch(`${apiBaseUrl}/words/${id}`, {
        method: "DELETE",
        headers: {
          "Content-Type": "application/json",
        },
      });
      console.log("response: ", response);
      if (response.ok) {
        alert("Item deleted successfully!");
        
        document.location.reload();
      } else {
        alert("Failed to delete item. Please try again.");
      }
    } catch (error) {
      console.error("Error deleting item:", error);
      alert("An error occurred. Please try again.");
    }
  }
}

function showTable(functionName) {
  const content = document.getElementById("content");
  const tabs = document.querySelectorAll(".sidebar .nav-link");
  tabs.forEach((tab) => tab.classList.remove("active"));
  document.getElementById(`tab-${functionName}`).classList.add("active");

  function editRow(id) {
    const editor = document.getElementById("editor");
    editor.value = `Bạn đang chỉnh sửa dòng có ID: ${id}`;
  }

  function saveChanges() {
    alert("Nội dung đã được lưu!");
  }
}
