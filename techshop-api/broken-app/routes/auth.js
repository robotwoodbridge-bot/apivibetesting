const express = require('express');
const jwt = require('jsonwebtoken');
const users = require('../data/users');
const { JWT_SECRET } = require('../middleware/auth');

const router = express.Router();

/**
 * @openapi
 * /auth/login:
 *   post:
 *     summary: Log in and receive a JWT token
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [email, password]
 *             properties:
 *               email:
 *                 type: string
 *                 example: demo@techshop.com
 *               password:
 *                 type: string
 *                 example: password123
 *     responses:
 *       200:
 *         description: Login successful — returns JWT token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 token:
 *                   type: string
 *                 user:
 *                   type: object
 *                   properties:
 *                     id: { type: integer }
 *                     email: { type: string }
 *                     name: { type: string }
 *       401:
 *         description: Invalid credentials
 *       400:
 *         description: Missing email or password
 */
// BUG B1: Returns 200 + token even when password is wrong
router.post('/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password are required' });
  }

  const user = users.find(u => u.email === email);

  if (!user) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }

  // BUG B1: password is never checked — any password works for a valid email
  const token = jwt.sign(
    { id: user.id, email: user.email, name: user.name },
    JWT_SECRET,
    { expiresIn: '1h' }
  );

  res.json({
    token,
    user: { id: user.id, email: user.email, name: user.name }
  });
});

module.exports = router;
