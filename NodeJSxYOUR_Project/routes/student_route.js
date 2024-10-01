const express = require('express');
const {
    post_all_std,
    put_std,
} = require("../controllers/student_controller");

const route = express.Router();

route.post('/fill_info',post_all_std);
route.put('/fill_info/:std_id',put_std);

module.exports = route;
