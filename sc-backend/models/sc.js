const mongoose = require('mongoose');

const sc = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  number: { type: String, required: true }, // phone number as string
  password: { type: String, required: true }
}, { timestamps: true });

const Sc = mongoose.model('Sc', sc);
module.exports =Sc;
