const express = require('express');
const route = express.Router();
const authenticateToken = require('../middlewares/auth_middlewares');

const {
    register,
    login,
    refresh
} = require('../controllers/auth_controller');

route.post('/', async (req, res) => {
    res.sendStatus(404);
});

route.post('/register', register);
route.post('/login', login);
route.post('/refresh', refresh);

// -------------------------------------- Admin -----------------------------------------

const {
    getusers,
    getuser,
    postuser,
    putuser,
    deluser
} = require("../controllers/admin_controller");


route.get('/read/users',authenticateToken,getusers);
route.get('/read/user/:id',authenticateToken,getuser);
route.post('/add/user',postuser);
route.put('/edit/user/:id',authenticateToken,putuser);
route.delete('/del/:id',authenticateToken,deluser);

// -------------------------------------- User -----------------------------------------

const {
    post_std,
    get_stds,
    get_std,
    put_std,
    del_std,
} = require('../controllers/user_controller');

route.post('/fill_info',authenticateToken,post_std);
route.get('/read_info',authenticateToken,get_stds);
route.get('/read_info/:std_id',authenticateToken,get_std);
route.put('/fill_info/:std_id',authenticateToken,put_std);
route.delete('/:std_id',authenticateToken,del_std);


module.exports = route;