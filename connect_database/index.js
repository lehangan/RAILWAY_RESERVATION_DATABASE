const {Pool, Client} = require('pg');

const client = new Client({
    host:'localhost',
    user:'postgres',
    port: 5432,
    password: 'Ngan3010@',
    database: 'railway_project'
});

client.connect();

client.query( `select * from station` , (err, res) =>{
    if(!err){
        console.log(res.rows);
    }
    else{
        console.log(err.message);
    }
    client.end;
})