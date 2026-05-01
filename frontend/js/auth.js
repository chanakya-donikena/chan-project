const API_BASE = 'http://localhost:3000/api';

function getLoggedInUser() {
  const token = localStorage.getItem('auth_token');
  const user = localStorage.getItem('auth_user');
  if (token && user) {
    try {
      return JSON.parse(user);
    } catch {
      return null;
    }
  }
  return null;
}

function logout() {
  localStorage.removeItem('auth_token');
  localStorage.removeItem('auth_user');
  window.location.href = 'index.html';
}

function showAlert(elementId, message, type) {
  const el = document.getElementById(elementId);
  if (!el) return;
  el.textContent = message;
  el.className = `alert alert-${type} show`;
}

function hideAlerts() {
  ['error-msg', 'success-msg'].forEach((id) => {
    const el = document.getElementById(id);
    if (el) {
      el.className = 'alert';
      el.textContent = '';
    }
  });
}

function setButtonLoading(btnId, loading) {
  const btn = document.getElementById(btnId);
  if (!btn) return;
  btn.disabled = loading;
  btn.textContent = loading ? 'Please wait...' : btn.dataset.originalText;
}
