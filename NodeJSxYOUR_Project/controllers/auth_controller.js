const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/user');

exports.register = async (req, res) => {
    const {
        username,
        password,
        email
    } = req.body;
    try {
        const hashedpassword = await bcrypt.hash(password, 10);
        const user = new User({
            username,
            password: hashedpassword,
            email,
            role: 0
        });
        await user.save();
        res.status(200).send("Register Successful");
    } catch (err) {
        res.status(400).send(err.message);
    }
}

exports.login = async (req, res) => {
    const {
        username,
        password
    } = req.body;
    try {
        const user_old = await User.findOne({
            username
        });
        if (!user_old) return res.status(400).send('user not found');
        const isMatch = await bcrypt.compare(password, user_old.password);
        if (!isMatch) return res.status(400).send('Invalid credntials');

        const user = await User.findOne({ username }).select("-password");

        const accessToken = jwt.sign({
            userId: user._id
        }, process.env.ACCESS_TOKEN_SECRET, {
            expiresIn: "1m"
        });
        const refreshToken = jwt.sign({
            userId: user._id
        }, process.env.REFRESH_TOKEN_SECRET, {
            expiresIn: "20m"
        });
        res.json({
            user: user,
            token: {
                accessToken,
                refreshToken
            }
        });
    } catch (err) {
        console.log(err);
    }
}

exports.refresh = async (req, res) => {
    const { token } = req.body;
    if (!token) return res.status(400).json({ message: 'Token is required' });
    jwt.verify(token, process.env.REFRESH_TOKEN_SECRET, (err, user) => {
        if (err) return res.status(403).json({ message: 'Invalid or expired refresh token' });
        const accessToken = jwt.sign({
            userId: user.userId
        }, process.env.ACCESS_TOKEN_SECRET, {
            expiresIn: '1m'
        });
        res.json({ accessToken });
    })
}