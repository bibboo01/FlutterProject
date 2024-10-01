const User = require("../models/user");
const express = require("express");

exports.getusers = async (req, res) => {
    try {
        const users = await User.find();
        res.json(users);
    } catch (err) {
        res.status(404).send(err.message);
    }
}

exports.getuser = async (req, res) => {
    try {
        const { id } = req.params;
        const user = await User.findById(id);
        res.json(user);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
}

exports.postuser = async (req, res) => {
    const { user_id, username, password, role } = req.body;
    const user = new User({ user_id, username, password, role });
    try {
        const newUser = await user.save();
        res.status(201).json(newUser);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
}

exports.deluser = async (req, res) => {
    try {
        const { id } = req.params;
        const user = await User.findById(id);
        if (!user) return res.status(404).json({
            message: "user not found"
        })
        const deluser = await User.findByIdAndDelete(id);
        res.json(deluser);
    } catch (err) {
        res.status(500).json(err)
    }
}

exports.putuser = async (req, res) => {
    try {
        const { id } = req.params;
        const user = await User.findById(id);
        if (!user) return res.status(404).json({
            message: "user not found"
        })
        const data = {
            $set: req.body
        }
        const putuser = await User.findByIdAndUpdate(id, data);
        res.json(putuser);
    } catch (err) {
        res.status(500).json(err)
    }
}