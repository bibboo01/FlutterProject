const std_info_ = require("../models/std_tbl");
const std_sch = require("../models/std_school_tbl");
const std_details = require("../models/std_details_tbl");
const { default: mongoose } = require("mongoose");

exports.post_std = async (req, res) => {
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
        res.status(201).json(newdata_std, newdata_std_sch, newdata_std_det);
    } catch (err) {
        res.status(400).json({
            message: err.message
        });
    }
}

exports.get_stds = async (req, res) => {
    try {
        const data_std = await std_info_.aggregate([
            // First $lookup to join with std_details_tbl
            {
                $lookup: {
                    from: 'std_details_tbl',
                    localField: 'std_id',
                    foreignField: 'std_id',
                    as: 'details'
                }
            },
            // Unwind details to make it a single object
            {
                $unwind: {
                    path: '$details',
                    preserveNullAndEmptyArrays: true // Preserve documents with no matching details
                }
            },
            // Second $lookup to join with std_school_tbl
            {
                $lookup: {
                    from: 'std_school_tbl',
                    localField: 'std_id',
                    foreignField: 'std_id',
                    as: 'school'
                }
            },
            // Unwind school to make it a single object
            {
                $unwind: {
                    path: '$school',
                    preserveNullAndEmptyArrays: true // Preserve documents with no matching school
                }
            },
            // Restructure the result to have the desired format
            {
                $project: {
                    _id: 1,
                    std_id: 1,
                    prefix: 1,
                    std_Fname: 1,
                    std_Lname: 1,
                    std_nickname: 1,
                    std_religion: 1,
                    major: 1,
                    std_tel: 1,
                    details: {
                        _id: '$details._id',
                        std_id: '$details.std_id',
                        std_father_name: '$details.std_father_name',
                        std_father_tel: '$details.std_father_tel',
                        std_mother_name: '$details.std_mother_name',
                        std_mother_tel: '$details.std_mother_tel',
                        std_parent_name: '$details.std_parent_name',
                        std_parent_tel: '$details.std_parent_tel',
                        std_parent_rela: '$details.std_parent_rela',
                        allergic_things: '$details.allergic_things',
                        allergic_drugs: '$details.allergic_drugs',
                        allergic_condition: '$details.allergic_condition'
                    },
                    school: {
                        _id: '$school._id',
                        std_id: '$school.std_id',
                        sch_name: '$school.sch_name',
                        sch_province: '$school.sch_province'
                    }
                }
            },
            // Reformat the result to match the desired output
            {
                $group: {
                    _id: '$_id',
                    std_id: { $first: '$std_id' },
                    prefix: { $first: '$prefix' },
                    std_Fname: { $first: '$std_Fname' },
                    std_Lname: { $first: '$std_Lname' },
                    std_nickname: { $first: '$std_nickname' },
                    std_religion: { $first: '$std_religion' },
                    major: { $first: '$major' },
                    std_tel: { $first: '$std_tel' },
                    details: { $first: '$details' },
                    school: { $first: '$school' }
                }
            },
            // Rename the _id field to std_info
            {
                $project: {
                    _id: 0,
                    std_info: {
                        _id: '$_id',
                        std_id: '$std_id',
                        prefix: '$prefix',
                        std_Fname: '$std_Fname',
                        std_Lname: '$std_Lname',
                        std_nickname: '$std_nickname',
                        std_religion: '$std_religion',
                        major: '$major',
                        std_tel: '$std_tel',
                        details: '$details',
                        school: '$school'
                    }
                }
            }
        ]).exec();

        res.status(200).json(data_std);
    } catch (err) {
        console.error('Error fetching student data:', err); // Log the error for debugging
        res.status(500).json({
            message: 'Error fetching student data',
            error: err.message
        });
    }


}

exports.get_std = async (req, res) => {

    const { std_id } = req.params;

    if (!std_id) {
        return res.status(400).json({ message: 'Student ID is required' });
    }
    try {
        const data_std = await std_info_.aggregate([
            {
                $match: { std_id } // Match the specific student ID
            },
            {
                $lookup: {
                    from: 'std_details_tbl', // Collection to join
                    localField: 'std_id',    // Field from the current collection
                    foreignField: 'std_id',  // Field from the collection to join
                    as: 'details'            // Alias for the joined data
                }
            },
            {
                $unwind: {
                    path: '$details',  // Deconstructs the array
                    preserveNullAndEmptyArrays: true // Preserve the original document if the array is empty
                }
            },
            {
                $lookup: {
                    from: 'std_school_tbl', // Collection to join
                    localField: 'std_id',   // Field from the current collection
                    foreignField: 'std_id', // Field from the collection to join
                    as: 'school'            // Alias for the joined data
                }
            },
            {
                $unwind: {
                    path: '$school',  // Deconstructs the array
                    preserveNullAndEmptyArrays: true // Preserve the original document if the array is empty
                }
            }
        ]).exec();
        res.status(200).json(data_std);
    } catch (err) {
        res.status(500).json({ message: 'Error fetching students', error: err.message });
    }
}

exports.put_std = async (req, res) => {
    const { std_id } = req.params;

    if (!std_id) {
        res.status(400).send('Student ID is required')
    }
    const updateData = req.body;

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
    } catch (e) {
        res.status(500).send(e.message);
    }
};

exports.del_std = async (req, res) => {
    try {
        const { std_id } = req.params;
        if (!std_id) return res.status(404).json({
            message: "Student not found"
        })
        const deldated1 = await std_info_.findOneAndDelete(std_id);
        const deldated2 = await std_sch.findOneAndDelete(std_id);
        const deldated3 = await std_details.findOneAndDelete(std_id);
        res.json({ deldated1, deldated2, deldated3 }).send("Delete Successful");
    } catch (err) {
        res.status(500).json(err)
    }
}