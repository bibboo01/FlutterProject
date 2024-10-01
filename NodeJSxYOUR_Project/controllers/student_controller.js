const std_info_ = require("../models/std_tbl");
const std_sch = require("../models/std_school_tbl");
const std_details = require("../models/std_details_tbl");

exports.post_all_std = async (req, res) => {
    const {
        std_id,
        prefix,
        std_Fname,
        std_Lname,
        std_nickname,
        std_religion,
        major,
        std_tel,
        sch_name,
        sch_province,
        std_father_name,
        std_father_tel,
        std_mother_name,
        std_mother_tel,
        std_parent_name,
        std_parent_tel,
        std_parent_rela,
        allergic_things,
        allergic_drugs,
        allergic_condition
    } = req.body;

    const data_std = new std_info_({
        std_id,
        prefix,
        std_Fname,
        std_Lname,
        std_nickname,
        std_religion,
        major,
        std_tel
    });

    const data_std_sch = new std_sch({
        std_id,
        sch_name,
        sch_province
    });

    const data_std_det = new std_details({
        std_id,
        std_father_name,
        std_father_tel,
        std_mother_name,
        std_mother_tel,
        std_parent_name,
        std_parent_tel,
        std_parent_rela,
        allergic_things,
        allergic_drugs,
        allergic_condition
    });

    try {
        const newdata_std = await data_std.save();
        const newdata_std_sch = await data_std_sch.save();
        const newdata_std_det = await data_std_det.save();

        res.status(201).json({ newdata_std, newdata_std_sch, newdata_std_det });
    } catch (err) {
        res.status(400).json({
            message: err.message
        });
    }
}

exports.put_std = async (req, res) => {
    const { std_id } = req.params;

    if(!std_id){
        res.status(400).send('Student ID is required')
    }
    const updateData = req.body;
    // Separate the update data based on your schema
    const updateStdInfo = {
        prefix: updateData.prefix,
        std_Fname: updateData.std_Fname,
        std_Lname: updateData.std_Lname,
        std_nickname: updateData.std_nickname,
        std_religion: updateData.std_religion,
        major: updateData.major,
        std_tel: updateData.std_tel
    };

    const updateStdSch = {
        sch_name: updateData.sch_name,
        sch_province: updateData.sch_province
    };

    const updateStdDetails = {
        std_father_name: updateData.std_father_name,
        std_father_tel: updateData.std_father_tel,
        std_mother_name: updateData.std_mother_name,
        std_mother_tel: updateData.std_mother_tel,
        std_parent_name: updateData.std_parent_name,
        std_parent_tel: updateData.std_parent_tel,
        std_parent_rela: updateData.std_parent_rela,
        allergic_things: updateData.allergic_things,
        allergic_drugs: updateData.allergic_drugs,
        allergic_condition: updateData.allergic_condition
    };
    try {
        const updatedStd = await std_info_.findOneAndUpdate(
            { std_id },
            { $set: updateStdInfo },
            { new: true }
        );

        // Update std_school_tbl
        const updatedStdSch = await std_sch.findOneAndUpdate(
            { std_id },
            { $set: updateStdSch },
            { new: true }
        );

        // Update std_details_tbl
        const updatedStdDet = await std_details.findOneAndUpdate(
            { std_id },
            { $set: updateStdDetails },
            { new: true }
        );
        res.status(200).send({
            updatedStd,
            updatedStdSch,
            updatedStdDet
        });
    }catch(e){
        res.status(500).send(e.message);
    }
};


