import { useState } from 'react';

export default function App() {
  const [form, setForm] = useState({
    email: '',
    password: '',
    message: '',
  });

  const [errors, setErrors] = useState({});
  const [success, setSuccess] = useState('');
  const [messages, setMessages] = useState([]);

  const validate = () => {
    const newErrors = {};

    if (!form.email) {
      newErrors.email = 'Email is required';
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) {
      newErrors.email = 'Invalid email format';
    }

    if (!form.password) {
      newErrors.password = 'Password is required';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    setSuccess('');

    if (validate()) {
      setSuccess('Registration successful');
    }
  };

  const addMessage = (e) => {
    e.preventDefault();
    setMessages([...messages, form.message]);
    setForm({ ...form, message: '' });
  };

  return (
    <div style={{ padding: 20 }}>
      <h2>Registration Form</h2>

      <form onSubmit={handleSubmit}>
        <div>
          <input
            id="email"
            value={form.email}
            onChange={(e) =>
              setForm({ ...form, email: e.target.value })
            }
          />
          {errors.email && <p style={{ color: 'red' }}>{errors.email}</p>}
        </div>

        <div>
          <input
            id="password"
            type="password"
            value={form.password}
            onChange={(e) =>
              setForm({ ...form, password: e.target.value })
            }
          />
          {errors.password && (
            <p style={{ color: 'red' }}>{errors.password}</p>
          )}
        </div>

        <button id="submit" type="submit">
          Register
        </button>
      </form>

      {success && <h3 style={{ color: 'green' }}>{success}</h3>}

      <hr />

      <h3>Messages (XSS test area)</h3>

      <form onSubmit={addMessage}>
        <input
          id="messageInput"
          value={form.message}
          onChange={(e) =>
            setForm({ ...form, message: e.target.value })
          }
        />
        <button id="send">Send</button>
      </form>

      <div id="messages">
        {messages.map((msg, i) => (
          <p
            key={i}
            dangerouslySetInnerHTML={{ __html: msg }}
          />
        ))}
      </div>
    </div>
  );
}

