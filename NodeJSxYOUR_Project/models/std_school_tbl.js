const mongoose = require('mongoose');

const userschSchema = new mongoose.Schema({
    std_id: { type: String, required: true },
    sch_name: { type: String, required: true }, 
    sch_province: { type: Number, required: true }
},{
    versionKey:false
});

module.exports = mongoose.model('std_school_tbl',userschSchema,'std_school_tbl');