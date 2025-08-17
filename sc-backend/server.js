require('dotenv').config();
const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const cookieParser = require('cookie-parser');
const Sc = require('./models/sc.js');

const app = express();
const bcryptSalt = bcrypt.genSaltSync(10);
const jwtSecret = 'fasefraw4r5r3wq45wdfgw34twdfg';

app.use(express.json());
app.use(cookieParser());
app.use(cors({
  credentials: true,
  origin: true
}));

mongoose.connect(process.env.MONGO_URL)
  .then(() => console.log('✅ MongoDB connected'))
  .catch(err => {
    console.error('❌ MongoDB connection error:', err);
    
  });

// Register route
app.post('/api/register', async (req, res) => {
  try {
    console.log(req.body);
   
    const { name, email, number, password } = req.body;
    const userDoc = await Sc.create({
      name,
      email,
      number,
      password: bcrypt.hashSync(password, bcryptSalt),
    });
    res.json(userDoc);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Registration failed' });
  }
});

// Login route
app.post('/api/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const userDoc = await Sc.findOne({ email });
    if (!userDoc) return res.status(404).json('User not found');

    const passOk = bcrypt.compareSync(password, userDoc.password);
    if (!passOk) return res.status(422).json('Invalid password');

    jwt.sign(
      { email: userDoc.email, id: userDoc._id },
      jwtSecret,
      {},
      (err, token) => {
        if (err) throw err;
        res.cookie('token', token, {
          httpOnly: true,
          secure: true,
          sameSite: 'None',
        }).json(userDoc);
      }
    );
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Login failed' });
  }
});

// Test route
app.get('/api/test', (req, res) => {
  res.json('test ok');
});

app.listen(4000,'0.0.0.0', () => {
  console.log('🚀 Server running on port 4000');
});
