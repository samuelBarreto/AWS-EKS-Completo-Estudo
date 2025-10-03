const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Database configuration
const dbConfig = {
  host: process.env.DB_HOST || 'mysql-service',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || 'dbpassword11',
  database: process.env.DB_NAME || 'usermanagement',
  port: process.env.DB_PORT || 3306
};

// Create database connection pool
const pool = mysql.createPool({
  ...dbConfig,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Test database connection
async function testConnection() {
  try {
    const connection = await pool.getConnection();
    console.log('✅ Database connected successfully');
    connection.release();
  } catch (error) {
    console.error('❌ Database connection failed:', error.message);
  }
}

// Initialize database and create users table
async function initializeDatabase() {
  try {
    const connection = await pool.getConnection();
    
    // Create database if not exists
    await connection.execute(`CREATE DATABASE IF NOT EXISTS ${dbConfig.database}`);
    await connection.execute(`USE ${dbConfig.database}`);
    
    // Create users table
    await connection.execute(`
      CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        age INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      )
    `);
    
    console.log('✅ Database and table initialized successfully');
    connection.release();
  } catch (error) {
    console.error('❌ Database initialization failed:', error.message);
  }
}

// Routes

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    message: 'User Management API is running',
    timestamp: new Date().toISOString()
  });
});

// GET /users - Get all users
app.get('/users', async (req, res) => {
  try {
    const [rows] = await pool.execute('SELECT * FROM users ORDER BY created_at DESC');
    res.json({
      success: true,
      data: rows,
      count: rows.length
    });
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching users',
      error: error.message
    });
  }
});

// GET /users/:id - Get user by ID
app.get('/users/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.execute('SELECT * FROM users WHERE id = ?', [id]);
    
    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }
    
    res.json({
      success: true,
      data: rows[0]
    });
  } catch (error) {
    console.error('Error fetching user:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching user',
      error: error.message
    });
  }
});

// POST /users - Create new user
app.post('/users', async (req, res) => {
  try {
    const { name, email, age } = req.body;
    
    // Validation
    if (!name || !email) {
      return res.status(400).json({
        success: false,
        message: 'Name and email are required'
      });
    }
    
    // Check if email already exists
    const [existingUsers] = await pool.execute('SELECT id FROM users WHERE email = ?', [email]);
    if (existingUsers.length > 0) {
      return res.status(409).json({
        success: false,
        message: 'Email already exists'
      });
    }
    
    const [result] = await pool.execute(
      'INSERT INTO users (name, email, age) VALUES (?, ?, ?)',
      [name, email, age || null]
    );
    
    res.status(201).json({
      success: true,
      message: 'User created successfully',
      data: {
        id: result.insertId,
        name,
        email,
        age
      }
    });
  } catch (error) {
    console.error('Error creating user:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating user',
      error: error.message
    });
  }
});

// PUT /users/:id - Update user
app.put('/users/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, email, age } = req.body;
    
    // Validation
    if (!name || !email) {
      return res.status(400).json({
        success: false,
        message: 'Name and email are required'
      });
    }
    
    // Check if user exists
    const [existingUsers] = await pool.execute('SELECT id FROM users WHERE id = ?', [id]);
    if (existingUsers.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }
    
    // Check if email already exists for another user
    const [emailCheck] = await pool.execute('SELECT id FROM users WHERE email = ? AND id != ?', [email, id]);
    if (emailCheck.length > 0) {
      return res.status(409).json({
        success: false,
        message: 'Email already exists for another user'
      });
    }
    
    await pool.execute(
      'UPDATE users SET name = ?, email = ?, age = ? WHERE id = ?',
      [name, email, age || null, id]
    );
    
    res.json({
      success: true,
      message: 'User updated successfully',
      data: {
        id: parseInt(id),
        name,
        email,
        age
      }
    });
  } catch (error) {
    console.error('Error updating user:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating user',
      error: error.message
    });
  }
});

// DELETE /users/:id - Delete user
app.delete('/users/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    // Check if user exists
    const [existingUsers] = await pool.execute('SELECT id FROM users WHERE id = ?', [id]);
    if (existingUsers.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }
    
    await pool.execute('DELETE FROM users WHERE id = ?', [id]);
    
    res.json({
      success: true,
      message: 'User deleted successfully'
    });
  } catch (error) {
    console.error('Error deleting user:', error);
    res.status(500).json({
      success: false,
      message: 'Error deleting user',
      error: error.message
    });
  }
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Unhandled error:', err);
  res.status(500).json({
    success: false,
    message: 'Internal server error',
    error: err.message
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found'
  });
});

// Start server
async function startServer() {
  await testConnection();
  await initializeDatabase();
  
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 User Management API running on port ${PORT}`);
    console.log(`📊 Health check: http://localhost:${PORT}/health`);
    console.log(`👥 Users endpoint: http://localhost:${PORT}/users`);
  });
}

startServer().catch(console.error);
