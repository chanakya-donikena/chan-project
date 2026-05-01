document.addEventListener('DOMContentLoaded', () => {
  if (getLoggedInUser()) {
    window.location.href = 'index.html';
    return;
  }

  const submitBtn = document.getElementById('submit-btn');
  submitBtn.dataset.originalText = submitBtn.textContent;

  document.getElementById('signup-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    hideAlerts();

    const name = document.getElementById('name').value.trim();
    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirm-password').value;

    if (!name || !email || !password || !confirmPassword) {
      showAlert('error-msg', 'Please fill in all fields.', 'error');
      return;
    }

    if (password.length < 6) {
      showAlert('error-msg', 'Password must be at least 6 characters.', 'error');
      return;
    }

    if (password !== confirmPassword) {
      showAlert('error-msg', 'Passwords do not match.', 'error');
      return;
    }

    setButtonLoading('submit-btn', true);

    try {
      const response = await fetch(`${API_BASE}/signup`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, email, password }),
      });

      const data = await response.json();

      if (!response.ok) {
        showAlert('error-msg', data.error || 'Signup failed. Please try again.', 'error');
        return;
      }

      showAlert('success-msg', 'Account created! Redirecting to login...', 'success');
      setTimeout(() => {
        window.location.href = 'login.html';
      }, 1500);
    } catch {
      showAlert('error-msg', 'Could not connect to server. Make sure the backend is running.', 'error');
    } finally {
      setButtonLoading('submit-btn', false);
    }
  });
});
