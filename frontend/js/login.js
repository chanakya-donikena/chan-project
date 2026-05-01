document.addEventListener('DOMContentLoaded', () => {
  if (getLoggedInUser()) {
    window.location.href = 'index.html';
    return;
  }

  const submitBtn = document.getElementById('submit-btn');
  submitBtn.dataset.originalText = submitBtn.textContent;

  document.getElementById('login-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    hideAlerts();

    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value;

    if (!email || !password) {
      showAlert('error-msg', 'Please fill in all fields.', 'error');
      return;
    }

    setButtonLoading('submit-btn', true);

    try {
      const response = await fetch(`${API_BASE}/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password }),
      });

      const data = await response.json();

      if (!response.ok) {
        showAlert('error-msg', data.error || 'Login failed. Please try again.', 'error');
        return;
      }

      localStorage.setItem('auth_token', data.token);
      localStorage.setItem('auth_user', JSON.stringify(data.user));

      showAlert('success-msg', 'Login successful! Redirecting...', 'success');
      setTimeout(() => {
        window.location.href = 'index.html';
      }, 1000);
    } catch {
      showAlert('error-msg', 'Could not connect to server. Make sure the backend is running.', 'error');
    } finally {
      setButtonLoading('submit-btn', false);
    }
  });
});
