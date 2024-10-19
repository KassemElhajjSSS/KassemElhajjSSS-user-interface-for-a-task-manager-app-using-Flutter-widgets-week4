const { where } = require('sequelize')
const {Task} = require('../../models/index')

const getTasks = async (req,res) => {
    try{
        const tasks = await Task.findAll()
        res.json({status: 'ok', message: 'tasks is fetched from db successfully', tasks: tasks})
    }catch(err){
        res.json({status: 'failed', message: err.message})
    }
}

const addTask = async (req, res) => {
    try{
        const {taskContent} = req.body
        const task = await Task.create({taskContent})
        res.json({status: 'ok', message:'task added successfuly', taskId: task.id})
    }catch(err){
        res.json({status: 'failed', message: err.message})
    }
}

const deleteTask = async (req, res) => {
    try{
        const id = req.params.id
        await Task.destroy({
            where:{
                id : parseInt(id)
            }
        })
        res.json({status: 'ok', message: 'task has been deleted successfuly!'})
    }catch(err){
        res.json({status: 'failed', message: err.message})
    }
}

const updateTask = async (req, res) => {
    try{
        const id = parseInt(req.params.id)
        const {taskContent} = req.body
        await Task.update(
            {taskContent},
            {where: {
                id: id
            }}
        )
        res.json({status: 'ok', message: "Task has been updated successfuly!"})
    }catch(err){
        res.json({status: 'failed', message: err.message})
    }
}

module.exports = {
    getTasks,
    addTask,
    deleteTask,
    updateTask,
}